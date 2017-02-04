//
//  DetailsViewController.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-03.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailsTable: UITableView!
    
    var hackerData : JSON?
    let HackerCellIdentifier = "DetailsHackerCellIdentifier"
    let HackerDetailIdentifier = "DetailsHackerItemIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsTable.register(UINib(nibName: "BigHackerCell", bundle: nil), forCellReuseIdentifier: "DetailsHackerCellIdentifier")
        detailsTable.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hackerData == nil ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { // Name and company
            let cell = tableView.dequeueReusableCell(withIdentifier: HackerCellIdentifier, for: indexPath) as! BigHackerCell
            
            if let hackerData = hackerData {
                cell.nameLabel.text = hackerData["name"].string
                cell.companyLabel.text = hackerData["company"].string
            }
            
            if let hackerData = hackerData, let imageUrl = hackerData["picture"].string {
                // Add some randomization
                if arc4random() % 2 == 0 {
                    cell.icon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "person1"))
                } else {
                    cell.icon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "person2"))
                }
            }
            return cell
        } else if indexPath.section < 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HackerDetailIdentifier)
            
            if let hackerData = hackerData {
                switch indexPath.section {
                case 1:
                    cell!.textLabel?.text = hackerData["phone"].string
                case 2:
                    cell!.textLabel?.text = hackerData["email"].string
                default:
                    cell!.textLabel?.text = ""
                }
                
            }
            
            return cell!
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.textLabel?.textColor = UIColor(red: 48/255.0, green: 123/255.0, blue: 246/255.0, alpha: 1)
        v.textLabel?.font = UIFont.systemFont(ofSize: 13)
        v.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 && section < 4 {
            return 13
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Phone"
        case 2:
            return "Email"
        case 3:
            return "Skills"
        default:
            break
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section > 0 && section < 4 {
            return 14
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if indexPath.section < 4 {
            return 30
        }
        return 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
