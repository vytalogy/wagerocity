//
//  OddHolder.swift
//  wagerocity
//
//  Created by Syed Haris Hussain on 04/07/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

class OddHolder:NSObject, Equatable {
    
    var stake: Double = 0.0
    var teamId: String = ""
    var oddId: String = ""
    var name: String = ""
    var teamVsTeam: String = ""
    var oddValue: String = "0.0"
    var betTypeSPT: String = ""
    var betOT: String = ""
    var betTypeString: String = ""
    var pointSpreadString: String = ""
    var teaserString: String = ""
    var oddType : String = "ao"
    var isChecked:Bool = false
    var leagueName : String = ""
    var riskValue: String = ""
    var parlayValue: Double = 0.0
    var position : String = ""
    var teaser1: Int = 0
    var teaser2: Int = 0
    var teaser3: Int = 0
    var teaserValues: Dictionary<Double, Int> = Dictionary<Double, Int>()
    var isTeamA:Bool = false
    var poolId:String = ""
    var poolCredit : Double = 0.0
    
}

func ==(lhs: OddHolder, rhs: OddHolder) -> Bool {
    if lhs.oddId == rhs.oddId &&
        lhs.name == rhs.name &&
    lhs.oddType == rhs.oddType &&
    lhs.betTypeSPT == rhs.betTypeSPT &&
    lhs.isChecked == rhs.isChecked &&
    lhs.oddValue == rhs.oddValue &&
    lhs.stake == rhs.stake &&
    lhs.oddValue == rhs.oddValue &&
        lhs.parlayValue == rhs.parlayValue {
            return true
    } else {
        return false
    }
}


