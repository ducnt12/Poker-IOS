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

struct EnterUserView: View {
    private let funcs = Common()
    private let difficulties = ["Beginner", "Pros"]
    
    @Binding var mute: Bool
    @Binding var showSheet: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var username = String()
    @State private var showGameView = false
    @State private var showText = false
    @State private var index = 0
    @State private var darkMode = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HeaderView(showSheet: $showSheet, mute: $mute, color: darkGreen)
                    .padding()
                VStack {
                    HStack{
                        TextField("Username", text: $username)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .padding()
                            .border(borderColor, width: 3)
                            .background(colorScheme == .light ? darkYellow : .black)
                        Button("Start game"){
                            if username != "" {
                                funcs.login(username: username)
                                showGameView = true
                            } else {
                                showText = true
                            }
                        }.fullScreenCover(isPresented: $showGameView, content: {
                            GameView(showSheet: $showGameView, mute: $mute,username: username, difficulty: difficulties[index])
                        })
                        .padding()
                        .background(darkYellow)
                        .border(borderColor, width: 4)
                        .foregroundColor(darkGreen)
                        
                    }.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height*0.29)
                    if showText {
                        Text("Enter your username to start game").foregroundColor(.red).onAppear{
                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                                withAnimation(.easeInOut(duration: 1)) {
                                    showText = false
                                }
                            }
                        }
                    }
                    NavigationView {
                        Form{
                            Section("Settings"){
                                Picker(selection: $index, label: Text("Difficulty")) {
                                    ForEach(0 ..< difficulties.count, id: \.self) {
                                        Text(self.difficulties[$0])
                                        }
                                    }
                                Toggle("Dark mode", isOn: $darkMode)
                            }.frame(maxHeight: .infinity,alignment: .top)
                            
                        }
                    }.navigationTitle("Difficuty")
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding()
            }.background{
                Image("background").resizable().edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct EnterUserView_Preview: PreviewProvider {
    static var previews: some View {
        EnterUserView(mute: .constant(false), showSheet: .constant(true))
    }
}
