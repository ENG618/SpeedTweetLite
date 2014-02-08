//
//  STLProfileViewController.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/8/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLMainViewController.h"

@interface STLProfileViewController : UIViewController

@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userScreenname;
@property (nonatomic) NSString *userDescription;
@property (nonatomic) NSString *userFollowers;
@property (nonatomic) NSString *userFriends;

@end
