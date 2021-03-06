//
//  LeaderboardViewController.swift
//  wagerocity
//
//  Created by Haris on 26/06/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

import UIKit
import Alamofire

class LeaderboardViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LeaderboardsPicksOfPlayerProtocol  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data : NSArray = NSArray.new()
    
    var leagueName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! LeaderboardTableViewCell
        var object : NSMutableDictionary = data[indexPath.row] as! NSMutableDictionary
        cell.setViews(indexPath.row + 1, data: &object)
        cell.delegate = self
        return cell
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 60.0
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func selectedUserId(playerId: String) {
        ServiceModel.getPicksOfPlayer(playerId, completion: { (body, error, statusCode) -> Void in
            
            if let err = error as NSError? {
                println(err)
            }
            
            if statusCode == 200 {
                var array = body as! NSArray
                println(array)
                if array.count > 0 {
                    self.performSegueWithIdentifier(Constants.Segue.PicksOfPlayer, sender: array)
                } else {
                    Utils.showMessage(self, message: "There are currently no picks!")
                }
            }
            else {
                Utils.showMessage(self, message: "There are currently no picks!")   
            }
        })
    }
    
    func refreshTableView() {
        SVProgressHUD.showWithStatus("Loading")
        Alamofire.request(.GET, "http://api.wagerocity.com/getLeaderboards", parameters: ["leagueName" : leagueName ,
            "year" : "2015", "userId" : Utils.getUser()!.userId])
            .responseJSON{ (request, response, body, error) in
                SVProgressHUD.dismiss()
                if let newError:NSError = error {
                    SVProgressHUD.showErrorWithStatus(newError.localizedDescription)
                } else {
                    var array = body as! NSArray
                    self.data = array.sortedArrayUsingDescriptors([NSSortDescriptor(key: "points", ascending: false)])
                    self.tableView.reloadData()
                }
        }
        
    }
    
   
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segue.PicksOfPlayer {
            var controller = segue.destinationViewController as! PicksOfPlayerViewController
            controller.data = sender as! NSArray
        }
    }
    
    
}
