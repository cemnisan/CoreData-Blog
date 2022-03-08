//
//  Article+CoreDataProperties.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 8.03.2022.
//
//

import Foundation
import CoreData

extension Article
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var author: Author?
}
