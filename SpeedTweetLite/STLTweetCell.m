//
//  STLTweetCell.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/6/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "STLTweetCell.h"

@implementation STLTweetCell

@synthesize tweetText, username;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCell
{
    twitterText.text = tweetText;
    twitterUsername.text = username;
}

@end
