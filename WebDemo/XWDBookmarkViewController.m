//
//  XWDAddBookmarkViewController.m
//  WebDemo
//
//  Created by Lammert Westerhoff on 15/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XWDBookmarkViewController.h"
#import "XWDAppDelegate.h"

@interface XWDBookmarkViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UITextField *imageField;

@end

@implementation XWDBookmarkViewController

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
    
    if (self.bookmark) {
        self.titleField.text = self.bookmark.title;
        self.urlField.text = self.bookmark.url;
        self.imageField.text = self.bookmark.imageUrl;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    if (!self.bookmark) {
        self.bookmark = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([XWDBookmark class]) inManagedObjectContext:MANAGED_OBJECT_CONTEXT];
    }
    
    self.bookmark.title = self.titleField.text;
    self.bookmark.url = self.urlField.text;
    self.bookmark.imageUrl = self.imageField.text;
    
    [MANAGED_OBJECT_CONTEXT save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.titleField) {
        [self.urlField becomeFirstResponder];
    } else if (textField == self.urlField) {
        [self.imageField becomeFirstResponder];
    } else {
        [self done:nil];
    }
    return YES;
}


@end
