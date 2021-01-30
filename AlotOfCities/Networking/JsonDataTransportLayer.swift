//
//  JsonDataTransportLayer.swift
//  JustCities
//
//  Created by Aly Yakan on 28/01/2021.
//  Copyright © 2021 Aly Yakan. All rights reserved.
//

import Foundation

struct JsonDataTransportLayer: DataTransportLayer {
    func fetch<T>(_ resource: DataResource, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        let workItem = DispatchWorkItem {
            completion(self.readJSONFromFile(fileName: String(describing: resource)))
        }
        DispatchQueue.global().async(execute: workItem)
    }

    private func readJSONFromFile<T: Decodable>(fileName: String) -> Result<T, Error> {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return .failure(DataTramsportLayerError.fileReadingFailed(name: fileName))
        }

        do {
            let fileUrl = URL(fileURLWithPath: path)
            // Getting data from JSON file using the file URL
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
