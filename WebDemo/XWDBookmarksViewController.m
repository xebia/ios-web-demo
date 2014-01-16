//
//  XWDBookmarksViewController.m
//  WebDemo
//
//  Created by Lammert Westerhoff on 15/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XWDBookmarksViewController.h"
#import "XWDAppDelegate.h"
#import "XWDBookmarkCell.h"
#import "XWDBookmark.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "XWDWebViewController.h"
#import "XWDBookmarkViewController.h"

@interface XWDBookmarksViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation XWDBookmarksViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([XWDBookmark class])];
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:MANAGED_OBJECT_CONTEXT
                                              sectionNameKeyPath:nil
                                              cacheName:@"bookmark"];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    [self.tableView reloadData];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWDBookmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XWDBookmarkCell" forIndexPath:indexPath];
    XWDBookmark *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.bookmarkTitleLabel.text = bookmark.title;
    if (bookmark.imageUrl.length > 0) {
        [cell.bookmarkImageView setImageWithURL:[NSURL URLWithString:bookmark.imageUrl]];
    } else {
        NSString *favicon = [NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@", bookmark.url];
        [cell.bookmarkImageView setImageWithURL:[NSURL URLWithString:favicon]];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        XWDBookmark *bookmark = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [MANAGED_OBJECT_CONTEXT deleteObject:bookmark];
        [MANAGED_OBJECT_CONTEXT save:nil];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OpenWeb"]) {
        XWDWebViewController *webViewController = segue.destinationViewController;
        XWDBookmark *bookmark = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        webViewController.url = [NSURL URLWithString:bookmark.url];
        webViewController.title = bookmark.title;
    } else if ([segue.identifier isEqualToString:@"EditBookmark"]) {
        XWDBookmarkViewController *bookmarkViewController = segue.destinationViewController;
        XWDBookmarkCell *cell = sender;
        XWDBookmark *bookmark = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
        bookmarkViewController.bookmark = bookmark;
    }
}

@end
