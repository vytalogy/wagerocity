//
//  MyPickTableViewCell.swift
//  wagerocity
//
//  Created by Syed Haris Hussain on 02/07/2015.
//  Copyright (c) 2015 Plego. All rights reserved.
//

import UIKit

class MyPickTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setViews (data : NSDictionary) {
        var pick : Pick! = Pick.modelObjectWithDictionary(data as [NSObject : AnyObject])
    }

}

//{
//    "bet_id": "12392",
//    "usr_id": "694",
//    "odd_id": "1392141",
//    "team_name": "A. Murray",
//    "pos": "under",
//    "odd_type": "ao",
//    "match_det": "R. Haase vs A. Murray",
//    "odds_val": "-5000",
//    "stake": "10000.00",
//    "bet_type": "single",
//    "bet_parent": "12391",
//    "bet_created": "1435789312",
//    "bet_result": "pending",
//    "bet_processed": "pending",
//    "pool_id": "0",
//    "match_id": "201507028176",
//    "teaser_point": "0",
//    "bet_ot": "1",
//    "bet_dis_odds": "a:2:{i:201507028176;a:3:{s:2:\"id\";s:7:\"1392141\";s:8:\"money_id\";s:7:\"1392141\";s:5:\"money\";s:5:\"-5000\";}i:201507028177;a:3:{s:2:\"id\";s:7:\"1392142\";s:8:\"money_id\";s:7:\"1392142\";s:5:\"money\";s:4:\"-485\";}}",
//    "league_name": "Tennis",
//    "os_bet": "0",
//    "bet_odd_val": "",
//    "is_pool_bet": "0",
//    "is_mobile_bet": "0",
//    "id": "201507028175",
//    "subleague_id": "12",
//    "scheduled_time": "2015-07-02 05:05:00",
//    "start_time": "2015-07-02 05:05:00",
//    "cst_scheduled_time": "2015-07-02 07:05:00",
//    "cst_start_time": "2015-07-02 07:05:00",
//    "team_A_number": "201507028175",
//    "team_A_name": "R. Haase",
//    "team_A_nickname": "R. Haase",
//    "team_A_abbr": "Rha",
//    "team_A_score": "0",
//    "team_A_period": "",
//    "team_B_number": "201507028176",
//    "team_B_name": "A. Murray",
//    "team_B_nickname": "A. Murray",
//    "team_B_abbr": "Mur",
//    "team_B_score": "0",
//    "team_B_period": "",
//    "mat_period": "0",
//    "mat_timer": "",
//    "mat_status": "",
//    "ref_id": "0",
//    "mat_processed": "pending",
//    "mat_created": "2015-06-29 16:36:05",
//    "pool_name": "",
//    "odd_info": [
//    {
//    "id": "1392141",
//    "sportsbook_id": "20",
//    "team_number": "201507028176",
//    "line_type": "GAME",
//    "points": "0.0",
//    "time_stamp": "2015-07-01 14:27:11",
//    "event_number": "201507028176",
//    "money": "-5000",
//    "ML": "true",
//    "over_money": "",
//    "under_money": "",
//    "created": "1435786147"
//    }
//    ],
//    "user_info": {
//        "user_id": "694",
//        "username": "HarisHussain",
//        "email": "syedharishussain@gmail.com",
//        "language": "en_US",
//        "timezone": "America/Los_Angeles",
//        "creation_date": "2014-10-24 15:52:58",
//        "facebook_uid": "10153242787353998",
//        "score": "-300.00",
//        "address": "address1",
//        "city": "0",
//        "country": "US",
//        "zip": "0",
//        "birthdate": "0000-00-00",
//        "state": "0",
//        "overallrank": "121st Place",
//        "credits": 121553,
//        "currentrecord": "-300.00"
//    },
//    "result": "- - -",
//    "team_A_logo": "",
//    "team_B_logo": ""
//}