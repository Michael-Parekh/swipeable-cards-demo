//
//  HomeViewModel.swift
//  Swipeable Cards Demo
//
//  Created by Michael Parekh on 5/26/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var fetched_users: [User] = []
    @Published var displaying_users: [User]?
    
    init() {
        // For this demo application, store all of the fetched sample User objects here.
        fetched_users = [
            User(name: "Jake", place: "Vadalia NYC", profilePic: "User1"),
            User(name: "Sarah", place: "Central Park NYC", profilePic: "User2"),
            User(name: "Nathan", place: "Metro Museum NYC", profilePic: "User3"),
            User(name: "Angelica", place: "Kips Bay NYC", profilePic: "User4"),
            User(name: "Megan", place: "Queens NYC", profilePic: "User5"),
            User(name: "Brandon", place: "Brooklyn NYC", profilePic: "User6")
        ]
        
        // To reduce memory usage, instantiate 'displaying_users' which is updated/removed based on user interaction.
        displaying_users = fetched_users
    }
}
