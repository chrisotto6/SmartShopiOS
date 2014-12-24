//
//  ItemCommunicator.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemCommunicatorDelegate;

@interface ItemCommunicator : NSObject
@property (weak, nonatomic) id<ItemCommunicatorDelegate> delegate;

- (void)searchItems:(NSString *)barcode;

@end
