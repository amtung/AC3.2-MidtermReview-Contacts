//
//  Contacts.swift
//  MidtermReview-Contacts
//
//  Created by Annie Tung on 12/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

class Contacts {
    let id: Int
    let record_url: String
    let name: String
    let company: String
    let role: String
    let email: String
    let avatar_url: String
    
    init(id: Int, record_url: String, name: String, company: String, role: String, email: String, avatar_url: String) {
        self.id = id
        self.record_url = record_url
        self.name = name
        self.company = company
        self.role = role
        self.email = email
        self.avatar_url = avatar_url
    }
    
    convenience init?(dict: [String:Any]) {
        guard
            let id = dict["id"] as? Int,
            let record_url = dict["record_url"] as? String,
            let name = dict["name"] as? String,
            let company = dict["company"] as? String,
            let role = dict["role"] as? String,
            let email = dict["email"] as? String,
            let avatar_url = dict["avatar_url"] as? String else { return nil }
        
        self.init(id: id, record_url: record_url, name: name, company: company, role: role, email: email, avatar_url: avatar_url)
    }
    
    class func parse(jsonData: Data) -> [Contacts]? {
        var contactsToReturn = [Contacts]()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String:Any]]
            if let validJson = json {
                
                for jsonDictionary in validJson {
                    if let contactsObject = Contacts(dict: jsonDictionary) {
                        contactsToReturn.append(contactsObject)
                    }
                }
            }
            return contactsToReturn
        } catch {
            print("Error parsing jsonData to array of contacts: \(error)")
            return nil
        }
    }
}
