//
//  AppDelegate.swift
//  FetchContactListSwift3
//
//  Created by piyush sinroja on 12/01/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - HUD Custom Method
    func showHUD(viewNew: UIView){
        DispatchQueue.main.async {
            self.indicator.center = viewNew.center
            self.indicator.frame.origin.y = self.indicator.frame.origin.y - 64
            self.indicator.backgroundColor = UIColor.lightGray
            viewNew.addSubview(self.indicator)
            viewNew.bringSubview(toFront: self.indicator)
            self.indicator.startAnimating(isUserInteractionEnabled: false)
        }
    }
    
    func HideHud() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating(isUserInteractionEnabled: true)
        }
    }
    
    //MARK emailAdrressValidation
    func emailAdrressValidation(strEmail : String)->Bool {
        // Password should not blank
        if strEmail.isEmpty{
            return false
        }
        //Email address should accept like:test@gmail.co.uk
        let emailRegEx = "[.0-9a-zA-Z_-]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailTest.evaluate(with: strEmail){
            return false
        }
        return true
    }
}
extension UIActivityIndicatorView {
    func startAnimating(isUserInteractionEnabled: Bool){
        self.startAnimating()
        self.superview?.isUserInteractionEnabled = isUserInteractionEnabled
    }
    func stopAnimating(isUserInteractionEnabled: Bool){
        self.stopAnimating()
        self.superview?.isUserInteractionEnabled = isUserInteractionEnabled
    }
}

extension UITextField{
    func padding(width: CGFloat) {
        let label = UILabel(frame: CGRect(x :0,y :0,width :width,height: 10))
        label.text = " "
        self.leftViewMode = .always
        self.leftView = label
        
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    func cornerRadiusAndBorder() {
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
}

extension UIButton{
    func cornerRadiusAndBorder() {
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
}

extension String
{
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

extension UIViewController
{
    //MARK:- Alert Function
    func alertShow(strMessage: String) {
        let alert = UIAlertController(title: "ContactDemoSwift3", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
}

