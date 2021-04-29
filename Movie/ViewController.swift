//
//  ViewController.swift
//  Movie
//
//  Created by Peiru Chiu on 2021/4/18.
//

import UIKit

private let reuseIdentifier = "MovieCollectionViewCell"
public let apiKey = "keyqPvP8mSgdHcmPh"
class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var movieCollectionViewFlowLayout: UICollectionViewFlowLayout!
    let urlStr = "https://api.airtable.com/v0/appYZwCuz5lum6K3K/Movie"
    var movieData: Array<Record> = []
    

    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setCell()
        fetchData(urlStr: urlStr) { (movieData) in
            guard let movieData = movieData else { return }
            Record.saveToFile(records: movieData)
        }
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                print(content)
                
            }
        }.resume()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        movieCollectionView.alwaysBounceVertical = true
        movieCollectionView.refreshControl = refreshControl


    }
    @objc
    private func didPullToRefresh(_ sender: Any) {
        fetchData(urlStr: urlStr) { (movieData) in
            guard let movieData = movieData else { return }
            Record.saveToFile(records: movieData)
        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        
        
        let alert = UIAlertController(title: "Add New Movie", message: nil, preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.placeholder = "movie name"
            textField.keyboardType = UIKeyboardType.default
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "imdb"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "release date:XXXX-XX-XX"
            textField.keyboardType = UIKeyboardType.default
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "genre"
            textField.keyboardType = UIKeyboardType.default
        }

        alert.addTextField{ (textField) in
            textField.placeholder = "image"
            textField.keyboardType = UIKeyboardType.URL
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "rank"
            textField.keyboardType = UIKeyboardType.numberPad
        }

        let okAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var name: String = ""
            var imdb : Double = 0.0
            var releasedate :Date
            var genre = [String]()
            var imageurl : String
            var rank : Int = 0
            
            name = (alert.textFields?[0].text)!
            imdb = Double((alert.textFields?[1].text)!) ?? 0.0
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            releasedate = dateFormatter.date(from: (alert.textFields?[2].text)!)!
            genre = ((alert.textFields?[3].text)?.components(separatedBy: " "))!
            imageurl = (alert.textFields?[4].text)!
            rank = Int((alert.textFields?[5].text)!)!
    
            let movieBody = ResponseData(records: [.init(id: nil,fields: .init(genre: genre, name: name, imdb: imdb, image: [.init(id: nil,url: imageurl)], releaseDate: releasedate, rank: rank))])
            
            
            let url = URL(string: "https://api.airtable.com/v0/appYZwCuz5lum6K3K/Movie")!
            var request = URLRequest(url: url)
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            formatter.string(from: Date())
            encoder.dateEncodingStrategy = .formatted(formatter)
            request.httpBody = try? encoder.encode(movieBody)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data,
                   let content = String(data: data, encoding: .utf8) {
                    print(content)
                }
            }.resume()
        }

        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.movieNameLabel.text = movieData[indexPath.item].fields.name
        cell.movieImageView.image = nil
        if let imageUrl = URL(string: movieData[indexPath.item].fields.image[0].url!) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.movieImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell
    }
    func setCell() {
        movieCollectionViewFlowLayout.itemSize = CGSize(width: 125, height: 180)
        movieCollectionViewFlowLayout.estimatedItemSize = .zero
        movieCollectionViewFlowLayout.minimumInteritemSpacing = 0
        movieCollectionViewFlowLayout.minimumLineSpacing = 0
    }

    // MARK: 下載電影資料
    func fetchData(urlStr: String, completionHandler: @escaping ([Record]?) -> Void) {
        print("fetch data...")
        
        let url = URL(string: urlStr+"?sort[][field]=rank")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "Get"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            if let data = data {
                do {
                    let result = try decoder.decode(ResponseData.self, from: data)
                    print("decode success")
                    self.movieData = result.records
                    completionHandler(result.records)
                    
                    DispatchQueue.main.async {
                        self.movieCollectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    // MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMovieDetail"{
            if let cell = sender as? MovieCollectionViewCell,
                let indexPath = movieCollectionView.indexPath(for: cell),
                let destinationController = segue.destination as? MovieDetailViewController{
                
                destinationController.movieDetailData = movieData[indexPath.row]
            }
   
            }
        }
}
