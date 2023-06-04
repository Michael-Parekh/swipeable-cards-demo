//
//  Home.swift
//  Swipeable Cards Demo
//
//  Created by Michael Parekh on 5/26/23.
//

import SwiftUI

struct Home: View {
    // Utilize the 'HomeViewModel' which contains all of the User data.
    @StateObject var homeData: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            // MARK: Top Navigation Bar
            Button {
                
            } label: {
                Image(systemName: "menucard")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                Text("Discover")
                    .font(.title.bold())
            )
            .foregroundColor(.black)
            .padding()
            
            
            // MARK: Users Card Stack
            ZStack {
                if let users = homeData.displaying_users {
                    if users.isEmpty {
                        // If there are no more Users left, then display the following message.
                        Text("Check back later for more matches!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        // If there are Users, display the User card stack.
                        // Note that the cards are in reversed order since it's a 'ZStack' (so fix it by using 'reversed').
                        ForEach(users.reversed()) { user in
                            StackCardView(user: user)
                                .environmentObject(homeData)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 30)
            .padding(.vertical)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            // MARK: Action Buttons
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(13)
                        .background(Color("Gray"))
                        .clipShape(Circle())
                }
                
                Button {
                    doSwipe(rightSwipe: true)
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(18)
                        .background(Color("Blue"))
                        .clipShape(Circle())
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "star.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(13)
                        .background(Color("Yellow"))
                        .clipShape(Circle())
                }
                
                Button {
                    doSwipe()
                } label: {
                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(18)
                        .background(Color("Pink"))
                        .clipShape(Circle())
                }
            }
            .padding(.bottom)
            .disabled(homeData.displaying_users?.isEmpty ?? false)
            .opacity((homeData.displaying_users?.isEmpty ?? false) ? 0.6 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    // Method that enables "swiping" by using the action buttons.
    func doSwipe(rightSwipe: Bool = false) {
        guard let first = homeData.displaying_users?.first else {
            return
        }
        
        // Use 'NotificationCenter' to POST the swipe action (and recieve it in 'StackCardView').
        NotificationCenter.default.post(name: NSNotification.Name("ACTIONFROMBUTTON"), object: nil,
            userInfo: [
                "id": first.id,
                "rightSwipe": rightSwipe
        ])
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
