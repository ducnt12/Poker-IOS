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

struct HeaderView: View {
    @Binding var showSheet: Bool
    @Binding var mute: Bool
    var color: Color
    
    func checkSound() -> String {
        if mute {
            return "speaker.slash.fill"
        }
        return "speaker.3.fill"
    }
    
    var body: some View {
        HStack{
            HStack(alignment: .top){
                Image(systemName: "chevron.left.2").onTapGesture {
                    showSheet = false
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
                    .foregroundColor(color)
                Image(systemName: checkSound()).onTapGesture {mute.toggle()}
                    .foregroundColor(color)
            }.padding()
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(showSheet: .constant(true), mute: .constant(false), color: .black)
    }
}
