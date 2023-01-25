//
//  CoreDataRepository.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import Combine
import CoreData

class CoreDataRepository<Entity: NSManagedObject> {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    /// load entities
    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil) -> AnyPublisher<[Entity], Error>
    {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    do {
                        let results = try context.fetch(request) as! [Entity]
                        promise(.success(results))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }

        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    /// get an object by id
    func object(_ id: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    guard let entity = try? context.existingObject(with: id) as? Entity else {
                        promise(.failure(RepositoryError.objectNotFound))
                        return
                    }
                    promise(.success(entity))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    /// create a new entity
    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(_: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    do {
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func delete(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    do {
                        context.delete(entity)
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    enum RepositoryError: Error {
        case objectNotFound
        case fieldDoesNotExist
    }
}
