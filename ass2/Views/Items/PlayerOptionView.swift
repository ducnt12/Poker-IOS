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

struct PlayerOptionView: View {
    @Binding var playerTurn: Bool
    var width: CGFloat
    var height: CGFloat
    var name: String
    
    
    var body: some View {
        Text(name).disabled(playerTurn).padding()
            .frame(width: width,
                   height: height).cornerRadius(15)
            .foregroundColor(.white)
            .background(darkYellow)
    }
}
