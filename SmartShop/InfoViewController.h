//
//  InfoViewController.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoViewControllerDelegate

@end

@interface InfoViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) id<InfoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameText;

@property (weak, nonatomic) IBOutlet UITextView *attributesText;

@property (nonatomic) int itemIDToView;

@end
