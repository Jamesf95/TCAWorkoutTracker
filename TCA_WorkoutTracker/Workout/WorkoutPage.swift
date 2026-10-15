//
//  WorkoutPage.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI
import ComposableArchitecture

struct WorkoutPage: View {

    /// TCA container for the page.
    @Bindable var store: StoreOf<WorkoutFeature>

    var body: some View {
        WorkoutPageContent(
            currentExercise: store.currentExercise,
            completedExercises: store.completedExercises,
            upNextExercises: store.upNextExercises,
            firstExerciseNumber: store.currentExerciseIndex + 2,
            reps: $store.reps,
            weight: $store.weight,
            canCompleteSet: store.canCompleteSet,
            onCompleteExercise: { store.send(.completeExerciseTapped) }
        )
    }
}

private struct WorkoutPageContent: View {
    let currentExercise: Exercise?
    let completedExercises: [Exercise]
    let upNextExercises: [Exercise]
    let firstExerciseNumber: Int
    @Binding var reps: String
    @Binding var weight: String
    let canCompleteSet: Bool
    let onCompleteExercise: () -> Void
    @FocusState private var focusedField: MetricField.FieldType?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let currentExercise {
                    Text(currentExercise.name)
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(AppColor.ink)

                    CurrentSetCard(
                        repsEntry: $reps,
                        weightEntry: $weight,
                        isDisabled: !canCompleteSet,
                        focusedField: $focusedField
                    ) {
                        focusedField = nil
                        onCompleteExercise()
                    }

                    if !completedExercises.isEmpty || !upNextExercises.isEmpty {
                        SessionQueue(
                            completedExercises: completedExercises,
                            exercises: upNextExercises,
                            firstExerciseNumber: firstExerciseNumber
                        )
                    }
                } else {
                    Text("Workout complete")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(AppColor.ink)
                        .frame(maxWidth: .infinity, minHeight: 240)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .navigationTitle("Active workout")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.canvas.ignoresSafeArea())
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
}

private struct SessionQueue: View {
    let completedExercises: [Exercise]
    let exercises: [Exercise]
    let firstExerciseNumber: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("SESSION QUEUE")
                .font(AppTypography.overline)
                .tracking(1.4)
                .foregroundStyle(AppColors.textSecondary)

            if !completedExercises.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Completed")
                        .font(AppTypography.sectionTitle)
                        .foregroundStyle(AppColors.ink)

                    ForEach(Array(completedExercises.enumerated()), id: \.element.id) { offset, exercise in
                        QueueExerciseRow(
                            exercise: exercise,
                            number: offset + 1,
                            isCompleted: true
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))

                Spacer().frame(height: 16)
            }

            if !exercises.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Up next")
                            .font(AppTypography.sectionTitle)
                            .foregroundStyle(AppColors.ink)

                        Spacer()

                        Text("\(exercises.count) left")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.textSecondary)
                            .contentTransition(.numericText())
                    }

                    VStack(spacing: 10) {
                        ForEach(Array(exercises.enumerated()), id: \.element.id) { offset, exercise in
                            QueueExerciseRow(
                                exercise: exercise,
                                number: firstExerciseNumber + offset
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.snappy(duration: 0.35), value: completedExercises)
        .animation(.snappy(duration: 0.35), value: exercises)
    }
}

private struct QueueExerciseRow: View {
    let exercise: Exercise
    let number: Int
    var isCompleted = false

    var body: some View {
        HStack(spacing: 16) {
            Text(number.formatted(.number.precision(.integerLength(2))))
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.textSecondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.ink)

                Text(metadata)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer(minLength: 8)

            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.ink)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    private var metadata: String {
        let muscle = exercise.primaryMuscles.first?.rawValue.capitalized
        let equipment = exercise.equipment?.displayName
        return [muscle, equipment].compactMap { $0 }.joined(separator: " · ")
    }
}

private struct CurrentSetCard: View {
    @Binding var repsEntry: String
    @Binding var weightEntry: String
    let isDisabled: Bool
    let focusedField: FocusState<MetricField.FieldType?>.Binding
    let onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Set")
                .font(AppTypography.caption)
            
            HStack(alignment: .bottom) {
                Text("1 of 3")
                    .font(AppTypography.cardTitle)
            }
            
            HStack {
                MetricField(
                    title: "Reps",
                    value: $repsEntry,
                    fieldType: .reps,
                    focusedField: focusedField
                )
                
                MetricField(
                    title: "Weight",
                    value: $weightEntry,
                    fieldType: .weight,
                    focusedField: focusedField
                )
            }
            
            HStack {
                Spacer()
                
                LimeButton(
                    title: "Complete set",
                    action: onComplete,
                    isDisabled: isDisabled
                )
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(AppColor.inkOnDark)
        .padding(16)
        .background(AppColors.darkCard, in: RoundedRectangle(cornerRadius: 12))
       
        
    }

}

private extension Equipment {
    var displayName: String {
        self == .body ? "Bodyweight" : rawValue.capitalized
    }
}

#Preview {
    NavigationStack {
        WorkoutPageContent(
            currentExercise: nil,
            completedExercises: [],
            upNextExercises: [],
            firstExerciseNumber: 1,
            reps: .constant(""),
            weight: .constant(""),
            canCompleteSet: false,
            onCompleteExercise: {}
        )
    }
}
