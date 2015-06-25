
import UIKit
import MultipeerConnectivity

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var fieldVertical: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titel: UINavigationItem!
    
    var chatid: String!
    var conversation: Array<Dictionary<String,  AnyObject>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeConstraints:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeConstraints:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView:", name: "didReceiveData", object: nil)
        conversation = aD.data.get("Message", predicat: chatid)
        textField.returnKeyType = UIReturnKeyType.Send
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollTableToBottom()
    }
    
    
    //  Scrollt Tabelle nach unten.
    //
    private func scrollTableToBottom() {
        let y = tableView.contentSize.height - tableView.frame.size.height
        
        if (y > 0) {
            let offset = CGPointMake(0, y)
            tableView.setContentOffset(offset, animated: false)
        }
    }
    
    //  Aktualisiert Tabelleninhalt.
    //
    func reloadTableView(notification: NSNotification) {
        if (notification.userInfo != nil) { // Noch prüfen ob richtige CHatid
            conversation.append(notification.userInfo as! Dictionary<String, AnyObject>)
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableView.reloadData()
            self.scrollTableToBottom()
        })
    }
    
    
    //  Liefert horizontale Anzahl der Zellen.
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //  Liefert vertikale Anzahl der Zellen.
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    
    //  Liefert eine definierte Zelle.
    //
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("conversationCell") as! ConversationCellTableViewCell
        
        cell.message.text = conversation[indexPath.item]["text"]?.description
        cell.datum.text = aD.dateFormatter.stringFromDate(conversation[indexPath.item]["date"] as! NSDate)
        
        return cell
    }
    
    
    //  Liefert passende Groesse fuer Tabellenzelle.
    //
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, 300, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont.systemFontOfSize(17.2)
        label.text = conversation[indexPath.item]["text"]?.description
        label.sizeToFit()
            
        return 44 + label.frame.height
    }
    
    
    //  Sendet Nachricht an Chatpartner.
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let receiver = [aD.session.getPeerById(chatid)]

        if (receiver[0] != nil && textField.text != "") {
            var content = ["id": aD.uuid, "from": aD.name, "date": NSDate(), "text": textField.text]
            let data = NSKeyedArchiver.archivedDataWithRootObject(content)
            aD.session.session.sendData(data, toPeers: receiver, withMode: MCSessionSendDataMode.Reliable, error: nil)
            content["id"] = chatid
            aD.data.insert("Message", id: nil, data: content)
            conversation.append(content)
            
            // Directaufruf von reloadTableView ueberlegen
            NSNotificationCenter.defaultCenter().postNotificationName("didReceiveData", object: nil, userInfo: nil)
        }

        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
    
    //  Passt Elementbeschraenkungen dem Keyboard an.
    //
    func changeConstraints(sender: NSNotification) {
        if (sender.name == "UIKeyboardWillShowNotification") {
            if let userInfo = sender.userInfo {
                fieldVertical.constant += userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue().size.height
                view.layoutIfNeeded()
            }
            
        } else {
            fieldVertical.constant = 15
            view.layoutIfNeeded()
        }
        
        scrollTableToBottom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beispiele() {
        
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": titel.description, "date": NSDate(), "text": "Yo was geht?"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": "me", "date": NSDate(), "text": "FU"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": titel.description, "date": NSDate(), "text": "jshdfjgh"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": titel.description, "date": NSDate(), "text": "aaaaa"])
        aD.data.insert("Message", id: nil, data: ["id": chatid, "from": "me", "date": NSDate(), "text": "gerfjhwkejfhkwj wifjh weif"])
    }
}
