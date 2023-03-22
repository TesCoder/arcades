// checkers content view

import SwiftUI


struct ProgressBarCheckers: View {
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

struct CheckersContentView: View {
    
    @ObservedObject var viewModel: CheckersGameFrameWork
    
    @State private var angle = 0.0

    @State private var card1 = -1
    @State private var card2 =  -1
    @State var progressValue: Float = 0

    @State var cardsTotal: Float = 0
 
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    
    /* Added for Timer*/
    @State private var timeRemaining = 600
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var timerColor = Color(uiColor: .green)
    @State private var blinkRadius: Double = 0
    
    
    // list of excluded game pieces and checkboard boxes during iteration
    // this is needed because the color of the last checkbox in a row is same as first, although it's every-other by design. To address this, the certain ones must be removed
    let excArrayString = ["9", "17", "18", "20", "25", "26", "31", "33", "34", "41", "42", "44", "49", "50", "55", "64", "73"]
    
    // Gestures in sequence
    // how far the circle has been dragged
    @State private var offset = CGSize.zero
    // whether it is currently being dragged or not
    @State private var isDragging = false
    
    // tracks player name
    @EnvironmentObject var nameData: NameTracker
    
    var body: some View {
                VStack{
                        Spacer()
                        // creates title
                        Text("Checkers!").font(.largeTitle) .foregroundColor(.blue).bold().rotationEffect(.degrees(angle))
                            .position(x: 200, y: 10)
                    Text("\(nameData.name), was this your favorite childhood game?") .multilineTextAlignment(.center)
                        .position(x: 200, y: 40)
                    
                    HStack{
                        /* Added */
                        Text("Time: \(timeRemaining)")
                            .font(.title3)
                            .foregroundColor(.black)
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
                    }.position(x: 200, y: 80)
                    

                    // resting place for pieces won top
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .foregroundColor(.white)
                                .frame(width: 324, height: 70)
                                .border(.green, width: 1)
                            Text("Move Won Pieces Here!").foregroundColor(.black)
                        }.position(x: 195, y: 140)
                    // resting place for pieces won bottom
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .foregroundColor(.green)
                                .frame(width: 324, height: 80)
                                .border(.black, width: 1)
                            Text("Move Won Pieces Here!").foregroundColor(.black)
                        }.position(x: 195, y: 559)
                    
                    // creates the back of gameboard that is black and red
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 35), spacing:4)]){
//                            let cardsTotalPrint = print("cardsTotal \(viewModel.cards.count)")
                            ForEach (viewModel.cards) { card in
                                if (!excArrayString.contains(card.content)) {
                                    ZStack{
                                        CheckersGameCard(card: card).aspectRatio(1, contentMode: .fit)
                                    }
                                }
                            }
                        }.padding(.horizontal, 40)
                    
                    // creates player pieces that are green and white
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 35), spacing:4)]){
//                            let cardsTotalPrint = print("cardsTotal \(viewModel.cards.count)")
                            ForEach (viewModel.cards) { card in
                                if (!excArrayString.contains(card.content)) {
                                    ZStack{
                                        Tokens(card: card).aspectRatio(1, contentMode: .fit)

                                    }
                                }
                            }
                        }.padding(.horizontal, 40)
                        
            }.scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { amount in
                        currentAmount = amount - 1
                    }
                    .onEnded { amount in
                        finalAmount += currentAmount
                        currentAmount = 0
                    }
            )
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
}

// Creates the red and black gameboard
struct CheckersGameCard: View {
    var card: UnitMaker.Card
    
    @State private var colors: [Color] = [.black, .red]
    
    @State private var animate = true
    
    var body: some View {
        
        let num = Int(card.content) ?? 0
        
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(colors[num % 2])
                .frame(width: 50, height: 40)
                .border(.black, width: 1)
                .onAppear() {
                    withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                        animate = true
                    }
                    //                .blendMode(.destinationOver) // transparent internal
                    
                }
        }.position(x: 18, y: 180)
    }
}

// creates game pieces green and white
struct Tokens: View {
    var card: UnitMaker.Card
    
    @State private var colors: [Color] = [.white, .red, .yellow]
    
    @State private var angle = 0.0
    @State private var animate = true
    
    // Gestures in sequence
    // how far the circle has been dragged
    @State private var offset = CGSize.zero
    // whether it is currently being dragged or not
    @State private var isDragging = false
    
    @State private var player1PiecesLocation: CGPoint = CGPoint(x: 13, y: -215)
    @State private var player2PiecesLocation: CGPoint = CGPoint(x: 13, y: -133)

    var body: some View {
        
        // creates int from card.content
        let num = Int(card.content) ?? 0
        
        let player1Pieces = ZStack {
            Circle()
                .fill(.green)
                .frame(width: 30, height: 30)
                .offset(offset) // x, y location
                .position(player1PiecesLocation)
                .gesture(DragGesture().onChanged { value in offset = value.translation; /*print("here"); print(self.player2PiecesLocation)*/})
                .padding(.top, 45)
                .shadow(color: .black, radius: 5)
        }
        
        let player2Pieces = ZStack{
            Circle()
                .fill(.white)
                .frame(width: 30, height: 30)
                .offset(offset) // x, y location
                .position(player2PiecesLocation)
                .gesture(DragGesture().onChanged { value in offset = value.translation; /*print("here"); print(self.player2PiecesLocation)*/})
                .padding(.top, 45)
                .shadow(color: .black, radius: 5)
        }

        
        if (card.isFaceUp) {
            ZStack{
                if (num % 2 == 0 && num < 32 )  {
                    //            let print2 = print(Text("\(card.content)\(card.isMatchedStat)"))
                    player1Pieces.onAppear() {
                        withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                            offset = .zero
                        }
                    }
                } else if (num % 2 == 0 && num > 55 ) {
                    player2Pieces.onAppear() {
                        withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                            offset = .zero
                        }
                    }
                }
            }
        } else {
            ZStack{
                if (num % 2 == 0 && num < 32 )  {
                    //            let print2 = print(Text("\(card.content)\(card.isMatchedStat)"))
                    player1Pieces.onAppear() {
                        withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                            offset = .zero
                        }
                    }
                } else if (num % 2 == 0 && num > 55 ) {
                    player2Pieces.onAppear() {
                        withAnimation(.timingCurve(0,1,1,1, duration: 0).delay( 0)) {
                            offset = .zero
                        }
                    }
                }
            }
        }
        
        
//            Text("\(num)").foregroundColor(.yellow)
        }
    
    }

struct CheckersContentView_Previews: PreviewProvider {
    static var previews: some View {
        CheckersContentView(viewModel: CheckersGameFrameWork())
     }
}


