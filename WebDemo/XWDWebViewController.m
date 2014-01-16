//
//  XWDViewController.m
//  WebDemo
//
//  Created by Lammert Westerhoff on 15/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import "XWDWebViewController.h"
#import <Touchpose/QTouchposeApplication.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface XWDWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XWDWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    [self.webView loadRequest:request];
}

-(void)viewDidAppear:(BOOL)animated
{
    ((QTouchposeApplication*)[QTouchposeApplication sharedApplication]).showTouches = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    ((QTouchposeApplication*)[QTouchposeApplication sharedApplication]).showTouches = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.webView goBack];
}
- (IBAction)forward:(id)sender {
    [self.webView goForward];
}

#pragma mark - Web View Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

@end
