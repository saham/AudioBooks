import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Variables
    var model:listing = listing()
    let API = APICaller()
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupActivity()
        API.fetchData{ data in
            switch data {
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
    
    // MARK: - Setup
    func setupActivity(isRunning: Bool = false) {
        if isRunning {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityHeightConstraint.constant = isRunning ? 20 : 0
        activityIndicator.isHidden = !isRunning
    }
}

// MARK: - tableView
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
    /**
     When user scrolls to the end of tableView, we reload another set of data
     -  We get 10 listings at a time, we add all 10 listings to our model
     */

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = model.results?.count, count - 1 == indexPath.row {
            setupActivity(isRunning:  true)
            guard !API.isPaging else {return}
            API.fetchData {[weak self] res in
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

