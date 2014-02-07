//
//  STLTweetCell.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/6/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLTweetCell : UITableViewCell
{
    IBOutlet UILabel *twitterText;
    IBOutlet UILabel *twitterUsername;
}

- (void)refreshCell;

@property (nonatomic, strong) NSString *tweetText;
@property (nonatomic, strong) NSString *username;

@end
