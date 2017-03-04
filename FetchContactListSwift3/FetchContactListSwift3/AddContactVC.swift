//
//  AddContactVC.swift
//  FetchContactListSwift3
//
//  Created by piyush sinroja on 12/01/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class AddContactVC: UIViewController , delegateCountry, UIGestureRecognizerDelegate{

    let appdelObj: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //UITextField Outlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    
    //UIButton Outlets
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    //UIScrollView Outlet
    @IBOutlet weak var scrollview: UIScrollView!
    
    // Other Var
    var activeTextField: UITextField!
    var refCountryListView : CountryListPopUpView? = nil

    var contactModel: CNContact?
    var dicData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txtName.padding(width: 5)
        txtMobile.padding(width: 5)
        txtEmailId.padding(width: 5)
        
        txtName.cornerRadiusAndBorder()
        txtMobile.cornerRadiusAndBorder()
        txtEmailId.cornerRadiusAndBorder()
        btnCountryCode.cornerRadiusAndBorder()
        btnCancel.cornerRadiusAndBorder()
        btnSave.cornerRadiusAndBorder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactVC.keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactVC.keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ContactHelper.objContactHelper.delegateContact = self // Delegate refer Give
        
        if contactModel != nil && dicData != nil{
            btnSave.setTitle("Update", for: UIControlState.normal)
            
            let name = dicData?.object(forKey: "fullname") as! String?
            let mobile = dicData?.object(forKey: "mobile") as! String?
            let isdcode = dicData?.object(forKey: "isdcode") as! String?
            
            // Name Display
            txtName.text = name
            
            var newString = ""
            if (mobile?.hasPrefix(isdcode!))! {
                let strremain = mobile?.substring(from: (mobile?.index((mobile?.startIndex)!, offsetBy: (isdcode?.characters.count)!))!)
                
                newString = strremain!
            }
            else{
                newString = mobile!
            }
            
            // Mobile Number Display
            txtMobile.text =  newString
            
            // Email Id Display
            if let emailId = dicData?.object(forKey: "email") as! String?{
                txtEmailId.text = emailId
            }
            
            btnCountryCode.setTitle(isdcode, for: UIControlState.normal)
        }
        else{
            btnSave.setTitle("Save", for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Keyboard Notification Method
    func keyboardWasShown(aNotification: NSNotification) {
        
        if let userInfo = aNotification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                
                scrollview.contentInset = contentInsets
                scrollview.scrollIndicatorInsets = contentInsets
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardSize.height
            } else {
        }
        } else {
           
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(aNotification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            let contentInsets: UIEdgeInsets = .zero
            self.scrollview.contentInset = contentInsets
            self.scrollview.scrollIndicatorInsets = contentInsets
        }, completion: {(finished: Bool) -> Void in
        })
    }
    
    //MARK:- Button Actions
    @IBAction func btnSave(_ sender: Any) {
    if !(txtName.text?.isEmpty)! && !(txtMobile.text?.isEmpty)!{
            if btnSave.titleLabel?.text == "Save" {
                AddContact()
            }
            else{
                updateData()
            }
        }
    }

    @IBAction func btnCountryCode(_ sender: Any) {
         activeTextField?.resignFirstResponder()
        let xibCountryListView = Bundle.main.loadNibNamed("CountryListPopUpView", owner: self, options: nil)?[0] as! CountryListPopUpView
         xibCountryListView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
         xibCountryListView.delegate = self
         let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
         tap.delegate = self
         xibCountryListView.addGestureRecognizer(tap)
         tap.cancelsTouchesInView = true
         xibCountryListView.SetupCountryView()
         self.view.addSubview(xibCountryListView)
         refCountryListView = xibCountryListView
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        activeTextField?.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    //MARK:- UITapGestureRecognizer
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        refCountryListView?.removeFromSuperview()
        refCountryListView = nil
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: (refCountryListView?.viewList)!))! {
            return false
        }
        else{
            return true
        }
    }

    //MARK:- Add Contact To Device Contact
    func AddContact(){
         if  validationCheck() == true {
            let dicDetails = generateAllDetailDic()
            ContactHelper.objContactHelper.addContact(addDic: dicDetails, controller : self)
        }
    }
    
    func generateAllDetailDic() ->NSDictionary  {
        let arrFullname: [String] = self.txtName.text!.trim().components(separatedBy: " ")
        let fullNo = btnCountryCode.currentTitle! + txtMobile.text!
        let emailId = txtEmailId.text!.trim()
        
        let dic: NSDictionary = ["Fullname": arrFullname , "Mobile": fullNo, "EmailID" : emailId]
        return dic
    }
    
    //MARK:- Update Contact To Device Contact
    func updateData() {
        if  validationCheck() == true {
            let dicDetails = generateAllDetailDic()
            ContactHelper.objContactHelper.updateContact(addDic: dicDetails, contactModel: contactModel!, controller: self)
        }
    }
    
    //MARK:- ValidationCheck
    func validationCheck() -> Bool {
        if (txtName.text?.trim().isEmpty)! || txtName.text?.trim() == nil
        {
            alertShow(strMessage: "Please enter full name")
            return false
        }
        else if (txtName.text?.trim().characters.count)! > 0 {
            let arrFullname = txtName.text?.trim().components(separatedBy: " ")
            
            if (arrFullname?.count)! < 2 {
                alertShow(strMessage: "Please enter first and last name")
                return false
            }
        }
        
        if (txtMobile.text?.isEmpty)! || txtMobile.text == nil
        {
            alertShow(strMessage: "Please enter mobile number")
            return false
        }
        else if (txtMobile.text?.characters.count)! > 0
        {
            let checkmobile: Bool = myMobileNumberValidate(number: txtMobile.text!)
            if checkmobile == false {
                alertShow(strMessage: "Please enter valid mobile number")
                return false
            }
        }
        
        if (txtEmailId.text?.trim().characters.count)! > 0 && txtEmailId.text?.trim() != ""
        {
            let isValidEmail: Bool = appdelObj.emailAdrressValidation(strEmail: "\(txtEmailId.text!.trim())")
            
            if isValidEmail == true {
                return true
            }
            else{
                alertShow(strMessage: "Please enter valid email")
                return false
            }
        }
        return true
    }
    func myMobileNumberValidate(number: String) -> Bool {
        let numberRegEx = "[0-9]{10,15}"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        if !numberTest.evaluate(with: number){
            return false
        }
        return true
    }
    
    //MARK:- DelegateCountry Methods
    func selectedCountry (passstring: String, index: NSInteger){
        print(passstring)
        print(index)
        refCountryListView?.removeFromSuperview()
        refCountryListView = nil
        btnCountryCode.setTitle(passstring, for: UIControlState.normal)
    }

}

