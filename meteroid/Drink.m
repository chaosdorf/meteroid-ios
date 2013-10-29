//
//  Drink.m
//  meteroid
//
//  Created by Gerrit on 29.10.13.
//  Copyright (c) 2013 Chaos Computer Club Düsseldorf / Chaosdorf e.V. All rights reserved.
//

#import "Drink.h"

@implementation Drink

@synthesize logoUrl;

-(AppDelegate*) app
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(NSData *)loadImageData:(NSString *)tmpLogoUrl {
    
    if(tmpLogoUrl == nil) {
        return UIImagePNGRepresentation([UIImage imageNamed: @"stub.png"]);
    }
    
    NSString *http = @"http://";
    NSString *https = @"https://";
    
    NSMutableString *msUrl = [[NSMutableString alloc] init];
    
    if(self.app.ssl == TRUE) {
        [msUrl appendString: https];
    } else {
        [msUrl appendString: http];
    }
    
    NSString *newHostname = [self.app.hostname copy];
    
    if ([self.app.hostname hasPrefix:http]) {
        newHostname = [self.app.hostname substringFromIndex:[http length]];
    }
    
    if ([self.app.hostname hasPrefix:https]) {
        newHostname = [self.app.hostname substringFromIndex:[https length]];
    }
    
    Url *url = [[Url alloc] init];
    [msUrl appendString: [url encodeToPercentEscapeString:newHostname]];
    [msUrl appendString: @":"];
    [msUrl appendString: [NSString stringWithFormat:@"%d%@", self.app.port, tmpLogoUrl]];

    return [NSData dataWithContentsOfURL:[NSURL URLWithString: msUrl]];

}


@end
