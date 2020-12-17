import UIKit
import SwiftyJSON

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
    
    var jsonData: JSON = JSON()
    
    var passedRepoName: String = ""
    var passedRepoOwner: String = ""
    var passedRepoImageUrl: String = ""
    var passedRepoUrl: String = ""
    var passedRepoStars: Int = 0
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTitle.text = passedRepoName
        repoAuthorName.text = passedRepoOwner
        repoImage.load(url: URL(string: passedRepoImageUrl)!)
        stars.text = "★ Number of Stars (\(passedRepoStars))"
        
        viewOnline.layer.cornerRadius = 20
        shareRepo.layer.cornerRadius = 10
        
        tableView.sectionHeaderHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate = self
        tableView.dataSource = self
        
        getCommits(owner: passedRepoOwner, repoName: passedRepoName)
    }
    
    func getCommits(owner: String, repoName: String) {
        let task = URLSession.shared.dataTask(with: URL(string: "https://api.github.com/repos/\(owner)/\(repoName)/commits")!) { data, response, error in
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
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell") as! CommitCell
        cell.commitNumber.text = "\(indexPath.row + 1)"
        cell.commitAuthor.text = jsonData[indexPath.row]["commit"]["author"]["name"].stringValue.uppercased()
        cell.commitMessage.text = jsonData[indexPath.row]["commit"]["message"].stringValue
        cell.email.text = jsonData[indexPath.row]["commit"]["author"]["email"].stringValue
        return cell
    }
    
    
    @IBAction func viewOnline(_ sender: Any) {
        guard let url = URL(string: passedRepoUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func shareRepo(_ sender: Any) {
        let description = "Check out this repo. It's lit!🔥🔥"
        let url = URL(string: passedRepoUrl)!
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [description, url], applicationActivities: nil)
        
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
