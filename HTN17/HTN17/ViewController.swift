//
//  ViewController.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-03.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dm : DataManager?
    var hackerData : JSON?
    @IBOutlet weak var hackerTable: UITableView!
    
    let HackerCellIdentifier = "HackerCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dm = DataManager(remoteURL: "https://htn-interviews.firebaseio.com/users.json")
        dm?.startDownload(completionHandler: { (success, result, error) in
            if success == true {
                self.hackerData = result
                self.hackerTable.reloadData()
            } else {
                print("fail")
            }
        })
        
        hackerTable.register(UINib(nibName: "HackerCell", bundle: nil), forCellReuseIdentifier: "HackerCellIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hackerData = hackerData {
            return hackerData.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HackerCellIdentifier, for: indexPath) as! HackerCell
        
        if let hackerData = hackerData {
            cell.nameLabel.text = hackerData[indexPath.row]["name"].string
        }
        
        if let hackerData = hackerData, let imageUrl = hackerData[indexPath.row]["picture"].string {
            // Add some randomization
            if arc4random() % 2 == 0 {
                cell.icon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "person1"))
            } else {
                cell.icon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "person2"))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if let hackerData = hackerData {
            details.hackerData = hackerData[indexPath.row]
        }
        self.navigationController!.pushViewController(details, animated: true)
    }

}

