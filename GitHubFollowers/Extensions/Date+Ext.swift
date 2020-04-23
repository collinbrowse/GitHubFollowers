//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/16/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}



/**
        dateFormatter.dateStyle    = .full                  // Tuesday, March 17, 2015
        dateFormatter.dateStyle    = .long               // March 17, 2015
        dateFormatter.dateStyle    = .medium       // Mar 17, 2015
        dateFormatter.dateStyle    = .short              // Locale="en_US_POSIX" => 4/17/15 --- Local="en_UK" => 17/4/15
 */
