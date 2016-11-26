import Foundation
import MapKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class StatusRequest {
    let URL = Foundation.URL(string: "https://d3fs7ffajw43z3.cloudfront.net/status.json")!
    static var cachedStores:[Store] = [Store()]
    
    func perform(_ callback:@escaping (_ stores:[Store], _ error:NSError?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL, completionHandler: {
            (data, response, error) in
 
            if error != nil {
                callback(StatusRequest.cachedStores, error as NSError?)
                return
            }

            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode != 200 {
                
                callback(StatusRequest.cachedStores, NSError(domain: "server", code: -1, userInfo: [
                    "statusCode": statusCode,
                    "response": httpResponse
                ]))
                
            } else {
                
                var parseError: NSError? = nil
                let jsonObject:Any?
                
                do {
                    jsonObject = try JSONSerialization.jsonObject(with: data!,
                                    options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch let error as NSError {
                    parseError = error
                    jsonObject = nil
                } catch {
                    fatalError()
                }
                
                if parseError != nil {
                    callback(StatusRequest.cachedStores, error as NSError?)
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

                                store.taps.sort { $0.name < $1.name }
                            }
                            
                            StatusRequest.cachedStores.append(store)
                        }
                        
                        callback(StatusRequest.cachedStores, nil)
                        return
                    }
                }
                
                callback(StatusRequest.cachedStores, NSError(domain: "server", code: -1, userInfo: [
                    "message": "Could not parse JSON",
                    "response": httpResponse
                ]))
            }
            
            
        }) 
        
        task.resume()
    }
}
