//
//  Friend.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "Friend.h"

@implementation Friend
@synthesize profilePic, friendName;

- (id)initWithData:(NSString*)friendText profileImg:(UIImage*)profileImg
{
    self.friendName = friendText;
    self.profilePic = profileImg;
    
    return self;
}

@end
