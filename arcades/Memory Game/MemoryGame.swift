// Memory Game logic

import Foundation

struct MemoryGame {
    
    public var cards: Array<Card> // private(set) sets private allows getting but not setting
    private(set) var numberOfPairs: Int
    
    private(set) var revealedCards: Array<Card>
    private(set) var numberOfTaps: Int
    private(set) var roundCounter: Int
    public var tappedCardPosition: Int
    
    
    struct Card: Identifiable {
        var content: String
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var id: Int // required by Identifiable protocol
        var isMatchedStat: Int = 0 // defines card state 0: inactive, 1: active unmatched, 2: active matched
        
    }

    mutating func chooseCard(_ card: Card) {
        
        for index in cards.indices {
//            print("Stat: \(cards[index].content) \(cards[index].isFaceUp) \(cards[index].id) Stat\(card.isMatchedStat)")

            if cards[index].id == card.id {
                tappedCardPosition = index
                if cards[index].isFaceUp == true && cards[index].isMatchedStat == 1 {
                } else {
                    cards[index].isFaceUp.toggle()
                }
//                print("SelStat: \(cards[index].content) \(cards[index].isFaceUp) \(cards[index].id) Stat\(card.isMatchedStat)")
//                print("--")
                tappedCardPosition = index
            }
        }
         
        if numberOfTaps == 1 {
//            print("*********************************")
//            print("ROUND\(roundCounter)")
//            print("Tap# \(numberOfTaps)")
//            print("sCardTap1v2: \(cards[tappedCardPosition])")

            revealedCards[0] = Card(content: card.content, isFaceUp: true, isMatched: false, id: tappedCardPosition, isMatchedStat: 0)
                
                //  v2 for unmatched cards isMatchedStat == 1, resets isMatchedStat
                for index in cards.indices {
                    if cards[tappedCardPosition].content == cards[index].content
                        &&  cards[tappedCardPosition].id == cards[index].id
                        && cards[index].isMatchedStat == 1 && cards[index].isFaceUp == true {
//                        print("test2 \(cards[tappedCardPosition])")
                        cards[index].isMatchedStat = 0
                    }
                }
//            print("cardsisTwinUpd: \(cards)")
        }

        if numberOfTaps == 2 {
//            print("sCardTap2v2: \(cards[tappedCardPosition])")
            
            revealedCards[1] = Card(content: card.content, isFaceUp: true, isMatched: false, id: tappedCardPosition, isMatchedStat: 0)
//            print("rCardTap2: \(revealedCards)")
            
//            if cards[tappedCardPosition].content == card.content {
            if revealedCards[0].content == revealedCards[1].content {
                print(">Matched")
                cards[revealedCards[0].id].isMatched.toggle()
                cards[revealedCards[1].id].isMatched.toggle()

                cards[revealedCards[0].id].isMatchedStat = 2
                cards[revealedCards[1].id].isMatchedStat = 2
                
                revealedCards[0] = Card(content: "blank", isFaceUp: false, isMatched: false, id: 0)
                revealedCards[1] = Card(content: "blank", isFaceUp: false, isMatched: false, id: 0)
                numberOfTaps = 1
                
                for index in cards.indices {
                    if cards[index].isMatchedStat == 2 {
//                        print("Matched cards: \(cards[index])")
                    }
                }
            } else {
//                print("Not matched")
                cards[revealedCards[0].id].isMatchedStat = 1
                cards[revealedCards[1].id].isMatchedStat = 1

                for index in cards.indices {
                    if cards[index].isMatchedStat == 1 {
//                        print("Unmatched cards: \(cards[index])")
                    }
                }
                
                revealedCards[0] = Card(content: "blank", isFaceUp: false, isMatched: false, id: 0)
                revealedCards[1] = Card(content: "blank", isFaceUp: false, isMatched: false, id: 0)
                numberOfTaps = 1
            }
            roundCounter += 1
        } else {
            numberOfTaps += 1
//            print("round end")
        }
    }
    
    init(numberOfPairsOfCards: Int, contentFactory: (Int) -> String){
        cards = []
        numberOfPairs = numberOfPairsOfCards
        numberOfTaps = 1
        tappedCardPosition = 0
        roundCounter = 1
        revealedCards = []
        
        //  reserves memory/array positions for line 32 to work, or causes error
        for index in 0..<2 {
            let content = "blank"
            revealedCards.append(Card(content: content, id: index))
        }
        
        for index in 0..<numberOfPairsOfCards {
            let content = contentFactory(index)
            cards.append(Card(content: content, id: index * 2))
            cards.append(Card(content: content, id: index * 2 + 1))
        }
        cards.shuffle()
    }
    
    /* Added */
    mutating func restart() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isMatchedStat = 0
            roundCounter = 1
            numberOfTaps = 1
            tappedCardPosition = 0
        }
        cards.shuffle()
    }
}



