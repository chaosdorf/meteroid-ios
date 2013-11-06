//
//  UserDetailsController.m
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

#import "UserDetailsController.h"

@interface UserDetailsController ()

@end

@implementation UserDetailsController

@synthesize lbUsername;
@synthesize user;
@synthesize imageUser;
@synthesize lbCurrentBalance;
@synthesize btDefaultUser;
@synthesize drinkList;
@synthesize drinks;

@synthesize plusFive;
@synthesize plusTen;
@synthesize plusTwenty;
@synthesize plusFifty;

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reloadTableView:(id)sender;
{
    [self loadDrinks];
    [self.drinkList reloadData];
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


- (void)viewDidAppear:(BOOL)animated
{
    btDefaultUser.hidden = FALSE;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sDefaultUser = [standardUserDefaults stringForKey:@"defaultUser"];
    BOOL singleUserMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_single_user_mode_preference"];
    
    if(([sDefaultUser isEqualToString:user.uid]) || (singleUserMode == FALSE)) {
        btDefaultUser.hidden = TRUE;
    } else {
        btDefaultUser.hidden = FALSE;
    }
    
    [self loadDrinks];
    [self.drinkList reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.drinks = [[NSMutableArray alloc] init];
    [drinkList setDelegate:self];
    [drinkList setDataSource:self];
    [self loadDrinks];

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];

    [self.drinkList addSubview:refresh];
    
    btDefaultUser.hidden = FALSE;
    lbUsername.text = user.name;
    lbCurrentBalance.text = [NSString stringWithFormat:@"%.2lf€", user.balance];
    
    if (user.imageData) {
        UIImage *image = [UIImage imageWithData:user.imageData];
        imageUser.image = image;
    } else {
        UIImage *image = [UIImage imageWithData:[user loadImageData:user.email]];
        imageUser.image = image;
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sDefaultUser = [standardUserDefaults stringForKey:@"defaultUser"];
    BOOL singleUserMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_single_user_mode_preference"];
    
    if(([sDefaultUser isEqualToString:user.uid]) || (singleUserMode == FALSE)) {
        btDefaultUser.hidden = TRUE;
    } else {
        btDefaultUser.hidden = FALSE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBalance:(double)amount
{
    NSMutableString *methodname = [[NSMutableString alloc] init];
    [methodname appendString: @"users/"];
    [methodname appendFormat: @"%@", user.uid];
    [methodname appendString: @"/deposit?amount="];
    [methodname appendString: [NSString stringWithFormat:@"%.2lf", amount]];
    
    json = [[Json alloc] init];
    [json jsonPostRequest:nil methodename:methodname hostname:self.app.hostname port:self.app.port useSsl:self.app.ssl];
    
    [self.view makeToast:[NSString stringWithFormat:@"           %.2lf€           ", amount]
                duration:1.0
                position:@"center"];
}

- (IBAction)plusFive:(id)sender {
    [self.view setUserInteractionEnabled:NO];
    //[plusFive setEnabled:NO];
    [self setBalance:5.0];
    user = [user getUserData:user.uid];
    lbCurrentBalance.text = [NSString stringWithFormat:@"%.2lf€",user.balance];
    //[plusFive setEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)plusTen:(id)sender {
    [self.view setUserInteractionEnabled:NO];
    //[plusTen setEnabled:NO];
    [self setBalance:10.0];
    user = [user getUserData:user.uid];
    lbCurrentBalance.text = [NSString stringWithFormat:@"%.2lf€",user.balance];
    //[plusTen setEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)plusTwenty:(id)sender {
    [self.view setUserInteractionEnabled:NO];
    //[plusTwenty setEnabled:NO];
    [self setBalance:20.0];
    user = [user getUserData:user.uid];
    lbCurrentBalance.text = [NSString stringWithFormat:@"%.2lf€",user.balance];
    //[plusTwenty setEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)plusFifty:(id)sender {
    [self.view setUserInteractionEnabled:NO];
    //[plusFifty setEnabled:NO];
    [self setBalance:50.0];
    user = [user getUserData:user.uid];
    lbCurrentBalance.text = [NSString stringWithFormat:@"%.2lf€",user.balance];
    //[plusFifty setEnabled:YES];
    [self.view setUserInteractionEnabled:YES];
}

- (IBAction)editUser:(id)sender {
    
    CustomIOS7AlertView *editUserDialog = [[CustomIOS7AlertView alloc] init];
    [editUserDialog setButtonTitles:[NSMutableArray arrayWithObjects:@"Cancel", @"Edit", nil, nil]];
    [editUserDialog setUseMotionEffects:TRUE];
    UIView *editUserView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil] lastObject];
    [editUserDialog setContainerView:editUserView];
    [editUserDialog show];
    
    //[self loadUsers];
    //[self.tableView reloadData];
}

- (IBAction)setDefaultUser:(id)sender {
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:user.uid forKey:@"defaultUser"];
    [standardUserDefaults synchronize];
    
    [self.view makeToast: @"default user set!"
                duration:1.0
                position:@"center"
                   title:[NSString stringWithFormat:@"User ID %@", user.uid]];
    
    btDefaultUser.hidden = TRUE;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [drinks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UserDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"UserDetailsCell" owner:self options:nil];
        
        for (id currentObjects in objects) {
            if ([currentObjects isKindOfClass:[UITableViewCell class]]) {
                cell = (UserDetailsCell *)currentObjects;
                break;
            }
        }
    }
    
    Drink *drink = [drinks objectAtIndex:indexPath.row];
    [cell setCellDetails:drink];
    
    // Configure the cell...
    
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view setUserInteractionEnabled:NO];
    Drink *drink = [drinks objectAtIndex:indexPath.row];
    [self setBalance:-drink.price];
    user = [user getUserData:user.uid];
    lbCurrentBalance.text = [NSString stringWithFormat:@"%.2lf€",user.balance];
    [self.drinkList deselectRowAtIndexPath:indexPath animated:YES];
    [self.view setUserInteractionEnabled:YES];
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
    drinks = [[NSMutableArray alloc] init];
    
    // DEBUG
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);
    
    NSArray* arrResult = [[NSJSONSerialization JSONObjectWithData: responseData options:kNilOptions error:&error] mutableCopy];
    
    for(NSDictionary *dic in arrResult) {
        
        // TODO: catch missing 'keys'
        
        Drink *drink = [[Drink alloc] init];
        drink.name = [dic objectForKey:@"name"];
        drink.bottleSize = [dic objectForKey:@"bottle_size"];;
        drink.caffeine = [dic objectForKey:@"caffeine"];
        drink.logoUrl = [dic objectForKey:@"logoUrl"];
        drink.createdAt = [dic objectForKey:@"created_at"];
        drink.price = [[dic objectForKey:@"price"] doubleValue];
        
        [self.drinks addObject:drink];
    }
    
    [self.drinkList reloadData];
}

- (void)loadDrinks
{
    responseData = [[NSMutableData alloc] init];
    
    NSMutableString *msUrl = [[NSMutableString alloc] init];
    [msUrl appendFormat: @"%@", self.app.getUri];
    [msUrl appendString: @"/drinks.json"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:msUrl]];  //asynchronous call
    
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
    [tmpimg removeFromSuperview];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
