//
//  UserListController.h
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
#import "UserListCell.h"
#import "UserDetailsController.h"
#import "User.h"
#import "CustomIOS7AlertView.h"

@interface UserListController : UITableViewController <UINavigationControllerDelegate, CustomIOS7AlertViewDelegate> { // Fehlt hier ein Connection-Delegate?
    NSMutableData *responseData;
}

@property (nonatomic, retain) NSMutableArray *users;
@property (strong, nonatomic) IBOutlet UITableView *userList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createUser;

- (IBAction)createUser:(id)sender;

- (AppDelegate*) app;

@end
