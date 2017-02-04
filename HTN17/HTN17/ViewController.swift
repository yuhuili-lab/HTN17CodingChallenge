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
    var hackerDataArray : [JSON]?
    @IBOutlet weak var hackerTable: UITableView!
    
    let HackerCellIdentifier = "HackerCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dm = DataManager(remoteURL: "https://htn-interviews.firebaseio.com/users.json")
        dm?.startDownload(completionHandler: { (success, result, error) in
            if success == true {
                let rawArray = result?.arrayValue
                self.hackerDataArray = rawArray!.sorted(by: self.sortByName)
                self.hackerTable.reloadData()
            } else {
                print("fail")
            }
        })
        
        hackerTable.register(UINib(nibName: "HackerCell", bundle: nil), forCellReuseIdentifier: "HackerCellIdentifier")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = hackerTable.indexPathForSelectedRow {
            hackerTable.deselectRow(at: indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func sortByName (j1: JSON, j2: JSON) -> Bool {
        return j1["name"].stringValue < j2["name"].stringValue
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let hackerDataArray = hackerDataArray {
            return hackerDataArray.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HackerCellIdentifier, for: indexPath) as! HackerCell
        
        if let hackerDataArray = hackerDataArray {
            cell.nameLabel.text = hackerDataArray[indexPath.row]["name"].string
        }
        
        if let hackerDataArray = hackerDataArray, let imageUrl = hackerDataArray[indexPath.row]["picture"].string {
            // Add some randomization
            if arc4random() % 2 == 0 {
                cell.icon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "person1"))
            } else {
                cell.icon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "person2"))
            }
        }
        
        if indexPath.row >= 0 {
            
            for (_, view) in cell.skillsView.subviews.enumerated().reversed() {
                view.removeFromSuperview()
            }
            
            var xoffset : CGFloat = 0
            let height = cell.skillsView.frame.height
            let maxWidth = cell.skillsView.frame.width
            
            if let hackerDataArray = hackerDataArray {
                for (_, json) in hackerDataArray[indexPath.row]["skills"] {
                    
                    let l1Width = json["name"].stringValue.widthWithConstrainedHeight(height: height)
                    let l2Width = max(json["rating"].stringValue.widthWithConstrainedHeight(height: height), height) // Preserve square
                    
                    let l1 = UILabel()
                    l1.numberOfLines = 1
                    l1.text = json["name"].string
                    l1.textAlignment = .center
                    l1.frame = CGRect(x: xoffset, y: 0, width: l1Width, height: height)
                    l1.widthAnchor.constraint(equalToConstant: l1Width).isActive = true
                    cell.skillsView.addSubview(l1)
                    
                    xoffset += l1Width + 5
                    
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
                    
                    l2.frame = CGRect(x: xoffset, y: 0, width: l2Width, height: height)
                    l2.widthAnchor.constraint(equalToConstant: l2Width).isActive = true
                    cell.skillsView.addSubview(l2)
                    
                    xoffset += l2Width + 5
                    
                    if xoffset > maxWidth - 5 {
                        l1.removeFromSuperview()
                        l2.removeFromSuperview()
                        break
                    }
                }
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if let hackerDataArray = hackerDataArray {
            details.hackerData = hackerDataArray[indexPath.row]
        }
        self.navigationController!.pushViewController(details, animated: true)
    }

}

// http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
extension String {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)], context: nil)
        
        return boundingBox.width
    }
}

extension UIColor {
    var isLight: Bool {
        let components = self.cgColor.components
        let c1 = components![0] * 299
        let c2 = components![1] * 587
        let c3 = components![2] * 114
        
        let brightness = c1 + c2 + c3
        
        if brightness < 500 {
            return false
        } else {
            return true
        }
    }
}
