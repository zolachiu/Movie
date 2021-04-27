//
//  MovieDetailViewController.swift
//  Movie
//
//  Created by Peiru Chiu on 2021/4/26.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var data = ResponseData(records: [])
    var movieDetailData = Record(fields: .init(genre: [], name: "", imdb: 0.0, image: [.init(url: "")], releaseDate: Date(), rank: 0))
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releasedate: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var imdb: UILabel!
    @IBOutlet weak var rank: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageUrl = URL(string: movieDetailData.fields.image[0].url) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.ImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        let genrestring = movieDetailData.fields.genre
        name.text = movieDetailData.fields.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        releasedate.text = dateFormatter.string(from: movieDetailData.fields.releaseDate)
        genre.text = genrestring.joined(separator: " ")
        imdb.text = String(movieDetailData.fields.imdb!)
        rank.text = String(movieDetailData.fields.rank!)
        
    }
//
//    @IBAction func editItem(_ sender: UIBarButtonItem) {
//        let alert = UIAlertController(title: "Edit Movie Data", message: nil, preferredStyle: .alert)
//
//        alert.addTextField{ [self] (textField) in
//            textField.placeholder = "movie name"
//            textField.text = self.movieDetailData.fields.name
//            textField.keyboardType = UIKeyboardType.default
//            movieDetailData.fields.name = textField.text!
//        }
//        alert.addTextField{ [self] (textField) in
//            textField.placeholder = "imdb"
//            textField.text = String(self.movieDetailData.fields.imdb!)
//            textField.keyboardType = UIKeyboardType.decimalPad
//            movieDetailData.fields.imdb = Double(textField.text!)
//        }
//        alert.addTextField{ [self] (textField) in
//
//            textField.placeholder = "release date:XXXX-XX-XX"
//            textField.text = String(self.movieDetailData.fields.releaseDate)
//            textField.keyboardType = UIKeyboardType.default
//            movieDetailData.fields.releaseDate = Date(from: textField.text)
//
//        }
//        alert.addTextField{ [self] (textField) in
//            textField.placeholder = "genre"
//            textField.text = String(self.movieDetailData.fields.genre.joined(separator: " "))
//            textField.keyboardType = UIKeyboardType.default
//            movieDetailData.fields.genre = [textField.text!]
//        }
//
//        alert.addTextField{ [self] (textField) in
//            textField.placeholder = "image"
//            textField.text = String(self.movieDetailData.fields.image[0].url)
//            textField.keyboardType = UIKeyboardType.URL
//            movieDetailData.fields.image[0].url = textField.text!
//        }
//        alert.addTextField{ [self] (textField) in
//            textField.placeholder = "rank"
//            textField.text = String(self.movieDetailData.fields.rank!)
//            textField.keyboardType = UIKeyboardType.numberPad
//            movieDetailData.fields.rank = Int(textField.text!)
//        }
//
//
//        let okAction = UIAlertAction(title: "Edit", style: .default) { [self] (_) in
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let movieBody = MovieBody(records: [.init(fields: .init(name:  (alert.textFields?[0].text!)!, imdb: Double((alert.textFields?[1].text!)!), releaseDate: formatter.date(from: (alert.textFields?[2].text!)!)!, genre: [(alert.textFields?[3].text!)!], image: [.init(url: URL(string: (alert.textFields?[4].text!)!)!)],rank: Int( (alert.textFields?[5].text!)!
//)))])
//
////            let fields = Fields(name: (alert.textFields?[0].text!)!, imdb: Double((alert.textFields?[1].text!)!), releaseDate: formatter.date(from: (alert.textFields?[2].text!)!)!, genre: [(alert.textFields?[3].text!)!], image: [.init(url: URL(string: (alert.textFields?[4].text!)!)!)], rank: Int( (alert.textFields?[5].text!)!
////            ))
//
//            let url = URL(string: "https://api.airtable.com/v0/appYZwCuz5lum6K3K/Movie/\(self.movieDetailData.id)")!
//            print(url)
//            var request = URLRequest(url: url)
//            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//            request.httpMethod = "PATCH"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let encoder = JSONEncoder()
//            formatter.string(from: Date())
//            encoder.dateEncodingStrategy = .formatted(formatter)
//            request.httpBody = try? encoder.encode(movieBody)
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                if let data = data,
//                   let content = String(data: data, encoding: .utf8) {
//                    print(content)
//                }
//            }.resume()
//
//        }
//        alert.addAction(okAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
//    }
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
