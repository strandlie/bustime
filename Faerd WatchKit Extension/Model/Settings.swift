//
//  Settings.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 23/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import Combine

final class Settings: ObservableObject {
    @Published var firstScreenSelection = { () -> FirstScreenSelection in
        let savedValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.firstScreen.rawValue)
        switch(savedValue) {
            case FirstScreenSelection.list.rawValue:
                return FirstScreenSelection.list
            case FirstScreenSelection.favorites.rawValue:
                return FirstScreenSelection.favorites
            default:
                return FirstScreenSelection.list
        }
    }()
    
    static let shared = Settings()
    
    private var canc: AnyCancellable!
    
    
    init() {
        canc = $firstScreenSelection.sink(receiveValue: { newValue in
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.firstScreen.rawValue)
        })
    }
    
    deinit {
        canc.cancel()
    }

    
}

enum FirstScreenSelection: String, CaseIterable {
    case list = "list"
    case favorites = "favorites"
    
    init?(id: Int) {
        switch id {
        case 1: self = .list
        case 3: self = .favorites
        default: return nil
        }
    }
}



