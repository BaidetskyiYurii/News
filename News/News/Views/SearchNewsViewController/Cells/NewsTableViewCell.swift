//
//  NewsTableViewCell.swift
//  News
//
//  Created by Baidetskyi Jurii on 03.02.2023.
//

import UIKit

enum LoadingState {
    case notLoading
    case loading
    case loaded
}

class NewsTableViewCell: UITableViewCell {
    
    var savedNewsURL = String()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    var loadingState: LoadingState = .notLoading {
        didSet {
            switch loadingState {
            case .notLoading:
                activityIndicator.stopAnimating()
            case .loading:
                activityIndicator.startAnimating()
            case .loaded:
                activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoutiteButtonOutlet: UIButton! {
        didSet {
            favoutiteButtonOutlet.setTitle("", for: .normal)
            favoutiteButtonOutlet.setImage(UIImage(named: "star.circle"), for: .normal)
            favoutiteButtonOutlet.isHidden = false
            favoutiteButtonOutlet.isEnabled = true
        }
    }
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageViewNews: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newNews = ArticleSaved(context: managedContext)
        
        newNews.setValue(titleLabel.text, forKey:  #keyPath(ArticleSaved.title))
        newNews.setValue(sourceLabel.text, forKey: #keyPath(ArticleSaved.sourceName))
        newNews.setValue(authorLabel.text, forKey: #keyPath(ArticleSaved.author))
        newNews.setValue(imageViewNews.image?.pngData(), forKey: #keyPath(ArticleSaved.image))
        newNews.setValue(savedNewsURL, forKey: #keyPath(ArticleSaved.url))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
        favoutiteButtonOutlet.setImage(UIImage(named: "star.circle.fill"), for: .normal)
    }
    
    func setNews(with model: Article) {
        savedNewsURL = model.url ?? ""
        titleLabel.text = model.title
        sourceLabel.text = model.source.name
        authorLabel.text = model.author
        loadingState = .loading
        imageViewNews.downloaded(from: URL(string: model.urlToImage ?? "") ?? URL(fileURLWithPath: ""))
        loadingState = .loaded
    }
    
    func setFavouriteNews(with model: ArticleSaved) {
        favoutiteButtonOutlet.isHidden = true
        favoutiteButtonOutlet.isEnabled = false
        savedNewsURL = model.url ?? ""
        titleLabel.text = model.title
        sourceLabel.text = model.sourceName
        authorLabel.text = model.author
        imageViewNews.image = UIImage(data: model.image ?? Data())
        loadingState = .loaded
    }
}
