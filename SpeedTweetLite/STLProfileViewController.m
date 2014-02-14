//
//  STLProfileViewController.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/8/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "STLProfileViewController.h"

@interface STLProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;


@end

@implementation STLProfileViewController

@synthesize userName,
            userScreenname,
            userDescription,
            userFollowers,
            userFriends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Format NSNumber to String
//    NSString *followersString = [userFollowers stringValue];
//    NSString *friendsString = [userFriends stringValue];
    //Set label text
    self.nameLabel.text = userName;
    self.usernameLabel.text = userScreenname;
    self.descriptionLabel.text = userDescription;
    self.followersLabel.text = userFollowers;
    self.friendsLabel.text = userFriends;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
