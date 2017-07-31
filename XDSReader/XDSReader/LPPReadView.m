//
//  LPPReadView.m
//  XDSReader
//
//  Created by dusheng.xu on 07/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "LPPReadView.h"
#import "LPPChapterModel.h"
@interface LPPReadView () <DTAttributedTextContentViewDelegate>

{
    NSRange _selectRange;
    NSRange _calRange;
    NSArray *_pathArray;
    
    UIPanGestureRecognizer *_pan;
    //滑动手势有效区间
    CGRect _leftRect;
    CGRect _rightRect;
    
    CGRect _menuRect;
    //是否进入选择状态
    BOOL _selectState;
    BOOL _isDirectionRight; //滑动方向  (0---左侧滑动 1 ---右侧滑动)
}

@property (nonatomic,strong) XDSMagnifierView *magnifierView;

@property (strong, nonatomic) DTAttributedTextView *readTextView;

@property (nonatomic, strong) NSAttributedString *readAttributedContent;

@property (nonatomic, copy) NSString *content;

@end
@implementation LPPReadView

//MARK: -  override super method
- (instancetype)initWithFrame:(CGRect)frame readAttributedContent:(NSAttributedString *)readAttributedContent{
    if (self = [super initWithFrame:frame]) {
        self.readAttributedContent = [[NSMutableAttributedString alloc] initWithAttributedString:readAttributedContent];
        self.content = readAttributedContent.string;
        [self createUI];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGRect leftDot,rightDot = CGRectZero;
    _menuRect = CGRectZero;
    
    //绘制选中区域的背景色
    [self drawSelectedPath:_pathArray leftDot:&leftDot rightDot:&rightDot];
    
    //绘制选中区域前后的大头针
    [self drawDotWithLeft:leftDot right:rightDot];
}


//MARK: - ABOUT UI UI相关
- (void)createUI{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self addGestureRecognizer:({
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress;
    })];
    [self addGestureRecognizer:({
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.enabled = NO;
        _pan = pan;
        pan;
    })];
    
    
    CGRect frame = self.bounds;
    // we draw images and links via subviews provided by delegate methods
    self.readTextView = [[DTAttributedTextView alloc] initWithFrame:frame];
    self.readTextView.shouldDrawImages = YES;
    self.readTextView.shouldDrawLinks = YES;
    self.readTextView.textDelegate = self; // delegate for custom sub views
    self.readTextView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.readTextView];
    self.readTextView.attributedString = self.readAttributedContent;
}

//TODO: docs
-(void)drawDotWithLeft:(CGRect)leftDocFrame right:(CGRect)rightDocFrame{
    if (CGRectEqualToRect(CGRectZero, leftDocFrame) || (CGRectEqualToRect(CGRectZero, rightDocFrame))){
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef pathRef = CGPathCreateMutable();
    [[UIColor orangeColor] setFill];
    CGPathAddRect(pathRef, NULL, CGRectMake(CGRectGetMinX(leftDocFrame)-2, CGRectGetMinY(leftDocFrame),2, CGRectGetHeight(leftDocFrame)));
    CGPathAddRect(pathRef, NULL, CGRectMake(CGRectGetMaxX(rightDocFrame), CGRectGetMinY(rightDocFrame),2, CGRectGetHeight(rightDocFrame)));
    CGContextAddPath(ctx, pathRef);
    CGContextFillPath(ctx);
    CGPathRelease(pathRef);
    CGFloat dotSize = 15.f;//doc size  小圆点尺寸
    CGFloat clickableSize = dotSize + 20.f;//clickable size 可点区域尺寸
    _leftRect = CGRectMake(CGRectGetMinX(leftDocFrame)-clickableSize/2,
                           CGRectGetMinY(leftDocFrame)-clickableSize/2,
                           clickableSize,
                           clickableSize);
    _rightRect = CGRectMake(CGRectGetMaxX(rightDocFrame)-clickableSize/2,
                            CGRectGetMaxY(rightDocFrame)-clickableSize/2,
                            clickableSize,
                            clickableSize);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMinX(leftDocFrame)-dotSize/2, CGRectGetMinY(leftDocFrame)-dotSize/2, dotSize, dotSize),[UIImage imageNamed:@"r_drag-dot"].CGImage);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMaxX(rightDocFrame)-dotSize/2, CGRectGetMaxY(rightDocFrame)-dotSize/2, dotSize, dotSize),[UIImage imageNamed:@"r_drag-dot"].CGImage);
}

