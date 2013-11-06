//
//  UserDetailsController.h
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

#import <UIKit/UIKit.h>
#import "User.h"
#import "Toast+UIView.h"
#import "Json.h"
#import "UserDetailsCell.h"
#import "Drink.h"
#import "CustomIOS7AlertView.h"

@interface UserDetailsController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableData *responseData;
    Json *json;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSMutableArray *drinks;

@property (weak, nonatomic) IBOutlet UITableView *drinkList;
@property (weak, nonatomic) IBOutlet UILabel *lbUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *lbCurrentBalance;
@property (weak, nonatomic) IBOutlet UIButton *btDefaultUser;

@property (weak, nonatomic) IBOutlet UIButton *plusFive;
@property (weak, nonatomic) IBOutlet UIButton *plusTen;
@property (weak, nonatomic) IBOutlet UIButton *plusTwenty;
@property (weak, nonatomic) IBOutlet UIButton *plusFifty;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editUser;

- (AppDelegate*) app;

- (void)setBalance:(double)amount;

- (IBAction)plusFive:(id)sender;
- (IBAction)plusTen:(id)sender;
- (IBAction)plusTwenty:(id)sender;
- (IBAction)plusFifty:(id)sender;
- (IBAction)editUser:(id)sender;



@end
