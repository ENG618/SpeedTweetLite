//
//  FriendsViewController.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/13/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;


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
    //Show loading dialog
    [self showLoading];
    
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
                        //NSLog(@"The accounts on the simulator is/are: %@", accounts);
                        //Grab current account
                        ACAccount *currentAccount = [accounts objectAtIndex:0];
                        if (currentAccount != nil) {
                            NSString *friendString = @"https://api.twitter.com/1.1/friends/list.json?cursor=-1&skip_status=true&include_user_entities=false";
                            
                            //Request data from Twitter
                            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:friendString] parameters:nil];
                            if (request != nil) {
                                //1.1 api requires a user to be logged in
                                [request setAccount:currentAccount];
                                
                                //response handler block
                                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                                    NSInteger responsCode = [urlResponse statusCode];
                                    if (responsCode == 200) {
                                        //Twitts in users feed
                                        twitterFeed = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                                        if (twitterFeed != nil) {
                                            NSLog(@"This is the current feed: %@", twitterFeed);
                                            NSLog(@"twitterFeed has %d objects in it", [twitterFeed count]);
                                            //Access users in dictionary
                                            tempArray = [twitterFeed objectForKey:@"users"];
                                            //Create friends array
                                            friendsList = [[NSMutableArray alloc] init];
                                            
                                            for (int i=0; i<[tempArray count]; i++) {
                                                //Obtain username
                                                NSString *username = [[tempArray objectAtIndex:i]objectForKey:@"screen_name"];
                                                //Obtain user pic
                                                NSString *picURL = [[tempArray objectAtIndex:i]objectForKey:@"profile_image_url"];
                                                NSString *largeImgURL = [picURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                                NSURL *urlImage = [NSURL URLWithString:largeImgURL];
                                                NSData *imageData = [NSData dataWithContentsOfURL:urlImage];
                                                
                                                //NSLog(@"username: %@", username);
                                                
                                                Friend *aFriend = [[Friend alloc] initWithData:username profileImg:[UIImage imageWithData:imageData]];
                                                [friendsList addObject:aFriend];
                                                
                                            }
                                            
                                            //Roload Collection View with updated objects
                                            [self.friendsCollectionView reloadData];
                                            
                                            //Dismiss loding dialog
                                            [self dismissLoading];
                                        }
                                    }
                                }];
                            }else{
                                //Create allert if there is no connection availible
                                UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                                                       message:@"There seems to be no data connection.  Please check to make sure you are connected to the internet."
                                                                                      delegate:nil
                                                                             cancelButtonTitle:nil
                                                                             otherButtonTitles:@"Okay", nil];
                                //Show alert
                                [noConnection show];
                            }
                        }
                    }
                }else{
                    //User denied access to twitter...Alert user
                    //Create alert
                    UIAlertView *accessDenied = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                           message:@"You have denied access to Twitter and this app will not function.  Please visit the system settings to enagle access"
                                                                          delegate:nil
                                                                 cancelButtonTitle:nil
                                                                 otherButtonTitles:@"Okay", nil];
                    //Show allert
                    [accessDenied show];
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
                                              message:@"Please wait while we find your firends"
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
    if (friendsList != nil) {
        return [friendsList count];
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Configure Cell
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"friendCell" forIndexPath:indexPath];
    if (cell != nil) {
        if (friendsList != nil) {
            Friend *current = [friendsList objectAtIndex:indexPath.row];
            [cell resetWithLable:[current friendName] cellImage:[current profilePic]];
        }
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    dvc = [segue destinationViewController];
    NSArray *indexPaths = [self.friendsCollectionView indexPathsForSelectedItems];
    NSIndexPath *index = [indexPaths objectAtIndex:0];
    
    Friend *current = [friendsList objectAtIndex:index.row];
    NSLog(@"Friend name: %@", current.friendName);
    dvc.name = current.friendName;
    dvc.pic = current.profilePic;

    
}

@end
