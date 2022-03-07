//
//  DataFormatter+Ex.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import Foundation

extension Date
{
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