//TODO: Magnifier View
-(void)showMagnifier{
    if (!_magnifierView) {
        self.magnifierView = [[XDSMagnifierView alloc] init];
        self.magnifierView.readView = self;
        [self addSubview:self.magnifierView];
    }
}
-(void)hiddenMagnifier{
    if (_magnifierView) {
        [self.magnifierView removeFromSuperview];
        self.magnifierView = nil;
    }
}
//MARK: - DELEGATE METHODS 代理方法
//TODO: DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
              viewForAttributedString:(NSAttributedString *)string
                                frame:(CGRect)frame
{
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    
    
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
    button.GUID = identifier;
    
    // get image with normal link text
    UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
    [button setImage:normalImage forState:UIControlStateNormal];
    
    // get image for highlighted link text
    UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];

    [button setImage:highlightImage forState:UIControlStateHighlighted];
    
    // use normal push action for opening URL
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    
//    // demonstrate combination with long press
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
//    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
                    viewForAttachment:(DTTextAttachment *)attachment
                                frame:(CGRect)frame{
    
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        XDSReadConfig *config = [XDSReadConfig shareInstance];
        CGFloat fontSize = (config.currentFontSize > 1)?config.currentFontSize:config.cachefontSize;
        NSString *header = @"你好";
        CGRect headerFrame = [header boundingRectWithSize:CGSizeMake(100, 100)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                                  context:nil];
        CGFloat headIndent = CGRectGetWidth(headerFrame);
        
        frame.origin.x -= headIndent;
        
        
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
//        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL){
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = YES;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
//            // use normal push action for opening URL
//            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
//            
//            // demonstrate combination with long press
//            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
//            [button addGestureRecognizer:longPress];
//            
            [imageView addSubview:button];
        }
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
 shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock
                            frame:(CGRect)frame
                          context:(CGContextRef)context
                   forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    //    CGColorRef color = [textBlock.backgroundColor CGColor];
    CGColorRef color = [[UIColor blueColor] CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    
    return YES; // draw standard background
}

//MARK: - ABOUT REQUEST 网络请求

//MARK: - ABOUT EVENTS 事件响应
- (void)linkPushed:(DTLinkButton *)button{
    NSLog(@"xxxxxxxxxxxxxxx");
}

-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    CGPoint point = [longPress locationInView:self.readTextView];
    [self hiddenMenu];
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        
        //传入手势坐标，返回选择文本的range和frame
        CGRect rect = [self parserRectWithPoint:point range:&_selectRange];
        
        //显示放大镜
        [self showMagnifier];
        
        self.magnifierView.touchPoint = point;
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            _pathArray = @[NSStringFromCGRect(rect)];
            [self setNeedsDisplay];
            
        }
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        
        //隐藏放大
        [self hiddenMagnifier];
        if (!CGRectEqualToRect(_menuRect, CGRectZero)) {
            [self showMenu];
        }
    }
}
-(void)pan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan locationInView:self];
    [self hiddenMenu];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self showMagnifier];
        self.magnifierView.touchPoint = point;
        
        if (CGRectContainsPoint(_rightRect, point)||CGRectContainsPoint(_leftRect, point)) {
            if (CGRectContainsPoint(_leftRect, point)) {
                _isDirectionRight = NO;   //从左侧滑动
            }
            else{
                _isDirectionRight=  YES;    //从右侧滑动
            }
        }
        
        //传入手势坐标，返回选择文本的range和frame数组，一行一个frame
        NSArray *path = [self parserRectsWithPoint:point range:&_selectRange paths:_pathArray isDirectionRight:_isDirectionRight];
        _pathArray = path;
        [self setNeedsDisplay];
        
        
    }else{
        [self hiddenMagnifier];
        _selectState = NO;
        if (!CGRectEqualToRect(_menuRect, CGRectZero)) {
            [self showMenu];
        }
    }
    
}

