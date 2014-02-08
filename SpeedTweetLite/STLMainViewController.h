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
#import "STLTweetCell.h"

@interface STLMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tweetTableView;
//    __weak IBOutlet UILabel *twitterText;
//    __weak IBOutlet UILabel *twitterUsername;
    
    
    UIAlertView *loadingAlert;
    NSArray *twitterFeed;
    
}

@property NSString *tweetText;
@property NSString *tweetDate;
@property NSString *tweetedBy;

-(void)showLoading;
-(void)dismissLoading;

- (IBAction)newTweet:(id)sender;
- (IBAction)refresh:(id)sender;

@end
