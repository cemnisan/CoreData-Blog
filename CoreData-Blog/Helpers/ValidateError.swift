//
//  ValidateError.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 7.03.2022.
//

import Foundation

enum ValidateError: Error
{
    case isTitleEmpty
    case titleTooShort
    case isContentEmpty
    case contentTooShort
}
