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

// Card struct
struct Card: Identifiable, Codable, Equatable{
    var id = UUID()
    var type: String
    var rank: String
    var imageName: String
    var value = Int()

    init(type: String, rank: String) {
        self.type = type
        self.rank = rank
        self.imageName = "\(self.rank)_of_\(self.type)"
        self.calculateValue()
    }
    
    mutating func calculateValue() {
        if (self.rank == "jack" || self.rank == "queen" || self.rank == "king") {
            self.value = 10
        } else if (self.rank == "ace") {
            self.value = 11
        } else {
            self.value = (Int(rank) ?? 0)!
        }
    }
}
