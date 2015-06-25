
import UIKit
import CoreData

class ChatsViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCollection:", name: "newContact", object: nil)
        
        // Aktualisierung zur Laufzeit einbauen
        aD.contacts = aD.data.get("Contact", predicat: nil)
    }
    
    func reloadCollection(notification: NSNotification) {
        NSOperationQueue.mainQueue().addOperationWithBlock({
            () -> Void in self.collectionView!.reloadData()
        })
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("chatsCell", forIndexPath: indexPath) as! ChatsCellCollectionViewCell
        
        cell.img.image = UIImage(named: "platzhalter")
        cell.txt.textColor = UIColor.whiteColor()
        cell.txt.text = aD.contacts[indexPath.item]["name"] as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue!.identifier == "Conversation" {
            let index = self.collectionView!.indexPathForCell(sender as! UICollectionViewCell)
            let cVC = segue!.destinationViewController as! ConversationViewController
            
            cVC.titel.title = aD.contacts[index!.item]["name"] as? String
            cVC.chatid = aD.contacts[index!.item]["id"] as? String
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aD.contacts.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
