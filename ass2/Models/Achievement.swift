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

struct Achievement: Identifiable, Codable, Equatable{
    var id = UUID()
    var name: String
    var content: String
    var image_name = ""
    var gained = false

    init(name: String, content: String) {
        self.name = name
        self.content = content
        image_name = self.name.lowercased()
    }
}
