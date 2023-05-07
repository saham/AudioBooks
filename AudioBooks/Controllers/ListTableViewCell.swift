import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    // MARK: - Setup
    func config(podcast:result?) {
        imageDownload(from: podcast?.thumbnail) { image in
            DispatchQueue.main.async {
                self.listImageView.image = image
            }
        }
        self.titleLabel.text = podcast?.title_original ?? ""
        self.publisherLabel.text = podcast?.publisher
        self.favoriteLabel.text = podcast?.isFavorite ?? false ? stringConstant.word.Favourited.rawValue : ""
        self.favoriteLabel.textColor = .red
        publisherLabel.textColor = .gray
        self.listImageView.layer.cornerRadius = 12
    }
}
