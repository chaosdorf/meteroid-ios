//
//  User.m
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

#import "User.h"

@implementation User

@synthesize uid;
@synthesize name;
@synthesize email;
@synthesize balance;
@synthesize createdAt;
@synthesize imageData;

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(NSData *)loadImageData:(NSString *)tmpEmail {
    if((tmpEmail.length != 0) && (self.app.connectedToNetwork == TRUE)) {
        gravatarLoader = [[GravatarLoader alloc] initWithTarget:self andHandle:nil/*@selector(setGravatarImage:)*/];
        NSURL* url = [gravatarLoader loadEmail:tmpEmail withSize:50];
        return [NSData dataWithContentsOfURL:url];
    } else {
        return UIImagePNGRepresentation([UIImage imageNamed: @"stub.png"]);
    }
}

-(User*)getUserData:(NSString *)tmpUid
{
    NSError *error = nil;
    
    User *user = [[User alloc] init];
    [user setUid:tmpUid];
    
    NSMutableString *methodname = [[NSMutableString alloc] init];
    [methodname appendString: @"users/"];
    [methodname appendFormat: @"%@", user.uid];
    [methodname appendString: @".json"];
    
    json = [[Json alloc] init];
    NSData* dataResult = [json jsonPostRequest:nil methodename:methodname hostname:self.app.hostname port:self.app.port useSsl:self.app.ssl];
    

    if(dataResult == nil) {
        return user;

//        // TODO:
//        [self.view makeToast:@"connection failed"
//                    duration:1.0
//                    position:@"top"];
    }
    
    NSDictionary* dic = [[NSJSONSerialization JSONObjectWithData:dataResult options:kNilOptions error:&error] mutableCopy];
    
    user.name = [dic objectForKey:@"name"];
    user.balance = [[dic objectForKey:@"balance"] doubleValue];
    //user.uid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    user.email = [dic objectForKey:@"email"];
    
    user.imageData = [user loadImageData:user.email];
    
    
    return user;
}

@end
