//
//  TimelineUserHeaderView.swift
//  iOSCleanArchitectureTwitterSample
//
//  Created by Kodama.Kotaro on 2016/11/15.
//  Copyright © 2016年 koutalou. All rights reserved.
//

import UIKit
import Kingfisher

class TimelineUserHeaderView: UIView {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var displayName: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroudImageView: UIImageView!
    
    func updateView(_ timelineModel: UserViewModel) {
        self.name.text = "@" + timelineModel.screenName
        self.displayName.text = timelineModel.name
        self.profileImageView.kf.setImage(with: URL(string: timelineModel.profileUrl))
        self.backgroudImageView.kf.setImage(with: URL(string: timelineModel.profileBackgroundUrl))
        self.descriptionLabel.text = timelineModel.userDescription
    }
}
