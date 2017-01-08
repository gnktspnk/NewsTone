//
//  WebViewController.swift
//  NewsReader
//
//  Created by Gennadii Tsypenko on 07.01.17.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        webView.loadRequest(URLRequest(url: URL(string: url!)!))
    }

   

}
