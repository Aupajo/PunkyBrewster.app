import Foundation

class StatusRequest {
    let URL = NSURL(string: "https://d3fs7ffajw43z3.cloudfront.net/status.json")!
    
    func perform(callback:(store:Store?, error:NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(URL) {
            (data, response, error) in
 
            if error != nil {
                callback(store: nil, error: error)
                return
            }

            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode != 200 {
                
                callback(store: nil, error: NSError(domain: "server", code: -1, userInfo: [
                    "statusCode": statusCode,
                    "response": httpResponse
                ]))
                
            } else {
                
                var parseError: NSError? = nil
                let jsonObject:AnyObject?
                
                do {
                    jsonObject = try NSJSONSerialization.JSONObjectWithData(data!,
                                    options: NSJSONReadingOptions(rawValue: 0))
                } catch let error as NSError {
                    parseError = error
                    jsonObject = nil
                } catch {
                    fatalError()
                }
                
                if parseError != nil {
                    callback(store: nil, error: error)
                    return
                }
                
                if let status = jsonObject as? [String:AnyObject] {
                    if let stores = status["stores"] as? [[String:AnyObject]] {
                        if let firstStore = stores.first {
                            let store = Store()
                            
                            if let taps = firstStore["taps"] as? [[String:AnyObject]] {
                                
                                for beerData in taps {
                                    store.taps.append(Beer.fromJSON(beerData))
                                }

                                store.taps.sortInPlace { $0.name < $1.name }

                                callback(store: store, error: nil)
                                return
                            }
                        }
                    }
                }
                
                callback(store: nil, error: NSError(domain: "server", code: -1, userInfo: [
                    "message": "Could not parse JSON",
                    "response": httpResponse
                ]))
            }
            
            
        }
        
        task.resume()
    }
}