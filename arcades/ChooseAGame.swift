// game selection view

import SwiftUI

struct ChooseAGame: View {
    // tracks userName across views
    @EnvironmentObject var nameData: NameTracker

    
    var body: some View {
            
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ScrollView {

                NavigationLink(destination:
                    MemoryGameContentView(viewModel: MemoryGameFramework())
                    ) {
                        ZStack {
                            Image("brain")
                            Text("Play \nMemory Game!")
                                .foregroundColor(Color.white)
                                .font(.system(size: 50))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .shadow(color: Color(uiColor: .red), radius: 3)
                        }
                    }
                    
                    NavigationLink(destination:
                    CheckersContentView(viewModel: CheckersGameFrameWork())
                    ) {
                        ZStack {
                            Image("checkers")
                            Text("Play \nCheckers!")
                                .foregroundColor(Color.white)
                                .font(.system(size: 50))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .shadow(color: Color(uiColor: .green), radius: 3)
                        }
                    }
                }
            }
    }
}

struct ChooseAGame_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAGame().environmentObject(NameTracker())
    }
}
