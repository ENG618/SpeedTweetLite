//
//  STLTweetDetailViewController.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/6/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLTweetDetailViewController : UIViewController
{
    __weak IBOutlet UILabel *tweet;
    __weak IBOutlet UILabel *tweetTime;
    __weak IBOutlet UILabel *tweetedBy;
    
}


@property NSString *tweet;
@property NSString *tweetTime;
@property NSString *tweetedBy;

@end
