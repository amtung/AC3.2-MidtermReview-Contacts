//
//  APIManager.swift
//  MidtermReview-Contacts
//
//  Created by Annie Tung on 12/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    func getRequest(endPoint: String, completion: @escaping (Data) -> Void) {
        
        let endPointURL = URL(string: endPoint)!
        var request = URLRequest(url: endPointURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic a2V5LTE6VS1ydnktb0c2cFBXSjZLb2xGeF8=", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error requesting at: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Response status code: \(httpResponse.statusCode)")
            }
            guard let validData = data else { return }
            completion(validData)
            
            }.resume()
    }
    
    
    func postRequest(firstName: String, lastName: String, email: String, completion: @escaping (HTTPURLResponse?) -> Void) {
        let url = URL(string: "https://api.fieldbook.com/v1/584758a9348a2403003dd0f3/contacts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic a2V5LTE6VS1ydnktb0c2cFBXSjZLb2xGeF8=", forHTTPHeaderField: "Authorization")
        let newBody: [String:Any] = [
            "name": firstName + " " + lastName,
            "company": "C4Q",
            "role": "Developer",
            "email": email,
            "avatar_url": "https://randomuser.me/api/portraits/women/\(arc4random_uniform(UInt32(100))).jpg"
        ]
        do {
            let newBodyData = try JSONSerialization.data(withJSONObject: newBody, options: [])
            request.httpBody = newBodyData
            print(newBodyData)
        } catch {
            print("Error with posting: \(error)")
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error posting at: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                print("Error response status code: \(httpResponse.statusCode)")
                completion(httpResponse)
            }
            guard let validData = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: []) as? [String:Any]
                if let validJson = json {
                    print(validJson)
                }
            } catch {
                print("Error encountered: \(error)")
            }
        }.resume()
    }
    
    
    
    
    func postRequest2(firstName: String, lastName: String, email: String, completion: @escaping (HTTPURLResponse?) -> Void) {
        let url = URL(string: "https://api.fieldbook.com/v1/584758a9348a2403003dd0f3/contacts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic a2V5LTE6VS1ydnktb0c2cFBXSjZLb2xGeF8=", forHTTPHeaderField: "Authorization")
        let body: [String:Any] = [
            "name": firstName + " " + lastName,
            "company": "C4Q",
            "role": "Developer",
            "email": email,
            "avatar_url": "https://randomuser.me/api/portraits/women/\(arc4random_uniform(UInt32(100))).jpg"
        ]
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = bodyData
        } catch {
            print("Error encountered: \(error)")
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered during URLSession: \(error)")
            }
            if response != nil {
                let httpResponse = (response! as! HTTPURLResponse)
                completion(httpResponse)
            }
            guard let validData = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                dump(json)
            } catch {
                print("Error converting back to json: \(error)")
            }
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

