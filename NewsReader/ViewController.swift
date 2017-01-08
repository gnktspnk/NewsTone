//
//  ViewController.swift
//  NewsReader
//
//  Created by Gennadii Tsypenko on 04.01.17.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    
    var articles:[Article]? = []
    var source = "hacker-news"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchArticles(from: source)
        
    }
    
    func fetchArticles(from source: String){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=\(source)&sortBy=top&apiKey=3b989271fc51492bae29e48f67ced5a1")!)
        
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String:AnyObject]] {
                    
                    self.sourceLabel.text = source
                    
                    
                    for x in articlesFromJson{
                        let article = Article()
                        
                        if let title = x["title"] as? String,
                           let author = x["author"] as? String,
                           let desc = x["description"] as? String,
                           let url = x["url"] as? String,
                           let image = x["urlToImage"] as? String {
                            
                            article.headline = title
                            article.author = author
                            article.desc = desc
                            article.url = url
                            article.urlToImage = image
                            
                            self.articles?.append(article)
                        }
                        
                        
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch let error{
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "article", for: indexPath ) as! ArticleCell
        
        cell.title.text = articles?[indexPath.item].headline
        cell.desc.text = articles?[indexPath.item].desc
        cell.author.text = articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (articles?[indexPath.item].urlToImage)!)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
        
    }
    
    let menuManager = MenuManager()
    @IBAction func menuPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    
}


extension UIImageView{
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){(data, response, error) in
        
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        
        }
        
        task.resume()
    }
    
}

