//
//  StorageService.swift
//  Paint
//
//  Created by Илья Мудрый on 28.07.2021.
//

import Foundation
import UIKit

struct StorageService {
    
    // MARK: Helper
    
    private struct Documents {
        static var path: URL {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[0]
        }
        
        static var files: [String] {
            let filePath = Documents.path
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: filePath.path)
                return files.filter { $0.hasSuffix(".png") || $0.hasSuffix(".jpg") || $0.hasSuffix(".jpeg") }
            } catch let error {
                print("Reading files error: ", error)
                return [String]()
            }
        }
    }
    
    // MARK: Save
    
    func save(drawing: Drawing, completion: () -> ()) {
        let filePath = Documents.path.appendingPathComponent(drawing.name + ".png")
        do {
            try drawing.imageData.write(to: filePath)
            completion()
        } catch let error { print("Saving file to \"Documents\" error: ", error) }
    }
    
    // MARK: Restore
    
    func restoreImages(completion: ([Drawing]) -> ()) {
        var drawings = [Drawing]()
        Documents.files.forEach { path in
            let filePath = Documents.path.appendingPathComponent(path)
            guard let fileData = FileManager.default.contents(atPath: filePath.path) else { return }
            drawings.append(Drawing(name: filePath.deletingPathExtension().lastPathComponent, imageData: fileData))
        }
        // TODO: Сортировку по дате изменения
        #warning("Сделать сортировку по дате изменения")
        completion(drawings.sorted { $0.name > $1.name })
    }
    
    // MARK: Count
    
    func count() -> Int {
        return Documents.files.count
    }
}
