//
//  Departure.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 08/09/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import Combine

class Departure: ObservableObject, Identifiable {
    
    @Published var time: Date
    var timeToDeparture: String {
        get {
            return Departure.formatTime(time)
        }
        set {
            fatalError("Cannot set timeToDeparture in Departure-class")
        }
    }
    
    let id: String
    let destinationName: String
    let publicCode: String
    var isRealTime: Bool
    
    
    
    init(time: Date, isRealTime: Bool, destinationName: String, publicCode: String) {
        self.id = UUID().uuidString
        self.time = time
        self.isRealTime = isRealTime
        self.destinationName = destinationName
        self.publicCode = publicCode
    }
    
    
    static func formatTime(_ time: Date) -> String {
        if time.timeIntervalSinceNow > 9 * 60 {
            /*
            If the departure is more than 10 minutes in the future, return
            the time of departure correctly formatted
            */
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: time)
            let hourString = hour < 10 ? "0" + String(hour) : String(hour)
            
            let minute = calendar.component(.minute, from: time)
            let minuteString = minute < 10 ? "0" + String(minute) : String(minute)
            
            return "\(hourString):\(minuteString)"
    
        }
        /*
        Else return the waiting time in minutes
         */
        return String(format: "%.0f", time.timeIntervalSinceNow / 60) + " min"
    }
}
