//
//  XDSMenuBottomView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMenuBottomView.h"

@interface XDSMenuBottomView ()
@property (nonatomic,strong) XDSReadProgressView *progressView;
@property (nonatomic,strong) XDSThemeView *themeView;
@property (nonatomic,strong) UIButton *minSpacing;
@property (nonatomic,strong) UIButton *mediuSpacing;
@property (nonatomic,strong) UIButton *maxSpacing;
@property (nonatomic,strong) UIButton *catalog;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UIButton *lastChapter;
@property (nonatomic,strong) UIButton *nextChapter;
@property (nonatomic,strong) UIButton *increaseFont;
@property (nonatomic,strong) UIButton *decreaseFont;
@property (nonatomic,strong) UILabel *fontLabel;

@end
@implementation XDSMenuBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMenuBottomViewUI];
    }
    return self;
}
-(void)createMenuBottomViewUI{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.slider];
    [self addSubview:self.catalog];
    [self addSubview:self.progressView];
    [self addSubview:self.lastChapter];
    [self addSubview:self.nextChapter];
    [self addSubview:self.increaseFont];
    [self addSubview:self.decreaseFont];
    [self addSubview:self.fontLabel];
    [self addSubview:self.themeView];
}
-(UIButton *)catalog{
    if (!_catalog) {
        _catalog = [XDSReaderUtil commonButtonSEL:@selector(showCatalog) target:self];
        [_catalog setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
    }
    return _catalog;
}
-(XDSReadProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[XDSReadProgressView alloc] init];
        _progressView.hidden = YES;
        
    }
    return _progressView;
}
-(UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        _slider.minimumTrackTintColor = RGB(227, 0, 0);
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateNormal];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(changeMsg:) forControlEvents:UIControlEventValueChanged];
        [_slider addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return _slider;
}
-(UIButton *)nextChapter{
    if (!_nextChapter) {
        _nextChapter = [XDSReaderUtil commonButtonSEL:@selector(jumpChapter:) target:self];
        [_nextChapter setTitle:@"下一章" forState:UIControlStateNormal];
    }
    return _nextChapter;
}
-(UIButton *)lastChapter{
    if (!_lastChapter) {
        _lastChapter = [XDSReaderUtil commonButtonSEL:@selector(jumpChapter:) target:self];
        [_lastChapter setTitle:@"上一章" forState:UIControlStateNormal];
    }
    return _lastChapter;
}
-(UIButton *)increaseFont{
    if (!_increaseFont) {
        _increaseFont = [XDSReaderUtil commonButtonSEL:@selector(changeFont:) target:self];
        [_increaseFont setTitle:@"A+" forState:UIControlStateNormal];
        [_increaseFont.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _increaseFont.layer.borderWidth = 1;
        _increaseFont.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _increaseFont;
}
-(UIButton *)decreaseFont{
    if (!_decreaseFont) {
        _decreaseFont = [XDSReaderUtil commonButtonSEL:@selector(changeFont:) target:self];
        [_decreaseFont setTitle:@"A-" forState:UIControlStateNormal];
        [_decreaseFont.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _decreaseFont.layer.borderWidth = 1;
        _decreaseFont.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _decreaseFont;
}
-(UILabel *)fontLabel{
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.font = [UIFont systemFontOfSize:14];
        _fontLabel.textColor = [UIColor whiteColor];
        _fontLabel.textAlignment = NSTextAlignmentCenter;
        _fontLabel.text = [NSString stringWithFormat:@"%d",(int)[XDSReadConfig shareInstance].fontSize];
    }
    return _fontLabel;
}
-(XDSThemeView *)themeView{
    if (!_themeView) {
        _themeView = [[XDSThemeView alloc] init];
    }
    return _themeView;
}
#pragma mark - Button Click
-(void)jumpChapter:(UIButton *)sender{
    NSInteger currentChapter = CURRENT_RECORD.currentChapter;
    
    if (sender == _nextChapter) {
        if (currentChapter < CURRENT_RECORD.totalChapters - 1) {
            currentChapter += 1;
        }
    }else{
        currentChapter -= 1;
    }
    
    [[XDSReadManager sharedManager] readViewJumpToChapter:currentChapter page:0];
    _slider.value = CURRENT_RECORD.currentPage/((float)(CURRENT_RECORD.chapterModel.pageCount-1))*100;
    [_progressView title:CURRENT_RECORD.chapterModel.title progress:[NSString stringWithFormat:@"%.1f%%",_slider.value]];
    
}
-(void)changeFont:(UIButton *)sender{
    BOOL plus = (sender == _increaseFont);
    [[XDSReadManager sharedManager] configReadFontSize:plus];
    _fontLabel.text = @([XDSReadConfig shareInstance].fontSize).stringValue;
}
#pragma mark showMsg

-(void)changeMsg:(UISlider *)sender{
    NSInteger page =ceil((_readModel.chapterModel.pageCount-1)*sender.value/100.00);
    [[XDSReadManager sharedManager] readViewJumpToChapter:CURRENT_RECORD.currentChapter page:page];
    _slider.value = CURRENT_RECORD.currentPage/((float)(CURRENT_RECORD.chapterModel.pageCount-1))*100;
    [_progressView title:CURRENT_RECORD.chapterModel.title progress:[NSString stringWithFormat:@"%.1f%%",_slider.value]];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (_slider.state == UIControlStateNormal) {
        _progressView.hidden = YES;
    }
    else if(_slider.state == UIControlStateHighlighted){
        _progressView.hidden = NO;
    }
    
}
-(UIImage *)thumbImage{
    CGRect rect = CGRectMake(0, 0, 15,15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:7.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    {
        [[UIColor whiteColor] setFill];
        [path fill];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}
-(void)showCatalog{
    if ([self.mvdelegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.mvdelegate menuViewInvokeCatalog:self];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    
    _slider.frame = CGRectMake(50, 20, width-100, 30);
    _lastChapter.frame = CGRectMake(5, 20, 40, 30);
    _nextChapter.frame = CGRectMake(DISTANCE_FROM_LEFT_GUIDEN(_slider)+5, 20, 40, 30);
    _decreaseFont.frame = CGRectMake(10, DISTANCE_FROM_TOP_GUIDEN(_slider)+10, (width-20)/3, 30);
    _fontLabel.frame = CGRectMake(DISTANCE_FROM_LEFT_GUIDEN(_decreaseFont), DISTANCE_FROM_TOP_GUIDEN(_slider)+10, (width-20)/3,  30);
    _increaseFont.frame = CGRectMake(DISTANCE_FROM_LEFT_GUIDEN(_fontLabel), DISTANCE_FROM_TOP_GUIDEN(_slider)+10,  (width-20)/3, 30);
    _themeView.frame = CGRectMake(0, DISTANCE_FROM_TOP_GUIDEN(_increaseFont)+10, width, 40);
    _catalog.frame = CGRectMake(10, DISTANCE_FROM_TOP_GUIDEN(_themeView), 30, 30);
    _progressView.frame = CGRectMake(60, -60, width-120, 50);
    
}
-(void)dealloc{
    [_slider removeObserver:self forKeyPath:@"highlighted"];
}
@end
@interface XDSThemeView ()
@property (nonatomic,strong) UIView *theme1;
@property (nonatomic,strong) UIView *theme2;
@property (nonatomic,strong) UIView *theme3;
@end
@implementation XDSThemeView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.theme1];
    [self addSubview:self.theme2];
    [self addSubview:self.theme3];
}
-(UIView *)theme1{
    if (!_theme1) {
        _theme1 = [[UIView alloc] init];
        _theme1.backgroundColor = [UIColor whiteColor];
        [_theme1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme1;
}
-(UIView *)theme2{
    if (!_theme2) {
        _theme2 = [[UIView alloc] init];
        _theme2.backgroundColor = RGB(188, 178, 190);
        [_theme2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme2;
}
-(UIView *)theme3{
    if (!_theme3) {
        _theme3 = [[UIView alloc] init];
        _theme3.backgroundColor = RGB(190, 182, 162);
        [_theme3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme3;
}
-(void)changeTheme:(UITapGestureRecognizer *)tap{
    [[XDSReadManager sharedManager] configReadTheme:tap.view.backgroundColor];
}
-(void)layoutSubviews{
    CGFloat spacing = (CGRectGetWidth(self.frame)-40*3)/4;
    _theme1.frame = CGRectMake(spacing, 0, 40, 40);
    _theme2.frame = CGRectMake(DISTANCE_FROM_LEFT_GUIDEN(_theme1)+spacing, 0, 40, 40);
    _theme3.frame = CGRectMake(DISTANCE_FROM_LEFT_GUIDEN(_theme2)+spacing, 0, 40, 40);
}
@end



@interface XDSReadProgressView ()
@property (nonatomic,strong) UILabel *label;
@end
@implementation XDSReadProgressView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
        [self addSubview:self.label];
    }
    return self;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:[XDSReadConfig shareInstance].fontSize];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
    }
    return _label;
}
-(void)title:(NSString *)title progress:(NSString *)progress{
    _label.text = [NSString stringWithFormat:@"%@\n%@",title,progress];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _label.frame = self.bounds;
}
@end
