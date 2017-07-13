//
//  XDSNoteViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSNoteViewController.h"
#import "XDSNoDataView.h"
#import "XDSNoteCell.h"
@interface XDSNoteViewController ()
@property (nonatomic, strong) XDSNoDataView *noDataView;
@end

@implementation XDSNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataView = [XDSNoDataView newInstance];
    self.noDataView.frame = self.view.bounds;
    self.noDataView.titleLabel.text = @"暂未添加笔记";
    self.noDataView.contentLabel.text = @"在阅读时选择文可以添加笔记";
    [self.view addSubview:self.noDataView];
    self.noDataView.hidden = YES;
    
    self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if (CURRENT_BOOK_MODEL.chapterContainNotes.count) {
        self.noDataView.hidden = YES;
    }else{
        self.noDataView.hidden = NO;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CURRENT_BOOK_MODEL.chapterContainNotes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CURRENT_BOOK_MODEL.chapterContainNotes[section].notes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
//    return CURRENT_BOOK_MODEL.chapterContainNotes[section].title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDSNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDSNoteCell"];
    if (nil == cell) {
        cell = [[XDSNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XDSNoteCell"];
    }
    
    XDSNoteModel *noteModel = CURRENT_BOOK_MODEL.chapterContainNotes[indexPath.section].notes[indexPath.row];
    cell.nontLabel.text = noteModel.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_cvDelegate && [_cvDelegate respondsToSelector:@selector(catalogueViewDidSelectedNote:)]){
        XDSNoteModel *noteModel = CURRENT_BOOK_MODEL.chapterContainNotes[indexPath.section].notes[indexPath.row];
        [_cvDelegate catalogueViewDidSelectedNote:noteModel];
    }
}
@end
