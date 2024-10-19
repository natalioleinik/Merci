//
//  GratitudeEntry.swift
//  Merci
//
//  Created by Natali Oleinik on 10/19/24.
//

import Foundation

struct GratitudeEntry: Codable {
    var gratitude: String
    var date: Date
    var position: CGPoint // Ensure this property exists
}

