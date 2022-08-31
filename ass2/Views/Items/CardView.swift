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

struct CardFace: View {
    let width: CGFloat
    let height: CGFloat
    let imageName: String
    @Binding var degree: Double
    
    var body: some View {
        ZStack {
            Image(imageName).resizable()
                .frame(width: width, height: height, alignment: .center)
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardView: View {
    let faceUpName: String
    let width: CGFloat
    let height: CGFloat

    private let durationAndDelay = 0.3

    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    @State private var isFlipped = false

    func flipCard() {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        }
    }

    var body: some View {
        ZStack {
            CardFace(width: width, height: height, imageName: "down_of_face", degree: $backDegree)
            CardFace(width: width, height: height, imageName: faceUpName, degree: $frontDegree)
        }.onAppear{
            flipCard()
        }.onDisappear{
            flipCard()
        }
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(faceUpName: "2_of_clubs", width: 65, height: 100)
    }
}
