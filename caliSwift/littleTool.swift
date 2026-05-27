//
//  littleTool.swift
//  caliSwift
//
//  Created by Lemonade on 2026/5/23.
//
import Foundation

func percentString(from numerator: Int, denominator: Int) -> String {
    guard denominator != 0 else { return "0.0%" } // 避免除以零
    let percent = Double(numerator) / Double(denominator) * 100.0 // 转为 Double 计算百分数
    
    let _output = String(format: "%.1f%%", percent)
    let output = "\u{001B}[1;31m\(_output)\u{001B}[0m"
    return output// 四舍五入保留一位小数
}


func resizeTerminal(rows: Int, cols: Int) {
    print("\u{001B}[8;\(rows);\(cols)t", terminator: "")
    fflush(stdout)
}


func quickLookImage(at path: String) {
    let process = Process()
    process.launchPath = "/usr/bin/qlmanage"
    process.arguments = ["-p", path]
    process.launch()
}

var stepCount = 1
func mark(printting: String, blankRow: Int){
    let blankString = String(repeating: "\n", count: blankRow)
    print("\(blankString)\u{001B}[33m---------- \(stepCount). \(printting) ----------\u{001B}[0m")
    stepCount += 1
}


func clearScreen() {
    let process = Process()
    process.launchPath = "/usr/bin/clear"   // clear 命令的路径
    process.arguments = []                  // 无需参数
    process.launch()
    process.waitUntilExit()
}


