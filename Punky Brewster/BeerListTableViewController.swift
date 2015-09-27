import UIKit

class BeerListTableViewController: UITableViewController {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    var beers:[Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        initActivityIndicator()
        refresh(nil)
    }
    
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if sender == nil {
            activityIndicator.startAnimating()
        }
        
        let request = BeerListRequest()
        request.perform {
            (retrievedBeers:[Beer], error:NSError?) -> Void in
            
            if(error != nil) {
                print("Error: \(error)")
            } else {
                self.beers = retrievedBeers
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if sender != nil {
                    sender?.endRefreshing()
                } else {
                    self.activityIndicator.stopAnimating()
                }

                self.tableView.reloadData()
            })
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
    
    private func initActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
    }

}
