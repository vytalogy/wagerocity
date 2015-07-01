//
//  Utils.swift
//  wagerocity
//
//  Created by Haris on 26/06/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

import UIKit


class Utils: NSObject {
    
    static func getUser () -> User {
        let data = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaults.User) as! NSData
        var user: User = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! User
        return user
    }
    
    static func showLoader () {
        SVProgressHUD.showWithStatus("Loading", maskType:UInt(SVProgressHUDMaskTypeBlack))
    }
    
    static func hideLoader () {
        SVProgressHUD.dismiss()
    }
    
    static func showError (error: NSError) {
        SVProgressHUD.showErrorWithStatus(error.localizedDescription)
    }
    
    static func sportsList () -> Array<String> {
        return ["NFL", "NCAA Football", "MLB", "NBA", "NCAA Basketball", "NHL", "Soccer" ,"Tennis"]
    }
    
    static func sportsImage(name: String) -> UIImage {
        var string = name.lowercaseString
        if string == "nfl" {
            return UIImage(named: "nfl")!
        } else if string == "ncaa football" {
            return UIImage(named: "ncaa_football")!
        } else if string == "mlb" {
            return UIImage(named: "mlb")!
        } else if string == "nba" {
            return UIImage(named: "nba")!
        } else if string == "ncaa basketball" {
            return UIImage(named: "ncaa_basketball")!
        } else if string == "nhl" {
            return UIImage(named: "nhl")!
        } else if string == "soccer" {
            return UIImage(named: "soccer")!
        }else if string == "tennis" {
            return UIImage(named: "tennis")!
        }
        return UIImage(named: "sports")!
    }
    
    static func sportsNameForParam (name: String) -> String {
        var string = name.lowercaseString
        
        if string == "nfl" {
            return "nfl"
        } else if string == "ncaa football" {
            return "ncaaf"
        } else if string == "mlb" {
            return "mlb"
        } else if string == "nba" {
            return "nba"
        } else if string == "ncaa basketball" {
            return "ncaab"
        } else if string == "nhl" {
            return "nhl"
        } else if string == "soccer" {
            return "soccer"
        }else if string == "tennis" {
            return "tennis"
        }
        return ""
    }
    
    static func getBetTypeOT(betOt: Int , position: String ) -> String {
        switch (betOt) {
        case 1: return "MoneyLine"
        case 3: return "PointSpread"
        case 4: return position.lowercaseString == "over" ? "Over" : "Under"
        default: return ""
        }
    }
    
    static func getToWinAmount (value: Double, betOddValue: Double) -> Double {
        
        if betOddValue > 0 {
            
            var amountNeededToWinADollar = 100 / abs(betOddValue)
            
            var percentage = abs(amountNeededToWinADollar - 1) / amountNeededToWinADollar
            
            var percentageBasedValue = value * percentage
            
            return ceil(value + percentageBasedValue)
            
        } else {
            
            var amountNeededToWinADollar = abs(betOddValue) / 100
            
            var percentage = abs(amountNeededToWinADollar - 1) / amountNeededToWinADollar
            
            var percentageBasedValue = value * percentage
            
            return ceil(value - percentageBasedValue)

        }
        
    }
    
    static func pointSpreadString (data: NSDictionary) {
//       var string = String(format: "%d", point)
    }
    
//    {
    //        id = 1388523;
    //        over = "-115";
    //        point = 105;
    //        "point_id" = 1388523;
    //        "point_mid" = "1.3";
    //        "total_id" = 1388524;
    //        "total_mid" = "2.8";
    //        under = "-105";
    //    }
}
