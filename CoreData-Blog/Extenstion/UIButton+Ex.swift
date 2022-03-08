//
//  UIButton+Ex.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//

import UIKit

extension UIButton
{
    func setBookMark(bookMark: SelectBookMark)
    {
        self.setBackgroundImage(
            UIImage(systemName: bookMark.selectedBookMark),
            for: .normal)
    }
}
