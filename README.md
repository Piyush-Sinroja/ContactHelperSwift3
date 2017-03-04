# ContactHelperSwift3
ContactHelperSwift3 contains Fetch, Delete, Add and Update Contact Functionality

Contact List And Search Contact
![alt tag](https://github.com/IosPower/ContactHelperSwift3/blob/master/Images/Simulator%20Screen%20Shot%2009-Feb-2017%2C%205.32.32%20PM.jpg)

                                                ContactHelper

with the help of this, We can Fetch Contact, Delete Contact from Device and Add/Update Contact To Device. We Can also modify According to our requirement. 

Advantages of this Demo: 
1: Contact Functionality

    Fetch , Delete , Update, Add Contact

2: Country Picker Functionality

    Search Functionality,  Country picker Added, Country JSON Self Made.   Convert Country Code To Country Name.

Steps:

1.	import Contacts and ContactsUI frameworks in your project.

2.	In info.plist File add key :
 Privacy - Contacts Usage Description.

3.	Add  this  line In  viewWillAppear function

ContactHelper.objContactHelper.delegateContact = self
          
4.	 Fetch Contact Details

ContactHelper.objContactHelper.getContactList(controller: self)

// Here Self  is ViewController

//  When We Call Above Method then Below Delegate Method is Automatic Call Through Delegate

func allContactList(array: NSArray)

this method is Delegate Method that Contains
Array of  Contact Details 

5.	 Add NewContact Details

ContactHelper.objContactHelper.addContact(addDic: dicDetails, controller : self)

// Here DicDetails

let DicDetails: NSDictionary = ["Fullname": ArrayOFFullname , "Mobile": fullNo, "EmailID" : emailId]

// self is ViewController

6.	 Update Contact Details

ContactHelper.objContactHelper.updateContact(addDic: dicDetails, contactModel: contactModel!, controller: self)

// Here DicDetails

let DicDetails: NSDictionary = ["Fullname": ArrayOFFullname , "Mobile": fullNo, "EmailID" : emailId]

// ContactModel is contactModel which you want to Update  

// self is ViewController

// After Add/Update Method

Below Delegate Method is Called

func contactAddedOrUpdateSuccess()

7.	 Delete Contact Detail

ContactHelper.objContactHelper.deleteContact(dicdata: dicData, controller: self)

// Here Dicdata is your ContactDetails

// in DicData ContactModel is Available   which we want to Delete

Note: please print DicData then You will know

// self is ViewController

// After Delete successfull 
Fetch Contact Details With this Delegate Method

func allContactList(array: NSArray)



8.	 Take Extension of ContactFetchDelegate

//These Are Delegate Methods of ContactFetchDelegate
 
  func allContactList(array: NSArray)
  func contactAddedOrUpdateSuccess()
  func updateDetails(indexpathValue: IndexPath)

9.	You Can Also Modify ContactHelper.swift According yo your requirement

// Please Check Demo For More Details

