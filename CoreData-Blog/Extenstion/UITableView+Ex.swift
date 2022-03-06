//
//  UITableView+Ex.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import UIKit

extension UITableView
{
    func register(nibName: String,
                  cell: String)
    {
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cell)
    }
}
