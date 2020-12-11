import UIKit

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

class RepositoriesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        searchBar.delegate = self
        
        self.tableView.sectionHeaderHeight = 70
        self.tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepositoriesCell
        
        cell.repoImage.image = UIImage(named: "image.png")
        cell.repoName.text = "Repozytorium"                            //Dane do testowania
        cell.repoStars.text = "☆ " + "1234"
        
        return cell
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5        //wartość do testów
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    @objc func DismissKeyboard() {
        self.view.endEditing(true)
    }
}
