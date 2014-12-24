//
//  ItemManager.m
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import "ItemManager.h"
#import "ItemBuilder.h"
#import "ItemCommunicator.h"

@implementation ItemManager

-(void)fetchItems:(NSString *)barcode {
    [self.communicator searchItems:barcode];
}

-(void)receivedItemsJSON:(NSData *)objectNotation {
    NSError *error = nil;
    NSArray *items = [ItemBuilder itemFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingItemsFailedWithError:error];
    }
    else {
        [self.delegate didReceiveItems:items];
    }
}

-(void)fetchingItemsFailedWithError:(NSError *)error {
    [self.delegate fetchingItemsFailedWithError:error];
}
@end
