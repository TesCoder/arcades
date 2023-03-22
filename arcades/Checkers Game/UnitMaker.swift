// playing unit maker

import Foundation

struct UnitMaker {
    
    public var cards: Array<Card> // private(set) sets private allows getting but not setting
    private(set) var numberOfPairs: Int
    
    struct Card: Identifiable {
        var content: String
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var id: Int // required by Identifiable protocol
        var isMatchedStat: Int = 0 // defines card state 0: inactive, 1: active unmatched, 2: active matched
    }

    mutating func chooseCard(_ card: Card) {
        
        for index in cards.indices {
            if cards[index].id == card.id {
                print(cards[index].content, cards[index].isMatchedStat)
                        
            if ((Int(card.content) ?? 0) % 2 == 0 && (Int(card.content) ?? 0) < 32 )  {
                print("pieces1")
                cards[index].isMatchedStat = 1
            } else if ((Int(card.content) ?? 0) % 2 == 0 && (Int(card.content) ?? 0) > 55 ) {
                print("pieces2")
                cards[index].isMatchedStat = 3
                print(cards[index].isMatchedStat, cards[index].content)
            }
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, contentFactory: (Int) -> String){
        cards = []
        numberOfPairs = numberOfPairsOfCards
//
        for index in 0..<numberOfPairsOfCards {
            let content = contentFactory(index)
            cards.append(Card(content: content, id: index * 2 + 1))
        }
//        cards.shuffle()
    }
    
    /* Restarts game */
    mutating func restart() {
        
        for index in cards.indices {
            cards[index].isFaceUp.toggle()
        }
        
    }
}



