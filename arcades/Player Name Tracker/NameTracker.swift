// player name tracker accross views

import Foundation
import Combine


class NameTracker : ObservableObject {
    @Published var timeCount = 0
    
    var name: String

    init() {
        name = ""
    }
    
    // name assigner
    func assignerName(val: String) -> String {
        name = val
        return name
    }
    
    @objc func timerDidFire() {
        timeCount += 1
    }
    
    func resetCount() {
        timeCount = 0
    }
}

