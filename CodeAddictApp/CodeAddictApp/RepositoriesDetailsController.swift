import UIKit

class CommitCell: UITableViewCell {
    @IBOutlet weak var commitNumber: UILabel!
    @IBOutlet weak var commitAuthor: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var commitMessage: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commitNumber.layer.masksToBounds = true
        commitNumber.layer.cornerRadius = commitNumber.frame.width/2
        commitNumber.backgroundColor = .systemGray6
        commitNumber.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}

class RepositoriesDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var repoAuthorName: UILabel!
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var viewOnline: UIButton!
    @IBOutlet weak var shareRepo: UIButton!
    
    @IBAction func viewOnline(_ sender: Any) {
    }
    
    @IBAction func shareRepo(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = 70
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewOnline.layer.cornerRadius = 20
        shareRepo.layer.cornerRadius = 10
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 10))
        header.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 20, width: header.frame.width, height: 30)
        label.text = "Commits History"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as! CommitCell
        
        cell.commitAuthor.text = "Commit author Name".uppercased()
        cell.commitNumber.text = "1"
        cell.commitMessage.text = "Krotki commit"
        cell.email.text = "email@authorname.com"
        
        return cell
    }
}
