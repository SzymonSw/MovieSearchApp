//
//  FilesHelper.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 24/01/2021.
//

import Foundation

class FilesHelper {
    static func jsonDataFromFile(filename: String) -> Data? {
        guard let jsonPath = Bundle.main.path(forResource: filename, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe) else {
            return nil
        }
        return data
        
    }
    
    static func jsonRawFromFile(filename: String) -> [String: Any]? {
        guard let schemaData = FilesHelper.jsonDataFromFile(filename: filename), let jsonRaw = try? JSONSerialization.jsonObject(with: schemaData) as? [String: Any] else {
            return nil
        }
        return jsonRaw
        
    }
    
}
