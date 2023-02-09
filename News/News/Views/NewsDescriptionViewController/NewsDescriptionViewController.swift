//
//  NewsDescriptionViewController.swift
//  News
//
//  Created by Baidetskyi Jurii on 04.02.2023.
//

import UIKit
import WebKit

class NewsDescriptionViewController: UIViewController {
    
    var urlString = String()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var previousButtonOutlet: UIButton! {
        didSet {
            previousButtonOutlet.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var nextButtonOutlet: UIButton!
    {
        didSet {
            nextButtonOutlet.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var refreshButtonOutlet: UIButton!{
        didSet {
            refreshButtonOutlet.setTitle("", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        webView.navigationDelegate = self
        loadRequest()
    }
    
     private func loadRequest() {
        guard let url = URL(string: urlString) else { return }
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        if webView.url != nil {
            webView.reload()
          } else {
              loadRequest()
          }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if webView.canGoBack {
            //TODO: button is enabled
//            previousButtonOutlet.isEnabled = true
                print("Can go back")
                webView.goBack()
                webView.reload()
            } else {
//                previousButtonOutlet.isEnabled = false
                print("Can't go back")
            }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if self.webView.canGoForward {
//            nextButtonOutlet.isEnabled = true
                print("Can go forward")
                self.webView.goBack()
                self.webView.reload()
            } else {
//                nextButtonOutlet.isEnabled = false
                print("Can't go forward")
            }
    }
}

extension NewsDescriptionViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}
