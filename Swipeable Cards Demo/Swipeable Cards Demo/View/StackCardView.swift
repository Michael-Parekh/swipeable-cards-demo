//
//  StackCardView.swift
//  Swipeable Cards Demo
//
//  Created by Michael Parekh on 5/26/23.
//

import SwiftUI

// 'StackCardView' represents each of the swipeable User cards.
struct StackCardView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: User
    
    var body: some View {
        // Use 'GeometryReader' to read the size and position of the card's parent view (so we can create a layout that adapts to changes in the parent view’s size and position).
        GeometryReader { proxy in
            let size = proxy.size
            
            let index = CGFloat(homeData.getIndex(user: user))
            // Use the index of the current User to show the offset preview of the next two cards at the top (only first three Users).
            let topOffset = (index <= 2 ? index : 2) * 15
            
            ZStack {
                Image(user.profilePic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - topOffset, height: size.height)
                    .cornerRadius(15)
                    .offset(y: -topOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .contentShape(Rectangle())
    }
}

struct StackCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
