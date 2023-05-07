import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    // MARK: - Setup
    func config(podcast: result?) {
        imageDownload(from: podcast?.thumbnail) { image in
            DispatchQueue.main.async {
                self.listImageView.image = image
            }
        }
        titleLabel.text = podcast?.title_original ?? ""
        publisherLabel.text = podcast?.publisher
        favoriteLabel.text = podcast?.isFavorite ?? false ? stringConstant.word.Favourited.rawValue : ""
        favoriteLabel.textColor = .red
        publisherLabel.textColor = .gray
        listImageView.layer.cornerRadius = 12
    }
}
