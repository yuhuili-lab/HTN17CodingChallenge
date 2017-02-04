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
        
        if indexPath.row >= 0 {
            
            cell.skillStackView.translatesAutoresizingMaskIntoConstraints = false
            
            for (_, view) in cell.skillStackView.subviews.enumerated().reversed() {
                cell.skillStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
            
            if let hackerData = hackerData {
                for (_, json) in hackerData[indexPath.row]["skills"] {
                    let l1 = UILabel()
                    l1.numberOfLines = 1
                    l1.text = json["name"].string
                    l1.textAlignment = .center
                    l1.widthAnchor.constraint(equalToConstant: l1.intrinsicContentSize.width).isActive = true
                    l1.heightAnchor.constraint(equalToConstant: cell.skillStackView.frame.height).isActive = true
                    l1.translatesAutoresizingMaskIntoConstraints = false
                    cell.skillStackView.addArrangedSubview(l1)
                    
                    let l2 = UILabel()
                    l2.numberOfLines = 1
                    l2.text = json["rating"].stringValue
                    l2.textColor = UIColor.white
                    l2.backgroundColor = UIColor(red: 0, green: 54/255.0, blue: 191/255.0, alpha: 1)
                    l2.layer.cornerRadius = 2
                    l2.layer.masksToBounds = true
                    l2.textAlignment = .center
                    l2.widthAnchor.constraint(equalToConstant: json["rating"].stringValue.widthWithConstrainedHeight(height: cell.skillStackView.frame.height)).isActive = true
                    l2.heightAnchor.constraint(equalToConstant: cell.skillStackView.frame.height).isActive = true
                    l2.translatesAutoresizingMaskIntoConstraints = false
                    cell.skillStackView.addArrangedSubview(l2)
                }
            }
            
            // To push subviews of stack view to left
            let blankView = UIView()
            blankView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            blankView.heightAnchor.constraint(equalToConstant: cell.skillStackView.frame.height).isActive = true
            blankView.translatesAutoresizingMaskIntoConstraints = false
            cell.skillStackView.addArrangedSubview(blankView)
            
            
            
            
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

// http://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
extension String {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width + 10
    }
}
