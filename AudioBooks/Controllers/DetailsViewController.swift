import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Variables
    var podcast: result?
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Outlet
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        podcast?.isFavorite.toggle()
        setFavoriteButton()
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    // MARK: - Setup
    func setFavoriteButton() {
        if let isFavorite = podcast?.isFavorite {
            favoriteButton.setTitle(isFavorite ? stringConstant.word.Favourited.rawValue : stringConstant.word.Favourite.rawValue, for: [])
        }
    }
    func config() {
        setFavoriteButton()
        favoriteButton.layer.cornerRadius = 12
        titleLabel.text = podcast?.title_original
        publisherLabel.text = podcast?.publisher
        detailImageView.layer.cornerRadius = 12
        // Mobile does not modify the received HTML text. It's left to backend to add formatting tags to the string
        descriptionTextView.attributedText = podcast?.description_highlighted?.htmlToAttributedString
        imageDownload(from: podcast?.thumbnail) { image in
            DispatchQueue.main.async {
                self.detailImageView.image = image
            }
        }
    }
}
