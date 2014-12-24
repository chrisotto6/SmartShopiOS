//
//  ViewController.m
//  SmartShop
//
//  Created by Chris on 10/30/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

#import "ViewController.h"
#import "ItemViewController.h"
#import "DBManager.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrLists;

@property (nonatomic) int recordIDToView;

-(void)loadData;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tblList.delegate = self;
    self.tblList.dataSource = self;
    
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
    ItemViewController *itemViewController = [segue destinationViewController];
    itemViewController.delegate = self;
    itemViewController.recordIDToView =self.recordIDToView;
    
}

#pragma mark - Private method implementation

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from lists";
    
    // Get the results.
    if (self.arrLists != nil) {
        self.arrLists = nil;
    }
    self.arrLists= [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblList reloadData];
}

- (IBAction)addNewList:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add List" message:@"Enter new list name:" delegate:self cancelButtonTitle:@"Add" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"List name";
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *listName = [[alertView textFieldAtIndex:0] text];
    NSLog(@"ENTERED: %@",listName);

    //Prepare the query String
    NSString *query = [NSString stringWithFormat:@"insert into lists values (null, '%@')", listName];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    [self loadData];
}

#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrLists.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listNames" forIndexPath:indexPath];
    
    NSInteger indexOfListname = [self.dbManager.arrColumnNames indexOfObject:@"ListName"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrLists objectAtIndex:indexPath.row] objectAtIndex:indexOfListname]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToView = [[[self.arrLists objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueViewList" sender:self];
    NSLog(@"ID : %d",self.recordIDToView);
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrLists objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from lists where pk_ListId=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Delete from items
        query = [NSString stringWithFormat:@"delete from items where fk_ListID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}


@end
