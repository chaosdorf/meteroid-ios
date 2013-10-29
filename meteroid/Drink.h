//
//  Drink.h
//  meteroid
//
//  Created by Gerrit on 29.10.13.
//  Copyright (c) 2013 Chaos Computer Club Düsseldorf / Chaosdorf e.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Json.h"
#import "Url.h"

@interface Drink : NSObject {
    Json *json;
}

@property (nonatomic, copy) NSString *drinkId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bottleSize;
@property (nonatomic, copy) NSString *caffeine;
@property (nonatomic, copy) NSString *logoUrl;
@property double price;
@property (nonatomic, copy) NSDate *createdAt;

@property (nonatomic, retain) NSData *imageData;

-(AppDelegate *) app;
-(NSData *)loadImageData:(NSString *)tmpLogoUrl;

@end
