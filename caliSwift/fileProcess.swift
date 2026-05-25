//
//  csvReader.swift
//  caliSwift
//
//  Created by Lemonade on 2026/5/22.
//
import Foundation
import AppKit


// MARK: -findCsvInFolder
func findCsvInFolder(keywords:[String]) -> [URL] {
    // 1. 初始化应用（命令行工具需要，才能弹出窗口）
    let app = NSApplication.shared
    app.setActivationPolicy(.accessory)
    app.activate(ignoringOtherApps: true)

    // 2. 弹出选择文件夹窗口
    let panel = NSOpenPanel()
    panel.canChooseFiles = false
    panel.canChooseDirectories = true
    panel.allowsMultipleSelection = false
    panel.message = "请选择放置csv文件的文件夹"
    panel.prompt = "选择"

    guard panel.runModal() == .OK, let folderURL = panel.url else {
        print("未选择文件夹")
        return []   // 返回空数组表示失败
    }

    // 3. 遍历文件夹，找到所有以 keyword 结尾的文件
    var urls: [URL] = []   // 提前初始化
    for keyword in keywords {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: folderURL,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )

            let matchedFiles = fileURLs.filter { $0.lastPathComponent.hasSuffix(keyword) }

            guard !matchedFiles.isEmpty else {
                print("⚠️ 在 \(folderURL.path) 中没有找到以 '\(keyword)' 结尾的文件")
                return []
            }

            print("📁 在 [\(folderURL.path)] 中找到 \(matchedFiles.count) 个文件: ")
            for url in matchedFiles {
                print(url.path)
            }
            urls += matchedFiles
        } catch {
            print("❌ 读取文件夹失败: \(error.localizedDescription)")
            // urls 已是空数组，无需额外处理
        }
    }

    return urls
}


// MARK: -csvReader
func csvReader(url:URL) -> [String] {
   // 1. 读取文件内容
    guard let content = try? String(contentsOf: url, encoding: .utf8) else {
        print("❌ 无法读取文件")
        exit(1)
    }
    // 2. 简单解析：按行分割，每行再按逗号分割，用制表符对齐打印
    let rows = content.components(separatedBy: .newlines)
        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    
    return rows
}


// MARK: -mkdirOnDesktop
func mkdirOnDesktop(_ name: String) -> URL? {
    // 获取桌面路径，失败则打印并返回 nil
    guard let desk = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else {
        print("ERROR: FAIL TO GET DESKTOP URL")
        return nil
    }

    let url = desk.appendingPathComponent(name)
    let fm = FileManager.default

    // 如果文件夹不存在，尝试创建
    if !fm.fileExists(atPath: url.path) {
        do {
            try fm.createDirectory(at: url, withIntermediateDirectories: false)
        } catch {
            print("ERROR: FAIL TO CREATE FOLDER")
            return nil
        }
    }

    return url
}
