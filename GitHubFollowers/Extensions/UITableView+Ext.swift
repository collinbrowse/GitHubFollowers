//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/22/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import UIKit


extension UITableView {
    
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    
    func removeExcessCells() {
        //tableFooterView = UIView(frame: .zero)
    }
}
