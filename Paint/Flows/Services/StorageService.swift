//
//  StorageService.swift
//  Paint
//
//  Created by Илья Мудрый on 28.07.2021.
//

import Foundation
import UIKit

struct StorageService {
    
    // MARK: Save
    
    public func save(drawing: Drawing) {
        guard let directoryPath = documentDirectoryPath() else { return }
        let filePath = directoryPath.appendingPathComponent(drawing.name + ".png")
        do {
            try drawing.imageData.write(to: filePath)
        } catch let error {
            print("Save to file system error: ", error)
        }
    }
    
    // MARK: Restore
    
    public func restoreImages() -> [Drawing] {
        if let filePath = documentDirectoryPath() {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: filePath.path)
                var drawings = [Drawing]()
                #warning("сделать кастомную проверку на расширение файла")
                files
                    .filter { $0.hasSuffix(".png") || $0.hasSuffix(".jpg") || $0.hasSuffix(".jpeg")}
                    .forEach { path in
                        guard let directoryPath = documentDirectoryPath() else { return }
                        let filePath = directoryPath.appendingPathComponent(path)
                        guard let fileData = FileManager.default.contents(atPath: filePath.path) else { return }
                        drawings.append(Drawing(name: filePath.deletingPathExtension().lastPathComponent,
                                                imageData: fileData))
                    }
                return drawings.sorted { $0.name > $1.name}
            } catch let error {
                print("Reading error: ", error)
            }
        }
        return [Drawing]()
    }
    
    // MARK: Helper path
    private func documentDirectoryPath() -> URL? {
        let urls = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        guard let path = urls.first else { return nil }
        return path
    }
    
    public func count() -> Int {
        if let filePath = documentDirectoryPath() {
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: filePath.path)
                return files.filter { $0.hasSuffix(".png") }.count
            }
            catch let error {
                print("Reading path error: ", error)
            }
        }
        return 0
    }
}
