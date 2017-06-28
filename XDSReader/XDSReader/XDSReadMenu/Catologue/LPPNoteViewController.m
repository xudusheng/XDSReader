//
//  LPPNoteViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPNoteViewController.h"
#import "LPPNoDataView.h"
#import "LPPNoteCell.h"
@interface LPPNoteViewController ()
@property (nonatomic, strong) LPPNoDataView *noDataView;
@end

@implementation LPPNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataView = [LPPNoDataView newInstance];
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
    return CURRENT_BOOK_MODEL.chapterContainNotes[section].title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPPNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LPPNoteCell"];
    if (nil == cell) {
        cell = [[LPPNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LPPNoteCell"];
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
