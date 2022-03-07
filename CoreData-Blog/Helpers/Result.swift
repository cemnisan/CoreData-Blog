//
//  Result.swift
//  CoreData-Blog
//
//  Created by Cem Nisan on 6.03.2022.
//

import Foundation

enum Result<Value>
{
    case success(Value)
    case failure(Error)
}
