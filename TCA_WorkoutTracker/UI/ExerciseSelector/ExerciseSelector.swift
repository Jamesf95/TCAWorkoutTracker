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
    let selectedMuscleGroup: MuscleGroup
    let onMuscleGroupSelected: (MuscleGroup) -> Void
    @Binding var selectedExercises: [Exercise]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MuscleGroup.allCases, id: \.self) { group in
                        muscleFilterButton(
                            title: group.rawValue,
                            isSelected: selectedMuscleGroup == group
                        ) {
                            onMuscleGroupSelected(group)
                        }
                    }
                }
            }

            LazyVStack {
                ForEach(exercises) { exercise in
                    let isSelected = selectedExercises.contains(exercise)
                    Button {
                        withAnimation(.snappy(duration: animationDuraration)) {
                            if isSelected {
                                selectedExercises.removeAll { $0 == exercise }
                            } else {
                                selectedExercises.append(exercise)
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

    private func muscleFilterButton(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(isSelected ? .white : AppColors.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.ink : AppColors.surface, in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(isSelected ? .clear : AppColors.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Filter by \(title)")
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
    @Previewable @State var selectedExercises: [Exercise] = []
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
        ExerciseSelector(
            exercises: allExercises,
            selectedMuscleGroup: .arms,
            onMuscleGroupSelected: { _ in },
            selectedExercises: $selectedExercises
        )
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppColors.canvas)
}
