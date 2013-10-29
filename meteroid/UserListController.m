//
//  UserListController.m
//  meteroid
//
//  Copyright (C) 2013  Gerrit Giehl <r4mp@chaosdorf.de>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UserListController.h"

@interface UserListController ()

@end

@implementation UserListController

@synthesize users;
@synthesize userList;

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    // custom refresh logic would be placed here...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [self reloadTableView:nil];
    
    [refresh endRefreshing];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadUsers];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.users = [[NSMutableArray alloc] init];
    [userList setDelegate:self];
    [userList setDataSource:self];
    
    [self loadUsers];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultUser = [standardUserDefaults stringForKey:@"defaultUser"];
    BOOL singleUserMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_single_user_mode_preference"];
    
    if((defaultUser != nil) && (singleUserMode == TRUE)) {
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                      bundle:nil];
        UserDetailsController *userDetails = [sb instantiateViewControllerWithIdentifier:@"UserDetails"];
        User *user = [[User alloc] init];
        userDetails.user = [user getUserData:defaultUser];
        
        if(userDetails.user.name == nil) {
            [self.view makeToast:@"an error occured!"
                        duration:1.0
                        position:@"center"];
            
            return;
        } else {
            [self.navigationController pushViewController:userDetails animated:YES];
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reloadTableView:(id)sender;
{
    [self loadUsers];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [users count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"UserListCell" owner:self options:nil];
        
        for (id currentObjects in objects) {
            if ([currentObjects isKindOfClass:[UITableViewCell class]]) {
                cell = (UserListCell *)currentObjects;
                break;
            }
        }

    }
    
    User *user = [users objectAtIndex:indexPath.row];
    
    [cell setCellDetails:user];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                  bundle:nil];
    UserDetailsController *userDetails = [sb instantiateViewControllerWithIdentifier:@"UserDetails"];

    userDetails.user = [users objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:userDetails animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [tmpimg removeFromSuperview];
    
    [self.view makeToast:@"connection failed"
                duration:1.0
                position:@"center"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error = nil;
    users = [[NSMutableArray alloc] init];
    
    // DEBUG
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    
    NSArray* arrResult = [[NSJSONSerialization JSONObjectWithData: responseData options:kNilOptions error:&error] mutableCopy];
    
    for(NSDictionary *dic in arrResult) {
        User *user = [[User alloc] init];
        user.name = [dic objectForKey:@"name"];
        user.email = [dic objectForKey:@"email"];
        user.balance = [[dic objectForKey:@"balance"] doubleValue];
        user.uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        
        [users addObject:user];
    }
    
    [self.tableView reloadData];
}

- (void)loadUsers
{
    responseData = [[NSMutableData alloc] init];
    
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame=CGRectMake(145, 160, 25, 25);
    av.tag  = 1;
    [self.view addSubview:av];
    [av startAnimating];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *hostname = [standardUserDefaults stringForKey:@"hostname_preference"];
    BOOL useSsl = [standardUserDefaults boolForKey:@"use_ssl_preference"];
    int port = [standardUserDefaults integerForKey:@"port_preference"];
    
    NSMutableString *msUrl = [[NSMutableString alloc] init];
    
    if(useSsl == TRUE) {
        [msUrl appendString: @"https://"];
    } else {
        [msUrl appendString: @"http://"];
    }
    [msUrl appendFormat: @"%@", hostname];
    [msUrl appendFormat: @":%d", port];
    [msUrl appendString: @"/users.json"];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:msUrl]];  //asynchronous call
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [tmpimg removeFromSuperview];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
