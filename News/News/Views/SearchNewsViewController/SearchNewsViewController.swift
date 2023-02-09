//
//  ViewController.swift
//  News
//
//  Created by Baidetskyi Jurii on 29.01.2023.
//

import UIKit

class SearchNewsViewController: UIViewController {
    
    private let customCellID = "NewsTableViewCell"
    private let loadingCellID = "LoadingTableViewCell"
    
    let searchViewModel = SearchNewsViewModel()
    private let networkManager: NewsManageable = NewsManager()
    
    private var page = 1
    private var pageSize = 5
    
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
        setupSearchViewModelObserver()
    }
    
    @objc func refreshTableView() {
        searchViewModel.searchNews(value:  searchBar.text ?? "Love", page: String(page), pageSize: String(pageSize))
        tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    func setupSearchViewModelObserver() {
        
        searchViewModel.searchResults.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        searchViewModel.error.bind { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(message: "Try one more time", title: "Something goes wrong!")
                    print(error)
                }
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
        tableView.register(UINib(nibName: loadingCellID, bundle: nil), forCellReuseIdentifier: loadingCellID)
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
        guard let newsModel = searchViewModel.searchResults.value?.articles?[indexPath.item] else { return }
        vc.urlString = newsModel.url ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension SearchNewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return searchViewModel.searchResults.value?.articles?.count ?? 0
        case 1:
            if searchViewModel.searchResults.value?.articles?.count ?? 0 > 0  {
                return 1
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellID, for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
            }
            
            guard let newsModel = searchViewModel.searchResults.value?.articles?[indexPath.item] else { return UITableViewCell() }
            cell.setNews(with: newsModel)
            return cell
            
        } else if searchViewModel.searchResults.value?.totalResults ?? 0 > 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellID, for: indexPath) as? LoadingTableViewCell else {
                return UITableViewCell()
            }
            
            cell.loadMoreClouser = { [weak self] in
                
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                
                self?.searchViewModel.searchNews(value:  self?.searchBar.text ?? "Love", page: String(self?.page ?? 1), pageSize: String(self?.pageSize ?? 5))
                self?.page += 1
            }
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}

extension SearchNewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.searchNews(value:  searchBar.text ?? "Love", page: String(page), pageSize: String(pageSize))
        page = 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchViewModel.searchNews(value:  searchBar.text ?? "Love", page: String(page), pageSize: String(pageSize))
        self.searchBar.endEditing(true)
        page = 1
    }
}



