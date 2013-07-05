//
//  DetailViewController.m
//  TraficoSV
//
//  Created by Nelson Chicas on 7/1/13.
//  Copyright (c) 2013 Jwebes de apps. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@property (nonatomic, strong) NSDictionary *tweet;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweet:(NSDictionary *)tweet
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        self.tweet = tweet;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Detalle";
    
    NSString *pictureUrl = (NSString *)[[self.tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
    [self.userImage setImageWithURL:[NSURL URLWithString:pictureUrl] placeholderImage:[UIImage imageNamed:pictureUrl]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormatter dateFromString:(NSString *)[self.tweet objectForKey:@"created_at"]];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    [timeFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.timeLabel.text = [timeFormatter stringFromDate:date];
    
    NSString *username = (NSString *)[[self.tweet objectForKey:@"user"] objectForKey:@"name"];
    self.userLabel.text = username;
    NSString *tweetText = (NSString *)[self.tweet objectForKey:@"text"];
    self.tweetLabel.text = tweetText;
    
    // Verificando si el tweet tiene un link 
    if( [[self.tweet objectForKey:@"entities"] objectForKey:@"media"] != nil ) {
        for( NSDictionary *media in [[self.tweet objectForKey:@"entities"] objectForKey:@"media"] ) {
            NSString *type = (NSString *)[media objectForKey:@"type"];
            if( [type isEqualToString:@"photo"] ) {
                self.webView.hidden = NO;
                self.nodataImage.hidden = YES;
                NSString *contentUrl = (NSString *)[media objectForKey:@"media_url"];
                [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:contentUrl]]];
                break;
            }
        }
    }
    
    // Verificando si el tweet tiene coordenadas 

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private methods


@end
