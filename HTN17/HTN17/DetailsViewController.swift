//
//  DetailsViewController.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-03.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit
import SwiftyJSON

let skillHeight : CGFloat = 20
let skillSeparation : CGFloat = 5
let skillXOffset : CGFloat = 20
let skillPaddingTop : CGFloat = 10

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailsTable: UITableView!
    
    var hackerData : JSON?
    let HackerCellIdentifier = "DetailsHackerCellIdentifier"
    let HackerDetailIdentifier = "DetailsHackerItemIdentifier"
    let HackerSkillsCell = "HackerSkillsCell"
    
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
        } else if indexPath.section < 3 {
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
        } else if indexPath.section == 3 {
            
            var yoffset : CGFloat = skillPaddingTop
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: HackerSkillsCell), let hackerData = hackerData {
                
                for subview in cell.subviews.enumerated().reversed() {
                    if let s = subview.element as? UILabel {
                        s.removeFromSuperview()
                    }
                }
                
                for (_, json) in hackerData["skills"] {
                    
                    let l1Width = json["name"].stringValue.widthWithConstrainedHeight(height: skillHeight)
                    let l2Width = max(json["rating"].stringValue.widthWithConstrainedHeight(height: skillHeight), skillHeight) // Preserve square
                    
                    let l1 = UILabel()
                    l1.numberOfLines = 1
                    l1.text = json["name"].string
                    l1.textAlignment = .center
                    l1.frame = CGRect(x: skillXOffset, y: yoffset, width: l1Width, height: skillHeight)
                    l1.widthAnchor.constraint(equalToConstant: l1Width).isActive = true
                    cell.addSubview(l1)
                    
                    
                    
                    let skillColor = SkillsManager.sharedInstance.colorForSkill(skill: json["name"].stringValue)
                    
                    let l2 = UILabel()
                    l2.numberOfLines = 1
                    l2.text = json["rating"].stringValue
                    l2.layer.backgroundColor = skillColor.cgColor
                    if skillColor.isLight {
                        l2.textColor = UIColor.black
                    } else {
                        l2.textColor = UIColor.white
                    }
                    l2.layer.cornerRadius = 2
                    l2.layer.masksToBounds = true
                    l2.textAlignment = .center
                    l2.font = UIFont.systemFont(ofSize: 14)
                    
                    l2.frame = CGRect(x: skillXOffset+l1Width+5, y: yoffset, width: l2Width, height: skillHeight)
                    l2.widthAnchor.constraint(equalToConstant: l2Width).isActive = true
                    cell.addSubview(l2)
                    
                    yoffset += 25
                }
                
                return cell
            }
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
        } else if indexPath.section < 3 {
            return 30
        } else if indexPath.section == 3 {
            if let hackerData = hackerData {
                return CGFloat(hackerData["skills"].count) * (skillSeparation + skillHeight) + skillPaddingTop
            } else {
                return 0
            }
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
