import UIKit

class Beer: NSObject {
    var name:String?
    var imageURL:NSURL?
    var abv:Float?
    var pricePerLitre:Float?
    
    static func fromJSON(properties:[String:AnyObject]) -> Beer {
        let beer = Beer()
        beer.name = properties["name"] as? String
        beer.imageURL = NSURL(string: properties["image_url"] as! String)
        beer.abv = properties["abv"] as? Float
        beer.pricePerLitre = properties["price"] as? Float
        return beer
    }
}
