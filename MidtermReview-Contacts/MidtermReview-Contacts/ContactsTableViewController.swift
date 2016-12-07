//
//  ContactsTableViewController.swift
//  MidtermReview-Contacts
//
//  Created by Annie Tung on 12/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    var contacts = [Contacts]()
    let fieldBookAPI = "https://api.fieldbook.com/v1/584758a9348a2403003dd0f3/contacts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
    }
    
    var isFirstTime = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIRequestManager.manager.getRequest(endPoint: fieldBookAPI) { (data: Data?) in
            guard let validData = data else { return }
            if let validObj = Contacts.parse(jsonData: validData) {
                DispatchQueue.main.async {
                    self.contacts = validObj
                    self.tableView.reloadData()
                    if !self.isFirstTime {
                        self.scrollToBottom()
                    }
                    self.isFirstTime = false
                }
            }
        }
    }
    
    func scrollToBottom() {
        let lastIndexPath = IndexPath(row: contacts.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let myContact = contacts[indexPath.row]
        cell.textLabel?.text = myContact.name
        cell.detailTextLabel?.text = myContact.email
        let avatarURL = myContact.avatar_url
        
        APIRequestManager.manager.getRequest(endPoint: avatarURL) { (data: Data?) in
            DispatchQueue.main.async {
                guard let validData = data else { return }
                cell.imageView?.image = UIImage(data: validData)
                cell.imageView?.layer.cornerRadius = 50
                cell.imageView?.layer.masksToBounds = true
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let contact = contacts[indexPath.row]
            destinationVC.contacts = contact
        }
    }
    
}
