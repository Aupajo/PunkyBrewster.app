import UIKit
import SDWebImage

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
        photoView.sd_setImageWithURL(beer.imageURL)
    }
}
