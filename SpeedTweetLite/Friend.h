//
//  Friend.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
{
    NSMutableArray *Firends;
}

@property (nonatomic) UIImage *profilePic;
@property (nonatomic) NSString *friendName;

- (id)initWithData:(NSString*)friendText profileImg:(UIImage*)profileImg;

@end
