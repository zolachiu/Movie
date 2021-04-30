//
//  MovieController.swift
//  Movie
//
//  Created by Peiru Chiu on 2021/4/30.
//

import Foundation
struct MovieController {
    static let shared = MovieController()
    var baseUrlString = "https://api.airtable.com/v0/appYZwCuz5lum6K3K/Movie"
    var baseRequest = URLRequest(url: URL(string: "https://api.airtable.com/v0/appYZwCuz5lum6K3K/Movie")!)
    
    func uploadData(with movieBody: ResponseData, completionHandler: @escaping(Bool?) -> Void) {
        var request = baseRequest
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.string(from: Date())
        encoder.dateEncodingStrategy = .formatted(formatter)
        request.httpBody = try? encoder.encode(movieBody)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print("Upload successfully")
                print(content)
                completionHandler(true)
            }else if error != nil{
                print("Upload failed")
                completionHandler(false)
            }
        }.resume()
    }
    func editData(with movieBody: ResponseData, completionHandler: @escaping(Bool?) -> Void) {
        var request = baseRequest
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.string(from: Date())
        encoder.dateEncodingStrategy = .formatted(formatter)
        request.httpBody = try? encoder.encode(movieBody)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("\(error?.localizedDescription)")
            }
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print("udpate success")
                print(content)
                completionHandler(true)
            }
            else{
                print("update failed")
                completionHandler(false)
            }
        }.resume()
    }
    func deleteData(with id: String, completionHandler: @escaping(Bool?) -> Void) {
        
        var deleteUrlString = baseUrlString
        deleteUrlString += "/\(id)"
        print(deleteUrlString)
        var request = URLRequest(url: URL(string: deleteUrlString)!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        let deleteitem = deletedata(id: id, deleted: true)
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(deleteitem)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("\(error?.localizedDescription)")
            }
            if let data = data,
            let content = String(data: data, encoding: .utf8) {
                print("Delete successfully")
                print(content)
                
                completionHandler(true)
                
            }else{
                print("Delete failed")
                completionHandler(false)
            }
            
        }.resume()
    }
 
    
}
