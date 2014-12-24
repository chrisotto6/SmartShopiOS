//
//  ItemCommunicator.m
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import "ItemCommunicatorDelegate.h"
#import "ItemCommunicator.h"

#define API_KEY @"9b322eaada88d663930626c7feda769b"

@implementation ItemCommunicator

-(void)searchItems:(NSString *)barcode {
    NSString *urlAsString = [NSString stringWithFormat:@"http://www.outpan.com/api/get-product.php?apikey=%@&barcode=%@",API_KEY, barcode];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingItemFailedWithError:error];
        }
        else {
            [self.delegate receivedItemJSON:data];
        }
    }];
}

@end
