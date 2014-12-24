//
//  ItemViewController.m
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import "ItemViewController.h"
#import "DBManager.h"
#import "InfoViewController.h"
#import "CaptureViewController.h"


@interface ItemViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrItem;

@property (nonatomic) int itemIDToView;


-(void)loadData;

@end

@implementation ItemViewController

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
    
    self.tblItems.delegate = self;
    self.tblItems.dataSource = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"smartShop.db"];
    
    // Load the Data
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"idSegueViewItem"]) {
        InfoViewController *infoViewController = [segue destinationViewController];
        infoViewController.itemIDToView = self.itemIDToView;
    } else if ([segue.identifier isEqualToString:@"segueCapture"]) {
        CaptureViewController *captureViewController = [segue destinationViewController];
        captureViewController.recordIDToView = self.recordIDToView;
    }
}



-(void)loadData{
    NSLog(@"The previous record is %d", self.recordIDToView);
    
    // Form the query.
    NSString *query = [NSString stringWithFormat:@"select * from items where fk_ListID = %d", self.recordIDToView];
    
    // Get the results.
    if (self.arrItem != nil) {
        self.arrItem = nil;
    }
    self.arrItem= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblItems reloadData];
}

#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrItem.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemNames" forIndexPath:indexPath];
    
    NSInteger indexOfItemname = [self.dbManager.arrColumnNames indexOfObject:@"Name"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrItem objectAtIndex:indexPath.row] objectAtIndex:indexOfItemname]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.itemIDToView = [[[self.arrItem objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueViewItem" sender:self];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrItem objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from items where pk_ItemId=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}

- (IBAction)addNewItem:(id)sender {
    [self performSegueWithIdentifier:@"segueCapture" sender:self];
}
@end
