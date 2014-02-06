//
//  STLMainViewController.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/6/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "STLTweetCell.h"

@interface STLMainViewController : UITableViewController
{
    IBOutlet UITableView *tweetTableView;
    __weak IBOutlet UILabel *twitterText;
    __weak IBOutlet UILabel *twitterUsername;
    
    
    NSArray *twitterFeed;
    
}

@end
