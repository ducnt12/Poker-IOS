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

struct LeaderboardView: View {
    @Binding var showSheet: Bool
    @Binding var mute: Bool
    
    private let funcs = Common()
    
    @State private var players = [Player]()
    
    func initialize() {
        players = funcs.getAllPlayers()
        players = players.sorted {
            $0.consecutiveWin > $1.consecutiveWin
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HeaderView(showSheet: $showSheet, mute: $mute, color: darkGreen).frame(width: geometry.size.width, height: geometry.size.height*0.01)
                    .padding(.top)
                    .padding(.bottom, geometry.size.height*0.1)
                    .background(darkYellow)
                
                List{
                    ForEach(players, id: \.id) {player in
                        HStack {
                            Image("user").resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            Text(player.username).font(bodyFont).foregroundColor(darkGreen)
                            Text("\(player.consecutiveWin)").frame(maxWidth: .infinity, alignment: .trailing).font(bodyFont).foregroundColor(darkGreen)
                        }.padding()
                            .background(darkYellow)
                            .cornerRadius(5)
                    }
                }.background(.pink)
            }.overlay(
                Text("Leaderboard").foregroundColor(.white).font(headerFont).padding().background(lightBlue)
                    .offset(y: -geometry.size.height*0.39)
                    
            )
            .onAppear{self.initialize()}
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct LeaderboardView_Preview: PreviewProvider {
    static var previews: some View {
        LeaderboardView(showSheet: .constant(true), mute: .constant(false))
    }
}
