//
//  DetailViewController.h
//  TraficoSV
//
//  Created by Nelson Chicas on 7/1/13.
//  Copyright (c) 2013 Jwebes de apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *tweetLabel;
@property (nonatomic, strong) IBOutlet UIImageView *nodataImage;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

- (id)initWithTweet:(NSDictionary *)tweet;

@end