-(void)showMenu {
    if ([self becomeFirstResponder]) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopy:)];
        UIMenuItem *menuItemNote = [[UIMenuItem alloc] initWithTitle:@"笔记" action:@selector(menuNote:)];
        UIMenuItem *menuItemShare = [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(menuShare:)];
        NSArray *menus = @[menuItemCopy,menuItemNote,menuItemShare];
        [menuController setMenuItems:menus];
        [menuController setTargetRect:CGRectMake(CGRectGetMidX(_menuRect), CGRectGetHeight(self.frame)-CGRectGetMidY(_menuRect), CGRectGetHeight(_menuRect), CGRectGetWidth(_menuRect)) inView:self];
        [menuController setMenuVisible:YES animated:YES];
        
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)hiddenMenu{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
#pragma mark Menu Function
-(void)menuCopy:(id)sender{
    [self hiddenMenu];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:[_content substringWithRange:_selectRange]];
    [XDSReaderUtil showAlertWithTitle:@"成功复制以下内容" message:pasteboard.string];
    
}
-(void)menuNote:(id)sender{
    [self hiddenMenu];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"笔记" message:[_content substringWithRange:_selectRange]  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入内容";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XDSNoteModel *model = [[XDSNoteModel alloc] init];
        model.content = [_content substringWithRange:_selectRange];
        model.note = alertController.textFields.firstObject.text;
        model.date = [NSDate date];
        LPPChapterModel *chapterModel = CURRENT_RECORD.chapterModel;
        model.locationInChapterContent = _selectRange.location + [chapterModel.pageLocations[CURRENT_RECORD.currentPage] integerValue];
        [[XDSReadManager sharedManager] addNoteModel:model];
    }];
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [(UIViewController *)nextResponder presentViewController:alertController animated:YES completion:nil];
            break;
        }
    }
}

-(void)menuShare:(id)sender{
    [self hiddenMenu];
}
//MARK: - OTHER PRIVATE METHODS 私有方法

//绘制选中区域的背景色
- (void)drawSelectedPath:(NSArray *)pathArray leftDot:(CGRect *)leftDot rightDot:(CGRect *)rightDot{
    if (pathArray.count < 1) {
        _pan.enabled = NO;
        return;
    }
    _pan.enabled = YES;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    [[UIColor cyanColor] setFill];
    for (int i = 0; i < [pathArray count]; i++) {
        CGRect rect = CGRectFromString([pathArray objectAtIndex:i]);
        CGPathAddRect(pathRef, NULL, rect);
        if (i == 0) {
            *leftDot = rect;
            _menuRect = rect;
        }
        if (i == [pathArray count]-1) {
            *rightDot = rect;
        }
        
    }
    
    //绘制选择区域的背景色
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, pathRef);
    CGContextFillPath(ctx);
    CGPathRelease(pathRef);
}

-(void)cancelSelected{
    if (_pathArray) {
        _pathArray = nil;
        [self hiddenMenu];
        [self setNeedsDisplay];
    }
}
//MARK: - ABOUT MEMERY 内存管理
- (void)setReadAttributedString:(NSAttributedString *)readAttributedString{
    _readAttributedContent = [[NSMutableAttributedString alloc] initWithAttributedString:readAttributedString];
    self.readTextView.attributedString = self.readAttributedContent;
    self.content = _readAttributedContent.string;
}
- (void)dataInit{
    
}

//=============================
- (CGRect)parserRectWithPoint:(CGPoint)point range:(NSRange *)selectRange{
    
    DTCoreTextLayoutFrame *visibleframe = self.readTextView.attributedTextContentView.layoutFrame;    
    NSArray *linse = visibleframe.lines;
    CGRect rect = CGRectZero;
    if (nil == linse) {
        return rect;
    }
    if (linse.count) {
        for (DTCoreTextLayoutLine *layoutLine in linse) {
            CGRect layoutLineFrame = layoutLine.frame;
            if (CGRectContainsPoint(layoutLineFrame, point)) {
                //获取行位置
                NSRange stringRange = [layoutLine stringRange];
                //获取手势在该页中的位置
                NSInteger index = [layoutLine stringIndexForPosition:point];
                CGFloat xStart = [layoutLine offsetForStringIndex:index];
                CGFloat xEnd;
                //默认选中两个单位
                if (index > stringRange.location+stringRange.length-2) {
                    xEnd = xStart;
                    xStart = [layoutLine offsetForStringIndex:index-2];
                    (*selectRange).location = index - 2;
                }else{
                    xEnd = [layoutLine offsetForStringIndex:index+2];
                    (*selectRange).location = index;
                }
                (*selectRange).length = 2;
                
                CGFloat leading = layoutLine.frame.origin.x;
                rect = layoutLineFrame;
                rect.origin.x = xStart + leading;
                rect.size.width = fabs(xStart-xEnd);
                break;
            }
        }
    }
    return rect;
}

