// home page view

import SwiftUI

extension HorizontalAlignment {
    enum MidAccountAndName2: AlignmentID {
        static func defaultValue(in f: ViewDimensions) -> CGFloat {
            f[.top]
        }
    }
    
    static let midAccountAndName2 = HorizontalAlignment(MidAccountAndName2.self)
    
}

struct HomePageView: View {
    // var to hold userName
    @State private var userName: String = ""
    
    // tracks player name across views
    @StateObject var nameData: NameTracker = NameTracker()
    
    // allows proceed once user enters correct length userName
    @State private var proceed: Bool = false
    
    // instructs user length of userName
    @State private var userNameInst: String = "*Must be at least 5 chars"
    
    @State private var animationAmount = 1.0
    
    var body: some View {
        NavigationView{
            ZStack {
                ZStack{
                    // Set Background Color
                    Color.black.ignoresSafeArea()

                    // Set Background Image
                    Image("background")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.95)
                }

                VStack{
                    
                    if (proceed == true) {
                        VStack{
                            // rectange spaceholder
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 200, height: 200)
                                .opacity(0)
                            
                            // displays updated name retreived from NameTracker()
                            Text("Welcome to \nArcades!\(nameData.name)!")
                                .foregroundColor(Color.white)
                                .font(.system(size: 70))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .shadow(radius: 10)
                                .shadow(color: .white, radius: 10)
                                .offset(x: 0, y: -60)
                            
                            ScrollView {
                                NavigationLink(destination:
                                    ChooseAGame()
                                ) {
                                    ZStack {
                                        // test to confirm data is being properly stored
    //                                    Text(nameData.assignerName(val: userName))

                                        Text("Play Now")
                                        .font(.title3)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 5)
                                        .background(Color(uiColor: .white))
                                        .clipShape(Capsule())
                                        .shadow(radius: 10)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        
                        ZStack{
                            Text("Welcome to \nArcades!")
                                .foregroundColor(Color.white)
                                .font(.system(size: 70))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .shadow(radius: 10)
                                .shadow(color: .white, radius: 10)
                            
                            Text("Welcome to \nArcades!")
                                .foregroundColor(Color.white)
                                .font(.system(size: 34))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                                .scaleEffect(animationAmount)
                                .animation(.easeInOut(duration: 1) .repeatCount(4, autoreverses: true), value: animationAmount)
                                .onAppear {
                                    animationAmount = 2
                                }.offset(x: -1, y: 5)
                                .shadow(color: .white, radius: 10)
                                .opacity(0.5)
                        }

                        VStack(alignment: .midAccountAndName2) {
                            HStack{
                                Text("Enter User\nName:")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20))
                                    .multilineTextAlignment(.center)
                                    .padding(.leading, 40.0)
                                    

                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                        .frame(width: 200, height: 35)
                                        .opacity(0.8)
                                        .border(.black, width: 1)

                                    TextField("Enter user name", text: $userName)
                                        .multilineTextAlignment(.center)
                                    
                                    // assigns new name to userName
                                    let newName = nameData.assignerName(val: userName)

                                }.padding(.leading, -30.0)
                                .alignmentGuide(.midAccountAndName2) {
                                    f in f[HorizontalAlignment.trailing]}
                            }
                        }
                        Text("\(userNameInst)")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                     
                        Button("Continue") {
                            if (userName.count >= 5) {
                                proceed = true
                            }
                        }
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Color(uiColor: .white))
                        .clipShape(Capsule())
                        .shadow(radius: 10)

                        // rectange spaceholder
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 200)
                            .opacity(0)
                    }
                     
                }
            }
        }.environmentObject(nameData)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
