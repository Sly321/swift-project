//
//  SettingsViewController.swift
//  Chat
//
//  Created by zerg on 15.06.15.
//  Copyright (c) 2015 zerg. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var moodText: UITextField!
    @IBOutlet weak var interestsText: UITextField!
    @IBOutlet weak var aboutmeText: UITextField!
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    var userdata: [Dictionary<String, AnyObject>]?
    @IBOutlet var textFieldsCollection: [UITextField]! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aD.currentView = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        for textfield in textFieldsCollection{
                textfield.delegate = self
        }
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeConstraints:", name: UIKeyboardWillShowNotification, object: nil)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeConstraints:", name: UIKeyboardWillHideNotification, object: nil)
        
        userdata = aD.data.get("User", predicat: nil)
        userDataToTextField(userdata!)
        
        NSLog("userData: ")
        NSLog("%@", userdata![0]["name"] as! String)
        //NSLog("%@", userdata![0]["age"] as! String)
        NSLog("%@", userdata![0]["gender"] as! String)
        NSLog("%@", userdata![0]["mood"] as! String)
        NSLog("%@", userdata![0]["interests"] as! String)
        NSLog("%@", userdata![0]["about_me"] as! String)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tastatur Funktion
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        for textfield in textFieldsCollection{
            textfield.resignFirstResponder()
            self.view.endEditing(true)
        }
    }
    
    /*
    func changeConstraints(sender: NSNotification) {
        if (sender.name == "UIKeyboardWillShowNotification") {
            if let userInfo = sender.userInfo {
                bottomSpace.constant += userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue().size.height
                view.layoutIfNeeded()
            }
            
        } else {
            bottomSpace.constant = 46
            view.layoutIfNeeded()
        }
        
    }
    */
    
    func userDataToTextField(data: AnyObject){
        
        if(data[0].valueForKey("name") != nil && data[0].valueForKey("name") as! String != String("")){
            NSLog("Username: %@", data[0].valueForKey("name") as! String)
            usernameText.text = data[0].valueForKey("name") as! String
        }
        else{
            usernameText.text = "Gib einen Namen ein"
            usernameText.textColor = UIColor.lightGrayColor()
        }
        
        
        if(data[0].valueForKey("age") != nil && data[0].valueForKey("age") as! String != String("")){
            ageText.text = data[0].valueForKey("age") as! String
            NSLog("Alter-IF")
        }
        else{
            ageText.textColor = UIColor.lightGrayColor()
            ageText.text = "Wann hast Geburtsdatum?"
        }
        
        if(data[0].valueForKey("gender") != nil && data[0].valueForKey("gender") as! String != String("")){
            genderText.text = data[0].valueForKey("gender") as! String
            NSLog("Alter-IF")
        }
        else{
            genderText.textColor = UIColor.lightGrayColor()
            genderText.text = "Mann oder Frau?"
        }
        
        if(data[0].valueForKey("mood") != nil && data[0].valueForKey("mood") as! String != String("")){
            moodText.text = data[0].valueForKey("mood") as! String
            NSLog("Alter-IF")
        }
        else{
            moodText.textColor = UIColor.lightGrayColor()
            moodText.text = "Wie sieht deine Stimmung aus heute?"
        }
        
        if(data[0].valueForKey("interests") != nil && data[0].valueForKey("interests") as! String != String("")){
            interestsText.text = data[0].valueForKey("interests") as! String
            NSLog("Alter-IF")
        }
        else{
            interestsText.textColor = UIColor.lightGrayColor()
            interestsText.text = "Gibt es Interessen?"
        }
        
        if(data[0].valueForKey("about_me") != nil && data[0].valueForKey("about_me") as! String != String("")){
            aboutmeText.text = data[0].valueForKey("about_me") as! String
            NSLog("Alter-IF")
        }
        else{
            aboutmeText.textColor = UIColor.lightGrayColor()
            aboutmeText.text = "Erzähl etwas über dich"
        }
    
        
    }
    
    
    @IBAction func saveSettings(sender: AnyObject) {
        
        if(usernameText != String("")){
                userdata![0]["name"] = usernameText.text
        }
        
        if(moodText != String("") && moodText != String("Wie sieht deine Stimmung aus heute?")){
            userdata![0]["mood"] = moodText.text
        }
        
        if(ageText != String("") && ageText != String("Wann hast Geburtsdatum?")){
            userdata![0]["age"] = ageText.text
        }
        
        if(genderText != String("") && genderText != String("Mann oder Frau?")){
            userdata![0]["gender"] = genderText.text
        }
        
        if(interestsText != String("") && interestsText != String("Gibt es Interessen?")){
            userdata![0]["interests"] = interestsText.text
        }
        
        if(aboutmeText != String("") && aboutmeText != String("Erzähl etwas über dich")){
            userdata![0]["about_me"] = aboutmeText.text
        }
        
        aD.data.updateUser(userdata!)
    }
    
    func textboxCheck(data: AnyObject, property: String) -> Bool{
        if(data[0].valueForKey(property) == nil || data[0].valueForKey(property) as! String == String("")){
            return true
        }
        else{
            return false
        }
    }
    
    @IBAction func ClearTextFieldUsername(sender: AnyObject) {
        if(textboxCheck(userdata!, property: "name")){
            usernameText.textColor = UIColor.blackColor()
            usernameText.text = ""
        }
    }
    
    
    @IBAction func ClearTextFieldAge(sender: AnyObject) {
        if(textboxCheck(userdata!, property: "age")){
            ageText.textColor = UIColor.blackColor()
            ageText.text = ""
        }
    }
    
    @IBAction func ClearTextFieldGender(sender: AnyObject) {
        if(textboxCheck(userdata!, property: "gender")){
            genderText.textColor = UIColor.blackColor()
            genderText.text = ""
        }
    }
    
    @IBAction func ClearTextFieldMood(sender: AnyObject) {
        if(textboxCheck(userdata!, property: "mood")){
            moodText.textColor = UIColor.blackColor()
            moodText.text = ""
        }
    }
    
    @IBAction func ClearTextFieldInterests(sender: AnyObject) {
        if(textboxCheck(userdata!, property: "interests")){
            interestsText.textColor = UIColor.blackColor()
            interestsText.text = ""
        }
    }
    
    @IBAction func ClearTextFieldAboutme(sender: AnyObject) {
        if(textboxCheck(userdata!, property: "about_me")){
            aboutmeText.textColor = UIColor.blackColor()
            aboutmeText.text = ""
        }
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
