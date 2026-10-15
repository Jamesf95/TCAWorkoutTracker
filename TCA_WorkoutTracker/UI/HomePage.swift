//
//  HomePage.swift
//  TCA_WorkoutTracker
//
//  Created by James Foot on 15/10/2026.
//

import SwiftUI

struct HomePage: View {
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(dateLabel)
                    .font(AppTypography.overline)
                    .foregroundStyle(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Ready to get stronger?")
                    .font(AppTypography.largeTitle)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.canvas)
        
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

#Preview {
    HomePage()
}
