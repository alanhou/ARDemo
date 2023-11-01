//
//  ResourceLoader.swift
//  Tap Makes Cup
//
//  Created by Alan on 2023/11/1.
//

import Foundation
import Combine
import RealityKit

class ResourceLoader {
    typealias LoadCompletion = (Result<CupEntity, Error>) -> Void
    
    private var loadCancellable: AnyCancellable?
    private var cupEntity: CupEntity?
    
    func loadResources(completion: @escaping LoadCompletion) -> AnyCancellable? {
        guard let cupEntity else {
            loadCancellable = CupEntity.loadAsync.sink { result in
                if case let .failure(error) = result {
                    print("Failed to load CupEntity: \(error)")
                    completion(.failure(error))
                }
            } receiveValue: { [weak self] cupEntity in
                guard let self else {
                    return
                }
                self.cupEntity = cupEntity
                completion(.success(cupEntity))
            }
            return loadCancellable
        }
        completion(.success(cupEntity))
        return loadCancellable
    }
        
    func createCup() throws -> Entity {
        guard let cup = cupEntity?.model else {
            throw ResourceLoaderError.resourceNotLoaded
        }
        return cup.clone(recursive: true)
    }
}

enum ResourceLoaderError: Error {
    case resourceNotLoaded
}
