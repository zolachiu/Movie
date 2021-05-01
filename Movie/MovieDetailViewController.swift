//
//  MovieDetailViewController.swift
//  Movie
//
//  Created by Peiru Chiu on 2021/4/26.
//

import UIKit

class MovieDetailViewController: UIViewController {
    var data = ResponseData(records: [])
    var movieDetailData = Record(id: nil,fields: .init(genre: [], name: "", imdb: 0.0, image: [.init(id: nil,url: "")], releaseDate: Date(), rank: 0))
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releasedate: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var imdb: UILabel!
    @IBOutlet weak var rank: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageUrl = URL(string: movieDetailData.fields.image[0].url!) {
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
        genre.text = genrestring.joined(separator: ",")
        imdb.text = String(movieDetailData.fields.imdb!)
        rank.text = String(movieDetailData.fields.rank!)
        print(movieDetailData.fields.genre)
        
    }
    @IBAction func editItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Edit Movie Data", message: nil, preferredStyle: .alert)
        
        

        alert.addTextField{ [self] (textField) in
            textField.placeholder = "movie name"
            textField.text = self.movieDetailData.fields.name
            textField.keyboardType = UIKeyboardType.default
            movieDetailData.fields.name = textField.text!
        }
        alert.addTextField{ [self] (textField) in
            textField.placeholder = "imdb"
            textField.text = String(self.movieDetailData.fields.imdb!)
            textField.keyboardType = UIKeyboardType.decimalPad
            movieDetailData.fields.imdb = Double(textField.text!)
        }
        alert.addTextField{ [self] (textField) in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            textField.placeholder = "release date:XXXX-XX-XX"
            textField.text = formatter.string(from: self.movieDetailData.fields.releaseDate)
            textField.keyboardType = UIKeyboardType.default
            movieDetailData.fields.releaseDate = formatter.date(from: textField.text!)!

        }
        alert.addTextField{ [self] (textField) in
            textField.placeholder = "genre"
            textField.text = String(self.movieDetailData.fields.genre.joined(separator: ","))
            textField.keyboardType = UIKeyboardType.default
            movieDetailData.fields.genre = [textField.text!]
        }
        alert.addTextField{ [self] (textField) in
            textField.placeholder = "rank"
            textField.text = String(self.movieDetailData.fields.rank!)
            textField.keyboardType = UIKeyboardType.numberPad
            movieDetailData.fields.rank = Int(textField.text!)
        }

        let okAction = UIAlertAction(title: "Edit", style: .default) { [self] (_) in
            
            let nametext = alert.textFields?[0].text ?? ""
            let imdbtext = alert.textFields?[1].text ?? ""
            let releasedatetext = alert.textFields?[2].text ?? ""
            let genretext = alert.textFields?[3].text ?? ""
            let ranktext = alert.textFields?[4].text ?? ""

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var name: String = ""
            var imdb : Double = 0.0
            var releasedate :Date
            var genre = [String]()
            var rank : Int = 0
            
            
            
            name = nametext
            imdb = Double(imdbtext) ?? 0.0
            releasedate = formatter.date(from: releasedatetext) ?? Date()
            genre = genretext.components(separatedBy: ",")
            rank = Int(ranktext) ?? 0
            
    
            let movieBody = ResponseData(records: [.init(id: movieDetailData.id,fields: .init(genre: genre, name: name, imdb: imdb, image: [.init(id: movieDetailData.fields.image[0].id,url: nil)], releaseDate: releasedate, rank: rank))])
            
            if alert.textFields?[0].text == "" || alert.textFields?[1].text == "" || alert.textFields?[2].text == "" || alert.textFields?[3].text == "" || alert.textFields?[4].text == ""{
                DispatchQueue.main.async {
                    Tool.shared.showAlert(in: self, with: "修改失敗")
                }
                return
                
            }
            
            MovieController.shared.editData(with: movieBody){ (success) in
                guard let success = success else {return}
                if success{
                    DispatchQueue.main.async {
                        Tool.shared.showResultAndToRoot(in: self, with: "修改成功")
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        Tool.shared.showAlert(in: self, with: "修改失敗")
                    }
                }
                
            }

        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func deleteData(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "刪除資料", message: "你確定要刪除資料嗎？", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default) { [self] (_) in
            
            let id = movieDetailData.id
            MovieController.shared.deleteData(with : id!){ (deleted) in
                guard let deleted = deleted else {return}
                if deleted {
                    DispatchQueue.main.async {
                        Tool.shared.showResultAndToRoot(in: self, with: "刪除成功")
                    }
                }else{
                    DispatchQueue.main.async {
                        Tool.shared.showAlert(in: self, with: "刪除失敗")
                    }
                }
                
            }
            
        }
            alert.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            
        }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
