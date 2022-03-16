part of health;

/// List of all available data types.
enum HealthDataType {
  ACTIVE_ENERGY_BURNED,
  AUDIOGRAM,
  BASAL_ENERGY_BURNED,
  BLOOD_GLUCOSE,
  BLOOD_OXYGEN,
  BLOOD_PRESSURE_DIASTOLIC,
  BLOOD_PRESSURE_SYSTOLIC,
  BODY_FAT_PERCENTAGE,
  BODY_MASS_INDEX,
  BODY_TEMPERATURE,
  DIETARY_CARBS_CONSUMED,
  DIETARY_ENERGY_CONSUMED,
  DIETARY_FATS_CONSUMED,
  DIETARY_PROTEIN_CONSUMED,
  FORCED_EXPIRATORY_VOLUME,
  HEART_RATE,
  HEART_RATE_VARIABILITY_SDNN,
  HEIGHT,
  RESTING_HEART_RATE,
  STEPS,
  WAIST_CIRCUMFERENCE,
  WALKING_HEART_RATE,
  WEIGHT,
  DISTANCE_WALKING_RUNNING,
  FLIGHTS_CLIMBED,
  MOVE_MINUTES,
  DISTANCE_DELTA,
  MINDFULNESS,
  WATER,
  SLEEP_IN_BED,
  SLEEP_ASLEEP,
  SLEEP_AWAKE,
  EXERCISE_TIME,
  WORKOUT,
  HEADACHE_NOT_PRESENT,
  HEADACHE_MILD,
  HEADACHE_MODERATE,
  HEADACHE_SEVERE,
  HEADACHE_UNSPECIFIED,

  // Heart Rate events (specific to Apple Watch)
  HIGH_HEART_RATE_EVENT,
  LOW_HEART_RATE_EVENT,
  IRREGULAR_HEART_RATE_EVENT,
  ELECTRODERMAL_ACTIVITY,
}

enum HealthDataAccess {
  READ,
  WRITE,
  READ_WRITE,
}

/// List of data types available on iOS
const List<HealthDataType> _dataTypeKeysIOS = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.AUDIOGRAM,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.DIETARY_CARBS_CONSUMED,
  HealthDataType.DIETARY_ENERGY_CONSUMED,
  HealthDataType.DIETARY_FATS_CONSUMED,
  HealthDataType.DIETARY_PROTEIN_CONSUMED,
  HealthDataType.ELECTRODERMAL_ACTIVITY,
  HealthDataType.FORCED_EXPIRATORY_VOLUME,
  HealthDataType.HEART_RATE,
  HealthDataType.HEART_RATE_VARIABILITY_SDNN,
  HealthDataType.HEIGHT,
  HealthDataType.HIGH_HEART_RATE_EVENT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  HealthDataType.LOW_HEART_RATE_EVENT,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.STEPS,
  HealthDataType.WAIST_CIRCUMFERENCE,
  HealthDataType.WALKING_HEART_RATE,
  HealthDataType.WEIGHT,
  HealthDataType.FLIGHTS_CLIMBED,
  HealthDataType.DISTANCE_WALKING_RUNNING,
  HealthDataType.MINDFULNESS,
  HealthDataType.SLEEP_IN_BED,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.WATER,
  HealthDataType.EXERCISE_TIME,
  HealthDataType.WORKOUT,
  HealthDataType.HEADACHE_NOT_PRESENT,
  HealthDataType.HEADACHE_MILD,
  HealthDataType.HEADACHE_MODERATE,
  HealthDataType.HEADACHE_SEVERE,
  HealthDataType.HEADACHE_UNSPECIFIED,
];

/// List of data types available on Android
const List<HealthDataType> _dataTypeKeysAndroid = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
  HealthDataType.BODY_FAT_PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.HEART_RATE,
  HealthDataType.HEIGHT,
  HealthDataType.STEPS,
  HealthDataType.WEIGHT,
  HealthDataType.MOVE_MINUTES,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.SLEEP_IN_BED,
  HealthDataType.WATER,
];

