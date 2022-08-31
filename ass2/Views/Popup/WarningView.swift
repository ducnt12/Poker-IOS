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

struct WarningView: View {
    @Binding var showWarning: Bool
    
    var body: some View {
        if showWarning {
            ZStack {
                Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
                
                HStack {
                    Image("warning").resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipShape(Circle())
                    Text("You are out of coin. Add more to continue!").foregroundColor(.white)
                }.padding().background(.red)
            }.onAppear{
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                    withAnimation(.easeInOut(duration: 1)) {
                        showWarning = false
                    }
                }
            }
            .onTapGesture {
                showWarning = false
            }
        }
    }
}

struct Warning_Preview: PreviewProvider {
    static var previews: some View {
        WarningView(showWarning: .constant(true))
    }
}


