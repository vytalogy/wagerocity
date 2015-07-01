//
//  ViewController.swift
//  wagerocity
//
//  Created by Syed Haris Hussain on 10/06/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            returnUserData()
        }
        else {
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData() {
        Utils.showLoader()
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                
                println("Error: \(error)")
                
            } else {
                
                //                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                //                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                //                println("User Email is: \(userEmail)")
                
                let id : AnyObject? = result.valueForKey("id")
                
                Alamofire.request(.GET, "http://api.wagerocity.com/getUser", parameters: ["facebookID" : id!])
                    .responseJSON{ (request, response, body, error) in
                        Utils.hideLoader()
                        if (error != nil) {
                            if let newError:NSError = error {
                                Utils.hideLoader()
                                Utils.showError(newError)
                            }
                            
                        } else {
                            let request1:NSMutableURLRequest = request as! NSMutableURLRequest
                            
                            var user : User! = User.modelObjectWithDictionary(body as! Dictionary<NSObject, AnyObject>)
                            self.saveUserObject(user)
                            self.performSegueWithIdentifier(Constants.Segue.Dashboard, sender: nil)
                        }
                }
                
                
            }
        })
    }
    
    func saveUserObject(user: User) {
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: Constants.UserDefaults.User)
    }
    
}

