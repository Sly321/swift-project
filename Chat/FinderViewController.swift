
import UIKit
import MultipeerConnectivity
import Foundation

class FinderViewController: UIViewController, MPCBrowserDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aD.advertiser.view = self
        aD.browser.delegate = self
        aD.browser.browser.startBrowsingForPeers()
        println(aD.username)
    }
    
    override func viewWillDisappear(animated: Bool) {
        aD.browser.browser.stopBrowsingForPeers()
    }
    
    //  ................................................................................
    //
    //
    //
    //
    // wenn Peer gefunden ... gefundene / erreichbare Peers zeichnen
    // SENDER FINDET SICH AUCH SELBER
    
    
    func foundPeer() {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            var yDis: CGFloat = 20  // our Starting Offset, could be 0
            
            
            for (index, name) in enumerate(self.aD.browser.foundPeers) {
                
                let btn = UIButton(frame: CGRect(x: 50, y: yDis, width: 250, height: 30))
                
                btn.backgroundColor = UIColor.lightGrayColor()
                btn.setTitle("\(name.displayName)", forState: UIControlState.Normal)
                btn.tag = index
                btn.addTarget(self, action: "btnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                self.view.addSubview(btn)
                
                yDis += 50
            }
        }
        
    }
    
    //
    //  wenn Peer nicht mehr erreichbar, dann alles neu zeichnen?
    
    func lostPeer() {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            
            self.foundPeer()
        }
    }
    
    //
    //
    //
    //
    //
    //................................................................................
    

    
    func btnPressed(sender: UIButton!) {
        let selectedPeer = aD.browser.foundPeers[sender.tag] as MCPeerID
        aD.browser.browser.invitePeer(selectedPeer, toSession: aD.session.session, withContext: nil, timeout: 10)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}