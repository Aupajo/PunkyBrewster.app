import Foundation
import MapKit

class StatusRequest {
    let URL = NSURL(string: "https://d3fs7ffajw43z3.cloudfront.net/status.json")!
    static var cachedStores:[Store] = [Store()]
    
    func perform(callback:(stores:[Store], error:NSError?) -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(URL) {
            (data, response, error) in
 
            if error != nil {
                callback(stores: StatusRequest.cachedStores, error: error)
                return
            }

            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode != 200 {
                
                callback(stores: StatusRequest.cachedStores, error: NSError(domain: "server", code: -1, userInfo: [
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
                    callback(stores: StatusRequest.cachedStores, error: error)
                    return
                }
                
                if let status = jsonObject as? [String:AnyObject] {
                    if let stores = status["stores"] as? [[String:AnyObject]] {
                        StatusRequest.cachedStores = []
                        
                        for storeJSON in stores {
                            let store = Store()
                            
                            if let storeName = storeJSON["name"] as? String {
                                store.name = storeName
                            }
                            
                            if let storeShortAddress = storeJSON["short_address"] as? String {
                                store.shortAddress = storeShortAddress
                            }
                            
                            if let location = storeJSON["location"] as? [String:AnyObject] {
                                if let latitude = location["latitude"] as? Double {
                                    if let longitude = location["longitude"] as? Double {
                                        store.location = CLLocation(
                                            latitude: latitude,
                                            longitude: longitude
                                        )
                                    }
                                }
                            }
                            
                            if let storeHours = storeJSON["hours"] as? String {
                                store.hours = storeHours
                            }
                            
                            if let taps = storeJSON["taps"] as? [[String:AnyObject]] {
                                for beerData in taps {
                                    store.taps.append(Beer.fromJSON(beerData))
                                }

                                store.taps.sortInPlace { $0.name < $1.name }
                            }
                            
                            StatusRequest.cachedStores.append(store)
                        }
                        
                        callback(stores: StatusRequest.cachedStores, error: nil)
                        return
                    }
                }
                
                callback(stores: StatusRequest.cachedStores, error: NSError(domain: "server", code: -1, userInfo: [
                    "message": "Could not parse JSON",
                    "response": httpResponse
                ]))
            }
            
            
        }
        
        task.resume()
    }
}