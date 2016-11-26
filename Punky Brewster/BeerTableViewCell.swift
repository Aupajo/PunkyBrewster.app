import UIKit
import SDWebImage

class BeerTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var pricePerLitreLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    func refreshFrom(_ beer: Beer) {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        let pricePerLitre = NSNumber(value: beer.pricePerLitre!)
        
        nameLabel.text = beer.name!
        abvLabel.text = "\(beer.abv!)%"
        pricePerLitreLabel.text = "\(currencyFormatter.string(from: pricePerLitre)!)/L"
        photoView.sd_setImage(with: beer.imageURL as URL!)
    }
}
