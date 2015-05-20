//
//  MenuViewController.m
//
//  Created by Michael Liao on 5/22/14.
//  Copyright (c) 2014 iTranswarp. All rights reserved.
//

#import "MenuViewController.h"
#import "MainViewController.h"
#import "APBlog.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate>

@property (strong) NSArray* blogs;

@property (strong, nonatomic) NSURLConnection* networkConnection;

@property (strong, nonatomic) NSMutableData* networkData;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController

- (void)cleanupNetworkConnection
{
    self.networkData = nil;
    self.networkConnection = nil;
}

- (void)requestMenuFromNetwork
{
    [self showNetworkError:NO showIndicator:NO];
    NSURL* theURL = [NSURL URLWithString:@"http://awesome.liaoxuefeng.com/api/blogs?format=html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:theURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn) {
        self.networkConnection = conn;
        [self showNetworkError:NO showIndicator:YES];
    }
    else {
        [self connection:nil didFailWithError:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"FAILED:didFailWithError");
    if (self.networkConnection!=connection) {
        return;
    }
    [self cleanupNetworkConnection];
    [self showNetworkError:YES showIndicator:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.networkConnection!=connection) {
        return;
    }
    self.networkData = [NSMutableData dataWithCapacity:1024];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.networkConnection!=connection) {
        return;
    }
    [self.networkData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.networkConnection!=connection) {
        return;
    }
    NSLog(@"connectionDidFinishLoading");
    NSUInteger len = [self.networkData length];
    if (len==0) {
        [self connection:connection didFailWithError:nil];
        return;
    }
    // try parse json:
    NSError* err = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:self.networkData options:0 error:&err];
    if (err!=nil) {
        [self connection:connection didFailWithError:err];
        return;
    }
    // save:
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:32];
    NSArray* blogs = json[@"blogs"];
    for (NSDictionary* c in blogs) {
        [array addObject:[APBlog blogWithDictionary:c]];
    }
    self.blogs = array;
    [self cleanupNetworkConnection];
    [self showNetworkError:NO showIndicator:NO];
    [self.tableView reloadData];
}

- (void)showNetworkError:(BOOL)showError showIndicator:(BOOL)showIndicator
{
    NSLog(@"showNetworkError: %d, showIndicator: %d", showError, showIndicator);
    if (showIndicator) {
        [self.indicator startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else {
        [self.indicator stopAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APBlog* selected = [self.blogs objectAtIndex:indexPath.row];
    MainViewController* mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"blogVC"];
    mainVC.title = selected.name;
    [mainVC initBlog:selected];
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.blogs==nil) {
        return 0;
    }
    return [self.blogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    APBlog* blog = [self.blogs objectAtIndex:row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    // Configure the cell:
    cell.textLabel.text = blog.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
    // Do any additional setup after loading the view.
    [self requestMenuFromNetwork];
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
