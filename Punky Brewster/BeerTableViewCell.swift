import UIKit

class BeerTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var pricePerLitreLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    func refreshFrom(beer: Beer) {
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        
        nameLabel.text = beer.name!
        abvLabel.text = "\(beer.abv!)%"
        pricePerLitreLabel.text = "\(currencyFormatter.stringFromNumber(beer.pricePerLitre!)!)/L"
        photoView.image = nil
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
            if let imageData = NSData(contentsOfURL: beer.imageURL!) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.photoView.image = UIImage(data: imageData)
                })
            }
        })

    }
}
