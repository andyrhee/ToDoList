//
//  ToDoListViewController.m
//  ToDoList
//
//  Created by Andy Rhee on 1/18/14.
//  Copyright (c) 2014 andyrhee. All rights reserved.
//

#import "ToDoListViewController.h"
#import "EditableCell.h"
#import "Item.h"

@interface ToDoListViewController ()

@property (nonatomic, strong) NSMutableArray *todoList;

@property (nonatomic, strong) UIBarButtonItem *addButtonItem;

@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;
- (IBAction)editEnd:(id)sender;
- (void)saveToDoList;

@end

@implementation ToDoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //self.todoList = [[NSMutableArray alloc] init];
        self.todoList = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"todoList"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    
    //self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.todoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";

    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *item = [self.todoList objectAtIndex:indexPath.row];
    
    NSLog(@"item %@ at row %d", item, indexPath.row);
    
    cell.todoItemTextField.text = item;

    //objc_setAssociated
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int sectionIndex = indexPath.section;
    int rowIndex = indexPath.row;
    NSLog(@"rowIndex: %d", rowIndex);
    
    EditableCell *cell = (EditableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.todoList[rowIndex] = cell.todoItemTextField.text;
    [self.tableView reloadData];

}


- (void)add:(id)sender
{
    NSLog(@"Add: %@", sender);
    
    [self.todoList insertObject:@"" atIndex:0];

    NSLog(@"todoList.count: %d", self.todoList.count);

    [self.tableView reloadData];

    // set first respondent to text field in the selected cell

    [self saveToDoList];

}

- (void)saveToDoList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.todoList forKey:@"todoList"];

    [defaults synchronize];
}

- (IBAction)editEnd:(id)sender {
    NSLog(@"editEnd");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"textField: %@", textField);
    
    [textField resignFirstResponder];
    
    NSLog(@"self.tableView: %@", self.tableView);
    
    return NO;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.todoList removeObjectAtIndex:indexPath.row];
        [self saveToDoList];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        NSString *str = @"inserted string";
//        [self.todoList insertObject:str atIndex:0];
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

/*
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath: %@", indexPath);
    
    // Navigation logic may go here, for example:
    // Create the next view controller.
    // *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
}
*/


@end


