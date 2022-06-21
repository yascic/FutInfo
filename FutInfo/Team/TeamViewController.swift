//
//  TeamViewController.swift
//  FutInfo
//
//  Created by Yahya Aščić on 15.05.22.
//

import UIKit

class TeamViewController: LoadingViewController, UITableViewDataSource, UITableViewDelegate {
    var team: Team!
    private var networkManager = NetworkManager.shared
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var abbreviation: UILabel!
    @IBOutlet weak var playerList: UITableView!
    @IBOutlet weak var dismiss: UIBarButtonItem!
    @IBAction func infoTapped(_ sender: UIBarButtonItem) {
        goToTeam()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismiss.target = self
        dismiss.action = #selector(dismissTeam)
        playerList.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        fetchTeamDetails(withId: team.id)
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        if identifier == "goToTeam" {
//            goToTeam()
//        }
//    }
    
    @objc func dismissTeam() {
        dismiss(animated: true)
    }
    
    func goToTeam() {
        let teamViewController = storyboard?.instantiateViewController(withIdentifier: "teamDetailVC") as! TeamDetailViewController
//        let nav = UINavigationController(rootViewController: teamViewController)
        var playerData = [Int: (String, String?)]()
        playerData[0] = ("Name", team?.name)
        playerData[1] = ("Abkürzung", team?.tla)
        playerData[2] = ("Land", team?.area?.name)
        playerData[3] = ("Gegründet", "\(team?.founded ?? 0)")
        playerData[4] = ("Klubfarben", team?.clubColors)
        playerData[5] = ("Stadion", team?.venue)
        teamViewController.playerData = playerData


        navigationController?.pushViewController(teamViewController, animated: true)
    }
    
    func fetchTeamDetails(withId id: Int) {
        showLoadingView()
        networkManager.getTeamDetails(fromId: team.id) { [weak self] (result) in
            self?.dismissLoadingView()
            DispatchQueue.main.async {
                switch result {
                case .success(let team):
                    self?.networkManager.downloadImage(from: team.crestUrl!) { [weak self] (image) in
                        DispatchQueue.main.async {
                            self?.logo.image = image
                        }
                    }
                    self?.teamName.text = team.name
                    self?.abbreviation.text = team.tla
                    self?.team = team
                    dump(self?.team)
                    self?.playerList.reloadData()
                case .failure(let error):
                    self?.alertUser(withTitle: "Something went wrong", withMessage: error.localizedDescription, dismissText: "OK", onCompletion: {
                        self?.dismiss(animated: true) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)
        cell.textLabel?.text = self.team.squad?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.team.squad?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playerList.deselectRow(at: indexPath, animated: true)
        let playerViewController = storyboard?.instantiateViewController(withIdentifier: "playerVC") as! PlayerViewController
//        let nav = UINavigationController(rootViewController: playerViewController)
        playerViewController.player = self.team.squad?[indexPath.row]
        navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Spieler"
    }
}
