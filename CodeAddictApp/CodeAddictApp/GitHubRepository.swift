import Foundation
import RxSwift

class GitHubRepository {
    private let networkService = NetworkService()
    private let baseURL = "https://api.github.com"
    
    func getCommits(owner: String, repoName: String) -> Observable<[Commits]> {
        return networkService.execute(url: URL(string: baseURL + "/repos/\(owner)/\(repoName)/commits")!)
    }
}
