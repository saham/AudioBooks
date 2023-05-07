import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    func config(podcast:result?) {
        imageDownload(from: podcast?.thumbnail) { image in
            DispatchQueue.main.async {
                self.listImageView.image = image
            }
        }
        self.titleLabel.text = podcast?.title_original ?? ""
        self.publisherLabel.text = podcast?.publisher
        self.favoriteLabel.text = podcast?.isFavorite ?? false ? "Fave" : ""
        self.favoriteLabel.textColor = .red
        publisherLabel.textColor = .gray
        
        self.listImageView.layer.cornerRadius = 12
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
