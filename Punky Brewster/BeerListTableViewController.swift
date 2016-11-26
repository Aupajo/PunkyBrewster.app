import UIKit

class BeerListTableViewController: UITableViewController {
    @IBOutlet weak var errorView:UIView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var stores:[Store] = StatusRequest.cachedStores
    
    var firstStore:Store? {
        return stores.first
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        initActivityIndicator()
        initErrorView()
        refresh(nil)
        promptForNotifications()
    }
    
    
    @IBAction func refresh(_ sender: UIControl?) {
        errorView.isHidden = true
        
        if (sender as? UIRefreshControl) == nil {	
            activityIndicator.startAnimating()
        }
    
        let request = StatusRequest()
        request.perform {
            (stores:[Store], error:NSError?) -> Void in
 
            DispatchQueue.main.async(execute: {
                if (sender as? UIRefreshControl) != nil {
                    (sender as! UIRefreshControl).endRefreshing()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                
                self.stores = stores
 
                if error != nil {
                    self.errorView.isHidden = false
                }
                
                self.tableView.reloadData()
            })
        }
    }
    
    // Touch events
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && firstStore != nil && !firstStore!.taps.isEmpty {
            firstStore!.taps.sort(by: { (a, b) in a.abvPerDollar > b.abvPerDollar })
            tableView.reloadData()
        }
    }

    // Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstStore != nil ? firstStore!.taps.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerCell", for: indexPath) as! BeerTableViewCell
        
        if firstStore != nil {
            let beer = firstStore!.taps[(indexPath as NSIndexPath).row]
            cell.refreshFrom(beer)
        }
    
        return cell
    }
    
    func promptForNotifications() {
        let defaults = UserDefaults.standard
        let appHasPromptedUser = "promptedForNotifications"
        
        if defaults.bool(forKey: appHasPromptedUser) != true {
            let title = "New beer notifications"
            let message = "Would you like to be notified when new beers become available? You can disable this in Settings."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Cancel
            let cancelAction = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            
            // OK
            let OKAction = UIAlertAction(title: "Notify me 🍻", style: .default) { (action) in
                self.nativePromptForNotifications()
            }
            
            alertController.addAction(OKAction)
            
            self.navigationController!.present(alertController, animated: true, completion: nil)
            
            defaults.set(true, forKey: appHasPromptedUser)
        }
    }
    
    func nativePromptForNotifications() {
        OneSignal.defaultClient().registerForPushNotifications()
    }
    
    fileprivate var screenCenter:CGPoint {
        get {
            let screenDimensions = UIScreen.main.bounds.size
            let shiftUpwardsOffset = CGFloat(50)
            return CGPoint(x: screenDimensions.width / 2, y: screenDimensions.height / 2 - shiftUpwardsOffset)
        }
    }
    
    fileprivate func initActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.screenCenter
        view.addSubview(activityIndicator)
    }
    
    fileprivate func initErrorView() {
        errorView.center = self.screenCenter
        errorView.isHidden = true
        view.addSubview(errorView)
    }

}
