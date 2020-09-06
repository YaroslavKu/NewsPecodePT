//
//  ArticleCell.swift
//  NewsPecodePT
//
//  Created by Slavik on 05.09.2020.
//  Copyright © 2020 Me. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var author: UILabel!
    
    func setArticle(title: String, desc: String, urlToImage: String, source: String, author: String) {
        
        self.title.text = title
        self.desc.text = desc
        self.img.downloaded(from: urlToImage)
        self.source.text = source
        self.author.text = author
        
    }

}
