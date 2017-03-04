//
//  ViewController.swift
//  FetchContactListSwift3
//
//  Created by piyush sinroja on 12/01/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController {

    let appdelObj: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //UITableView Outlet
     @IBOutlet weak var tblAddReferral: UITableView!
    
    //MARK:- UITextField  IBOutlet
    @IBOutlet weak var txtSearch: UITextField!
    
    var strSearch : NSString = NSString()
    var arrtempList : NSArray = NSArray()
    var arrContactList : NSMutableArray = NSMutableArray()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tblAddReferral.contentInset = UIEdgeInsetsMake(0, 0, 0, 0); //values
        tblAddReferral.estimatedRowHeight = 110
        tblAddReferral.rowHeight = UITableViewAutomaticDimension
        
        txtSearch.padding(width: 22)
        txtSearch.cornerRadiusAndBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ContactHelper.objContactHelper.delegateContact = self
        
        //------------------------FetchContact---------------///
        fetchContactDetails()
        //------------------------------------------------//
    }
    
    //MARK:- FetchContactDetails
    func fetchContactDetails() {
        ContactHelper.objContactHelper.getContactList(controller: self)
    }

    //MARK:- Search Update
    func searchFunction(textField: UITextField){
        if textField == txtSearch {
                if arrtempList.count > 0 {
            updatedResults(NormalListArr: arrtempList as! NSMutableArray, strKey: "fullname")
            }
        }
    }
    
    func updatedResults(NormalListArr: NSMutableArray, strKey: NSString) {
        var filteredListarr: NSMutableArray?
        filteredListarr = nil
        filteredListarr = NSMutableArray.init(array: NormalListArr)
        let predicate: NSPredicate?
//        if strKey.length > 0 {
//            predicate = NSPredicate(format: "%K BEGINSWITH[cd]%@", strKey, "\(strSearch)")
//        } else {
//            predicate = NSPredicate(format: "self BEGINSWITH[cd] %@", "\(strSearch)")
//        }
        
        if strKey.length > 0 {
            predicate = NSPredicate(format: "%K contains[c]%@", strKey, "\(strSearch)")
        } else {
            predicate = NSPredicate(format: "self contains[c] %@", "\(strSearch)")
        }
        
        filteredListarr?.filter(using: predicate!)
        if strSearch.length == 0 {
                updateContactListTableView(filteredarr: NormalListArr)
        } else {
                updateContactListTableView(filteredarr: filteredListarr!)
        }
    }
    
    func updateContactListTableView(filteredarr: NSMutableArray) {
        if filteredarr.count > 0 {
            tblAddReferral.isHidden = false
            arrContactList = filteredarr
            tblAddReferral.reloadData()
        } else {
            tblAddReferral.isHidden = true
        }
    }

    //MARK:- Cell UIButton Actions
    func btnAddInCell(sender: UIButton)  {
        print(sender.tag)
        let dic: NSDictionary =  arrContactList[sender.tag] as! NSDictionary
        let strCheck = dic.object(forKey: "isadded") as! String
        
        if strCheck == "0" {
            dic.setValue("1", forKey: "isadded")
            arrContactList.replaceObject(at: sender.tag, with: dic)
        }
        else{
            dic.setValue("0", forKey: "isadded")
            arrContactList.replaceObject(at: sender.tag, with: dic)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            let indexpath: NSIndexPath = NSIndexPath(row: sender.tag, section: 0)
            self.tblAddReferral.reloadRows(at: [indexpath as IndexPath], with: UITableViewRowAnimation.none)
        })
    }

    @IBAction func btnAdd(_ sender: Any) {
        txtSearch.resignFirstResponder()
        let addContactVCobj = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        self.present(addContactVCobj!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UITextField Methods
extension ViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if strSearch == "" {
            txtSearch.text = ""
        } else {
            txtSearch.text = strSearch as String
        }
        searchFunction(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text! as NSString)
            .replacingCharacters(in: range, with: string)
        strSearch = String(format: "%@", currentString) as NSString
        searchFunction(textField: textField)
        return true
    }
}

//MARK:- UITableViewDataSource  Methods
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContactList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactTableCell
        
        let dic: NSDictionary = arrContactList[indexPath.row] as! NSDictionary
        
        let btnadd: UIButton = Cell.btnAdd
        btnadd.tag = indexPath.row
        btnadd.addTarget(self, action: #selector(self.btnAddInCell), for: .touchUpInside)
        
        let name = dic.object(forKey: "fullname") as! String?
        let mobile = dic.object(forKey: "mobile") as! String?
        let isdcode = dic.object(forKey: "isdcode") as! String?
        let countryName = dic.object(forKey: "countryName") as! String?
    
        Cell.lblName.text = name
        Cell.countryName.text = countryName
        
        var newString = ""
        if (mobile?.hasPrefix(isdcode!))! {
            let strremain = mobile?.substring(from: (mobile?.index((mobile?.startIndex)!, offsetBy: (isdcode?.characters.count)!))!)
            
            newString = strremain!
        }
        else{
            newString = mobile!
        }
        
        if isdcode == "" {
            Cell.lblMobile.text = newString
        }
        else{
            Cell.lblMobile.text = isdcode! + "-" + newString
        }
        
        Cell.backgroundColor = UIColor.clear
        Cell.selectionStyle = UITableViewCellSelectionStyle.none
        return Cell
    }
}

//MARK:- UITableViewDelegate  Methods
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //txtSearch.resignFirstResponder()
        let addContactVCobj = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        
        let dic: NSDictionary =  arrContactList[indexPath.row] as! NSDictionary
        let cModel = dic.object(forKey: "contactModel") as! CNContact?
        addContactVCobj?.contactModel = cModel
        addContactVCobj?.dicData = dic
        
        DispatchQueue.main.async {
            self.present(addContactVCobj!, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print(indexPath.row)
            if let dicData: NSDictionary = arrContactList[indexPath.row] as? NSDictionary{
                ContactHelper.objContactHelper.deleteContact(dicdata: dicData, controller: self)
            }
        }
    }
}

//MARK:- ContactFetchDelegate
extension ViewController: ContactFetchDelegate
{
    func updateDetails(indexpathValue: IndexPath){
        self.tblAddReferral.reloadRows(at: [indexpathValue], with: UITableViewRowAnimation.automatic)
    }

    func allContactList(array: NSArray){
        print(array)
        DispatchQueue.main.async {
            self.arrContactList = array.mutableCopy() as! NSMutableArray
            self.arrtempList =  array
            print(self.arrtempList)
            self.tblAddReferral.reloadData()
        }
    }
}
