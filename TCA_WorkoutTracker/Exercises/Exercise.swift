//
//  Exercise.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 12/10/2026.
//

import Foundation

public enum Muscle: String, Codable, CaseIterable, Sendable {
    case abdominals = "abdominals"
    case hamstrings = "hamstrings"
    case calves = "calves"
    case shoulders = "shoulders"
    case adductors = "adductors"
    case glutes = "glutes"
    case quadriceps = "quadriceps"
    case biceps = "biceps"
    case forearms = "forearms"
    case abductors = "abductors"
    case triceps = "triceps"
    case chest = "chest"
    case lowerBack = "lower back"
    case traps = "traps"
    case middleBack = "middle back"
    case lats = "lats"
    case neck = "neck"
}

public enum Equipment: String, Codable, CaseIterable, Sendable {
    case body = "body only"
    case machine = "machine"
    case kettlebells = "kettlebells"
    case dumbbell = "dumbbell"
    case cable = "cable"
    case barbell = "barbell"
    case bands = "bands"
    case medicineBall = "medicine ball"
    case exerciseBall = "exercise ball"
    case eZCurlBar = "e-z curl bar"
    case foamRoll = "foam roll"
    case other = "other"
}

public enum Category: String, Codable, CaseIterable, Sendable {
    case strength = "strength"
    case stretching = "stretching"
    case plyometrics = "plyometrics"
    case strongman = "strongman"
    case powerlifting = "powerlifting"
    case cardio = "cardio"
    case olympicWeightlifting = "olympic weightlifting"
    case crossfit = "crossfit"
    case weightedBodyweight = "weighted bodyweight"
    case assistedBodyweight = "assisted bodyweight"
}

public struct Exercise: Codable, Hashable, Sendable, Identifiable {
    public let name: String
    public let aliases: [String]?
    public let primaryMuscles: [Muscle]
    public let secondaryMuscles: [Muscle]
    public let equipment: Equipment?
    public let category: Category
    public let instructions: [String]
    public let description: String?
    public let tips: [String]?

    public init(
        name: String,
        aliases: [String]? = nil,
        primaryMuscles: [Muscle],
        secondaryMuscles: [Muscle],
        equipment: Equipment? = nil,
        category: Category,
        instructions: [String],
        description: String? = nil,
        tips: [String]? = nil
    ) {
        self.name = name
        self.aliases = aliases
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.category = category
        self.instructions = instructions
        self.description = description
        self.tips = tips
    }
    
    public var id: String {
        self.name
    }
}

public struct ExerciseWrapper: Codable, Hashable, Sendable {
    public let exercises: [Exercise]
    
    public init(exercises: [Exercise]) {
        self.exercises = exercises
    }
}
