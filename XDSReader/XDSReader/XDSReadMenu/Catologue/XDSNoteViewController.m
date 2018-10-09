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

#import "XDSNoteHTMLVC.h"

@interface XDSNoteViewController ()
@property (nonatomic, strong) XDSNoDataView *noDataView;

@property (nonatomic, strong) UILabel *noteCountLabel;

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
    
    
    self.noteCountLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"";
        label.font = [UIFont boldSystemFontOfSize:15];
        
        label;
    });
    
    self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.noteCountLabel];
    self.navigationItem.leftBarButtonItem = leftBar;

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"导出笔记" style:UIBarButtonItemStylePlain target:self action:@selector(exportNote)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if (CURRENT_BOOK_MODEL.chapterContainNotes.count) {
        self.noDataView.hidden = YES;
    }else{
        self.noDataView.hidden = NO;
    }
    
    NSInteger count = 0;
    for (XDSChapterModel *chapter in CURRENT_BOOK_MODEL.chapterContainNotes) {
        count += chapter.notes.count;
    }
    
    self.noteCountLabel.text = count>0?[NSString stringWithFormat:@"笔记 · %ld", count]:@"";
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return CURRENT_BOOK_MODEL.chapterContainNotes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CURRENT_BOOK_MODEL.chapterContainNotes[section].notes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapterContainNotes[section];
    return chapterModel.chapterName;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDSNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDSNoteCell class])];
    if (nil == cell) {
        cell = [[XDSNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([XDSNoteCell class])];
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

//导出笔记
- (void)exportNote {
    XDSNoteHTMLVC *noteWebVC = [[XDSNoteHTMLVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noteWebVC];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    if ([presentedVC isKindOfClass:[XDSReadPageViewController class]]) {
        [presentedVC presentViewController:nav animated:YES completion:nil];
    }
}
@end
