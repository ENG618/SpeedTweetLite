//
//  FiriendDetailsViewController.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "FiriendDetailsViewController.h"

@interface FiriendDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImg;

@end

@implementation FiriendDetailsViewController
@synthesize name, pic;

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
    //set labels
    self.nameLabel.text = name;
    self.profileImg.image = pic;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
