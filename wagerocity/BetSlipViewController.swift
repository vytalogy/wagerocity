//
//  BetSlipViewController.swift
//  wagerocity
//
//  Created by Haris on 26/06/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

import UIKit
import FBSDKShareKit

protocol BetSlipCompletion {
    func showMyPicks()
}

class BetSlipViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeBetButton: UIButton!
    
    var delegate:BetSlipCompletion! = nil
    
    var oddHolders : Array<OddHolder> = [OddHolder]()
    
    var finalOdds : Array<OddHolder> = [OddHolder]()
    
    var poolCredits : String = ""
    
    var numberOfBets = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addParlayOdd()
        checkteaserCase()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oddHolders.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BetSlipTableViewCell
        cell.setViews(&oddHolders[indexPath.row])
        return cell
    }
    
    @IBAction func placeBet(sender: AnyObject) {
        
//        var array = oddHolders.filter { (oddholder) -> Bool in
//            return oddholder.isChecked && oddholder.riskValue != "0.0" && oddholder.riskValue != ""
//        }
        
        var array = oddHolders
        
        if array.isEmpty {
            return
        }
        
        finalOdds = array
        
        var alert = UIAlertController(
            title: "Share This With Your Friends!",
            message: "Earn $250 and Share This on Facebook With Your Friends.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Yes do it!", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
            let odd : OddHolder = array.first!
            var  content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "https://www.wagerocity.com")
            content.imageURL = NSURL(string: "https://www.wagerocity.com/user_data/images/logo1.png")
            content.contentTitle = odd.name
            content.contentDescription = "I just placed a $" + odd.riskValue + " wager via my Wagerocity Mobile App on " + odd.name + " at " + odd.oddValue
            
            FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
            ServiceModel.buyCredits("250", delegate: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel!", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
            if self.oddHolders.count == 0 {
                self.numberOfBets = 0
            } else if self.oddHolders.count == 1 && self.oddHolders[0].oddType == Constants.BetTypeSPT.Parley.lowercaseString {
                self.numberOfBets = 3
            } else {
                
                var oddholder: OddHolder?
                
                for odd: OddHolder in self.oddHolders {
                    if odd.oddId == "parley_bet" {
                        if odd.isChecked == false {
                            oddholder = odd
                        }
                    }
                }
                
                if let odd = oddholder {
                    self.oddHolders = self.arrayRemovingObject(odd, fromArray: self.oddHolders)
                }
                
                self.finalOdds = self.oddHolders
                
                
                self.numberOfBets = self.oddHolders.count
            }
//            self.numberOfBets = array.count
            self.processBet(&self.oddHolders)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func arrayRemovingObject<U: Equatable>(object: U, fromArray:[U]) -> [U] {
        return fromArray.filter { return $0 != object }
    }
    
    func processBet (inout array : Array<OddHolder>) {
        
        //        for odd: OddHolder in array {
        let odd: OddHolder = array.first!
        
        if odd.poolId == "" {
            if Utils.getUser()!.credits < (odd.riskValue as NSString).doubleValue {
                Utils.showMessage(self, message: "Not Enough Credit!")
                Utils.hideLoader()
                return
            } else {
//                ServiceModel.consumeCredits(odd.riskValue, delegate: self)
            }
        } else {
            if odd.poolCredit < (odd.riskValue as NSString).doubleValue {
                Utils.showMessage(self, message: "Not Enough Credit in your Pool Account!")
                Utils.hideLoader()
                return
            }
        }
        
        ServiceModel.betOnGame1(self,
            userId: Utils.getUser()!.userId,
            oddId: odd.oddId,
            oddVal: odd.oddType == Constants.BetTypeSPT.Parley.lowercaseString ? NSString(format: "%.2f",odd.parlayValue) as String : odd.oddValue,
            pos: odd.position,
            matchDetail: odd.teamVsTeam,
            stake: (odd.riskValue == "" ) ? "0" : odd.riskValue,
            matchID: odd.teamId,
            oddType: odd.oddType,
            teamName: odd.name,
            sportsName: odd.leagueName,
            bet_ot: odd.betOT,
            is_pool_bet: odd.poolId == "" ? "0" : "1",
            poolId: odd.poolId,
            numberOfBets: String(format: "%d", self.numberOfBets),
            completion: { (request, response, object , error, statusCode) -> Void in
                
                if statusCode == 200 {
                    array.removeAtIndex(0)
                    if array.count > 0 {
                        self.processBet(&array)
                    } else {
                        self.numberOfBets = 0
                        Utils.showLoader()
                        self.navigationController?.popViewControllerAnimated(false)
                        self.delegate.showMyPicks()
                    }
                }
                
                
        })
    }
    
    func addParlayOdd () {
        if isParlayCaseTrue() {
            
            var teamName = ""
            var teamANumber = ""
            
            for oddHolder in oddHolders {
                if oddHolder.betTypeString == "Point Spread" {
                    teamName = teamName + oddHolder.name + " " + oddHolder.pointSpreadString
                } else {
                    teamName  = teamName + oddHolder.name + " " + oddHolder.oddValue
                }
                teamName+="\n"
                
                if oddHolder.isTeamA {
                    teamANumber = oddHolder.teamId
                }
            }
            
            let parlayValue = Utils.parlayValue(oddHolders)
            
            var pOdd = OddHolder()
            
            pOdd.teamId = ""//oddHolders[0].teamId
            pOdd.oddId = "parley_bet"
            pOdd.name = "Parlay " + (NSString(format: "(%d Teams)", oddHolders.count) as String)
            pOdd.teamVsTeam = teamName + (NSString(format: "( %d Odds)", oddHolders.count) as String)
            pOdd.betTypeSPT = Constants.BetTypeSPT.Single
            pOdd.betOT = ""
            pOdd.oddType = "parley"
            pOdd.riskValue = ""
            pOdd.parlayValue = parlayValue
            pOdd.leagueName = ""
            pOdd.poolId = oddHolders[0].poolId
            pOdd.position = " "
            pOdd.leagueName = oddHolders[0].leagueName
            pOdd.poolCredit = oddHolders[0].poolCredit
            oddHolders.append(pOdd)
        }
    }
    
    func addTeaserOdd () {
        var count = filter(oddHolders, { (oddholder) -> Bool in
            return oddholder.betOT == "3" || oddholder.betOT == "4"
        }).count
        
        if count > 0 && count < 7 {
            var value: Dictionary<Double, Int> = teaserValuesForSport(oddHolders[0].leagueName)[count-2]
            
            var tOdd = OddHolder()
            
            tOdd.teamId = oddHolders[0].teamId
            tOdd.oddId = oddHolders[0].oddId
            tOdd.name = "Teaser"
            tOdd.teamVsTeam = ""
            tOdd.betTypeSPT = Constants.BetTypeSPT.Teaser
            tOdd.betOT = "1"
            tOdd.riskValue = "0.0"
            tOdd.teaserValues = value
            tOdd.poolId = oddHolders[0].poolId
        }
    }
    
    func isParlayCaseTrue () -> Bool {
        if oddHolders.count == 2 {
            if oddHolders[0].teamId == oddHolders[1].teamId {
                if (oddHolders[0].betOT == "1" && oddHolders[0].betOT == "3" ) ||
                    (oddHolders[0].betOT == "3" && oddHolders[0].betOT == "1" ) {
                        return false
                }
            }
        }
        return oddHolders.count > 1
    }
    
    func checkteaserCase () {
        if oddHolders.count > 1 {
            if oddHolders[0].leagueName == "nba" || oddHolders[0].leagueName == "nfl" {
                if oddHolders.count != 2 {
                    let case1 = !(oddHolders[0].betOT == "1" && oddHolders[1].betOT == "3")
                    let case2 = !(oddHolders[0].betOT == "3" && oddHolders[1].betOT == "1")
                    let case3 = !(oddHolders[0].betOT == "1" && oddHolders[1].betOT == "4")
                    let case4 = !(oddHolders[0].betOT == "4" && oddHolders[1].betOT == "1")
                    
                    if case1 || case2 || case3 || case4 {
                        addTeaserOdd()
                    }
                }
            }
        }
    }
    
    func teaserValuesForSport(leagueName: String) -> Array<Dictionary<Double, Int>> {
        var array = Array<Dictionary<Double, Int>>()
        if leagueName == "nfl" {
            var v = Dictionary<Double, Int>()
            
            v[6.0] = -110
            v[6.5] = -120
            v[7.0] = -130
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[6.0] = 180
            v[6.5] = 160
            v[7.0] = 140
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[6.0] = 300
            v[6.5] = 250
            v[7.0] = 200
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[6.0] = 450
            v[6.5] = 400
            v[7.0] = 300
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[6.0] = 600
            v[6.5] = 550
            v[7.0] = 500
            
            array.append(v)
        } else if leagueName == "nba" {
            var v = Dictionary<Double, Int>()
            
            v[4.0] = -110
            v[4.5] = -120
            v[5.0] = -130
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[4.0] = 180
            v[4.5] = 160
            v[5.0] = 140
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[4.0] = 300
            v[4.5] = 250
            v[5.0] = 200
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[4.0] = 450
            v[4.5] = 400
            v[5.0] = 300
            
            array.append(v)
            
            v = Dictionary<Double, Int>()
            
            v[4.0] = 750
            v[4.5] = 700
            v[5.0] = 650
            
            array.append(v)
        }
        return array
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        ServiceModel.buyCredits("250", delegate: self)
        self.numberOfBets = finalOdds.count
        processBet(&finalOdds)
        finalOdds = [OddHolder]()
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        self.numberOfBets = finalOdds.count
        processBet(&finalOdds)
        finalOdds = [OddHolder]()
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        self.numberOfBets = finalOdds.count
        processBet(&finalOdds)
        finalOdds = [OddHolder]()
    }
    
    func removeObject<T : Equatable>(object: T, inout fromArray array: [T])
    {
        var index = find(array, object)
        array.removeAtIndex(index!)
    }
    
    
}

