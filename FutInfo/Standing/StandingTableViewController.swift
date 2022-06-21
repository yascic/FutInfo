//
//  StandingTableViewController.swift
//  FutInfo
//
//  Created by Yahya Aščić on 15.05.22.
//

import UIKit

class StandingTableViewController: LoadingTableViewController {
    var league: League!
    var table: [TeamStanding] = []
    
    var networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = league.name
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = control
        showLoadingView()
        fetchStandings(withId: league.id) { [weak self] in
            self?.dismissLoadingView()
        }
    }
    
    func fetchStandings(withId id: Int, completion: (() -> ())? = nil) {
        networkManager.getLatestStandings(withId: id) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let table):
                    self?.table = table
                    dump(self?.table)
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.alertUser(withTitle: "Something went wrong", withMessage: error.localizedDescription, dismissText: "OK", onCompletion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    @objc func pullToRefresh() {
        tableView.refreshControl?.beginRefreshing()
        fetchStandings(withId: league.id) { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teamStanding = self.table[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingsCell", for: indexPath) as! StandingTableViewCell
        cell.position.text = "\(teamStanding.position)."
        cell.team.text = teamStanding.team.name
        cell.games.text = "\(teamStanding.playedGames)"
        cell.goals.text = "\(teamStanding.goalsFor):\(teamStanding.goalsAgainst)"
        cell.points.text = "\(teamStanding.points)"
        networkManager.downloadImage(from: teamStanding.team.crestUrl!) { (image) in
            DispatchQueue.main.async {
                cell.logo.image = image
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let teamViewController = storyboard?.instantiateViewController(withIdentifier: "teamVC") as! TeamViewController
        teamViewController.team = table[indexPath.row].team
        let nav = UINavigationController(rootViewController: teamViewController)
        present(nav, animated: true)
    }
}
