part of health;

/// Main class for the Plugin
class HealthFactory {
  static const MethodChannel _channel = const MethodChannel('flutter_health');
  String _deviceId;

  Map<HealthDataType, bool> _permissions;

  HealthFactory() {
    _permissions = Map.fromIterable(HealthDataType.values,
        key: (v) => v, value: (v) => false);
  }

  static PlatformType _platformType =
      Platform.isAndroid ? PlatformType.ANDROID : PlatformType.IOS;

  /// Check if a given data type is available on the platform
  bool _isDataTypeAvailable(HealthDataType dataType) =>
      _platformType == PlatformType.ANDROID
          ? _dataTypeKeysAndroid.contains(dataType)
          : _dataTypeKeysIOS.contains(dataType);

  /// Request access to GoogleFit/Apple HealthKit
  Future<bool> _requestAuthorization(HealthDataType type) async {
    //List<String> types = healthTypes.map((t) => _enumToString(t)).toList();

    List<HealthDataType> types = [type];

    /// If BMI is requested, then also ask for weight and height
    if (type == HealthDataType.BODY_MASS_INDEX) {
      types.add(HealthDataType.WEIGHT);
      types.add(HealthDataType.HEIGHT);
    }

    List<String> keys = types.map((e) => _enumToString(e)).toList();
    final bool isAuthorized =
        await _channel.invokeMethod('requestAuthorization', {'types': keys});
    return isAuthorized;
  }

  // Calculate the BMI using the last observed height and weight values.
  Future<List<HealthDataPoint>> _computeAndroidBMI(
      DateTime startDate, DateTime endDate) async {
    List<HealthDataPoint> heights =
        await getHealthDataFromType(startDate, endDate, HealthDataType.HEIGHT);
    List<HealthDataPoint> weights =
        await getHealthDataFromType(startDate, endDate, HealthDataType.WEIGHT);

    double h = heights.last.value.toDouble();

    HealthDataType dataType = HealthDataType.BODY_MASS_INDEX;
    HealthDataUnit unit = _dataTypeToUnit[dataType];

    List<HealthDataPoint> bmiHealthPoints = [];
    for (int i = 0; i < weights.length; i++) {
      double bmiValue = weights[i].value.toDouble() / (h * h);
      print('BMI: $bmiValue');
      HealthDataPoint x = HealthDataPoint._(
          bmiValue,
          HealthDataType.BODY_MASS_INDEX,
          unit,
          weights[i].dateFrom,
          weights[i].dateTo,
          _platformType,
          _deviceId);

      bmiHealthPoints.add(x);
    }
    return bmiHealthPoints;
  }

  // Main function for fetching health data
  Future<List<HealthDataPoint>> getHealthDataFromType(
      DateTime startDate, DateTime endDate, HealthDataType dataType) async {
    /// Ask for device ID only once
    if (_deviceId == null) {
      _deviceId = await DeviceId.getID;
    }

    /// If not implemented on platform, throw an exception
    if (!_isDataTypeAvailable(dataType)) {
      throw _HealthException(
          dataType, "Not available on platform $_platformType");
    }

    /// If permission not yet granted, ask for it
    if (!_permissions[dataType]) {
      bool granted = await _requestAuthorization(dataType);
      if (!granted) {
        String api = _platformType == PlatformType.ANDROID
            ? "Google Fit"
            : "Apple Health";
        throw _HealthException(dataType, "Permission was not granted for $api");
      } else {
        _permissions[dataType] = true;
      }
    }

    /// If BodyMassIndex is requested on Android, calculate this manually in Dart
    if (dataType == HealthDataType.BODY_MASS_INDEX &&
        _platformType == PlatformType.ANDROID) {
      return _computeAndroidBMI(startDate, endDate);
    }
    return _getData(startDate, endDate, dataType);
  }

  Future<List<HealthDataPoint>> _getData(
      DateTime startDate, DateTime endDate, HealthDataType dataType) async {
    // Set parameters for method channel request
    Map<String, dynamic> args = {
      'dataTypeKey': _enumToString(dataType),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch
    };

    List<HealthDataPoint> healthData = new List();
    HealthDataUnit unit = _dataTypeToUnit[dataType];

    /// Used for generating a UUID

    try {
      List fetchedDataPoints = await _channel.invokeMethod('getData', args);
      healthData = fetchedDataPoints.map((e) {
        num value = e["value"];
        DateTime from = DateTime.fromMillisecondsSinceEpoch(e["date_from"]);
        DateTime to = DateTime.fromMillisecondsSinceEpoch(e["date_to"]);
        return HealthDataPoint._(
            value, dataType, unit, from, to, _platformType, _deviceId);
      }).toList();
    } catch (error) {
      print(error);
    }
    return healthData;
  }

  static List<HealthDataPoint> removeDuplicates(List<HealthDataPoint> points) {
    List<HealthDataPoint> unique = [];

    for (HealthDataPoint p in points) {
      bool seenBefore = false;
      for (HealthDataPoint s in unique) {
        if (s == p) {
          seenBefore = true;
        }
      }
      if (!seenBefore) {
        unique.add(p);
      }
    }
    return unique;
  }
}
