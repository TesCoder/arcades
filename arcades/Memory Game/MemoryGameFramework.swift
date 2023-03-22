// Memory Game game framework

import SwiftUI

class MemoryGameFramework: ObservableObject {

    @Published private var model: MemoryGame =  CreateMemoryGame()

    static func CreateMemoryGame() -> MemoryGame {
        return MemoryGame(numberOfPairsOfCards: 6, contentFactory: makeContent)
    }
    
    static func makeContent(index: Int)-> String {
        let images = ["Airedale Terrier", "American Foxhound", "Dutch Shepherd", "Havanese", "Leonberger", "Mudi", "Norwegian Lundehund", "Pharaoh Hound", "Scottish Terrier", "Tosa", "Pitbull", "Rottweiler"]
        return images[index]
    }
    
    var cards: Array<MemoryGame.Card>{
        model.cards
    }
    
    var pairs: Int {
        model.numberOfPairs
    }
    
    func choose(_ card: MemoryGame.Card) {
        model.chooseCard(card)
    }
    
    /* Added */
    func restart() {
        model.restart()
    }

}
