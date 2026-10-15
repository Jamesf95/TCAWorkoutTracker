//
//  HomePage.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI
import ComposableArchitecture

struct HomePage: View {
    
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        ScrollView {
            scrollViewBody
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.canvas)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !store.selectedExercises.isEmpty {
                StartWorkoutCard(count: store.selectedExercises.count) {
                    store.send(.startWorkoutTapped)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: store.selectedExercises.isEmpty)
        .onAppear {
            if store.exerciseList.isEmpty && !store.isLoading {
                store.send(.initialLoad)
            }
        }
    }
    
    var scrollViewBody: some View {
        VStack(alignment: .leading) {
            Text(dateLabel)
                .font(AppTypography.overline)
                .foregroundStyle(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Ready to get stronger?")
                .font(AppTypography.largeTitle)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 40)

            exerciseSelectorSection

            Spacer()
                .frame(height: 40)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
    }
    
    var exerciseSelectorSection: some View {
        VStack {
            Text("Build your session")
                .font(AppTypography.overline)
                .foregroundStyle(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Select exercises")
                .font(AppTypography.sectionTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if store.error != nil {
                ErrorView(
                    title: "Error fetching exercises",
                    subtitle: "We're unable to load your exercises. Please retry later.",
                    onRetryClicked: {
                        store.send(.retryPressed)
                    }
                )
                
            } else if store.isLoading {
                ProgressView("Loading")
                    .padding([.vertical], 16)
                
            } else if store.exerciseList.isEmpty {
                ErrorView(title: "Exercises failed to load")
                
            } else {
                let binding = Binding<[Exercise]>(
                    get: { store.selectedExercises },
                    set: {
                        store.send(.selectedExercisesChanged($0))
                    }
                )
                ExerciseSelector(
                    exercises: store.exerciseList,
                    selectedExercises: binding
                )
            }
    
        }
    }
    
    
    var dateLabel: String {
        let date = Date.now
        let day = Calendar.current.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_GB")
        numberFormatter.numberStyle = .ordinal
        let ordinalDay = numberFormatter.string(from: NSNumber(value: day)) ?? "\(day)"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateFormat = "EEEE, "
        let weekday = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: date)

        return "\(weekday)\(ordinalDay) \(month)".uppercased()
    }
}

private struct StartWorkoutCard: View {
    let count: Int
    let onStartWorkoutTapped: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(count)")
                    .font(AppTypography.cardTitle)
                
                let pluralSuffix = count == 1 ? "" : "s"
                Text("exercise\(pluralSuffix)")
                    .font(AppTypography.caption)
                    
            }
            .foregroundStyle(AppColors.inkOnDark)
            
            Spacer()
            
            LimeButton(title: "Start workout", action: onStartWorkoutTapped)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(AppColors.darkCard, in: RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    let store = Store(
        initialState: HomeFeature.State(
            exerciseList: [
                Exercise(
                    name: "Barbell Squat",
                    primaryMuscles: [.quadriceps, .glutes],
                    secondaryMuscles: [.hamstrings],
                    category: .strength,
                    instructions: []
                )
            ],
            isLoading: false,
            error: nil
        )
    ) {
        HomeFeature()
    }

    HomePage(store: store)
}
