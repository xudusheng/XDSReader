//
//  XDSDemoViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 06/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "XDSDemoViewController.h"
#import "LPPChapterModel.h"
#import "LPPReadView.h"
@interface XDSDemoViewController () <DTAttributedTextContentViewDelegate>

@property (strong, nonatomic) LPPReadView *readView;
@property (strong, nonatomic) DTAttributedTextView *readTextView;
@property (strong, nonatomic) LPPChapterModel *chapterModel;
@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation XDSDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.chapterModel = [[LPPChapterModel alloc] init];
    
//    CGRect frame = CGRectMake(20,
//                              20,
//                              DEVICE_MAIN_SCREEN_WIDTH_XDSR - 40,
//                              DEVICE_MAIN_SCREEN_HEIGHT_XDSR - 40);
    
    CGRect frame = [XDSReadManager readViewBounds];
    [self.chapterModel paginateEpubWithBounds:frame];
    
    self.readView = [[LPPReadView alloc] initWithFrame:frame readAttributedContent:self.chapterModel.pageAttributeStrings[0]];
    
    [self.view addSubview:self.readView];
}


- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
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
    
    // demonstrate combination with long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
    [button addGestureRecognizer:longPress];
    
    return button;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL)
        {
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = YES;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            // use normal push action for opening URL
            [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            // demonstrate combination with long press
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
            [button addGestureRecognizer:longPress];
            
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

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
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


- (void)linkPushed:(DTLinkButton *)button{
    NSLog(@"xxxxxxxxxxxxxxx");
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan){
        DTLinkButton *button = (id)[gesture view];
        button.highlighted = NO;
        if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]]){
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description]
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Open in Safari", nil];
            [action showFromRect:button.frame inView:button.superview animated:YES];
        }
    }
}

- (void)nextPageButtonClick:(UIBarButtonItem *)barButton{
    _pageNum ++;
    
    if (_pageNum >= self.chapterModel.pageAttributeStrings.count) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.readView setReadAttributedString:self.chapterModel.pageAttributeStrings[_pageNum]];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self nextPageButtonClick:nil];
}
@end
