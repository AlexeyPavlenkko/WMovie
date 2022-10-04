//
//  CoreDataSortDescriptor.swift
//  WMovie
//
//  Created by Алексей Павленко on 04.10.2022.
//

import Foundation

enum CoreDataSortDescriptor {
    case latestSaved
    case alpabetical
    case latestReleased
    case topRating
    
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .latestSaved: return NSSortDescriptor(keyPath: \MovieEntity.saveDate, ascending: false)
        case .alpabetical: return NSSortDescriptor(keyPath: \MovieEntity.title, ascending: true)
        case .latestReleased: return NSSortDescriptor(keyPath: \MovieEntity.releaseDate, ascending: false)
        case .topRating: return NSSortDescriptor(keyPath: \MovieEntity.rate, ascending: false)
        }
    }
}
