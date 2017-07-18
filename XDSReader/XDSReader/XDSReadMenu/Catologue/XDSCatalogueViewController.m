//
//  XDSCatalogueViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSCatalogueViewController.h"

@interface XDSCatalogueViewController ()

@end

@implementation XDSCatalogueViewController
CGFloat const kCatalogueTableViewCellHeight = 44.f;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = kCatalogueTableViewCellHeight;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    //滚到可视区域
    NSInteger chapter = [CURRENT_BOOK_MODEL.chapters indexOfObject:CURRENT_RECORD.chapterModel];
    CGRect visibleRect = self.view.bounds;
    visibleRect.size.height = kCatalogueTableViewCellHeight;
    visibleRect.origin.y = kCatalogueTableViewCellHeight * chapter + CGRectGetHeight(self.view.bounds)/2 + kTabBarHeight;
    [self.tableView scrollRectToVisible:visibleRect animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CURRENT_BOOK_MODEL.chapters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    LPPChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapters[indexPath.row];
    cell.textLabel.text = chapterModel.chapterName;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (CURRENT_RECORD.chapterModel == chapterModel) {
        cell.textLabel.textColor = TEXT_COLOR_XDS_2;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cvDelegate && [_cvDelegate respondsToSelector:@selector(catalogueViewDidSelectedChapter:)]){
        LPPChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapters[indexPath.row];
        [_cvDelegate catalogueViewDidSelectedChapter:chapterModel];
    }
}
@end
