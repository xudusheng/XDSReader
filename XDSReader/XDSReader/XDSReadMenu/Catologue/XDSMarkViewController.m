//
//  XDSMarkViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMarkViewController.h"

#import "XDSNoDataView.h"
#import "XDSNoteCell.h"
@interface XDSMarkViewController ()
@property (nonatomic, strong) XDSNoDataView *noDataView;
@end

@implementation XDSMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataView = [XDSNoDataView newInstance];
    self.noDataView.frame = self.view.bounds;
    self.noDataView.titleLabel.text = @"未添加书签";
    self.noDataView.contentLabel.text = @"在阅读时点击书签按钮可以添加书签";
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES;
    
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if (CURRENT_BOOK_MODEL.chapterContainMarks.count) {
        self.noDataView.hidden = YES;
    }else{
        self.noDataView.hidden = NO;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return CURRENT_BOOK_MODEL.chapterContainMarks.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapterContainMarks[section];
    return chapterModel.marks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDSNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDSNoteCell"];
    if (nil == cell) {
        cell = [[XDSNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XDSNoteCell"];
    }
    XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapterContainMarks[indexPath.section];
    XDSMarkModel *markModel = chapterModel.marks[indexPath.row];
    cell.nontLabel.text = [NSString stringWithFormat:@"第%zd章 第%zd页\n%@", markModel.chapter, markModel.page, markModel.content];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cvDelegate && [_cvDelegate respondsToSelector:@selector(catalogueViewDidSelectedMark:)]){
        XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapterContainMarks[indexPath.section];
        XDSMarkModel *markModel = chapterModel.marks[indexPath.row];
        [_cvDelegate catalogueViewDidSelectedMark:markModel];
    }
}


@end
