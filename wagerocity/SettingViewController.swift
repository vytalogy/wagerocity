//
//  SettingViewController.swift
//  wagerocity
//
//  Created by Syed Haris Hussain on 10/07/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingViewController: BaseViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var record: UILabel!
    @IBOutlet weak var fblogin: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var user: User = Utils.getUser()
        
        if let available = user.credits as Double? {
            var formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            formatter.stringFromNumber(NSNumber(double: user.credits))
            
            credits.text = "$" + formatter.stringFromNumber(NSNumber(double: user.credits))!
            self.fblogin.delegate = self
        }
        
        if let rankString = user.overallrank {
            rank.text = rankString
        }
        
        if let recordString = user.currentrecord {
            record.text = "$" + recordString
        }
        
        var userImageURL = "https://graph.facebook.com/" + Utils.facebookId() + "/picture?width=150&height=150"
        
        image.sd_setImageWithURL(NSURL(string: userImageURL), placeholderImage: UIImage(named: "user1"))
        
        name.text = user.username as String
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        Utils.setFacebookId("")
    }
    
}