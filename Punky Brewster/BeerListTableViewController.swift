import UIKit

class BeerListTableViewController: UITableViewController {
    @IBOutlet weak var errorView:UIView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    var beers:[Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        initActivityIndicator()
        initErrorView()
        refresh(nil)
    }
    
    
    @IBAction func refresh(sender: UIControl?) {
        errorView.hidden = true
        
        if (sender as? UIRefreshControl) == nil {	
            activityIndicator.startAnimating()
        }
    
        let request = BeerListRequest()
        request.perform {
            (retrievedBeers:[Beer], error:NSError?) -> Void in
 
            dispatch_async(dispatch_get_main_queue(), {
                if (sender as? UIRefreshControl) != nil {
                    (sender as! UIRefreshControl).endRefreshing()
                } else {
                    self.activityIndicator.stopAnimating()
                }
 
                if error != nil {
                    self.beers = []
                    self.errorView.hidden = false
                } else {
                    self.beers = retrievedBeers
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
        if motion == .MotionShake && !beers.isEmpty {
            beers.sortInPlace({ (a, b) in a.abvPerDollar > b.abvPerDollar })
            tableView.reloadData()
        }
    }

    // Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BeerCell", forIndexPath: indexPath) as! BeerTableViewCell
        let beer = beers[indexPath.row]
        
        cell.refreshFrom(beer)
        
        return cell
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
