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

struct HighscoreView: View {
    @Binding var showHighscore: Bool
    var consecutiveWin: Int
    
    var body: some View {
        if showHighscore {
            ZStack{
                Text("New win streak: \(consecutiveWin)")
                    .padding()
                    .background(darkYellow)
                    .cornerRadius(15)
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .onAppear{ Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { timer in
                    withAnimation(.easeInOut(duration: 1)) {
                        showHighscore = false
                        SoundManager.instance.stopSound()
                    }
                }}
        }
    }
}

struct Highscore_Preview: PreviewProvider {
    static var previews: some View {
        HighscoreView(showHighscore: .constant(true), consecutiveWin: 2)
    }
}
