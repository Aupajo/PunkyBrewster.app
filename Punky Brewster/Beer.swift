import UIKit

class Beer: NSObject {
    static let HTTPS_IMAGE_DOMAIN = "d3g0s2k979mn74.cloudfront.net"
    
    var name:String?
    var imageURL:NSURL?
    var abv:Float?
    var pricePerLitre:Float?
    
    static func fromJSON(properties:[String:AnyObject]) -> Beer {
        let beer = Beer()
        let imageURLComponents:NSURLComponents = NSURLComponents(string: properties["image_url"] as! String)!
        
        // Images must be fetched through HTTPS for iOS 9
        imageURLComponents.scheme = "https"
        imageURLComponents.host = HTTPS_IMAGE_DOMAIN
        
        print(String(imageURLComponents.URL))
        
        beer.name = properties["name"] as? String
        beer.imageURL = imageURLComponents.URL
        beer.abv = properties["abv"] as? Float
        beer.pricePerLitre = properties["price"] as? Float
        return beer
    }
}