/// Maps a [HealthDataType] to a [HealthDataUnit].
const Map<HealthDataType, HealthDataUnit> _dataTypeToUnit = {
  HealthDataType.ACTIVE_ENERGY_BURNED: HealthDataUnit.CALORIES,
  HealthDataType.AUDIOGRAM: HealthDataUnit.DECIBEL_HEARING_LEVEL,
  HealthDataType.BASAL_ENERGY_BURNED: HealthDataUnit.CALORIES,
  HealthDataType.BLOOD_GLUCOSE: HealthDataUnit.MILLIGRAM_PER_DECILITER,
  HealthDataType.BLOOD_OXYGEN: HealthDataUnit.PERCENTAGE,
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: HealthDataUnit.MILLIMETER_OF_MERCURY,
  HealthDataType.BODY_FAT_PERCENTAGE: HealthDataUnit.PERCENTAGE,
  HealthDataType.BODY_MASS_INDEX: HealthDataUnit.NO_UNIT,
  HealthDataType.BODY_TEMPERATURE: HealthDataUnit.DEGREE_CELSIUS,
  HealthDataType.DIETARY_CARBS_CONSUMED: HealthDataUnit.GRAMS,
  HealthDataType.DIETARY_ENERGY_CONSUMED: HealthDataUnit.CALORIES,
  HealthDataType.DIETARY_FATS_CONSUMED: HealthDataUnit.GRAMS,
  HealthDataType.DIETARY_PROTEIN_CONSUMED: HealthDataUnit.GRAMS,
  HealthDataType.ELECTRODERMAL_ACTIVITY: HealthDataUnit.SIEMENS,
  HealthDataType.FORCED_EXPIRATORY_VOLUME: HealthDataUnit.LITER,
  HealthDataType.HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.HEIGHT: HealthDataUnit.METERS,
  HealthDataType.RESTING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.STEPS: HealthDataUnit.COUNT,
  HealthDataType.WAIST_CIRCUMFERENCE: HealthDataUnit.METERS,
  HealthDataType.WALKING_HEART_RATE: HealthDataUnit.BEATS_PER_MINUTE,
  HealthDataType.WEIGHT: HealthDataUnit.KILOGRAMS,
  HealthDataType.DISTANCE_WALKING_RUNNING: HealthDataUnit.METERS,
  HealthDataType.FLIGHTS_CLIMBED: HealthDataUnit.COUNT,
  HealthDataType.MOVE_MINUTES: HealthDataUnit.MINUTES,
  HealthDataType.DISTANCE_DELTA: HealthDataUnit.METERS,

  HealthDataType.WATER: HealthDataUnit.LITER,
  HealthDataType.SLEEP_IN_BED: HealthDataUnit.MINUTES,
  HealthDataType.SLEEP_ASLEEP: HealthDataUnit.MINUTES,
  HealthDataType.SLEEP_AWAKE: HealthDataUnit.MINUTES,
  HealthDataType.MINDFULNESS: HealthDataUnit.MINUTES,
  HealthDataType.EXERCISE_TIME: HealthDataUnit.MINUTES,
  HealthDataType.WORKOUT: HealthDataUnit.MINUTES,

  HealthDataType.HEADACHE_NOT_PRESENT: HealthDataUnit.MINUTES,
  HealthDataType.HEADACHE_MILD: HealthDataUnit.MINUTES,
  HealthDataType.HEADACHE_MODERATE: HealthDataUnit.MINUTES,
  HealthDataType.HEADACHE_SEVERE: HealthDataUnit.MINUTES,
  HealthDataType.HEADACHE_UNSPECIFIED: HealthDataUnit.MINUTES,

  // Heart Rate events (specific to Apple Watch)
  HealthDataType.HIGH_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.LOW_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: HealthDataUnit.NO_UNIT,
  HealthDataType.HEART_RATE_VARIABILITY_SDNN: HealthDataUnit.MILLISECONDS,
};

