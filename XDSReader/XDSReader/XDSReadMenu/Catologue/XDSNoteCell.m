//
//  XDSNoteCell.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/22.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSNoteCell.h"
@interface XDSNoteCell()
@property (nonatomic, strong) UILabel *nontLabel;
@end
@implementation XDSNoteCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
}


- (void)createUI{
    self.nontLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.numberOfLines = 3;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:label];

        NSDictionary *dic = NSDictionaryOfVariableBindings(label);
        
        NSArray *H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[label]-10-|"
                                                             options:NSLayoutFormatAlignmentMask
                                                             metrics:nil
                                                               views:dic];
        NSArray *V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[label]-5-|"
                                                             options:NSLayoutFormatAlignmentMask
                                                             metrics:nil
                                                               views:dic];
        [self.contentView addConstraints:H];
        [self.contentView addConstraints:V];
        label;
    });
}

@end
