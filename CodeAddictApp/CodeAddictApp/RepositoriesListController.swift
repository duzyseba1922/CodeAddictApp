import UIKit
import SwiftyJSON

class RepositoriesCell: UITableViewCell {
    
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoStars: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        repoImage.layer.cornerRadius = 15
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .systemGray6
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: -20))
    }
}

class RepositoriesListController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var jsonData: JSON = JSON()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.tableView.sectionHeaderHeight = 70
        self.tableView.keyboardDismissMode = .onDrag
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!.replacingOccurrences(of: " ", with: "_")
        let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/search/repositories?q=" + query)!) { data, response, error in
            guard let data=data else { return }
            do {
                self.jsonData = try JSON(data: data)
                DispatchQueue.main.async {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 10))
        header.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 20, width: header.frame.width, height: 30)
        label.text = "Repositories"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepositoriesCell
        cell.repoName.text = jsonData["items"][indexPath.row]["name"].stringValue
        cell.repoStars.text = "☆ \(jsonData["items"][indexPath.row]["stargazers_count"].intValue)"
        cell.repoImage.load(url: URL(string: jsonData["items"][indexPath.row]["owner"]["avatar_url"].stringValue)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData["items"].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepositoriesDetailsController") as! RepositoriesDetailsController
        detailsView.passedRepoName = jsonData["items"][indexPath.row]["name"].stringValue
        detailsView.passedRepoOwner = jsonData["items"][indexPath.row]["owner"]["login"].stringValue
        detailsView.passedRepoImageUrl = jsonData["items"][indexPath.row]["owner"]["avatar_url"].stringValue
        detailsView.passedRepoUrl = jsonData["items"][indexPath.row]["html_url"].stringValue
        detailsView.passedRepoStars = jsonData["items"][indexPath.row]["stargazers_count"].intValue
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
