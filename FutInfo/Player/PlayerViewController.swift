//
//  PlayerViewController.swift
//  FutInfo
//
//  Created by Yahya Aščić on 29.05.22.
//

import UIKit

class PlayerViewController: UITableViewController {
    
    var player: Player!
    
    var playerData = [Int: (String, String?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerData[0] = ("Name", player.name)
        playerData[1] = ("Position", player.position)
        playerData[2] = ("Nationalität", player.nationality)
        playerData[3] = ("Geburtsland", player.countryOfBirth)
        playerData[4] = ("Geburtstag", player.dateOfBirth?.replacingOccurrences(of: "T00:00:00Z", with: ""))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = playerData[indexPath.row]?.0
        cell.detailTextLabel?.text = playerData[indexPath.row]?.1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerData.count
    }
}
