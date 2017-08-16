//
//  KContacts
//
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit
import Contacts

enum fetchType {
    case number
    case name
    case mail
}

class KContacts: NSObject {
    
    private var contactStore = CNContactStore()
    private lazy var contacts:[CNContact] = []
    var auth:Bool = false
    
    func requestAuth() {
        
        switch(CNContactStore.authorizationStatus(for: .contacts)) {
        case .notDetermined, .denied:
            contactStore.requestAccess(for: .contacts, completionHandler: { (auth, error) in
                if auth {
                    print("auth success")
                    self.auth = true
                } else {
                    print("auth failed")
                    self.auth = false
                }
            })
        case .authorized: auth = true
        default: auth = false
        }

    }
   
    func fetchContacts(_ type: fetchType) -> [String]? {
        
        guard auth == true else {
            return nil
        }
        
        contacts = []
        
        var resultData:[String] = []
        
        let keys = [CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey]
        let request = CNContactFetchRequest(keysToFetch: keys  as [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                self.contacts.append(contact)
            }
        }
        catch {
            fatalError("@Fetch Error")
        }
        
        guard self.contacts.count > 0 else {
            return nil
        }
    
        switch type {
            
        case .number:
            
            for contact in contacts {
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value
                    resultData.append(phoneNumber.stringValue)
                }
                
            }
            
        case .name:
            
            for contact in contacts {
                resultData.append(contact.givenName)
            }
            
        case .mail:
            
            for contact in contacts {
                for mail in contact.emailAddresses {
                    if mail.label == CNLabelHome {
                        resultData.append(mail.value as String)
                        break
                    }
                }
            }
        }
        
        return resultData
    }
    
    func createContact(name:String,number:String) {

        guard auth == true else {
            return
        }
        
        let contact = CNMutableContact()
        
        let comp = name.components(separatedBy: " ")
        
        contact.givenName = comp.first!
        contact.familyName = comp.count > 1 ? comp[1] : ""
        
        let mNum = CNPhoneNumber(stringValue: number)
        let mVal = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mNum)
        
        contact.phoneNumbers = [mVal]
        
        let saveReq = CNSaveRequest()
        saveReq.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try contactStore.execute(saveReq)
            print("Saved new contact")
        } catch {
            fatalError("@ Create new contact error!")
        }
    }
    
    func checkContact(name:String) -> Bool? {
        
        guard auth == true else {
            return nil
        }
        
        var flag:Bool = false
        let predicate = CNContact.predicateForContacts(matchingName: name)
        let keys = [CNContactPhoneNumbersKey ,CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
        var contacts = [CNContact]()
       
        do {
            
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
            
            if contacts.count == 0 {
                flag = false
            } else {
                flag = true
            }
        }
        catch {
            flag = false
        }
    
        return flag
    }
    
}//
