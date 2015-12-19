//
//  TimelineViewController.swift
//  Nearby Tweets
//
//  Created by David Wayman on 12/9/15.
//  Copyright © 2015 David Wayman. All rights reserved.
//

import UIKit
import TwitterKit
import Alamofire

class TimelineViewController: UITableViewController, TWTRTweetViewDelegate {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    let tweetTableReuseIdentifier = "TweetCell"
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let tweetIDs = ["20", // @jack's first Tweet
        "510908133917487104"] // our favorite bike Tweet
    
    override func viewDidLoad() {
        // Setup the table view
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
        tableView.allowsSelection = false
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        // self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        // Load Tweets
        let client = TWTRAPIClient()
        client.loadTweetsWithIDs(tweetIDs) { tweets, error in
            if let ts = tweets as? [TWTRTweet] {
                self.tweets = ts
            } else {
                print("Failed to load tweets: \(error!.localizedDescription)")
            }
        }
        
        Alamofire.request(.GET, "https://api.twitter.com/1.1/search/tweets.json", parameters:["geocode": "\(userDefaults.doubleForKey("latitude")),\(userDefaults.doubleForKey("longitude")),1mi"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    // MARK: UITableViewDelegate Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
        cell.configureWithTweet(tweet)
        cell.tweetView.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
    }
}