//
//  UISearchController+Ex.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 10.03.2022.
//

import UIKit

extension UISearchController
{
    var isSearchBarEmpty: Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    var isSearching: Bool {
        return self.isActive && !isSearchBarEmpty
    }
}
