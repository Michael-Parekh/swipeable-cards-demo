//
//  User.swift
//  Swipeable Cards Demo
//
//  Created by Michael Parekh on 5/26/23.
//

import SwiftUI

// This struct represents the User model.
struct User: Identifiable {
    var id = UUID().uuidString
    var name: String
    var place: String
    var profilePic: String
}
