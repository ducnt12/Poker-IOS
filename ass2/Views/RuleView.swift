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

struct RuleView: View {
    @Binding var showSheet: Bool
    @Binding var mute: Bool
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack{
                    
                    //MARK: blackjack image
                    ZStack {
                        HeaderView(showSheet: $showSheet, mute: $mute, color: darkYellow)
                    }.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height*0.3)
                        .background(Image("Black-Jack-background").resizable().edgesIgnoringSafeArea(.top))
                    
                    //MARK: rule form
                    Form{
                        Section(header: Text("The Objective of Blackjack")) {
                            Text("Beat the dealer").bold()
                        }.headerProminence(.increased)
                        
                        Section(header: Text("How to beat the dealer")) {
                            Text("By drawing a hand value that is higher than the dealer’s hand value")
                            Text("By the dealer drawing a hand value that goes over 21.")
                            Text("By drawing a hand value of 21 on your first two cards, when the dealer does not.")
                        }
                        
                        Section(header: Text("How do you lose to the dealer?")) {
                            Text("Your hand value exceeds 21.")
                            Text("The dealers hand has a greater value than yours at the end of the round")
                        }
                        
                        Section(header: Text("Card value")) {
                            Text("2 through 10 count at face value, i.e. a 2 counts as two, a 9 counts as nine")
                            Text("Face cards (J,Q,K) count as 10")
                            Text("Ace can count as a 1 or an 11 depending on which value helps the hand the most")
                        }
                        
                        Section(header: Text("Steps to play")) {
                            Text("Place bet")
                            Text("Each draw 2 cards(1 up and 1 down for dealer, 2 up for player)")
                            Text("Naturals (Get an ace and a 10, then win immediately)")
                            Text("Decide how to play hand (Hit, Double down, Stand, Surrender)")
                            Text("Dealer plays hand")
                            Text("Gain bet if you win, lose bet if you lose, keep bet if it is a tie")
                        }
                        
                        Section(header: Text("Player options")) {
                            Group{Text("Hit: ").bold() + Text("Draw one card a time (Draw as many as you want)")}
                            Group{Text("Double Down: ").bold() + Text("Double your bet and draw 1 more card before stand")}
                            Group{Text("Stand: ").bold() + Text("Stop your turn")}
                            Group{Text("Surrender: ").bold() + Text("Give up haft of your bet")}
                        }
                        
                        Section(header: Text("Player options")) {
                            Group{Text("Hit: ").bold() + Text("Draw one card a time (Draw as many as you want)")}
                            Group{Text("Double Down: ").bold() + Text("Double your bet and draw 1 more card before stand")}
                            Group{Text("Stand: ").bold() + Text("Stop your turn")}
                            Group{Text("Surrender: ").bold() + Text("Give up haft of your bet")}
                        }
                        
                        Section(header: Text("Application Information")) {
                            HStack {
                                Text("App Name")
                                Spacer()
                                Text("RMIT Casino")
                            }
                            HStack {
                                Text("Course")
                                Spacer()
                                Text("COSC2659")
                            }
                            HStack {
                                Text("Year Published")
                                Spacer()
                                Text("2022")
                            }
                            HStack {
                                Text("Location")
                                Spacer()
                                Text("Saigon South Campus")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct RuleView_Preview: PreviewProvider {
    static var previews: some View {
        RuleView(showSheet: .constant(true), mute: .constant(false))
    }
}
