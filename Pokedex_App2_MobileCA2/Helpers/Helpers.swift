//
//  Helpers.swift
//  Pokedex_App2_MobileCA2
//
//  Created by Student on 17/05/2023.
//Where helper functions will go

import Foundation

extension Bundle{
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            let loadedData = try decoder.decode(T.self, from: data)
            return loadedData
        } catch {
            print("Decoding failed with error: \(error)")
            fatalError("Could not decode \(file) from bundle.")
        }
    }
    
    func fetchData<T: Decodable>(url: String, model: T.Type, completion:@escaping(T) -> (), failure:@escaping(Error) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                // If there is an error, return the error.
                if let error = error { failure(error) }
                return }
            
            do {
                let serverData = try JSONDecoder().decode(T.self, from: data)
                // Return the data successfully from the server
                completion((serverData))
            } catch {
                // If there is an error, return the error.
                failure(error)
            }
        }.resume()
    }
    
    
}
