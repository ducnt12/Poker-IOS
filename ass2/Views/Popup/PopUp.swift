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

struct PopUp: View {
    @Binding var showPopup: Bool
    var imageName: String
    var dealerCards: [Card]
    var playerCards: [Card]
    var playerPoint: Int
    var dealerPoint: Int
    var height: CGFloat
    
    @State private var showDetails = false
    
    var body: some View {
        if showPopup {
            ZStack {
                Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(imageName).resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showPopup = false
                                SoundManager.instance.stopSound()
                            }
                        }
                    Button("See Details") {
                        showDetails.toggle()
                    }.foregroundColor(.white)
                        
                        
                    if showDetails {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                HStack {
                                    ForEach(dealerCards, id: \.id) { card in
                                        CardView(faceUpName: card.imageName, width: 50, height: 100)
                                    }
                                    
                                    Text("\(dealerPoint)").foregroundColor(.white).frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                HStack {
                                    ForEach(playerCards, id: \.id) { card in
                                        CardView(faceUpName: card.imageName, width: 50, height: 100)
                                    }
                                    
                                    Text("\(playerPoint)").foregroundColor(.white).frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }
                    }
                }.padding()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct Popup_Preview: PreviewProvider {
    static var previews: some View {
        PopUp(showPopup: .constant(true), imageName: "you win", dealerCards: [], playerCards: [], playerPoint: 0, dealerPoint: 0, height: 350)
    }
}


