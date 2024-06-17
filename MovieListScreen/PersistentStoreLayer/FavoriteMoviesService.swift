//
//  FavoriteMovieService.swift
//  MovieList
//
//  Created by Александра Сергеева on 15.06.2024.
//

import Foundation
import CoreData

protocol IFavoriteMoviesService {
    func addMovieToFavorites(_ movie: FavoriteMovieCoreDataModel) throws
    func removeMovieFromFavorites(by id: Int) throws
    func fetchFavoriteMovies() throws -> [FavoriteMovieCoreDataModel]
}

final class FavoriteMoviesService {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension FavoriteMoviesService: IFavoriteMoviesService {
    func addMovieToFavorites(_ movie: FavoriteMovieCoreDataModel) throws {
        
        let managedContext = persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Movies", in: managedContext) else {
            throw CoreDataErrors.runtimeError("No entity")
        }
        
        let movieNsManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movieNsManagedObject.setValue(movie.title, forKey: "title")
        movieNsManagedObject.setValue(movie.pathToImage, forKey: "pathToImage")
        movieNsManagedObject.setValue(movie.id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch {
            throw CoreDataErrors.runtimeError("Could not save movie")
        }
    }
    
    func removeMovieFromFavorites(by id: Int) throws {
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        
        fetchRequest.predicate = predicate
        
        var moviesToDelete = [NSManagedObject]()
        
        do {
            let movieNsManagedObjects = try managedContext.fetch(fetchRequest)
            moviesToDelete = movieNsManagedObjects
        } catch {
            throw CoreDataErrors.runtimeError("Failed to fetch movies")
        }
        
        moviesToDelete.forEach { movie in
            managedContext.delete(movie)
        }
        
        do {
            try managedContext.save()
        } catch {
            throw CoreDataErrors.runtimeError("Could note delete movie")
        }
    }
    
    func fetchFavoriteMovies() throws -> [FavoriteMovieCoreDataModel] {
        
        var moviesArr = [FavoriteMovieCoreDataModel]()
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        
        do {
            let movieManagedObjects = try managedContext.fetch(fetchRequest)
            movieManagedObjects.forEach({ movieManagedObject in
                guard let id = movieManagedObject.value(forKey: "id") as? Int,
                      let title = movieManagedObject.value(forKey: "title") as? String,
                      let path = movieManagedObject.value(forKey: "pathToImage") as? String else {
                    return
                }
                let favoriteMovie = FavoriteMovieCoreDataModel(id: id, title: title, pathToImage: path)
                moviesArr.append(favoriteMovie)
            })
        } catch {
            throw CoreDataErrors.runtimeError("Could not fetch movies")
        }
        return moviesArr
    }
}
