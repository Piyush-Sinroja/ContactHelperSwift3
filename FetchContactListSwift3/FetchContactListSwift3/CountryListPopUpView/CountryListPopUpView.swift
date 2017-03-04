//
//  CountryListPopUpView.swift
//  ARDWM_Client
//
//  Created by piyush sinroja on 24/11/16.
//  Copyright © 2017 Piyush. All rights reserved.

import UIKit

@objc protocol delegateCountry{
    func selectedCountry (passstring: String, index: NSInteger)
}
class CountryListPopUpView: UIView,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var delegate: delegateCountry?
    var strSearch : NSString = NSString()
    var arrtempList : NSArray = NSArray()
    
    //MARK:- UITableView IBOutlet
    @IBOutlet weak var tblCountryList: UITableView!
    
    //MARK:- UITextField IBOutlet
    @IBOutlet weak var txtCountrySearch: UITextField!
    
    //MARK:- UIView IBOutlet
    @IBOutlet weak var viewList: UIView!
    
    //MARK:- Other Var
    var arrCountryList : NSArray = NSArray()
    var objCountryListCell: CountryListTableCell = CountryListTableCell()
    
    //MARK:- SetupCountryView
    func SetupCountryView() {
        tblCountryList.register(UINib(nibName: "CountryListTableCell", bundle: nil), forCellReuseIdentifier: "CountryListTableCell")
        
        tblCountryList.estimatedRowHeight = 44
        tblCountryList.rowHeight = UITableViewAutomaticDimension
        viewList.layer.cornerRadius = 5.0
        viewList.layer.borderWidth = 1.0
        viewList.layer.borderColor = UIColor.lightGray.cgColor
        viewList.layer.masksToBounds = true
        
        let filePath = Bundle.main.path(forResource: "CountryCodes", ofType: "json")!
        if let countyData: NSData = NSData(contentsOfFile: filePath) {
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: countyData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
                
                print(jsonResult)
                let sortByName = NSSortDescriptor(key: "name", ascending: true)
                let sortDescriptors = [sortByName]
                let sortedArray : NSArray = (jsonResult as NSMutableArray).sortedArray(using:
                    sortDescriptors) as NSArray
                
                print(sortedArray)
                
                arrCountryList = sortedArray
                
            } catch {
                print("JSON Processing Failed")
            }
        }
        arrtempList = arrCountryList.mutableCopy() as! NSArray
    }
    
    //MARK:- UITableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrCountryList.count
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            objCountryListCell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableCell") as! CountryListTableCell
        
            let dic : NSDictionary = arrCountryList[indexPath.row] as! NSDictionary
            objCountryListCell.countryName.text = dic.object(forKey: "name") as! String?
            
            if (dic.object(forKey: "dial_code") == nil) || (dic.object(forKey: "dial_code") is NSNull ){
                
            }
            else{
                
               let dialcode = dic.object(forKey: "dial_code") as! String?
               let newdialcode = dialcode?.replacingOccurrences(of: " ", with: "-")
                objCountryListCell.countryCode.text = newdialcode
            }

            objCountryListCell.backgroundColor = UIColor.clear
            objCountryListCell.selectionStyle = UITableViewCellSelectionStyle.none
            return objCountryListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
       // dismiss(animated: false, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        let dic : NSDictionary = arrCountryList[indexPath.row] as! NSDictionary
        objCountryListCell.countryName.text = dic.object(forKey: "name") as! String?
        
        if (dic.object(forKey: "dial_code") == nil) || (dic.object(forKey: "dial_code") is NSNull ){
            
        }
        else{
             delegate?.selectedCountry(passstring: (dic.object(forKey: "dial_code") as! String?)! , index : indexPath.row)
        }
    }
    
    //MARK:- UITextField Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        txtCountrySearch.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = (textField.text! as NSString)
            .replacingCharacters(in: range, with: string)

        strSearch = String(format: "%@", currentString) as NSString
       
        if textField == txtCountrySearch {
            updatedCountryResults(NormalListArr: arrtempList as! NSMutableArray, strKey: "name")
        }
        
        return true
    }
    
    //MARK:- Search Update
    func updatedCountryResults(NormalListArr: NSMutableArray, strKey: NSString) {
        
        var filteredListarr: NSMutableArray?
        filteredListarr = nil
        
        filteredListarr = NSMutableArray.init(array: NormalListArr)
        
        let predicate: NSPredicate?
        
        if strKey.length > 0 {
            predicate = NSPredicate(format: "%K BEGINSWITH[cd]%@", strKey, "\(strSearch)")
        }
        else {
            predicate = NSPredicate(format: "self BEGINSWITH[cd] %@", "\(strSearch)")
        }
        
        filteredListarr?.filter(using: predicate!)
    
        if strSearch.length == 0 {
            updateTableView(filteredarr: NormalListArr)
        }
        else{
            updateTableView(filteredarr: filteredListarr!)
        }
    }
    
    func updateTableView(filteredarr: NSMutableArray) {
        if filteredarr.count > 0 {
            self.tblCountryList.isHidden = false
            self.arrCountryList = filteredarr
            self.tblCountryList.reloadData()
        }
        else {
            self.tblCountryList.isHidden = true
        }
    }

}
