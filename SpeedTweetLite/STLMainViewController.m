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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                            
                            NSString *userTimeString = [NSString stringWithFormat:@"%@?%@&%@", @"https://api.twitter.com/1.1/statuses/user_timeline.json", @"screen_name=fullsail", @"count=3"];
                            
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
                                            
                                            [tweetTableView reloadData];
                                            NSLog(@"This is the twitter feed: %@", [twitterFeed description]);
                                            //NSLog(@"This is the first tweet: %@", [[twitterFeed objectAtIndex:0] description]);
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


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
