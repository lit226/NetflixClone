import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    func downloadTitle(model: Title, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleDataModel(context: context)
        
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.original_title = model.original_title
        item.overview = model.overview
        item.popularity = model.popularity
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.title = model.title
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchData(completion: @escaping(Result<[TitleDataModel], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        var request : NSFetchRequest<TitleDataModel>
        request = TitleDataModel.fetchRequest()
        
        do {
            let title = try context.fetch(request)
            completion(.success(title))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
        
    }
    
    func deleteData(model: TitleDataModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
