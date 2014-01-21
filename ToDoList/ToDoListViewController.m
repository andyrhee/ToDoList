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
#import <objc/runtime.h>

@interface ToDoListViewController ()

@property (nonatomic, strong) NSMutableArray *todoList;

@property (nonatomic, strong) UIBarButtonItem *addButtonItem;

@property BOOL isNavBarEditing;

- (IBAction)editEnd:(id)sender;
- (void)saveToDoList;

@end

@implementation ToDoListViewController

static char indexPathKey;

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
    
    self.addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTodoItem:)];
    
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
    
    cell.todoItemTextField.delegate = self;  // self is the ToDoListViewController
    
    objc_setAssociatedObject(cell.todoItemTextField, &indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
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
    
    [self saveToDoList];

}


- (void)addTodoItem:(id)sender
{
    NSLog(@"Add: %@", sender);
    
    [self.todoList insertObject:@"" atIndex:0];

    NSLog(@"todoList.count: %d", self.todoList.count);

    [self.tableView reloadData];
    
    // first responder
    EditableCell *cell = (EditableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    
//    NSLog(@"path: %@", path);
//    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
//    
//    NSLog(@"cell: %@", cell);
    
    BOOL status = [cell.todoItemTextField becomeFirstResponder];
    
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
    
//    NSArray *paths = [self.tableView indexPathsForVisibleRows];
//    
//    NSLog(@"path: %@", paths);
//    
//    for (int i = 0; i < paths.count; i++) {
//        NSIndexPath *path = paths[i];
//        
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
//        
//        NSLog(@"cell: %@", cell);
//        
//        if (cell.textLabel.text == nil) {
//            self.todoList[path.row] = @"";
//        }
//        else {
//            self.todoList[path.row] = cell.textLabel.text;
//        }
//    }
    
    [self saveToDoList];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    //NSLog(@"textField: %@", textField);
//    
//    [textField resignFirstResponder];
//    
//    //NSLog(@"self.tableView: %@", self.tableView);
//    
//    return NO;
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // About to edit some field.  Make sure there is a done button instead of an add button
    if (!self.isNavBarEditing) {
        [self toggleRightNavButton];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self updateToDoItem:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateToDoItem:textField];
    return YES;
}

// Update the data model after an edit has taken place
- (void)updateToDoItem:(UITextField *)textField {
    NSIndexPath *indexPath = objc_getAssociatedObject(textField, &indexPathKey);
    
    [self.todoList replaceObjectAtIndex:indexPath.row withObject:textField.text];
    
    [self saveToDoList];
    
    // update the table view
    [self.tableView reloadData];
}

- (void)toggleRightNavButton {
    UIBarButtonItem *theButton;
    self.isNavBarEditing = !(self.isNavBarEditing);
    if (self.isNavBarEditing) {
        theButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                  target:self
                                                                  action:@selector(doneEditing:)];
        // Dont allow the user to delete or reorder rows while editing
        self.navigationItem.leftBarButtonItem.enabled = NO;
        
    } else {
        theButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                  target:self
                                                                  action:@selector(addTodoItem:)];
        // Allow the user to delete or reorder rows while not editing
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
    }
    self.navigationItem.rightBarButtonItem = theButton;
}

- (void)doneEditing:(id)sender {
    [self toggleRightNavButton];
    
    // fire a should end editing call
    [self.tableView endEditing:YES];
}

// When the user enters Edit mode (to delete or reoder the list) then disable the add button
// and vice verse if they exit Edit mode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //NSLog(@"indexPath in canEditRowAtIndexPath: %@", indexPath);
    
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
    NSString *t1;
    
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


