//
//  ItemViewController.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemViewControllerDelegate

@end

@interface ItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<ItemViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemAdd;

- (IBAction)itemAddNew:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblItems;

@property (nonatomic) int recordIDToView;

@end
