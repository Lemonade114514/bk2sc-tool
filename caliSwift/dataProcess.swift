//
//  dataProcess.swift
//  caliSwift
//
//  Created by Lemonade on 2026/5/22.
//
import Foundation


struct para {
    var allCount = 0
    let _4958Drop = 7   ;   let _4958Pre = 78  ;   let _4958AxRow = 2
    let _4989Drop = 9   ;   let _4989Pre = 85  ;   let _4989AxRow = 5
}
var param = para()


// MARK: -splitData
func splitData(input:String, key:String) -> String {
    let parts = input.components(separatedBy: ",")
    let remaining: ArraySlice<String> = {
        switch key {
        case "4958-A":
            return parts.dropFirst(param._4958Drop).prefix(param._4958Pre)
        case "4989-A":
            return parts.dropFirst(param._4989Drop).prefix(param._4989Pre)
        default:
            print("UNDEFINE MIC TYPE")
            return []
        }
    }()
    let output = remaining.joined(separator: ",")
    
    return output
}


// MARK: -makeFileDataset
func makeFileDataset(raw:[String], fileName:String) -> ([String:String]) {
    // 1. check data volume
    guard raw.count > 3 else {
        print("ERROR: FILE HAVE NO ENOUGH DATA ROWS")
        return ([:])
    }
    
    // 2. get mic type
    var micType:String
    var axisRow:Int
    if fileName.contains("4989") {
        micType = "4989-A"
        axisRow = param._4989AxRow
    } else if fileName.contains("4958"){
        micType = "4958-A"
        axisRow = param._4958AxRow
    } else {
        print("UNDEFINE MIC TYPE")
        return ([:])
    }
    
    // 3. get axis
    var result = [String:String]()
    let axis = splitData(input:raw[axisRow], key:micType)
    result["axis"] = axis
    
    // 4. get data
    let filtered = raw.filter { row in
        let first = row.components(separatedBy: ",")[0] // first unit
        guard !first.isEmpty
            else { return false }  // cant be nil
        guard first.allSatisfy({ ("0"..."9").contains($0) })
            else { return false }  // all number
        return true
    }
    
    let denominator = filtered.count
    var numerator = 1
    for row in filtered {
        let data = row.components(separatedBy: ",")
        let key = data[0]
        let value = splitData(input: row, key: micType)
        
        result[key] = value
        let vel = percentString(from: numerator, denominator: denominator)
        print("\u{001B}[2K\rgetting data (\(vel)): SN: \(key)", terminator: "")
        fflush(stdout)
        numerator += 1
        param.allCount += 1
    }
    print("\u{001B}[2K\rOK")
    fflush(stdout)
    return result
}
