//
//  CoreDataManager.swift
//  WMovie
//
//  Created by Алексей Павленко on 02.10.2022.
//

import Foundation
import CoreData

typealias isSucceed = Bool

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    //MARK: NSPersistentContainer
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieEntity")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    //MARK: ViewContex
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: Save Movie
    func saveMovie(_ movie: Movie) -> isSucceed {
        let movieEntity = MovieEntity(context: viewContext)
        movieEntity.id = Int64(movie.id)
        movieEntity.title = movie.title
        movieEntity.releaseDate = movie.year
        movieEntity.saveDate = Date()
        movieEntity.posterImage = movie.posterImage
        movieEntity.overview = movie.overview
        movieEntity.rate = movie.rate ?? 0.0
        movieEntity.imageData = CacheManager.shared.getImage(for: movie.posterImage)?.pngData()
        NotificationCenter.default.post(name: NSNotification.movieWasSaved, object: nil)
        return save()
    }
    
    //MARK: - Delete Movie
    func deleteMovie(_ movie: MovieEntity) -> isSucceed {
        viewContext.delete(movie)
        NotificationCenter.default.post(name: NSNotification.movieWasDeleted, object: nil)
        return save()
    }
    
    func deleteMovie(_ movie: Movie) -> isSucceed {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "title contains[cd] %@", movie.title)
        request.predicate = predicate
        do {
            let movies = try viewContext.fetch(request)
            guard let movieEnt = movies.first else { return false }
            return deleteMovie(movieEnt)
        } catch let error {
            print("Unable to deleteMovie from viewContext.", error.localizedDescription)
            return false
        }
    }
    
    func checkIfMovieIsSaved(_ movie: Movie) -> Bool {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "title contains[cd] %@", movie.title)
        request.predicate = predicate
        do {
            let movies = try viewContext.fetch(request)
            return movies.isEmpty == false
        } catch let error {
            print("Unable to deleteMovie from viewContext.", error.localizedDescription)
            return false
        }
    }
    
    //MARK: Save ViewContext
    private func save() -> isSucceed {
        do {
            try viewContext.save()
            return true
        } catch {
            print("Failed to save.", error.localizedDescription)
            return false
        }
    }
    
    //MARK: FetchedResultsController
    func fetchedResultsController(sortedBy sortDescriptor: CoreDataSortDescriptor, query: String? = nil) -> NSFetchedResultsController<MovieEntity> {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        if let query = query {
            fetchRequest.predicate = NSPredicate(format: "title contains[cd] %@", query)
        }
        fetchRequest.sortDescriptors = [sortDescriptor.sortDescriptor]
        return NSFetchedResultsController<MovieEntity>(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}