- (NSArray *)parserRectsWithPoint:(CGPoint)point
                           range:(NSRange *)selectRange
                           paths:(NSArray *)paths
                 isDirectionRight:(BOOL)isDirectionRight{
    DTCoreTextLayoutFrame *visibleframe = self.readTextView.attributedTextContentView.layoutFrame;
    NSArray *linse = visibleframe.lines;
    if (nil == linse || linse.count < 1) {
        return paths;
    }
    
    NSRange positionRange = NSMakeRange(0, 0);
    BOOL containPoint = NO;
    for (DTCoreTextLayoutLine *layoutLine in linse) {
        CGRect layoutLineFrame = layoutLine.frame;
        if (CGRectContainsPoint(layoutLineFrame, point)) {
            //获取手势在该页中的位置
            NSInteger index = [layoutLine stringIndexForPosition:point];
            positionRange.location = index;
            containPoint = YES;
            break;
        }
    }

    if (!containPoint) {
        return paths;
    }
    
    //set selectedRange
    if (isDirectionRight) {
        if (positionRange.location > (*selectRange).location){
            //在选择区域之间
            (*selectRange).length = positionRange.location - (*selectRange).location;
        }else{
            //在选中区域左边
            (*selectRange).length = (*selectRange).location - positionRange.location;
            (*selectRange).location = positionRange.location;
        }
    }else{
        if(positionRange.location < (*selectRange).location) {
            //在选中区域左边
            (*selectRange).length = ((*selectRange).location - positionRange.location + (*selectRange).length);
            (*selectRange).location = positionRange.location;
        }else if(positionRange.location > (*selectRange).location + (*selectRange).length){
            //在选中区域右边
            (*selectRange).location = (*selectRange).location + (*selectRange).length;
            (*selectRange).length = positionRange.location - (*selectRange).location;
        }else{
            //在选择区域之间
            (*selectRange).length = (*selectRange).location + (*selectRange).length - positionRange.location;
            (*selectRange).location = positionRange.location;
            
        }
    }
    
    DTCoreTextLayoutLine *firstLine = [visibleframe lineContainingIndex:(*selectRange).location];
    DTCoreTextLayoutLine *lastLine = [visibleframe lineContainingIndex:((*selectRange).location + (*selectRange).length)];
    
    if (CGRectEqualToRect(firstLine.frame, lastLine.frame)) {
        CGRect frame = firstLine.frame;
        CGFloat minX = [firstLine offsetForStringIndex:(*selectRange).location];
        CGFloat maxX = [firstLine offsetForStringIndex:(*selectRange).location + (*selectRange).length];
        frame.origin.x += minX;
        frame.size.width = maxX - minX;
        return @[NSStringFromCGRect(frame)];
        
    }else{

        NSMutableArray *pathArray = [NSMutableArray arrayWithCapacity:0];
        
        NSInteger firstIndex = (*selectRange).location;
        NSInteger lastIndex = (*selectRange).location + (*selectRange).length;
        
        for (DTCoreTextLayoutLine *layoutLine in linse) {
            NSRange stringRange = layoutLine.stringRange;
            if (stringRange.location < firstIndex && layoutLine != firstLine) {
                continue;
            }else if (stringRange.location > lastIndex){
                continue;
            }
            
            CGRect lineFrame = layoutLine.frame;
            if (layoutLine == firstLine ) {
                CGFloat xStart = [layoutLine offsetForStringIndex:firstIndex];
                lineFrame.size.width = (CGRectGetWidth(lineFrame) - (xStart - CGRectGetMinX(lineFrame)));
                lineFrame.origin.x += xStart;
            }else if(layoutLine == lastLine){
                CGFloat xStart = [layoutLine offsetForStringIndex:lastIndex];
                lineFrame.size.width = (CGRectGetWidth(lineFrame) - (CGRectGetMaxX(lineFrame)- CGRectGetMinX(lineFrame) - xStart));
            }else{}
            [pathArray addObject:NSStringFromCGRect(lineFrame)];

        }
        return pathArray;
    }
}

@end
