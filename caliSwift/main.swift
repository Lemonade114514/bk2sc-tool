import Foundation

resizeTerminal(rows: 60, cols: 75)

// MARK: - 1. find folder
print("\n\n---------- scanning ----------")
let keywords = ["4958A.csv",
                "4989A.csv"]
let urls = findCsvInFolder(keywords: keywords)


// MARK: - 2. read csv
let start = Date()
var rawData = [String: [String]]()
var dataSets = [String: Dictionary<String, Any>]()
for (index,url) in urls.enumerated(){
    let fileName = url.path.components(separatedBy: "/").last ?? ""
    print("\n---------- reading data \(index+1)/\(urls.count): \(fileName) ----------")
    let raw = csvReader(url: url)
    rawData[fileName] = raw
    

    // MARK: - 3. split data
    let result = makeFileDataset(raw: raw, fileName: fileName)
    dataSets[fileName] = result
}


// MARK: - 4. make saving file/data
print("\n\n---------- exporting ----------")
var exportCount = 1
if let folder = mkdirOnDesktop("Calibration") {
    print("Output Folder：\(folder.path)")
    
    for (micType, dataset) in dataSets{
        for data in dataset{
            let saveAxis_ = dataset["axis"] as! String
            let saveAxis = saveAxis_.replacingOccurrences(of: ",", with: "\t")
            
            if data.key != "axis"{
                let saveData = (data.value as AnyObject).replacingOccurrences(of: ",", with: "\t")
                let saving = saveAxis + "\t\n" + saveData + "\t\n"
                
                // MARK: - 5. save data
                let fileURL = folder.appendingPathComponent("\(data.key).txt")
                try? saving.write(to: fileURL, atomically: true, encoding: .utf8)
                let exportPercent = percentString(from: exportCount, denominator: param.allCount)
                print("\u{001B}[2K\r(\(exportPercent)) Saving: \(data.key).txt", terminator: "")
                fflush(stdout)
                exportCount += 1
            }
        }
    }
}
print("\n\n---------- complete ----------")
let elapsed = Date().timeIntervalSince(start)
print(String(format: "⏱ 总耗时：\u{001B}[1;31m%.3f\u{001B}[0m 秒", elapsed))
