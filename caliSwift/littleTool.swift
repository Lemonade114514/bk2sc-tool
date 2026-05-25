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


