//
//  MovieData.swift
//  Movie
//
//  Created by Peiru Chiu on 2021/4/18.
//

import Foundation
// 讓 enum conform CaseIterable 這個 protocol 之後，就可以使用 enum.allCases 取得包含所有 case 的 array

struct ResponseData: Codable {
    let records: [Record]
}

struct Record: Codable {
    let id: String?
    var fields: Field
    static func saveToFile(records: [Record]) {
        print("save Movie Data")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(records) {
            // 產生一個UserDefaults物件
            let userDefault = UserDefaults.standard
            userDefault.set(data, forKey: "records")
        }
    }

    static func readMovieDataFromFile() -> [Record]? {
        print("read Movie Data")
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: "records"),
           let records = try? decoder.decode([Record].self, from: data) {
            return records
        } else {
            return nil
        }
    }
}
struct Field: Codable {
    var genre: [String]
    var name: String
    var imdb: Double?
    var image: [MovieImage]
    var releaseDate: Date
    var rank: Int?
    struct MovieImage: Codable {
        var url: String
    }
    
}
struct uploaddata: Codable{
    let id: String
    var fields: Field
}
struct deletedata: Codable{
    let id: String
    var deleted: Bool
}
