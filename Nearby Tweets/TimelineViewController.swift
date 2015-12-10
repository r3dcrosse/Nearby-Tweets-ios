//
//  TimelineViewController.swift
//  Nearby Tweets
//
//  Created by David Wayman on 12/9/15.
//  Copyright © 2015 David Wayman. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: TWTRTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: "#twitterflock", APIClient: client)
    }
}
