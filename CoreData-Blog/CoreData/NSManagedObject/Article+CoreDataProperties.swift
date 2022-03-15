//
//  Article+CoreDataProperties.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 15.03.2022.
//
//

import Foundation
import CoreData
import UIKit

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: K.Entity.article)
    }

    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var title: String?
    @NSManaged public var articleImage: UIImage?
    @NSManaged public var author: Author?

}

extension Article : Identifiable {

}
