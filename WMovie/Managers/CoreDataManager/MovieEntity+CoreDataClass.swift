//
//  MovieEntity+CoreDataClass.swift
//  WMovie
//
//  Created by Алексей Павленко on 02.10.2022.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
    
    private var yearFormatter: DateFormatter {
        let frmt = DateFormatter()
        frmt.dateFormat = "dd.MM.yyyy"
        return frmt
    }
    
    private var saveDateFormatter: DateFormatter {
        let frmt = DateFormatter()
        frmt.dateFormat = "MM-dd-yyyy HH:mm"
        return frmt
    }

    var rateString: String {
        return rate == 0.0 ? "Rating is not available yet" : "Rating: \(rate)"
    }
    
    var yearString: String {
        let yearFormatted = yearFormatter.string(from: releaseDate)
        return yearFormatted == "01.01.9999" ? "Release date is unknown" : "Release date: \(yearFormatted)"
    }
    
    var saveDateString: String {
        return "Save date: \(saveDateFormatter.string(from: saveDate))"
    }
    
    var formattedOverviewString: String {
        if let overview = overview {
            return "Overview: \(overview)"
        } else {
            return "Overview is not available"
        }
    }
}
