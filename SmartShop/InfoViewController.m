//
//  InfoViewController.m
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import "InfoViewController.h"
#import "DBManager.h"

@interface InfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfo;

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the dbManager object
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"smartShop.db"];
    
    // assign delegates
    self.attributesText.delegate = self;
    
    [self loadInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInfo {
    // Create the query
    NSString *query = [NSString stringWithFormat:@"select Name, Attributes from items where pk_ItemId=%d", self.itemIDToView];
    
    NSArray *results;
    
    // Load the results
    results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSLog(@"Name :%@", [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Name"]]);
    
    // Set the loaded data to the labels
    self.nameText.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Name"]];
    self.attributesText.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"Attributes"]];
}

@end
