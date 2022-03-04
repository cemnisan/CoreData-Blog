//
//  Author+CoreDataProperties.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 5.03.2022.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }


}

extension Author : Identifiable {

}
