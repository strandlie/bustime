//
//  BusStopList.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 19/08/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation

class BusStopList: ObservableObject {
    
    static let shared = BusStopList()
    
    @Published var stops: [BusStop]
    
    var distances: [String: String] = [:]
    
    func get(for id: String) -> BusStop? {
        return stops.first { $0.id == id }
    }
    
    func getClosestToUser() -> BusStop? {
        var closest: BusStop?
        var minDist: Double = Double.infinity
        stops.forEach { stop in
            let distance = User.shared.actualDistance(to: stop.location) ?? Double.infinity
            if (distance < minDist) {
                closest = stop
                minDist = distance
            }
        }
        return closest
    }
    
    func append(_ stop: BusStop) {
        if !self.stops.contains(stop) {
            self.stops.append(stop)
        }
        distances[stop.id] = User.shared.formattedDistance(to: stop.location)
    }
    
    func remove(at offset: Int, for stop: BusStop) {
        if self.stops.contains(stop) {
            self.stops.remove(at: offset)
        }
        distances.removeValue(forKey: stop.id)
    }
    
    func clean() {
           self.stops = self.stops.filter({ stop in
               guard let distance = User.shared.actualDistance(to: stop.location) else {
                   // This only happens if the user has no known location. In that case it should
                   // not display any stops, as the value of this app is only when location is known
                   return false
               }
               return distance < APIController.SEARCH_RADIUS
           })
    }
    
    func updateDepartures() {
        self.stops.forEach { stop in
            stop.updateRealtimeDepartures()
        }
    }
    
    func updateDistances() {
        self.stops.forEach { stop in
            distances[stop.id] = User.shared.formattedDistance(to: stop.location)
        }
    }
    
    func removeAll() {
        self.stops.forEach { stop in
            stop.departures.departures.removeAll()
        }
        self.stops.removeAll()
    }
    
    
    init() {

        self.stops = []
        self.distances = [:]
    }
    
}
