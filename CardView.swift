struct CardFace: View {
    let width: CGFloat
    let height: CGFloat
    let imageName: String
    @Binding var degree
    
    var body: some View {
        ZStack {
            Image(imageName).resizable()
                .frame(width: width, height: height, alignment: .center)
        }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct CardView: View {
    let faceUpName: String

    private let durationAndDelay = 0.3

    @State private var backDegree = 0.0
    @State private var frontDegree = -90.0
    @State var isFlipped = false

    func flipCard() {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        }
    }

    var body: some View {
        ZStack {
            CardFace(width: 65, height: 100, imageName: "down_of_face", degree: backDegree)
            CardFace(width: 65, height: 100, imageName: faceUpName, degree: frontDegree)
        }
    }
}