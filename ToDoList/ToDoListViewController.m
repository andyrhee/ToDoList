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
    
    UITextField *tf = cell.todoItemTextField;
    tf.text = item;
    
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
    
    // first responder
    //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    NSLog(@"path: %@", path);
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    NSLog(@"cell: %@", cell);
    
    BOOL status = [cell becomeFirstResponder];
    
    NSLog(@"first responder status: %hhd", status);

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
        //[tableView reloadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveToDoList];

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
    int from = fromIndexPath.row;
    int to = toIndexPath.row;
    NSString *t1, *t2;
    
    if (from > to) { // moving up
        t1 = self.todoList[to];
        self.todoList[to] = self.todoList[from];
        self.todoList[from] = self.todoList[from - 1];
        
        for (int i = from-1; i > to + 1; i--) {
            self.todoList[i] = self.todoList[i-1];
        }
        
        self.todoList[to + 1] = t1;
    }
    else if (from < to) { // moving down
        t1 = self.todoList[to];
        self.todoList[to] = self.todoList[from];
        self.todoList[from] = self.todoList[from + 1];
        
        for (int i = from+1; i < to - 1; i++) {
            self.todoList[i] = self.todoList[i+1];
        }
        
        self.todoList[to - 1] = t1;
    }
        
        /*
         a = [1, 2, 3, 4, 5]
         from = 2, to = 4 expected a = [1, 2, 4, 5, 3]
         t1 = a[4] => 5
         a[4] = a[2] => [1, 2, 3, 4, 3]
         a[2] = a[2+1] => [1, 2, 4, 4, 3]
         
         i = 3; i < 4-1 ? : false
         
         a[3] = 5 => [1, 2, 4, 5, 3]
         
         */
        


    
    [tableView reloadData];
    
    [self saveToDoList];
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


