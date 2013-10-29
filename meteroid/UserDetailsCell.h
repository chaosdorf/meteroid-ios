//
//  UserDetailsCell.h
//  meteroid
//
//  Created by Gerrit on 29.10.13.
//  Copyright (c) 2013 Chaos Computer Club Düsseldorf / Chaosdorf e.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drink.h"

@interface UserDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)setCellDetails:(Drink *) drink;

@end
