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

struct Player: Identifiable, Codable{
    var id = UUID()
    var username: String
    var coin = 100
    var highscore = 0
    var consecutiveWin = 0
    var blackjack = 0
    var achievements = [Achievement(name: "New champion", content: "Won 2 consecutive games"),
                        Achievement(name: "Blackjack master", content: "Had 3 blackjacks")]

    init(username: String) {
        self.username = username
    }
}
