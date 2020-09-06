//
//  NewsAPI.swift
//  NewsPecodePT
//
//  Created by Slavik on 05.09.2020.
//  Copyright © 2020 Me. All rights reserved.
//

import Foundation

class NewsAPI {
    private let apiKey = "74a51281fed54e53b2be7d5c41c3bfda"
    private let baseURL = "https://newsapi.org/v2"
    
    // MARK: - Articles
    
    var articles: [Article] = []
    var totalArticles: Int = 0
    var page: Int = 1
    var isPaginating: Bool = false
    
    func fetchNews(source: String? = nil, paginating: Bool = true, search: String? = nil) {
        print("Fetching news")
        var apiUrl = "\(baseURL)/top-headlines?apiKey=\(apiKey)&pageSize=\(10)&page=\(page)"
        
        if paginating {
            self.isPaginating = true
        }
        
        // Configure api request depends on parameters
        if source == nil {
            apiUrl += "&country=ua"
        } else {
            apiUrl += "&sources=\(source!)"
        }
        if search != nil {
            apiUrl += "&q=\(search ?? "")"
        }
        
        let urlRequest = URLRequest(url: URL(string: apiUrl.encodeUrl)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {
                    
                    self.totalArticles = json["totalResults"] as! Int
                    
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let title = articleFromJson["title"] as? String,
                            let author = articleFromJson["author"] as? String,
                            let desc = articleFromJson["description"] as? String,
                            let url = articleFromJson["url"] as? String,
                            let urlToImage = articleFromJson["urlToImage"] as? String,
                            let source = articleFromJson["source"]?["name"] as? String
                        {
                            article.author = author
                            article.desc = desc
                            article.title = title
                            article.url = url
                            article.urlToImage = urlToImage
                            article.source = source
                        }

                        self.articles.append(article)
                        print(self.articles.count)
                        
                    }
                    
                    self.page += 1
                    
                    if paginating {
                        self.isPaginating = false
                    }
                }
                DispatchQueue.main.async {
                    print("send reload")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableViewReloadData"), object: nil)
                }
                
            } catch let error {
                print(error)
            }
            
            
        }
        
        task.resume()
    }
    
    func clearArticles() {
        articles.removeAll()
        totalArticles = 0
        page = 1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableViewReloadData"), object: nil)
    }
    
    // MARK: - Sources
    
    var categories: [String] = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    var countries: [String] = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
    var sourceParemeters = SourceParameters()
    var sources: [Source] = []
    
    func fetchSources() {
        sources.removeAll()
        
        let apiUrl = "\(baseURL)/sources?apiKey=\(apiKey)&country=\(sourceParemeters.country)&category=\(sourceParemeters.category)"
        
        let urlRequest = URLRequest(url: URL(string: apiUrl.encodeUrl)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            
            if error != nil {
                print(error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let sourcesJson = json["sources"] as? [[String : AnyObject]] {
                    
                    for s in sourcesJson {
                        
                        if let id = s["id"] as? String, let name = s["name"] as? String {
                            
                            let source = Source()
                            
                            source.id = id
                            source.name = name
                            
                            self.sources.append(source)
                        }
                        
                        
                        
                    }
                    
                    print(urlRequest)
                }
                DispatchQueue.main.async {
                    print("send reload sources")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sourcesTableViewReloadData"), object: nil)
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
}
