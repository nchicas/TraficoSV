//
//  MasterViewController.h
//  TraficoSV
//
//  Created by Nelson Chicas on 7/1/13.
//  Copyright (c) 2013 Jwebes de apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController<UITableViewDataSource,
                                                   UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tweetsTable;

- (IBAction)reportTrafic:(id)sender;

@end
