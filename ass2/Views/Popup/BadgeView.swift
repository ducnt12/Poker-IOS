/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Nguyen Trung Duc
  ID: s3695504
  Created  date: 22/8/2022
  Last modified: 29/8/2022
  Acknowledgement: Lecture slides
*/

import SwiftUI

struct BadgeView: View {
    @Binding var showBadge: Bool
    var imageName: String
    var achievemnetName: String
    var achievementContent: String
    
    var body: some View {
        if showBadge {
            ZStack{
                HStack{
                    Image(imageName).resizable().frame(width: 50, height: 50)
                        .clipShape(Circle())
                    VStack {
                        Text(achievemnetName).foregroundColor(.white)
                        Text(achievementContent).foregroundColor(.white)
                    }
                }.padding()
                    .background(darkYellow)
                    .cornerRadius(15)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .onAppear{ Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { timer in
                    withAnimation(.easeInOut(duration: 1)) {
                        showBadge = false
                        SoundManager.instance.stopSound()
                    }
                }}
        }
    }
}

struct BadgeView_Preview: PreviewProvider {
    static var previews: some View {
        BadgeView(showBadge: .constant(true), imageName: "blackjack master", achievemnetName: "dasdsa", achievementContent: "dasdds")
    }
}
