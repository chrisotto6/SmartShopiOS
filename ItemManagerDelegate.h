//
//  ItemManagerDelegate.h
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ItemManagerDelegate

-(void)didReceiveItems:(NSArray *)items;

-(void)fetchingItemsFailedWithError:(NSError *)error;

@end
