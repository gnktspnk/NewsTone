//
//  MenuManager.swift
//  NewsReader
//
//  Created by Gennadii Tsypenko on 07.01.17.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let blackView = UIView()
    let menuTabView = UITableView()
    let sources = ["hacker-news", "techcrunch","abc-news-au", "ars-technica", "associated-press", "bbc-news", "bbc-sport"]
    var mainVC: ViewController?
    
    
    public func openMenu(){
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dissmisMenu)))
            
            let height:CGFloat = CGFloat(sources.count * 50)
            let y = window.frame.height - height
            
            menuTabView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            window.addSubview(blackView)
            window.addSubview(menuTabView)
            
            UIView.animate(withDuration: 0.5, animations: {
               
                self.blackView.alpha = 1
                self.menuTabView.frame.origin.y = y
            })
        }
    }
    
    public func dissmisMenu(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                
                self.menuTabView.frame.origin.y = window.frame.height
        
            }
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
        cell.textLabel?.text = sources[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC {
            vc.source = sources[indexPath.item]
            vc.fetchArticles(from: sources[indexPath.item])
            dissmisMenu()
        }
    }
    
    override init(){
        super.init()
        menuTabView.delegate = self
        menuTabView.dataSource = self
        menuTabView.isScrollEnabled = false
        menuTabView.bounces = false
        
        menuTabView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
        
    }

}
