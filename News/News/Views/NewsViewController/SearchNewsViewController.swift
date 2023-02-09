//
//  ViewController.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import UIKit
import CoreData

class SearchNewsViewController: UIViewController {
    
    
    private let customCellID = "NewsTableViewCell"
    
    private let networkManager: NewsManageable = NewsManager()
    private var news: NewsResponce?
    var favouriteNews = [ArticleSaved]()
    var loadedNews = [ArticleSaved]()
    
    private var refreshController: UIRefreshControl! {
        didSet {
            refreshController.tintColor = .black
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setRefreshController()
        searchBar.delegate = self
        
        
        getSavedNews()
    }
    
    func getSavedNews() {
        let newsFetch: NSFetchRequest<ArticleSaved> = ArticleSaved.fetchRequest()
//            let sortByDate = NSSortDescriptor(key: #keyPath(Note.dateAdded), ascending: false)
//            noteFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(newsFetch)
            print(results)
            loadedNews = results
            print(loadedNews[0].title!)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    @objc func refreshTableView() {
//        searchNews(value: searchBar.text ?? "")
        tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    func searchNews(value: String) {
        networkManager.searchNews(search: value) { [weak self] responseResult in
            switch responseResult {
            case let .success(res):
                let news = res
                DispatchQueue.main.async {
                    self?.news = news
                    self?.tableView.reloadData()
                }
                print("==============")
                print(news)
            case let .failure(error):
                // TODO: Error Screen
                print(error)
            }
        }
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        setCustomTableViewCell()
    }
    
    private func setCustomTableViewCell() {
        tableView.register(UINib(nibName: customCellID, bundle: nil), forCellReuseIdentifier: customCellID)
    }
    
    private func setRefreshController() {
        refreshController = UIRefreshControl()
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
}


extension SearchNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NewsDescriptionViewController") as? NewsDescriptionViewController else {
            return
        }
        let newsModel = news?.articles?[indexPath.row]
        vc.url = newsModel?.url ?? ""
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
}


extension SearchNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news?.articles?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellID, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        guard let newsModel = news?.articles?[indexPath.row] else { return UITableViewCell() }
        
        cell.setNews(with: newsModel)
        
        return cell
    }
}

extension SearchNewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchNews(value: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchNews(value: searchBar.text ?? "")
        self.searchBar.endEditing(true)
    }
}

