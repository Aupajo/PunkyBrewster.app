import UIKit

class BeerListTableViewController: UITableViewController {
    @IBOutlet weak var errorView:UIView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    var stores:[Store] = StatusRequest.cachedStores
    
    var firstStore:Store? {
        return stores.first
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        initActivityIndicator()
        initErrorView()
        refresh(nil)
        promptForNotifications()
    }
    
    
    @IBAction func refresh(sender: UIControl?) {
        errorView.hidden = true
        
        if (sender as? UIRefreshControl) == nil {	
            activityIndicator.startAnimating()
        }
    
        let request = StatusRequest()
        request.perform {
            (stores:[Store], error:NSError?) -> Void in
 
            dispatch_async(dispatch_get_main_queue(), {
                if (sender as? UIRefreshControl) != nil {
                    (sender as! UIRefreshControl).endRefreshing()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                
                self.stores = stores
 
                if error != nil {
                    self.errorView.hidden = false
                }
                
                self.tableView.reloadData()
            })
        }
    }
    
    // Touch events
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && firstStore != nil && !firstStore!.taps.isEmpty {
            firstStore!.taps.sortInPlace({ (a, b) in a.abvPerDollar > b.abvPerDollar })
            tableView.reloadData()
        }
    }

    // Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstStore != nil ? firstStore!.taps.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BeerCell", forIndexPath: indexPath) as! BeerTableViewCell
        
        if firstStore != nil {
            let beer = firstStore!.taps[indexPath.row]
            cell.refreshFrom(beer)
        }
    
        return cell
    }
    
    func promptForNotifications() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let appHasPromptedUser = "promptedForNotifications"
        
        if defaults.boolForKey(appHasPromptedUser) != true {
            let title = "New beer notifications"
            let message = "Would you like to be notified when new beers become available? You can disable this in Settings."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            // Cancel
            let cancelAction = UIAlertAction(title: "No thanks", style: .Cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            
            // OK
            let OKAction = UIAlertAction(title: "Notify me 🍻", style: .Default) { (action) in
                self.nativePromptForNotifications()
            }
            
            alertController.addAction(OKAction)
            
            self.navigationController!.presentViewController(alertController, animated: true, completion: nil)
            
            defaults.setBool(true, forKey: appHasPromptedUser)
        }
    }
    
    func nativePromptForNotifications() {
        OneSignal.defaultClient().registerForPushNotifications()
    }
    
    private var screenCenter:CGPoint {
        get {
            let screenDimensions = UIScreen.mainScreen().bounds.size
            let shiftUpwardsOffset = CGFloat(50)
            return CGPointMake(screenDimensions.width / 2, screenDimensions.height / 2 - shiftUpwardsOffset)
        }
    }
    
    private func initActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.screenCenter
        view.addSubview(activityIndicator)
    }
    
    private func initErrorView() {
        errorView.center = self.screenCenter
        errorView.hidden = true
        view.addSubview(errorView)
    }

}
