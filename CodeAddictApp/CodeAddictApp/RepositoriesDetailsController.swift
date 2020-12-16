import UIKit
import RxSwift
import RxCocoa

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

class RepositoriesDetailsController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var repoTitle: UILabel!
    @IBOutlet weak var stars: UILabel!
    @IBOutlet weak var repoAuthorName: UILabel!
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var viewOnline: UIButton!
    @IBOutlet weak var shareRepo: UIButton!
    
    private let githubRepository = GitHubRepository()
    private let disposeBag = DisposeBag()
    
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
        
        githubRepository.getCommits(owner: passedRepoOwner, repoName: passedRepoName).share()
        .bind(to: tableView.rx.items(cellIdentifier: "commitCell", cellType: CommitCell.self)) { index, commit, cell in
            cell.commitNumber.text = "\(index + 1)"
            cell.commitAuthor.text = commit.commit.author.name
            cell.commitMessage.text = commit.commit.message
            cell.email.text = commit.commit.author.email
        }.disposed(by: disposeBag)
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

struct Commits: Decodable {
    let commit: Commit
}

struct Commit: Decodable {
    let message: String
    let author: Author
}

struct Author: Decodable {
    let name: String
    let email: String
}
