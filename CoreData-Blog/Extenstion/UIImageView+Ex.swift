//
//  UIImage+Ex.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import UIKit

extension UIImageView
{
    func makeRounded()
    {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
