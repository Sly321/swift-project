
import UIKit
import MultipeerConnectivity
import Foundation

class FinderViewController: UIViewController, MPCBrowserDelegate, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    let aD = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var scrollView: UIScrollView!
    
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //aD.advertiser.view = self
        //aD.browser.delegate = self
        //aD.browser.browser.startBrowsingForPeers()
        //println(aD.username)
        
        // 1
        let image = UIImage(named:"dart")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        scrollView.addSubview(imageView)
        
        // 2
        scrollView.contentSize = image.size
        
        // 3
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        // 4
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        // 5
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        // 6
        centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
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