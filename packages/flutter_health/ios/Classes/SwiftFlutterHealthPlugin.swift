import Flutter
import UIKit
import HealthKit

public class SwiftFlutterHealthPlugin: NSObject, FlutterPlugin {
    
    let healthStore = HKHealthStore()
    var healthDataTypes = [HKSampleType]()
    var heartRateEventTypes = Set<HKSampleType>()
    var allDataTypes = Set<HKSampleType>()
    var dataTypesDict: [String: HKSampleType] = [:]
    var unitDict: [String: HKUnit] = [:]

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_health", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterHealthPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func checkIfHealthDataAvailable(call: FlutterMethodCall, result: @escaping FlutterResult) {
      result(HKHealthStore.isHealthDataAvailable())
  }

  func requestAuthorization(call: FlutterMethodCall, result: @escaping FlutterResult) {
      if #available(iOS 11.0, *) {
            healthStore.requestAuthorization(toShare: nil, read: allDataTypes) { (success, error) in
                result(success)
            }
        } 
        else {
            result(false)// Handle the error here.
        }
  }

  func getData(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? NSDictionary
    let dataTypeKey = (arguments?["dataTypeKey"] as? String) ?? "DEFAULT"

    let index = (arguments?["index"] as? Int) ?? -1
    let startDate = (arguments?["startDate"] as? NSNumber) ?? 0
    let endDate = (arguments?["endDate"] as? NSNumber) ?? 0
    let dateFrom = Date(timeIntervalSince1970: startDate.doubleValue / 1000)
    let dateTo = Date(timeIntervalSince1970: endDate.doubleValue / 1000)

    if (index >= 0 && index < healthDataTypes.count) {
        
        let dataType_ = dataTypesDict[dataTypeKey]
        let dataType = healthDataTypes[index]
        let predicate = HKQuery.predicateForSamples(withStart: dateFrom, end: dateTo, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)

        let query = HKSampleQuery(sampleType: dataType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) {
            x, samplesOrNil, error in
            
            guard let samples = samplesOrNil as? [HKQuantitySample] else {
                result(FlutterError(code: "FlutterHealth", message: "Results are null", details: error))
                return
            }

            if(samples != nil){
            result(samples.map { sample -> NSDictionary in
                let unit = self.unitFromDartType(type: index)
                return [
                    "value": sample.quantity.doubleValue(for: unit),
                    "unit": unit.unitString,
                    "date_from": Int(sample.startDate.timeIntervalSince1970 * 1000),
                    "date_to": Int(sample.endDate.timeIntervalSince1970 * 1000),
                ]
            })
            } else {
                print("Either there are no values or the user did not allow getting this value")
                result("Either there are no values or the user did not allow getting this value")
            }
            return
        }
        HKHealthStore().execute(query)
    } 
    else {
        print("Something wrong with request")
        result("Unsupported version or data type")
    }
    print("Unsupported version")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // Set up all data types
    initializeTypes()
    
    /// Handle checkIfHealthDataAvailable
    if(call.method.elementsEqual("checkIfHealthDataAvailable")){
        checkIfHealthDataAvailable(call: call, result: result)
    }
    /// Handle requestAuthorization
    else if(call.method.elementsEqual("requestAuthorization")){
        requestAuthorization(call: call, result: result)
    }

    /// Handle getData
    else if(call.method.elementsEqual("getData")){
        getData(call: call, result: result)
    }
    
  }
    func initializeTypes() {

        // Set up iOS 11 specific types (ordinary health data types)
        if #available(iOS 11.0, *) { 
            dataTypesDict["bodyFatPercentage"] = HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!
            dataTypesDict["height"] = HKSampleType.quantityType(forIdentifier: .height)!
            dataTypesDict["bodyMassIndex"] = HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!
            dataTypesDict["waistCircumference"] = HKSampleType.quantityType(forIdentifier: .waistCircumference)!
            dataTypesDict["stepCount"] = HKSampleType.quantityType(forIdentifier: .stepCount)!
            dataTypesDict["basalEnergyBurned"] = HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!
            dataTypesDict["activeEnergyBurned"] = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
            dataTypesDict["heartRate"] = HKSampleType.quantityType(forIdentifier: .heartRate)!
            dataTypesDict["bodyTemperature"] = HKSampleType.quantityType(forIdentifier: .bodyTemperature)!
            dataTypesDict["bloodPressureSystolic"] = HKSampleType.quantityType(forIdentifier: .bloodPressureSystolic)!
            dataTypesDict["bloodPressureDiastolic"] = HKSampleType.quantityType(forIdentifier: .bloodPressureDiastolic)!
            dataTypesDict["restingHeartRate"] = HKSampleType.quantityType(forIdentifier: .restingHeartRate)!
            dataTypesDict["walkingHeartRateAverage"] = HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!
            dataTypesDict["oxygenSaturation"] = HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!
            dataTypesDict["bloodGlucose"] = HKSampleType.quantityType(forIdentifier: .bloodGlucose)!
            dataTypesDict["electrodermalActivity"] = HKSampleType.quantityType(forIdentifier: .electrodermalActivity)!
            dataTypesDict["bodyMass"] = HKSampleType.quantityType(forIdentifier: .bodyMass)!

            healthDataTypes = [
                    HKSampleType.quantityType(forIdentifier: .bodyFatPercentage)!,
                    HKSampleType.quantityType(forIdentifier: .height)!,
                    HKSampleType.quantityType(forIdentifier: .bodyMassIndex)!,
                    HKSampleType.quantityType(forIdentifier: .waistCircumference)!,
                    HKSampleType.quantityType(forIdentifier: .stepCount)!,
                    HKSampleType.quantityType(forIdentifier: .basalEnergyBurned)!,
                    HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!,
                    HKSampleType.quantityType(forIdentifier: .heartRate)!,
                    HKSampleType.quantityType(forIdentifier: .bodyTemperature)!,
                    HKSampleType.quantityType(forIdentifier: .bloodPressureSystolic)!,
                    HKSampleType.quantityType(forIdentifier: .bloodPressureDiastolic)!,
                    HKSampleType.quantityType(forIdentifier: .restingHeartRate)!,
                    HKSampleType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
                    HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!,
                    HKSampleType.quantityType(forIdentifier: .bloodGlucose)!,
                    HKSampleType.quantityType(forIdentifier: .electrodermalActivity)!,
                    HKSampleType.quantityType(forIdentifier: .bodyMass)!,
                    ]
        }
        // Set up heart rate data types specific to the apple watch, requires iOS 12
        if #available(iOS 12.2, *){
            dataTypesDict["highHeartRateEvent"] = HKSampleType.categoryType(forIdentifier: .highHeartRateEvent)!
            dataTypesDict["lowHeartRateEvent"] = HKSampleType.categoryType(forIdentifier: .lowHeartRateEvent)!
            dataTypesDict["irregularHeartRhythmEvent"] = HKSampleType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!

            heartRateEventTypes =  Set([
                HKSampleType.categoryType(forIdentifier: .highHeartRateEvent)!,
                HKSampleType.categoryType(forIdentifier: .lowHeartRateEvent)!,
                HKSampleType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
                ])
        }

        // Concatenate heart events and health data types (both may be empty)
        allDataTypes = Set(heartRateEventTypes + healthDataTypes)
    }
    
    public func unitFromDartType(type: Int) -> HKUnit {
        unitDict["bodyFatPercentage"] = HKUnit.percent()
        unitDict["height"] = HKUnit.meter()
        unitDict["bodyMassIndex"] = HKUnit.init(from: "")
        unitDict["waistCircumference"] = HKUnit.meter()
        unitDict["stepCount"] = HKUnit.count()
        unitDict["basalEnergyBurned"] = HKUnit.kilocalorie()
        unitDict["activeEnergyBurned"] = HKUnit.kilocalorie()
        unitDict["heartRate"] = HKUnit.init(from: "count/min")
        unitDict["bodyTemperature"] = HKUnit.degreeCelsius()
        unitDict["bloodPressureSystolic"] = HKUnit.millimeterOfMercury()
        unitDict["bloodPressureDiastolic"] = HKUnit.millimeterOfMercury()
        unitDict["bodyFatPercentage"] = HKUnit.percent()
        unitDict["restingHeartRate"] = HKUnit.init(from: "count/min")
        unitDict["walkingHeartRateAverage"] = HKUnit.init(from: "count/min")
        unitDict["oxygenSaturation"] = HKUnit.percent()
        unitDict["bloodGlucose"] = HKUnit.init(from: "mg/dl")
        unitDict["electrodermalActivity"] = HKUnit.siemen()
        unitDict["bodyMass"] = HKUnit.gramUnit(with: .kilo)


        guard let unit: HKUnit = {
            switch (type) {
            case 0: // bodyFatPercentage
                return HKUnit.percent()
            case 1: // height
                return HKUnit.meter()
            case 2: // bodyMassIndex
                return HKUnit.init(from: "")
            case 3: // waistCircumference
                return HKUnit.meter()
            case 4: // stepCount
                return HKUnit.count()
            case 5,6: // basalEnergyBurned, activeEnergyBurned
                return HKUnit.kilocalorie()
            case 7, 11, 12: // heartRate, restingHeartRate, walkingHeartRateAverage
                return HKUnit.init(from: "count/min")
            case 8: // bodyTemperature
                return HKUnit.degreeCelsius()
            case 9,10: // bloodPressureSystolic, bloodPressureDiastolic
                return HKUnit.millimeterOfMercury()
            case 13: // oxygenSaturation
                return HKUnit.percent()
            case 14: // bloodGlucose
                return HKUnit.init(from: "mg/dl")
            case 15: // electrodermalActivity
                return HKUnit.siemen()
            case 16: // weight
                return HKUnit.gramUnit(with: .kilo)
            default:
                return HKUnit.count()
            }
            }() else {
                return HKUnit.count()
        }
        return unit
    }
}




