//
//  TeamDetailViewController.swift
//  FutInfo
//
//  Created by Yahya Aščić on 29.05.22.
//

import UIKit

class TeamDetailViewController: UITableViewController {
        
    var playerData = [Int: (String, String?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
