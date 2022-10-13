//
//  SMSSDKUIZonesCell.m
//  SMSSDKUI
//
//  Created by hower on 2018/3/12.
//  Copyright © 2018年 youzu. All rights reserved.
//

#import "SMSDemoZonesCell.h"
#import "SMSDemoDefines.h"

@interface SMSDemoZonesCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *zoneCodeLabel;
@property (nonatomic, strong) UIView *lineBottom;

@end

@implementation SMSDemoZonesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.nameLabel =
    ({
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(15, 17, 200, 13);
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        [self.contentView addSubview:nameLabel];
        nameLabel;
    });
    
    self.zoneCodeLabel =
    ({
        UILabel *nameDescLabel = [[UILabel alloc] init];
        nameDescLabel.frame = CGRectMake(self.frame.size.width - 30, 17, 60, 13);
        nameDescLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        nameDescLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:nameDescLabel];
        nameDescLabel;
    });
    
    
    self.lineBottom =
    ({
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(15, 44, self.frame.size.width - 30,1)];
        lineBottom.backgroundColor = SMSDemoRGB(0xE0E0E6);
        [self.contentView addSubview:lineBottom];
        
        lineBottom;
    });
    
    _nameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    _zoneCodeLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    _zoneCodeLabel.textColor = SMSDemoRGB(0xC7C7C7);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lineBottom.frame = CGRectMake(15, 44, self.frame.size.width - 30,1);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
