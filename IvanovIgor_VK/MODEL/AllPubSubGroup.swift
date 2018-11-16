//
//  AllPubSubGroup.swift
//  IvanovIgor_VK
//
//  Created by MAC on 26.09.2018.
//  Copyright © 2018 com.home. All rights reserved.
//

import Foundation



class PubSubGroup {
    var id: Int!
    var name: String!
    var description:String!
    var logo: String!
    
    init(id: Int, name: String, description: String, logo: String){
        self.id = id
        self.name = name
        self.description = description
        self.logo = logo
    }
    
    public class func allPubSubList()->[PubSubGroup] {
        return [
            PubSubGroup(id: 1, name: "Gambling", description: desc, logo: "🎲"),
            PubSubGroup(id: 2, name: "Classic Music", description: desc, logo: "🎻"),
            PubSubGroup(id: 3, name: "Computer Games", description: desc, logo: "🎮"),
            PubSubGroup(id: 4, name: "Airplans", description: desc, logo: "✈️"),
            PubSubGroup(id: 5, name: "Classic Buildings", description: desc, logo: "🏛"),
            PubSubGroup(id: 6, name: "Religion", description: desc, logo: "🕌"),
            PubSubGroup(id: 7, name: "Banks and Money", description: desc, logo: "🏦"),
            PubSubGroup(id: 8, name: "Time Management", description: desc, logo: "⏰"),
            PubSubGroup(id: 9, name: "Middle Ages", description: desc, logo: "⚔️"),
            PubSubGroup(id: 10, name: "Japanese Dolls", description: desc, logo: "🎎"),
            PubSubGroup(id: 11, name: "Celebration", description: desc, logo: "🎉"),
            PubSubGroup(id: 12, name: "Iphones", description: desc, logo: "📱"),
            PubSubGroup(id: 13, name: "Retro Tech", description: desc, logo: "💽"),
            PubSubGroup(id: 14, name: "Night Cities", description: desc, logo: "🏙"),
            PubSubGroup(id: 15, name: "Locations", description: desc, logo: "📍"),
            PubSubGroup(id: 16, name: "Lazy People", description: desc, logo: "💤"),
            PubSubGroup(id: 17, name: "Races", description: desc, logo: "🏁"),
            PubSubGroup(id: 18, name: "Helicopters", description: desc, logo: "🚁")
        ]
    }
}

