//
//  FriendsViewController.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    
    [self accessTwitter];

}

- (void)accessTwitter
{
    //Initializing account access
    ACAccountStore *store = [[ACAccountStore alloc] init];
    if (store != nil) {
        //Selecting the type of account we want to explore (ex: Twitter, Facebook, ...)
        ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        if (type != nil) {
            //Requesting access to account
            [store requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error){
                //If we are granted access by the user this block will exicuted
                if (granted) {
                    //Grab all the associated accounts (twitter accounts)
                    NSArray *accounts = [store accountsWithAccountType:type];
                    if (accounts != nil) {
                        NSLog(@"The accounts on the simulator is/are: %@", accounts);
                        //Grab current account
                        ACAccount *currentAccount = [accounts objectAtIndex:0];
                        if (currentAccount != nil) {
                            //Obtaining user time line
                            //NSString *userTimeString  = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
                            
                            NSString *friendString = @"https://api.twitter.com/1.1/friends/list.json?cursor=-1&skip_status=true&include_user_entities=false";
                            
                            //Request data from Twitter
                            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:friendString ] parameters:nil];
                            if (request != nil) {
                                //1.1 api requires a user to be logged in
                                [request setAccount:currentAccount];
                                
                                //response handler block
                                //                                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                                //                                    NSInteger responsCode = [urlResponse statusCode];
                                //                                    if (responsCode == 200) {
                                //                                        //Twitts in users feed
                                //                                        twitterFeed = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                                //                                        if (twitterFeed != nil) {
                                //
                                //                                            //[tweetTableView reloadData];
                                //
                                //                                            [self dismissLoading];
                                //                                        }
                                //                                    }
                                //                                }];
                            }
                        }
                    }
                }else{ //If user denys access this block will be exicuted
                    NSLog(@"User denied access to accounts :(");
                }
            }];
        }
    }
}

- (void)showLoading
{
    //Activity indicator in status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //Loading alert view
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..."
                                              message:@"Please wait while we gather your tweets."
                                             delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:nil, nil];
    //Activity indicator in status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [loadingAlert show];
}

- (void)dismissLoading
{
    //Dismiss allertView
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    //Stop status bar indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
    if (cell != nil) {
        
    }
    
    
    return cell;
}

@end
