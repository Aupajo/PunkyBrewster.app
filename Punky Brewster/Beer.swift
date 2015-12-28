import UIKit

class Beer: NSObject, NSCoding {
    let HTTPS_IMAGE_DOMAIN = "d3g0s2k979mn74.cloudfront.net"

    var name:String?
    var imageURL:NSURL?
    var abv:Float?
    var pricePerLitre:Float?

    init(name: String?, imageURL: NSURL?, abv: Float?, pricePerLitre: Float?) {
        self.name = name
        self.imageURL = imageURL
        self.abv = abv
        self.pricePerLitre = pricePerLitre
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey("name") as? String
        let imageURL = aDecoder.decodeObjectForKey("imageURL") as? NSURL
        let abv = aDecoder.decodeFloatForKey("abv") as Float
        let pricePerLitre = aDecoder.decodeFloatForKey("pricePerLitre") as Float
        self.init(
            name: name,
            imageURL: imageURL,
            abv: abv,
            pricePerLitre: pricePerLitre
        )
    }

    init(json:[String:AnyObject]) {
        let imageURLComponents:NSURLComponents = NSURLComponents(string: json["image_url"] as! String)!
        
        // Images must be fetched through HTTPS for iOS 9
        imageURLComponents.scheme = "https"
        imageURLComponents.host = HTTPS_IMAGE_DOMAIN
        
        self.name = json["name"] as? String
        self.imageURL = imageURLComponents.URL
        self.abv = json["abv"] as? Float
        self.pricePerLitre = json["price"] as? Float
    }
 
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(imageURL, forKey: "imageURL")
        aCoder.encodeObject(abv, forKey: "abv")
        aCoder.encodeObject(pricePerLitre, forKey: "pricePerLitre")
    }
}
