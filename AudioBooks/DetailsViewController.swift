import UIKit

class DetailsViewController: UIViewController{
    var podcast:result?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        podcast?.isFavorite.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }    
    func config() {
        titleLabel.text = podcast?.title_original
        publisherLabel.text = podcast?.publisher
        detailImageView.layer.cornerRadius = 12
        descriptionTextView.attributedText = podcast?.description_highlighted?.htmlToAttributedString
        imageDownload(from: podcast?.thumbnail) { image in
            DispatchQueue.main.async {
                self.detailImageView.image = image
            }
        }
    }
}
