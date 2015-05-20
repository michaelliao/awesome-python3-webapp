//
//  MainViewController.m
//
//  Created by Michael Liao on 5/22/14.
//  Copyright (c) 2014 iTranswarp. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<NSURLConnectionDataDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong) NSString* html;

@end

@implementation MainViewController

- (void)initBlog:(APBlog*) blog
{
    [self setHTML:blog.content];
}

- (void)setHTML:(NSString*) html
{
    NSString* header = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"htmlHeader" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString* footer = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"htmlFooter" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString* s = [NSString stringWithFormat:@"%@%@%@", header, html, footer];
    NSLog(@"HTML: %@", s);
    self.html = html;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:request.URL.absoluteString]];
        return NO;
    }
    NSURL* url = request.URL;
    NSString* s = url.absoluteString;
    NSLog(@"absoluteString: %@", s);
    NSLog(@"shouldStartLoadWithRequest: %@ %@ %@", request.URL.host, request.URL.path, request.URL.pathExtension);
    NSLog(@"shouldStartLoadWithRequest: %@", request.URL.absoluteString);
    return YES;
}

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
    [self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"http://awesome.liaoxuefeng.com/"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
