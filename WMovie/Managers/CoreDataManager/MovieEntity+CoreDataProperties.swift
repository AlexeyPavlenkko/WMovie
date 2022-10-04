//
//  MovieEntity+CoreDataProperties.swift
//  WMovie
//
//  Created by Алексей Павленко on 02.10.2022.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var releaseDate: Date
    @NSManaged public var saveDate: Date
    @NSManaged public var posterImage: String?
    @NSManaged public var overview: String?
    @NSManaged public var rate: Double
    @NSManaged public var imageData: Data?
    
}

extension MovieEntity : Identifiable {

}
