//
//  UserDetailsCell.m
//  meteroid
//
//  Created by Gerrit on 29.10.13.
//  Copyright (c) 2013 Chaos Computer Club Düsseldorf / Chaosdorf e.V. All rights reserved.
//

#import "UserDetailsCell.h"

@implementation UserDetailsCell

@synthesize logo;
@synthesize price;
@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellDetails:(Drink *) drink {
    
    name.text = [NSString stringWithFormat:@"(%@)", drink.name];
    price.text = [NSString stringWithFormat:@"-%.2lf€", drink.price];
    
    if (drink.imageData) {
        UIImage *image = [UIImage imageWithData:drink.imageData];
        logo.image = image;
    } else {
        UIImage *image = [UIImage imageWithData:[drink loadImageData:drink.logoUrl]];
        logo.image = image;
    }
}

@end
