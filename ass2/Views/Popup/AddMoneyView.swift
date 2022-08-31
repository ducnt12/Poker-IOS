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

struct AddCoinView: View {
    @Binding var showAddCoin: Bool
    @Binding var player: Player
    var height: CGFloat
    var width: CGFloat
    
    @State private var input = NumbersOnly()
    
    var body: some View {
        if showAddCoin {
            ZStack {
                Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        //MARK:Text field
                        TextField("Add coin", text: $input.value)
                            .foregroundColor(.black)
                            .keyboardType(.decimalPad)
                    }.padding()
                        .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 3))
                    HStack{
                        //MARK: Buttons
                        Button("Add") {
                            player.coin += Int(input.value) ?? 0
                            showAddCoin = false
                        }.padding().background(lightBlue).foregroundColor(.white)
                            .frame(width: width, height: height)
                        Button("Cancel") {
                            showAddCoin = false
                        }.padding().background(lightBlue).foregroundColor(.white)
                            .frame(width: width, height: height)
                    }
                    
                }.padding()
                .background(darkYellow)
            }
        }
    }
}

struct Add_Preview: PreviewProvider {
    static var previews: some View {
        AddCoinView(showAddCoin: .constant(true), player: .constant(Player(username: "")),height: 40, width: 200)
    }
}
