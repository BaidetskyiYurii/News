//
//  FavouroteNewsViewController.swift
//  News
//
//  Created by Baidetskyi Jurii on 05.02.2023.
//

import UIKit
import CoreData

class FavouriteNewsViewController: UIViewController {
    
    private let customCellID = "NewsTableViewCell"
    
    var favouriteNews = [ArticleSaved]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        getSavedNews()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        setCustomTableViewCell()
    }
    
    private func setCustomTableViewCell() {
        tableView.register(UINib(nibName: customCellID, bundle: nil), forCellReuseIdentifier: customCellID)
    }
    
    private func getSavedNews() {
        let newsFetch: NSFetchRequest<ArticleSaved> = ArticleSaved.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(ArticleSaved.title), ascending: true)
        newsFetch.sortDescriptors = [sortByName]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(newsFetch)
            print(results)
            favouriteNews = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}

extension FavouriteNewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "NewsDescriptionViewController") as? NewsDescriptionViewController else {
            return
        }
        
        vc.urlString = favouriteNews[indexPath.row].url ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavouriteNewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: customCellID, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setFavouriteNews(with: favouriteNews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context:NSManagedObjectContext = appDelegate.coreDataStack.managedContext
        
        if editingStyle == .delete {
            // Delete object from database
            let objectToDelete = favouriteNews[indexPath.row]
            context.delete(objectToDelete)
            
            appDelegate.coreDataStack.saveContext()
            
            favouriteNews.remove(at: indexPath.row)
            if let array = [indexPath] as? [IndexPath] {
                tableView.deleteRows(at: array, with: .fade)
            }
        }
    }
}
