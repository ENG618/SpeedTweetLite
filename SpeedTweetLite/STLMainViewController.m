//
//  STLMainViewController.m
//  SpeedTweetLite
//
//  Created by Eric Garcia on 2/6/14.
//  Copyright (c) 2014 Full Sail. All rights reserved.
//

#import "STLMainViewController.h"

@interface STLMainViewController ()

@end

@implementation STLMainViewController

//synthasize variables
@synthesize refreshControl,
            pic,
            tweetText,
            tweetDate,
            tweetedBy,
            username,
            userDescription,
            friends,
            followers;


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    self.refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(accessTwitter) forControlEvents:UIControlEventValueChanged];
    //self.refreshControl = refreshControl;
    
    [self accessTwitter];
    

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

-(void)accessTwitter
{
    //Show loading alertview
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
                        NSLog(@"The accounts on the simulator is/are: %@", accounts);
                        //Grab current account
                        ACAccount *currentAccount = [accounts objectAtIndex:0];
                        if (currentAccount != nil) {
                            //Obtaining user time line
                            //NSString *userTimeString  = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
                            
                            NSString *userTimeString = [NSString stringWithFormat:@"%@?%@", @"https://api.twitter.com/1.1/statuses/user_timeline.json", @"screen_name=garciaericn"];
                            
                            //Request data from Twitter
                            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:userTimeString ] parameters:nil];
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
                                            
                                            //[tweetTableView reloadData];
                                            
                                            [self dismissLoading];
                                        }
                                    }
                                }];
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

-(void)showLoading
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

-(void)dismissLoading
{
    //Dismiss allertView
    [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
    //Stop status bar indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [tweetTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button ations

- (IBAction)newTweet:(id)sender
{
    SLComposeViewController *composeVC = [ SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (composeVC != nil) {
        [composeVC setInitialText:@"Sent from STL"];
        //[composeVC addImage:[UIImage imageNamed:@"profilePic.png"]];
        
        [self presentViewController:composeVC animated:YES completion:nil];
        
    }
}
- (IBAction)refresh:(id)sender {
    [self accessTwitter];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (twitterFeed != nil) {
        return [twitterFeed count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell != nil) {
        
        // Configure the cell...
        //Obtain data from a single tweet
        NSDictionary *tweetDictionary = [twitterFeed objectAtIndex:indexPath.row];
        //NSLog(@"This is the tweetDictionary: %@", tweetDictionary);
        if (tweetDictionary != nil) {
            //Set text lable to tweet
            tweetText = [tweetDictionary valueForKey:@"text"];
            cell.textLabel.text = tweetText;
            //Set detailText to time of tweet
            tweetDate = [tweetDictionary valueForKey:@"created_at"];
            cell.detailTextLabel.text = tweetDate;
            
            //Obtain user data
            NSDictionary *userDictionary = [tweetDictionary objectForKey:@"user"];
            if (userDictionary != nil) {
                //Obtain profile image
                NSString *urlString = [userDictionary valueForKey:@"profile_image_url"];
                NSURL *urlImage = [NSURL URLWithString:urlString];
                NSData *imageData = [NSData dataWithContentsOfURL:urlImage];
                //Set icon image
                pic = [UIImage imageWithData:imageData];
                cell.imageView.image = pic;
                tweetedBy = [userDictionary valueForKey:@"name"];

            }
            
            //[cell refreshCell];
        }
        return cell;
    }
    return nil;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Obtain the path for the selected row
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    //Obtain data from a single tweet
    NSDictionary *tweetDictionary = [twitterFeed objectAtIndex:path.row];
    NSDictionary *userDictionary = [tweetDictionary objectForKey:@"user"];
    if ([segue.identifier isEqualToString:@"tweetDescription"]) {
        //Update variable with current selected tweet values
        tweetText = [tweetDictionary valueForKey:@"text"];
        tweetDate = [tweetDictionary valueForKey:@"created_at"];
        tweetedBy = [userDictionary valueForKey:@"name"];
        // Get the new view controller using [segue destinationViewController].
        STLTweetDetailViewController *tdvc = [segue destinationViewController];
        //Pass objects
        tdvc.t = tweetText;
        tdvc.tTime = tweetDate;
        tdvc.tBy = tweetedBy;
        
        
    }else if ([segue.identifier isEqualToString:@"profile"]){
        //Update variables
        tweetedBy = [userDictionary valueForKey:@"name"];
        username = [userDictionary valueForKey:@"screen_name"];
        userDescription = [userDictionary valueForKey:@"description"];
        followers = [userDictionary valueForKey:@"followers_count"];
        friends = [userDictionary valueForKey:@"friends_count"];
        // Get the new view controller using [segue destinationViewController].
        STLProfileViewController *pvc = [segue destinationViewController];
        NSString *followersString = [followers stringValue];
        NSString *friendsString = [friends stringValue];
        //Pass objects
        pvc.userName = tweetedBy;
        pvc.userScreenname = username;
        pvc.userDescription = userDescription;
        pvc.userFollowers = followersString;//followersString;
        pvc.userFriends = friendsString;//friendsString;
        
    }
    
    
    
}

@end
