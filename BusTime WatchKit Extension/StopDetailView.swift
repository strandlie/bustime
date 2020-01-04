//
//  StopDetailView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 16/08/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI
import Combine

struct StopDetailView: View {
    let stop: BusStop
    let distance: String
    
    @ObservedObject var departureList: DepartureList
    @EnvironmentObject var favoriteList: FavoriteList
    
    let filterClosure = { (departure: Departure) -> Bool in
        return departure.time.timeIntervalSinceNow >= 0
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(stop.name)
                    .bold()
                    .lineLimit(3)
                    .font(.title)
                    .truncationMode(.middle)
                HStack {
                    Button(action: { self.toggleFavorite() }  ) {
                        IconController.getSystemIcon(for: .star)
                            .colorMultiply(favoriteList.existsLocationFavorite(for: stop) ? .yellow : .white)
                    }.frame(width: 65)
                    Text(distance)
                        .font(.headline)
                    ForEach(stop.types, id: \.self) { type in
                        IconController.getIcon(for: type.rawValue)
                            .font(.title)
                    }
                }
            }
            departureList.departures.count == 0
                ? VStack{
                    Text("Ingen avganger")
                    }
                : nil
            
            ForEach(departureList.departures.filter(filterClosure)) { departure in
                
                NavigationLink(destination: LineDetailView(departureList: DepartureList(departures: self.departureList.filterDown(forPublicCode: departure.publicCode, forDestinationName: departure.destinationName)), stop: self.stop, distance: self.distance)) {
                    HStack {
                        ZStack(alignment: .leading) {
                            Text("123")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.publicCode)
                                .font(.subheadline)
                        }
                        ZStack(alignment: .leading) {
                            Text("111111111111111111")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.destinationName)
                                .font(.headline)
                                .truncationMode(.tail)
                                .lineLimit(2)
                        }
                        ZStack(alignment: .trailing) {
                            Text("22:30")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.formatTime(departure.time))
                                .italic()
                                .font(.headline)
                                .foregroundColor(departure.isRealTime ? .yellow : .white)
                        }
                    }
                }
                
            }
         
        }
        .navigationBarTitle("Avganger")
    }
    
    private func toggleFavorite() {
        if let existingFavorite = self.favoriteList.getLocationFavorite(for: self.stop) {
            self.favoriteList.remove(existingFavorite)
        } else {
            self.favoriteList.append(Favorite(self.stop))
        }
    }
    
}

#if DEBUG
struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
#endif