//MARK:- UITextField Methods
extension AddContactVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
      //  activeTextField = nil
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtName {
            txtMobile.becomeFirstResponder()
        }
        else if textField == txtMobile{
            txtEmailId.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtName
        {
            if string.isEmpty {
                return true
            }
            
            let regEx = "([a-zA-Z ])"
            let range = string.range(of:regEx, options:.regularExpression)
            if range != nil {
                let found = string.substring(with: range!)
                print("found: \(found)") // found: example
                
            }
            else{
                return false
            }
        }
            
        else if  textField == txtMobile
        {
            if string.isEmpty {
                return true
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if numberFiltered == "" {
                return false
            }
            else
            {
                let currentString = (textField.text! as NSString)
                    .replacingCharacters(in: range, with: string)
                
                let inteValue :Int? =  Int(currentString)
                
                if inteValue! > 0 {
                    let length = currentString.characters.count
                    if length > 15 {
                        return false
                    }
                }
                else
                {
                    return false
                }
            }
        }
        
        return true
    }
}

//MARK:- ContactFetchDelegate
extension AddContactVC : ContactFetchDelegate {
    func contactAddedOrUpdateSuccess() {
        print("Contact added Successfully")
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                        _ = self.navigationController?.popViewController(animated: true)
        //
        //                    }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

