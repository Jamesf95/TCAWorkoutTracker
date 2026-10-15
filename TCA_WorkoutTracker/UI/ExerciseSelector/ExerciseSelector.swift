//
//  ExerciseSelector.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI

private let animationDuraration: TimeInterval = 0.1

struct ExerciseSelector: View {

    let exercises: [Exercise]
    @Binding var selectedExercies: Set<Exercise>
    
    var body: some View {
        LazyVStack {
            ForEach(exercises) { exercise in
                let isSelected = selectedExercies.contains(exercise)
                Button {
                    withAnimation(.snappy(duration: animationDuraration)) {
                        if isSelected {
                            selectedExercies.remove(exercise)
                        } else {
                            selectedExercies.insert(exercise)
                        }
                    }
                }
                label: {
                    ExerciseCard(
                        exercise: exercise,
                        isSelected: isSelected
                    )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: isSelected)
                .accessibilityLabel(exercise.name)
                .accessibilityValue(isSelected ? "Selected" : "Not selected")
                .accessibilityHint(isSelected ? "Double-tap to remove from selection" : "Double-tap to add to selection")
            }
        }
    }
}

private struct ExerciseCard: View {
    let exercise: Exercise
    let isSelected: Bool
    
    var body: some View {
        let borderColor = isSelected ? AppColors.focusBorder : AppColors.border
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(AppTypography.cardTitle)
                
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            
            Spacer()

            Image(systemName: isSelected ? "checkmark" : "plus")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(isSelected ? .white : AppColors.textSecondary)
                .frame(width: 24, height: 24)
                .background(isSelected ? AppColors.ink : .clear, in: Circle())
                .overlay {
                    Circle()
                        .stroke(isSelected ? .clear : AppColors.border, lineWidth: 1)
                }
                .contentTransition(.symbolEffect(.replace))
        }
        .padding(16)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 1)
        }
        .animation(.snappy(duration: animationDuraration), value: isSelected)
        .keyframeAnimator(initialValue: CGFloat(1), trigger: isSelected) { content, scale in
            content.scaleEffect(scale)
        } keyframes: { _ in
            KeyframeTrack {
                CubicKeyframe(1.05, duration: 0.08)
                CubicKeyframe(1, duration: 0.14)
            }
        }
    }
    
    var subtitle: String {
        exercise.primaryMuscles
            .map { $0.rawValue }
            .map { $0.capitalized }
            .joined(separator: ", ")
    }
}

#Preview {
    @Previewable @State var selectedExercises: Set<Exercise> = []
    let allExercises = [
        Exercise(
            name: "Exercise 1",
            primaryMuscles: [.abductors],
            secondaryMuscles: [.abductors],
            category: .assistedBodyweight,
            instructions: []
        ),
        Exercise(
            name: "Exercise 2",
            primaryMuscles: [.abductors],
            secondaryMuscles: [.abductors],
            category: .assistedBodyweight,
            instructions: []
        )
    ]
    
    VStack {
        ExerciseSelector(exercises: allExercises, selectedExercies: $selectedExercises)
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.canvas)
}
