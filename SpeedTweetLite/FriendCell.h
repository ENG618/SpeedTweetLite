//
//  FriendCell.h
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *friendImage;
@property (strong, nonatomic) IBOutlet UILabel *friendLabel;

- (void)resetWithLable:(NSString*)labelText cellImage:(UIImage*)cellImage;

@end
