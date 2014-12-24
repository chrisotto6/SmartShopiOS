//
//  ItemBuilder.m
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import "ItemBuilder.h"
#import "Item.h"

@implementation ItemBuilder

+(NSArray *)itemFromJSON:(NSData *)objectNotation error:(NSError *__autoreleasing *)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    for (NSDictionary *itemDic in results) {
        Item *item = [[Item alloc] init];
        
        for (NSString *key in itemDic) {
            if ([item respondsToSelector:NSSelectorFromString(key)]) {
                [item setValue:[itemDic valueForKey:key] forKey:key];
            }
        }
        
        [items addObject:item];
    }
    
    return items;
}



@end
