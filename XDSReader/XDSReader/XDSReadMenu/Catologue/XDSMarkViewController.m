//
//  XDSMarkViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMarkViewController.h"

#import "XDSNoDataView.h"
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
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if (CURRENT_BOOK_MODEL.marks.count) {
        self.noDataView.hidden = YES;
    }else{
        self.noDataView.hidden = NO;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CURRENT_BOOK_MODEL.marks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    XDSMarkModel *markModel = CURRENT_BOOK_MODEL.marks[indexPath.row];
    cell.textLabel.text = markModel.date.description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cvDelegate && [_cvDelegate respondsToSelector:@selector(catalogueViewDidSelectedMark:)]){
        XDSMarkModel *markModel = CURRENT_BOOK_MODEL.marks[indexPath.row];
        [_cvDelegate catalogueViewDidSelectedMark:markModel];
    }
}


@end
