//
//  ItemManager.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemManagerDelegate.h"

@class ItemCommunicator;

@interface ItemManager : NSObject<ItemManagerDelegate>

@property (strong, nonatomic) ItemCommunicator *communicator;

@property (weak, nonatomic) id<ItemManagerDelegate> delegate;

-(void)fetchItems:(NSString *)barcode;

@end