const HealthDataTypeJsonValue = {
  HealthDataType.ACTIVE_ENERGY_BURNED: 'active_energy_burned',
  HealthDataType.AUDIOGRAM: 'audiogram',
  HealthDataType.BASAL_ENERGY_BURNED: 'basal_energy_burned',
  HealthDataType.BLOOD_GLUCOSE: 'blood_glucose',
  HealthDataType.BLOOD_OXYGEN: 'blood_oxygen',
  HealthDataType.BLOOD_PRESSURE_DIASTOLIC: 'blood_pressure_diastolic',
  HealthDataType.BLOOD_PRESSURE_SYSTOLIC: 'blood_pressure_systolic',
  HealthDataType.BODY_FAT_PERCENTAGE: 'body_fat_percentage',
  HealthDataType.BODY_MASS_INDEX: 'body_mass_index',
  HealthDataType.BODY_TEMPERATURE: 'body_temperature',
  HealthDataType.HEART_RATE: 'heart_rate',
  HealthDataType.HEART_RATE_VARIABILITY_SDNN: 'heart_rate_variability_sdnn',
  HealthDataType.HEIGHT: 'height',
  HealthDataType.RESTING_HEART_RATE: 'resting_heart_rate',
  HealthDataType.STEPS: 'steps',
  HealthDataType.WAIST_CIRCUMFERENCE: 'waist_circumference',
  HealthDataType.WALKING_HEART_RATE: 'walking_heart_rate',
  HealthDataType.WEIGHT: 'weight',
  HealthDataType.DISTANCE_WALKING_RUNNING: 'distance_walking_running',
  HealthDataType.FLIGHTS_CLIMBED: 'flights_climbed',
  HealthDataType.MOVE_MINUTES: 'move_minutes',
  HealthDataType.DISTANCE_DELTA: 'distance_delta',
  HealthDataType.MINDFULNESS: 'mindfulness',
  HealthDataType.WATER: 'water',
  HealthDataType.SLEEP_IN_BED: 'sleep_in_bed',
  HealthDataType.SLEEP_ASLEEP: 'sleep_asleep',
  HealthDataType.SLEEP_AWAKE: 'sleep_awake',
  HealthDataType.HIGH_HEART_RATE_EVENT: 'high_heart_rate_event',
  HealthDataType.LOW_HEART_RATE_EVENT: 'low_heart_rate_event',
  HealthDataType.IRREGULAR_HEART_RATE_EVENT: 'irregular_heart_rate_event',
  HealthDataType.ELECTRODERMAL_ACTIVITY: 'electrodermal_activity',
  HealthDataType.EXERCISE_TIME: 'exercise_time',
  HealthDataType.WORKOUT: 'workout',
  HealthDataType.HEADACHE_NOT_PRESENT: 'headache_not_present',
  HealthDataType.HEADACHE_MILD: 'headache_mild',
  HealthDataType.HEADACHE_MODERATE: 'headache_moderate',
  HealthDataType.HEADACHE_SEVERE: 'headache_severe',
  HealthDataType.HEADACHE_UNSPECIFIED: 'headache_unspecified',
};

const HealthDataUnitJsonValue = {
  HealthDataUnit.DECIBEL_HEARING_LEVEL: 'decibel_hearing_level',
  HealthDataUnit.BEATS_PER_MINUTE: 'beats_per_minute',
  HealthDataUnit.CALORIES: 'calories',
  HealthDataUnit.COUNT: 'count',
  HealthDataUnit.DEGREE_CELSIUS: 'degree_celsius',
  HealthDataUnit.KILOGRAMS: 'kilograms',
  HealthDataUnit.GRAMS: 'grams',
  HealthDataUnit.METERS: 'meters',
  HealthDataUnit.MILLIGRAM_PER_DECILITER: 'milligram_per_deciliter',
  HealthDataUnit.MILLIMETER_OF_MERCURY: 'millimeter_of_mercury',
  HealthDataUnit.MILLISECONDS: 'milliseconds',
  HealthDataUnit.MINUTES: 'minutes',
  HealthDataUnit.NO_UNIT: 'no_unit',
  HealthDataUnit.PERCENTAGE: 'percentage',
  HealthDataUnit.SIEMENS: 'siemens',
  HealthDataUnit.UNKNOWN_UNIT: 'unknown_unit',
  HealthDataUnit.LITER: 'liter',
};

const PlatformTypeJsonValue = {
  PlatformType.IOS: 'ios',
  PlatformType.ANDROID: 'android'
};

/// List of all [HealthDataPoint] units.
enum HealthDataUnit {
  DECIBEL_HEARING_LEVEL,
  BEATS_PER_MINUTE,
  CALORIES,
  COUNT,
  DEGREE_CELSIUS,
  GRAMS,
  KILOGRAMS,
  METERS,
  MILLIGRAM_PER_DECILITER,
  MILLIMETER_OF_MERCURY,
  MILLISECONDS,
  MINUTES,
  NO_UNIT,
  PERCENTAGE,
  SIEMENS,
  UNKNOWN_UNIT,
  LITER,
}
