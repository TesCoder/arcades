// Memory Game content view

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemOrange))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .opacity(0.9)
                        .foregroundColor(Color(UIColor.systemRed))
            }
            .cornerRadius(45)
            
        }
    }
}


struct MemoryGameContentView: View {
    
    @ObservedObject var viewModel: MemoryGameFramework
    
    @State private var angle = 0.0

    @State private var card1 = -1
    @State private var card2 =  -1
    @State var progressValue: Float = 0

    @State var cardsTotal: Float = 0

    /* Added for Timer*/
    @State private var timeRemaining = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var timerColor = Color(uiColor: .green)
    @State private var blinkRadius: Double = 0
    
    // tracks player name
    @EnvironmentObject var nameData: NameTracker
    
    var body: some View {
        ZStack{
            ScrollView {
                // creates title
                Text("Memory Game!").font(.largeTitle) .foregroundColor(.blue).bold().rotationEffect(.degrees(angle))
                Text("\(nameData.name), match each image with its pair.") .multilineTextAlignment(.center)
                
                HStack{
                    /* Added */
                    Text("Time: \(timeRemaining)")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(timerColor.opacity(1))
                        .clipShape(Capsule())
                        .shadow(color: Color(uiColor: .red), radius: blinkRadius)
                    
                    Button("Restart") {
                        withAnimation(){
                            viewModel.restart()
                            self.timeRemaining = 100
                        }
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(Color(uiColor: .blue))
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                }
                
                ProgressBar(value: $progressValue).frame(height: 20).padding([.leading, .trailing], 15).shadow(radius: 10)

                
                // creates LazyVGrid that iterates through images and displays
                // disables clicking when matched
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing:1)]){
//                    let cardsTotalPrint = print("cardsTotal \(viewModel.cards.count)")
                    ForEach (viewModel.cards) { card in
                        if card.isMatched == true && card.isMatchedStat == 2 {
                            GameCard(card: card).onAppear() {
                                self.startProgressBar(cardsTotal: Float(viewModel.cards.count))
                            }
                            
                        } else {
                            GameCard(card: card).aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    viewModel.choose(card)
                                }
                        }
                    }
                }
            }
            .onReceive(timer){ time in
                guard isActive else {return}
                
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
                
                if timeRemaining > 30 {
                    withAnimation() {
                        timerColor = Color(uiColor: .green)
                    }
                }
                else if timeRemaining < 30 && timeRemaining > 15 {
                    withAnimation(){
                        timerColor = Color(uiColor: .orange)
                    }
                }
                else if timeRemaining < 15 && timeRemaining > 10 {
                    withAnimation(){
                        timerColor = Color(uiColor: .red)
                    }
                }
                else if timeRemaining < 10 && timeRemaining > 0{
                    withAnimation(){
                        timerColor = Color(uiColor: .red)
                        startBlink()
                    }
                }
                else if timeRemaining == 0 {
                    viewModel.restart()
                    self.timeRemaining = 60
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    isActive = true
                } else {
                    isActive = false
                }
            }
        }
    }
    
    /* Added */
    func startBlink() {
        
        let seconds = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            withAnimation(){
                blinkRadius = 7.5
            }
//            print("opacitychange")
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                withAnimation(){
                    blinkRadius = 0
                }
//                print("opacitychange2")
            }
        }
    }
    
    func startProgressBar(cardsTotal: Float) {
//        let cardTotal2 = print("cardsTotal2 \(cardsTotal)")
        let progValTot: Float = cardsTotal/2.0
//        print("progValTot \(progValTot)")
            for _ in 0...Int(progValTot) {
                let jumpSize: Float = progValTot * 0.002
//                print("jumpSize \(jumpSize)")
                self.progressValue += jumpSize
            }
        }
        
    func resetProgressBar() {
        self.progressValue = 0.0
    }
    
}

// struct creates card view by using Z tack of rectangle and image
// it also creates a varaiable to control the faceUp or down of images
struct GameCard: View {
    var card: MemoryGame.Card
    
    // Gestures in sequence
    // how far the circle has been dragged
    @State private var offset = CGSize.zero
    // whether it is currently being dragged or not
    @State private var isDragging = false
    
    
    @State private var angle = 0.0
    @State private var animate = true
    
    var body: some View {
        ZStack{
            // creates a RoundedRectangle
            let greenBack = RoundedRectangle(cornerRadius: 10)
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
            
            let frameCard = ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.purple)
                        .frame(width: 80, height: 80)
                    Image(card.content).resizable()
                        .frame(width: 80, height: 80)
                    }
                    .rotation3DEffect(.degrees(angle), axis: (x: 0, y:1, z:0))
                    .opacity(animate ? 1.0 : 0.0)
                    .shadow(radius: 10)
            
            
            // face down card
            if !card.isFaceUp {
                greenBack.opacity(1)
                VStack {
//                    Text("FD\(String(card.isMatched))")
//                    Text("\(card.content)")
                }
//                let FaceDown = print("FaceDown \(card.content) \(card.isFaceUp) \(card.id) Stat\(card.isMatchedStat)")
                
            // new faceUp card (no matches, no twin)
            } else if card.isFaceUp && !card.isMatched && card.isMatchedStat == 0 {
//                // v1
//                frameCard.opacity(1)
                
                 //v2
                frameCard.onAppear() {
                    withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                        animate = true
                    }
                }
//                let faceUpMain = print("faceUpMain \(card.content) \(card.isFaceUp) \(card.id) Stat\(card.isMatchedStat)")
                VStack {
                    //Text("FU\(String(card.isMatched))")
                    //Text("\(card.content)")
                }
                
            // Matched: faceUp card & matched with a twin
            } else if card.isFaceUp && card.isMatched && card.isMatchedStat == 2 {
//                let twinMatched = print("TwinsMatched \(card.content) \(card.id) \(card.isFaceUp) Stat\(card.isMatchedStat)")
                frameCard.onAppear() {
                    withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                        animate = true
                    }
                }
                frameCard.opacity(1)
                frameCard            .gesture(DragGesture().onChanged { value in offset = value.translation })

                VStack {
                    Image(systemName: "checkmark").foregroundColor(.red)
//                    Text("FD\(String(card.isMatched))")
//                    Text("\(card.content)")
                }
                
            } else if card.isFaceUp && !card.isMatched && card.isMatchedStat == 1 {
//                let TwinsNotMatched = print("TwinsNotMatched \(card.content) \(card.id) \(card.isFaceUp)")
                greenBack.opacity(1)
                frameCard.onAppear() {
                    withAnimation(.timingCurve(0,1,1,1, duration: 3).delay( 1)) {
                        animate.toggle()
                    }
                }
                
                VStack {
//                    Text("FD\(String(card.isMatched))")
//                    Text("\(card.content)")
//                    Text("TwinNotMatched")
                }
            }
        }.padding()
    }
}

struct MemoryGameContentView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameContentView(viewModel: MemoryGameFramework()).environmentObject(NameTracker())

     }
}



