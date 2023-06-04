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
    
    // Properties that are required for the swipe gesture.
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe: Bool = false
    
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
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({ value in
                    // Update the card's X-axis offset while it's being dragged, otherwise set it to zero.
                    let translation = value.translation.width
                    offset = (isDragging ? translation: .zero)
                })
                .onEnded({ value in
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    withAnimation {
                        if checkingStatus > (width / 2) {
                            // Remove the card from the screen if it's dragged a sufficient distance.
                            offset = (translation > 0 ? width : -width) * 2
                            endSwipeActions()
                            
                            if translation > 0 {
                                rightSwipe()
                            } else {
                                leftSwipe()
                            }
                        } else {
                            // Reset the card to the center if it's not dragged far enough.
                            offset = .zero
                        }
                    }
                })
        )
        // Recieve the swipe POST notification from 'Home'.
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"), object: nil)) { data in
            guard let info = data.userInfo else {
                return
            }
            
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let width = getRect().width - 50
            
            if user.id == id {
                // Remove the card if the swiped card ID matches the ID of the current card on the stack.
                withAnimation {
                    offset = (rightSwipe ? width : -width) * 2
                    endSwipeActions()
                    
                    if rightSwipe {
                        self.rightSwipe()
                    } else {
                        leftSwipe()
                    }
                }
            }
        }
    }
    
    // Method to calculate the downward rotation of cards as they are swiped.
    func getRotation(angle: Double) -> Double {
        let rotation = (offset / (getRect().width - 50)) * angle
        return rotation
    }
    
    func endSwipeActions() {
        withAnimation(.none){endSwipe = true}
        
        // After the card is moved away from the screen, remove it from the array to preserve memory (delay time is based on the animation duration).
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let _ = homeData.displaying_users?.first {
                let _ = withAnimation {
                    homeData.displaying_users?.removeFirst()
                }
            }
        }
    }
    
    func leftSwipe() {
        print("Left swipe actions...")
    }
    
    func rightSwipe() {
        print("Right swipe actions...")
    }
}

struct StackCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Extend on 'View' to get the screen bounds.
extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
