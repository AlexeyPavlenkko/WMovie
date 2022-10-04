//
//  NSNotification+names.swift
//  WMovie
//
//  Created by Алексей Павленко on 02.10.2022.
//

import Foundation

extension NSNotification {
    static let movieWasSaved = Name("wmovie.movieWasSavedToCoreData")
    static let movieWasDeleted = Name("wmovie.movieWasDeletedToCoreData")
}
