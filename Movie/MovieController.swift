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
    
    //MARK: 新增電影資料
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
            
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200{
                    print("upload successfully")
                    completionHandler(true)
                }else{
                    print(response.statusCode)
                    print("upload failed")
                    completionHandler(false)
                }
            }
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
        }.resume()
    }
    //MARK: 修改電影資料
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
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200{
                    print("upload successfully")
                    completionHandler(true)
                }else{
                    print(response.statusCode)
                    print("upload failed")
                    completionHandler(false)
                }
            }
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
            }
        }.resume()
    }
    //MARK: 刪除電影資料
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
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200{
                    print("delete successfully")
                    completionHandler(true)
                }else{
                    print(response.statusCode)
                    print("delete failed")
                    completionHandler(false)
                }
            }
            if let data = data,
            let content = String(data: data, encoding: .utf8) {
                print(content)
            }
        }.resume()
    }
 
    
}
