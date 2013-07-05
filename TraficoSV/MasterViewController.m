//
//  MasterViewController.m
//  TraficoSV
//
//  Created by Nelson Chicas on 7/1/13.
//  Copyright (c) 2013 Jwebes de apps. All rights reserved.
//

#import "MasterViewController.h"
#import "TraficInfoCell.h"
#import "DetailViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "MBProgressHUD.h"

@interface MasterViewController ()

@property (nonatomic,strong) NSMutableArray *tweets;

- (void)loadTweets;

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tweets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"TraficoSV";
    [self loadTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private methods

- (void)loadTweets
{
    MBProgressHUD *waitHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if( error || !granted ) {
            [waitHUD hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TraficoSV"
                                                            message:@"No se pudo acceder a la cuenta de Twitter"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSArray *twAccountsArray = [accountStore accountsWithAccountType:accountType];
        ACAccount *account = [twAccountsArray objectAtIndex:0];
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
        NSString *query = @"#TraficoSV,#TráficoSV";
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                query, @"q",
                                @"recent", @"result_type",
                                @"25", @"count", nil];
        
        TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
        [request setAccount:account];
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if ( error ) {
                [waitHUD hide:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TraficoSV"
                                                                message:@"Error en la petición"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            NSArray *tweets = (NSArray *)[data objectForKey:@"statuses"];
            [self.tweets addObjectsFromArray:tweets];
            [self.tweetsTable reloadData];
            [waitHUD hide:YES];
        }];
    }];
}

#pragma mark Events

- (IBAction)reportTrafic:(id)sender
{
    if( [TWTweetComposeViewController canSendTweet] ) {
        TWTweetComposeViewController *composer = [[TWTweetComposeViewController alloc] init];
        [self presentModalViewController:composer animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TraficoSV"
                                                        message:@"No se puede mostrar el escritor de tweets"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TraficInfoCell *cell = (TraficInfoCell *)[self.tweetsTable dequeueReusableCellWithIdentifier:@"TraficInfoCell"];
    
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TraficInfoCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
    }
    
    NSDictionary *tweet = [self.tweets objectAtIndex:[indexPath row]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormatter dateFromString:(NSString *)[tweet objectForKey:@"created_at"]];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    cell.timeLabel.text = [timeFormatter stringFromDate:date];

    cell.userLabel.text = (NSString *)[[tweet objectForKey:@"user"] objectForKey:@"name"];
    cell.tweetLabel.text = (NSString *)[tweet objectForKey:@"text"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tweet = [self.tweets objectAtIndex:[indexPath row]];
    DetailViewController *detailView = [[DetailViewController alloc] initWithTweet:tweet];
    [self.navigationController pushViewController:detailView animated:YES];
}

@end
