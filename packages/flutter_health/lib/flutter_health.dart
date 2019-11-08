import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Custom Exception for the plugin,
/// thrown whenever the plugin is used on platforms
/// where some health data metric isnt available
class HealthDataNotAvailableException implements Exception {
  String _cause;

  HealthDataNotAvailableException(this._cause);

  @override
  String toString() {
    return _cause;
  }
}

/// Extracts the string value from an enum
String enumToString(enumItem) {
  return enumItem.toString().split('.')[1];
}

/// All health data types
enum HealthDataType {
  BODY_FAT_PERCENTAGE,
  HEIGHT,
  WEIGHT,
  BODY_MASS_INDEX,
  WAIST_CIRCUMFERENCE,
  STEPS,
  BASAL_ENERGY_BURNED,
  ACTIVE_ENERGY_BURNED,
  HEART_RATE,
  BODY_TEMPERATURE,
  BLOOD_PRESSURE_SYSTOLIC,
  BLOOD_PRESSURE_DIASTOLIC,
  RESTING_HEART_RATE,
  WALKING_HEART_RATE,
  BLOOD_OXYGEN,
  BLOOD_GLUCOSE,
  ELECTRODERMAL_ACTIVITY,

  /// Heart Rate events (specific to Apple Watch)
  HIGH_HEART_RATE_EVENT,
  LOW_HEART_RATE_EVENT,
  IRREGULAR_HEART_RATE_EVENT
}

const List<HealthDataType> _dataTypesIOS = [
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.HEIGHT,
  HealthDataType.WEIGHT,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.WAIST_CIRCUMFERENCE,
  HealthDataType.STEPS,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.HEART_RATE,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.WALKING_HEART_RATE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.ELECTRODERMAL_ACTIVITY,
  HealthDataType.HIGH_HEART_RATE_EVENT,
  HealthDataType.LOW_HEART_RATE_EVENT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT
];

const List<HealthDataType> _dataTypesAndroid = [
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.HEIGHT,
  HealthDataType.WEIGHT,
  HealthDataType.STEPS,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.HEART_RATE,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_GLUCOSE,
];


enum PlatformType { IOS, ANDROID }

/// A [HealthData] object corresponds to a data point from GoogleFit/Apple HK
class HealthData {
  num value;
  String unit;
  int dateFrom;
  int dateTo;
  String dataType;
  String platform;

  HealthData(
      {this.value,
      this.unit,
      this.dateFrom,
      this.dateTo,
      this.dataType,
      this.platform});

  HealthData.fromJson(Map<String, dynamic> json) {
    try {
      value = json['value'];
      unit = json['unit'];
      dateFrom = json['date_from'];
      dateTo = json['date_to'];
      dataType = json['data_type'];
      platform = json['platform_type'];
    } catch (error) {
      print(error);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['data_type'] = this.dataType;
    data['platform_type'] = this.platform;
    return data;
  }

  String toString() {
    Map<String, dynamic> json = this.toJson();
    return json.toString();
  }
}

class FlutterHealth {
  static const MethodChannel _channel = const MethodChannel('flutter_health');

  static PlatformType _platformType =
      Platform.isAndroid ? PlatformType.ANDROID : PlatformType.IOS;

  static String _methodName = 'getData';

  /// Check if a given data type is available on the platform
  static bool checkIfDataTypeAvailable(HealthDataType dataType) {
    return _platformType == PlatformType.ANDROID
        ? _dataTypesAndroid.contains(dataType)
        : _dataTypesIOS.contains(dataType);
  }

  ///  Check if GoogleFit/Apple HealthKit is enabled on the device
  static Future<bool> checkIfHealthDataAvailable() async {
    final bool isHealthDataAvailable =
        await _channel.invokeMethod('checkIfHealthDataAvailable');
    return isHealthDataAvailable;
  }

  /// Request access to GoogleFit/Apple HealthKit
  static Future<bool> requestAuthorization() async {
    final bool isAuthorized =
        await _channel.invokeMethod('requestAuthorization');
    return isAuthorized;
  }

  /// Main function for fetching health data
  static Future<List<HealthData>> getHealthDataFromType(
      DateTime startDate, DateTime endDate, HealthDataType dataType) async {
    List<HealthData> healthData = new List();

    String dataTypeKey = enumToString(dataType);

    /// If not implemented on platform, throw an exception
    if (dataTypeKey == null) {
      throw new HealthDataNotAvailableException(
          "Method ${dataType.toString()} not implemented for platform ${_platformType.toString()}");
    }

    /// Set parameters for method channel request
    Map<String, dynamic> args = {
      'dataTypeKey': dataTypeKey,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch
    };

    try {
      List result = await _channel.invokeMethod(_methodName, args);

      /// Process each data point received
      for (var x in result) {
        /// Add the platform_type and data_type fields
        x["platform_type"] = _platformType.toString();
        x["data_type"] = dataType.toString();

        /// Convert to JSON
        Map<String, dynamic> jsonData = Map<String, dynamic>.from(x);

        /// Convert JSON to HealthData object
        HealthData data = HealthData.fromJson(jsonData);
        healthData.add(data);
      }
    } catch (error) {
      print(error);
    }
    return healthData;
  }
}
