//
//  HackerCell.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-03.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit

class HackerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var arrow: UILabel!
    @IBOutlet weak var skillsView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
