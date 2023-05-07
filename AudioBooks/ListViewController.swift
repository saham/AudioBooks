import UIKit

class ListViewController: UIViewController {

    var model:listing = listing()
    let API = APICaller()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        activityHeightConstraint.constant = 0
        activityIndicator.isHidden = true
        API.fetchData(paginating: false) { res in
            switch res {
            case .success(let listing):
                self.model = listing
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - scrollView.frame.size.height) {
            activityIndicator.startAnimating()
            activityHeightConstraint.constant = 20
            activityIndicator.isHidden = false
            guard !API.isPaging else {return}
            API.fetchData(paginating: true) {[weak self] res in
                switch res {
                case .success(let listing):
                    if let newListing = listing.results {
                        self?.model.results?.append(contentsOf: newListing)
                        // It simulates 1.0 second delay in network call
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self?.activityIndicator.stopAnimating()
                            self?.activityHeightConstraint.constant = 0
                            self?.activityIndicator.isHidden = true
                            self?.tableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.results?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
        cell.config(podcast: model.results?[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let DVC = sb.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsViewController{
            DVC.podcast =  model.results?[indexPath.row]
            navigationController?.pushViewController(DVC, animated: true)
        }
    }
}

