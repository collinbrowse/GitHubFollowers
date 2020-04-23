//
//  ErrorMessage.swift
//  GitHubFollowers
//
//  Created by Collin Browse on 4/8/20.
//  Copyright © 2020 Collin Browse. All rights reserved.
//

import Foundation

enum GFError: String, Error {
    
    case invalidUsername = "This username is invalid"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse = "Invalid Response from the server"
    case invalidData = "The data fromt the server was invalid"
    case unableToFavorite = "There was an error adding the user to favorites"
    case alreadyInFavorites = "This user is already a favorite"
    
}
