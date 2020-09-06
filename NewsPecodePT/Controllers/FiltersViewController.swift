//
//  FiltersViewController.swift
//  NewsPecodePT
//
//  Created by Slavik on 04.09.2020.
//  Copyright © 2020 Me. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {
    
    @IBOutlet weak var appliedFilters: UILabel!
    
    var newsApi: NewsAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldReload), name:NSNotification.Name(rawValue: "sourcesTableViewReloadData"), object: nil)
        
        setupAppliedFilters()

        newsApi?.fetchSources()
    }
    
    @IBAction func back(_ sender: Any) {
        print("back")
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func shouldReload() {
      print("reload tableView")
      self.tableView.reloadData()
    }
    
    func setupAppliedFilters() {
        let appliedCategoty = newsApi?.sourceParemeters.category.count == 0 ? "All categories" : newsApi?.sourceParemeters.category
        let appliedCountry = newsApi?.sourceParemeters.country.count == 0 ? "All countries" : newsApi?.sourceParemeters.country.countryStringFromCountryCode
        
        appliedFilters.text = "\(appliedCategoty ?? "error") / \(appliedCountry ?? "error")"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsApi?.sources.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath)

        cell.textLabel?.text = newsApi?.sources[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsApi?.clearArticles()
        
        newsApi?.fetchNews(source: newsApi?.sources[indexPath.row].id)
        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Show News Categories

    @IBAction func showCategories(_ sender: Any) {
        let showCategoriesAlert = UIAlertController(title: "Choose category:", message: nil, preferredStyle: .actionSheet)
        
        for category in newsApi?.categories ?? [] {
            let categoryAction = UIAlertAction(title: category, style: .default) { (action: UIAlertAction) in
                self.newsApi?.sourceParemeters.category = category
                
                self.newsApi?.fetchSources()
                self.setupAppliedFilters()
            }
            
            showCategoriesAlert.addAction(categoryAction)
        }
        
        let allCategoriesAction = UIAlertAction(title: "All categories", style: .default) { (action: UIAlertAction) in
               self.newsApi?.sourceParemeters.category = ""
               self.newsApi?.fetchSources()
            self.setupAppliedFilters()
           }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        showCategoriesAlert.addAction(allCategoriesAction)
        showCategoriesAlert.addAction(cancelAction)
        
        self.present(showCategoriesAlert, animated: true, completion: nil)
    }
    
    // MARK: - Show News Countries
    
    @IBAction func showCountries(_ sender: Any) {
        let showCountriesAlert = UIAlertController(title: "Choose country:", message: nil, preferredStyle: .actionSheet)
        
        for country in newsApi?.countries ?? [] {
            let countryAction = UIAlertAction(title: country.countryStringFromCountryCode, style: .default) { (action: UIAlertAction) in
                self.newsApi?.sourceParemeters.country = country
                self.newsApi?.fetchSources()
                self.setupAppliedFilters()
            }
            
            showCountriesAlert.addAction(countryAction)
        }
        
        let allCountriesAction = UIAlertAction(title: "All countries", style: .default) { (action: UIAlertAction) in
            self.newsApi?.sourceParemeters.country = ""
            self.newsApi?.fetchSources()
            self.setupAppliedFilters()
           }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        showCountriesAlert.addAction(allCountriesAction)
        showCountriesAlert.addAction(cancelAction)
        
        self.present(showCountriesAlert, animated: true, completion: nil)
    }
    
}
