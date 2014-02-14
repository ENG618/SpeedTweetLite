//
//  FriendsViewController.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "FiriendDetailsViewController.h"
#import "FriendCell.h"
#import "Friend.h"

@interface FriendsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIAlertView *loadingAlert;
    NSDictionary *twitterFeed;
    NSArray *tempArray;
    NSMutableArray *friendsList;
}

- (void)accessTwitter;
- (void)showLoading;
- (void)dismissLoading;

@end
