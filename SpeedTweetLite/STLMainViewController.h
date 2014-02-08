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
#import "STLTweetDetailViewController.h"
#import "STLTweet.h"

@interface STLMainViewController : UITableViewController
{
    IBOutlet UITableView *tweetTableView;
    
    UIAlertView *loadingAlert;
    NSArray *twitterFeed;
    
}

@property (strong, nonatomic)UIRefreshControl *refreshControl;
@property UIImage *pic;
@property NSString *tweetText;
@property NSString *tweetDate;
@property NSString *tweetedBy;

-(void)showLoading;
-(void)dismissLoading;
-(void)accessTwitter;

@end
