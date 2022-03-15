//
//  ImageAttributeTransformer.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 15.03.2022.
//

import UIKit

@objc(ImageAttributeTransformer)
final class ImageAttributeTransformer: NSSecureUnarchiveFromDataTransformer
{
    override static var allowedTopLevelClasses: [AnyClass]
    {
        return super.allowedTopLevelClasses + [UIImage.self]
    }
    
    static func register()
    {
        let className = String(describing: ImageAttributeTransformer.self)
        let name = NSValueTransformerName(className)
        let transformer = ImageAttributeTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
