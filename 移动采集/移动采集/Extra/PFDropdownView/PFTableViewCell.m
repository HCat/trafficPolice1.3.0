//
//  PFTableViewCell.m
//  PFNavigationDropdownMenu
//
//  Created by Cee on 02/08/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "PFTableViewCell.h"

@implementation PFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                configuration:(PFConfiguration *)configuration
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.configuration = configuration;
        
        // Setup cell
        self.cellContentFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.configuration.cellHeight);
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = self.configuration.cellTextLabelColor;
        self.textLabel.font = self.configuration.cellTextLabelFont;
        self.textLabel.frame = CGRectMake(20, 0, self.cellContentFrame.size.width, self.cellContentFrame.size.height);
        
        // Checkmark icon
        self.checkmarkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.cellContentFrame.size.width - 30, (self.cellContentFrame.size.height - 11)/2, 13, 11)];
        self.checkmarkIcon.hidden = YES;
        self.checkmarkIcon.image = self.configuration.checkMarkImage;
        self.checkmarkIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.checkmarkIcon];
        
       
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bounds = self.cellContentFrame;
    self.contentView.frame = self.bounds;
}
@end
