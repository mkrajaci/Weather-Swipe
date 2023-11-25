//
//  WeatherButton.swift
//  Weather-Swipe
//
//  Created by Mario Krajačić on 25.11.2023..
//

import Foundation

import SwiftUI

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor.gradient)
            .foregroundStyle(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}
