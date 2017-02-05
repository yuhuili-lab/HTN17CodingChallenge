//
//  HackerMapCell.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-04.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit
import MapKit

class HackerMapCell: UITableViewCell {
    @IBOutlet weak var map: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
