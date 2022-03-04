//
//  Article+CoreDataProperties.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }


}

extension Article : Identifiable {

}
