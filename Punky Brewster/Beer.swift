import UIKit

class Beer: NSObject {
    static let HTTPS_IMAGE_DOMAIN = "d3g0s2k979mn74.cloudfront.net"
    
    var name:String?
    var imageURL:URL?
    var abv:Float?
    var pricePerLitre:Float?
    
    var abvPerDollar:Float {
        return abv! / pricePerLitre!
    }
    
    static func fromJSON(_ properties:[String:AnyObject]) -> Beer {
        let beer = Beer()
        var imageURLComponents:URLComponents = URLComponents(string: properties["image_url"] as! String)!
        
        // Images must be fetched through HTTPS for iOS 9
        imageURLComponents.scheme = "https"
        imageURLComponents.host = HTTPS_IMAGE_DOMAIN
        
        beer.name = properties["name"] as? String
        beer.imageURL = imageURLComponents.url
        beer.abv = properties["abv"] as? Float
        beer.pricePerLitre = properties["price"] as? Float
        return beer
    }
}
