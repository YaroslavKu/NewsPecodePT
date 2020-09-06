//
//  NewsViewController.swift
//  NewsPecodePT
//
//  Created by Slavik on 04.09.2020.
//  Copyright © 2020 Me. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UITableViewController, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var newsAPI = NewsAPI()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name:NSNotification.Name(rawValue: "tableViewReloadData"), object: nil)
        
        newsAPI.fetchNews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sourcesSegue" {
            let nav = segue.destination as! UINavigationController
            let fvc = nav.topViewController as! FiltersViewController
            
            fvc.newsApi = newsAPI
        }
    }
    
    @objc func shouldReload() {
      print("reload tableView")
      self.tableView.reloadData()
    }
    
    
    @IBAction func Refresh(_ sender: UIRefreshControl) {
        newsAPI.clearArticles()
        newsAPI.fetchNews(paginating: true)
        
        sender.endRefreshing()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsAPI.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") as! ArticleCell
        
        let article: Article = (newsAPI.articles[indexPath.row])
        
        if article.title != nil {
            cell.setArticle(title: article.title ?? " ",
                            desc: article.desc ?? " ",
                            urlToImage: article.urlToImage ?? " ",
                            source: article.source ?? " ",
                            author: article.author ?? " " )

            return cell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: newsAPI.articles[indexPath.row].url!) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }

    // MARK: - Scroll view delegate data source
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            if newsAPI.isPaginating ||
            ceil(Double(newsAPI.totalArticles) / 10) < Double(newsAPI.page) {
                //
            } else {
                newsAPI.fetchNews(paginating: true)
            }
        }
    }
    
    // MARK: - SFSafari view controller delegate data source
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Search bar delegate data source
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newsAPI.clearArticles()
        newsAPI.fetchNews(search: searchText)
    }

}
