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

import Foundation
import SwiftUI

struct MenuView: View {
    enum SheetContent {
        case rule, game, leaderboard
    }
    @Environment(\.colorScheme) var colorScheme
    
    @State var sheetContent: SheetContent? = nil
    @State private var showSheet = false
    @State private var showPopup = false
    @State private var mute = false
   
    func checkSound() -> String {
        if mute {
            SoundManager.instance.pauseBackgroundSound()
            return "speaker.slash.fill"
        }
        
        SoundManager.instance.playBackgroundSound(sound: .LocationsHappyVillage, fileType: .mp3)
        return "speaker.3.fill"
    }
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    ZStack{
                        Image(systemName: checkSound()).onTapGesture {
                            mute.toggle()
                        }.foregroundColor(darkGreen)
                    }.frame(maxWidth: .infinity, alignment: .topTrailing)
                        .padding(.bottom)
                        .padding(.trailing)
                    Image("blackjack-image").clipShape(Ellipse())
                        .shadow(radius: 20)
                    
                    Spacer().frame(height: geometry.size.height*0.04)
                    
                    Button("Start") {
                        sheetContent = .game
                        showSheet = true
                    }.frame(width: geometry.size.width*0.58, height: geometry.size.height*0.09)
                        .border(borderColor, width: 4)
                        .background(darkYellow)
                        .foregroundColor(darkGreen)
                        .font(bodyFont.bold())
                    
                    Spacer().frame(height: geometry.size.height*0.04)
                    
                    Button("Leadetboard"){
                        sheetContent = .leaderboard
                        showSheet = true
                    }.frame(width: geometry.size.width*0.58, height: geometry.size.height*0.09)
                        .border(borderColor, width: 4)
                        .background(darkYellow)
                        .foregroundColor(darkGreen)
                        .font(bodyFont.bold())
                    
                    Spacer().frame(height: geometry.size.height*0.04)
                    
                    Button("How to play") {
                        sheetContent = .rule
                        showSheet = true
                    }.frame(width: geometry.size.width*0.58, height: geometry.size.height*0.09)
                        .border(borderColor, width: 4)
                        .background(darkYellow)
                        .foregroundColor(darkGreen)
                        .font(bodyFont.bold())
                    .sheet(isPresented: $showSheet, content: {
                        switch sheetContent ?? .game{
                            case .rule:
                                RuleView(showSheet: $showSheet, mute: $mute)
                            case .game:
                            EnterUserView(mute: $mute, showSheet: $showSheet)
                            case .leaderboard:
                                LeaderboardView(showSheet: $showSheet, mute: $mute)
                        }
                    })
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
            .background(colorScheme == .light ? AnyView(Image("background").resizable().edgesIgnoringSafeArea(.all)) :
                AnyView(Image("dark_background").resizable().edgesIgnoringSafeArea(.all)))
        }
       
    }
}

struct MenuView_Preview: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
