//
//  ContactsViewController.swift
//  Chat
//
//  Created by zerg on 08.07.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var con: Array<Dictionary<String, AnyObject>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aD.currentView = self
        con = aD.contacts
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //  Liefert horizontale Anzahl der Zellen.
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //  Liefert vertikale Anzahl der Zellen.
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aD.contacts.count
    }
    
    
    //  Liefert eine Zelle mit Inhalt.
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsCell") as! ContactsTableViewCell
        
        cell.name.text = con[indexPath.item]["name"]?.description
        //cell.datum.text = aD.dateFormatter.stringFromDate(con[indexPath.item]["date"] as! NSDate)
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
