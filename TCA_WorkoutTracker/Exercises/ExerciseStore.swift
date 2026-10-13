//
//  ExerciseStore.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 12/10/2026.
//

import Foundation

enum ExerciseStoreError: Error {
    case noJsonFile
    case jsonParsingFailed
}

class ExerciseStore {
    
    func fetchAll() async throws (ExerciseStoreError) -> [Exercise] {
        
        // Mocking a network delay for more realistic state transitions.
        try? await Task.sleep(for: .seconds(2))
        
        // Potentially throwing an error
        let random = Int.random(in: 0...10)
        if random < 3 {
            throw .jsonParsingFailed
        }
        
        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
            throw .noJsonFile
        }
          
        let data = try fetchData(from: url)
        let wrapper = try decodeWrapper(from: data)
        return wrapper.exercises
    }
    
    private func fetchData(from url: URL) throws(ExerciseStoreError) -> Data {
        do {
            return try Data(contentsOf: url)
            
        } catch {
            print("Error fetching data: \(error)")
            throw .noJsonFile
        }
    }
    
    private func decodeWrapper(from data: Data) throws(ExerciseStoreError) -> ExerciseWrapper {
        do {
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(ExerciseWrapper.self, from: data)
            return wrapper
            
        } catch {
            print("Error decoding data data: \(error)")
            throw .jsonParsingFailed
        }
    }
    
}
