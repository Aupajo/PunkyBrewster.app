import Foundation

class BeerListRequest {
    let URL = NSURL(string: "http://punkybrewster.petenicholls.com/beers.json")!
    
    func perform(callback:(list:[Beer], error:NSError?) -> Void) {
        var retrieved:[Beer] = []
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(URL) {
            (data, response, error) in
            
            if error != nil {
                callback(list: [], error: error)
                return
            }
            
            var parseError: NSError? = nil
            let jsonObject:AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions(0),
                error: &parseError)
            
            if parseError != nil {
                println("JSON Error: \(parseError)")
                callback(list: [], error: error)
                return
            }
            
            println("\(jsonObject)")
            
            if let beers = jsonObject as? [[String:AnyObject]] {
                for beerJSON in beers {
                    retrieved.append(Beer.fromJSON(beerJSON))
                }
                
                retrieved.sort { $0.name < $1.name }
                
                callback(list: retrieved, error: nil)
            }
            
            
        }
        
        task.resume()
    }
}