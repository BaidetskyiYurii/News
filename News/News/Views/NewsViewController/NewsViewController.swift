//
//  NewsViewController.swift
//  News
//
//  Created by Baidetskyi Jurii on 05.02.2023.
//

import UIKit

class NewsViewController: UIViewController {

    private enum NewsTabType: Int {
        case search
        case favourite

        var title: String {
            switch self {
            case .search:
                return "Search News"
            case .favourite:
                return "Favoutite News"
            }
        }

        var vc: UIViewController {
            
            let stotyboard = UIStoryboard(name: "Main", bundle: nil)
            switch self {
            case .search:
                return stotyboard.instantiateViewController(withIdentifier: "SearchNewsViewController")
            case .favourite:
                return stotyboard.instantiateViewController(withIdentifier: "FavouriteNewsViewController")
            }
        }
    }

    @IBOutlet weak var notificationSegment: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    private let segmentTabs = [
        NewsTabType.search,
        NewsTabType.favourite
    ]
    private var selectedVC: UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedType = segmentTabs[0]
        changeVC(with: selectedType)
    }
    
    private func changeVC(with newNotificationType: NewsTabType) {
        if let selectedVC = selectedVC {
            selectedVC.willMove(toParent: nil)
            selectedVC.view.removeFromSuperview()
            selectedVC.removeFromParent()
        }

        let newVC = newNotificationType.vc
        selectedVC = newVC

        addChild(newVC)
        newVC.view.frame = containerView.bounds
        containerView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
    }
    
    @IBAction func tabDidChanged(_ sender: Any) {
        let selectedType = segmentTabs[notificationSegment.selectedSegmentIndex]
        changeVC(with: selectedType)
    }
}
