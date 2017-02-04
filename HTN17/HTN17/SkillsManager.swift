//
//  SkillsManager.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-04.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit

class SkillsManager: NSObject {
    private var skills = [String:UIColor]()
    static let sharedInstance = SkillsManager()
    
    override init() {
        super.init()
    }
    
    func colorForSkill(skill: String) -> UIColor {
        return skills[skill] ?? generateColorForSkill(skill: skill)
    }
    
    func generateColorForSkill(skill: String) -> UIColor {
        let randomRed : CGFloat = CGFloat(arc4random_uniform(256))/255.0
        let randomGreen : CGFloat = CGFloat(arc4random_uniform(256))/255.0
        let randomBlue : CGFloat = CGFloat(arc4random_uniform(256))/255.0
        let randomColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        skills[skill] = randomColor
        
        return randomColor
    }
    
    func numberOfSKills() -> Int {
        return skills.count
    }
    
}
