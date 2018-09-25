//
//  XDSBookCell.h
//  iHappy
//
//  Created by Hmily on 2018/9/17.
//  Copyright © 2018年 dusheng.xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define XDS_BOOK_CELL_IDENTIFIER @"XDSBookCell"
@interface XDSBookCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mContentLabel;

@end
