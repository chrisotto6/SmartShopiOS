//
//  ViewController.h
//  SmartShop
//
//  Created by Chris on 10/30/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//Global Variables
extern NSString *listName;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addList;
- (IBAction)addNewList:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@property (weak, nonatomic) IBOutlet UITableView *tblList;

@end
