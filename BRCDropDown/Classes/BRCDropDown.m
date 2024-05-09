//
//  BRCDropDown.m
//
//  Created by sunzhixiong on 2024/3/15.


#import "BRCDropDown.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

@implementation BRCDropDownItem

- (instancetype)initWithText:(nullable NSString *)text
                       image:(nullable UIImage *)image
                    imageUrl:(nullable NSString *)imageUrl
                onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    self = [super init];
    if (self) {
        self.itemText = text ?: @"";
        self.itemImage = image;
        self.itemImageUrl = imageUrl ?: @"";
        self.clickBlock = onClickBlock;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
                       image:(UIImage *)image
                onClickBlock:(BRCDropDownItemClickBlock)onClickBlock{
    return [self initWithText:text image:image imageUrl:nil onClickBlock:onClickBlock];
}

- (instancetype)initWithText:(NSString *)text
                    imageUrl:(NSString *)imageUrl
                onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    return [self initWithText:text image:nil imageUrl:imageUrl onClickBlock:onClickBlock];
}

- (instancetype)initWithText:(NSString *)text
                onClickBlock:(BRCDropDownItemClickBlock)onClickBlock{
    return [self initWithText:text image:nil imageUrl:nil onClickBlock:onClickBlock];
}

- (instancetype)initWithImage:(UIImage *)image
                 onClickBlock:(BRCDropDownItemClickBlock)onClickBlock{
    return [self initWithText:nil image:image imageUrl:nil onClickBlock:onClickBlock];
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                    onClickBlock:(BRCDropDownItemClickBlock)onClickBlock{
    return [self initWithText:nil image:nil imageUrl:imageUrl onClickBlock:onClickBlock];
}

+ (instancetype)itemWithText:(NSString *)text onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    return [[self alloc] initWithText:text onClickBlock:onClickBlock];
}

+ (instancetype)itemWithImage:(UIImage *)image onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    return [[self alloc] initWithImage:image onClickBlock:onClickBlock];
}

+ (instancetype)itemWithImageUrl:(NSString *)imageUrl onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    return [[self alloc] initWithImageUrl:imageUrl onClickBlock:onClickBlock];
}

+ (instancetype)itemWithText:(NSString *)text image:(UIImage *)image onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    return [[self alloc] initWithText:text image:image onClickBlock:onClickBlock];
}

+ (instancetype)itemWithText:(NSString *)text imageUrl:(NSString *)imageUrl onClickBlock:(BRCDropDownItemClickBlock)onClickBlock {
    return [[self alloc] initWithText:text imageUrl:imageUrl onClickBlock:onClickBlock];
}

@end

@interface BRCBubbleBackgroundView : UIView
<CAAnimationDelegate>

@property (nonatomic, strong) UIColor       *fillColor;
@property (nonatomic, strong) CAShapeLayer  *bubbleLayer;
@property (nonatomic, strong) UIColor       *bubbleColor;
@property (nonatomic, strong) UIView        *contentView;
@property (nonatomic, assign) CGSize        anchorViewSize;
@property (nonatomic, assign) CGPoint       arrowTip;
@property (nonatomic, assign) CGFloat       arrowInset;
@property (nonatomic, assign) CGFloat       cornerRadius;
@property (nonatomic, assign) CGFloat       arrowHeight;
@property (nonatomic, assign) CGFloat       animationDuration;
@property (nonatomic, assign) CGFloat       roundRadius;
@property (nonatomic, assign) CGFloat       arrowTopRadius;
@property (nonatomic, assign) CGFloat       arrowCustomPosition;
@property (nonatomic, assign) BRCDropDownArrowPosition      arrowPosition;
@property (nonatomic, assign) BRCDropDownArrowStyle         arrowStyle;
@property (nonatomic, assign) BRCDropDownContentAlignment   alignmentStyle;
@property (nonatomic, assign) BRCDropDownPopUpPosition      popUpPosition;
@property (nonatomic, assign) BRCDropDownPopUpAnimation     popUpAnimationStyle;
@property (nonatomic, copy)   void (^ __nullable dismissAnimationFinishBlock)(BOOL finished) ;

- (void)showAnimatedWithFrame:(CGRect)frame completion:(void (^ __nullable)(BOOL finished))completion;

- (void)dismissAnimatedWithCompletion:(void (^ __nullable)(BOOL finished))completion ;

- (void)setLayerShadow:(UIColor *)color
                offset:(CGSize)offset
                radius:(CGFloat)radius
               opacity:(CGFloat)opacity ;

@end

@interface BRCDropDown ()

@property (nonatomic, strong) UIView                    *anchorView;
@property (nonatomic, strong) BRCBubbleBackgroundView   *containerView;
@property (nonatomic, strong) CADisplayLink             *displayLink;
@property (nonatomic, assign) BOOL                      display;
@property (nonatomic, strong) id                        dataSource;


@end

@implementation BRCDropDown

#pragma mark - init

- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint {
    return [self initWithAnchorPoint:anchorPoint contentStyle:BRCDropDownContentStyleCustom];
}

- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint contentStyle:(BRCDropDownContentStyle)style {
    UIView *view = [UIView new];
    view.frame = CGRectMake(anchorPoint.x, anchorPoint.y, 0, 0);
    self = [self initWithAnchorView:view contentStyle:style];
    if (self) {
        _contextStyle = BRCDropDownContextStyleWindow;
    }
    return self;
}

- (instancetype)initWithAnchorView:(UIView *)anchorView contentStyle:(BRCDropDownContentStyle)style {
    self = [super init];
    if (self) {
        _contentStyle = style;
        _anchorView = anchorView;
        _dismissMode = BRCDropDownDismissModeNone;
        _webImageLoadBlock = ^(UIImageView *imageView,NSURL *imageUrl){
           
        };
        _cornerRadius = 10;
        _arrowInset = 15;
        _arrowRoundRadius = 4;
        _arrowRoundTopRadius = 4;
        _marginToKeyBoard = 10;
        _arrowCustomPosition = 0;
        _marginToAnchorView = 5;
        _animationDuration = 0.4;
        _shadowRadius = 8;
        _shadowOpacity = 1.0;
        _dismissMode = BRCDropDownDismissModeTapContent;
        _contextStyle = BRCDropDownContextStyleViewController;
        _popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
        _arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
        _arrowPosition = BRCDropDownArrowPositionLeft;
        _popUpPosition = BRCDropDownPopUpBottom;
        _contentStyle = BRCDropDownContentStyleTable;
        _contentAlignment = BRCDropDownContentAlignmentLeft;
        _autoHandlerDismiss = YES;
        _autoFitContainerSize = YES;
        _autoFitKeyBoardDisplay = YES;
        _autoCutoffRelief = YES;
        _contentTextColor = [UIColor blackColor];
        _contentTintColor = [UIColor blackColor];
        _backgroundColor = [UIColor systemGray6Color];
        _shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        _containerSize = CGSizeZero;
        _shadowOffset = CGSizeZero;
        [self addKeyBoardObserver];
    }
    return self;
}

- (instancetype)initWithAnchorView:(UIView *)anchorView {
    return [self initWithAnchorView:anchorView contentStyle:BRCDropDownContentStyleCustom];
}

+ (instancetype)dropDownWithAnchorPoint:(CGPoint)anchorPoint {
    return [[BRCDropDown alloc] initWithAnchorPoint:anchorPoint];
}

+ (instancetype)dropDownWithAnchorPoint:(CGPoint)anchorPoint contentStyle:(BRCDropDownContentStyle)style {
    return [[BRCDropDown alloc] initWithAnchorPoint:anchorPoint contentStyle:style];
}

+ (instancetype)dropDownWithAnchorView:(UIView *)anchorView contentStyle:(BRCDropDownContentStyle)style {
    return [[BRCDropDown alloc] initWithAnchorView:anchorView contentStyle:style];
}

+ (instancetype)dropDownWithAnchorView:(UIView *)anchorView {
    return [[BRCDropDown alloc] initWithAnchorView:anchorView];
}

#pragma mark - view monitoring

- (void)dealloc {
    [self stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startMonitoring {
    self.displayLink.paused = NO;
}

- (void)stopMonitoring {
    self.displayLink.paused = YES;
}

- (void)checkFrame {
    if (!self.anchorView) return;
    self.containerView.frame = [self containerFrame];
}

#pragma mark - public method

- (void)showAndAutoDismissAfterDelay:(NSTimeInterval)delay {
    [self show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)show {
    if ((!self.anchorView) || self.display) {
        return;
    }
    [self startMonitoring];
    [self showContainerViewAnimated];
}

- (void)dismiss {
    if ((!self.anchorView) || !self.display) {
        return;
    }
    [self stopMonitoring];
    [self dimissContainerViewAnimated];
}

- (void)toggleDisplay {
    if (self.display) {
        [self dismiss];
    } else {
        [self show];
    }
    self.display = !self.display;
}

- (void)showContainerViewAnimated {
    [self updateContainerViewWithPopupFrame];
    [self.dropDownContainerView addSubview:self.containerView];
    [self.containerView setLayerShadow:self.shadowColor offset:self.shadowOffset radius:self.shadowRadius opacity:self.shadowOpacity];
    self.containerView.frame = [self containerFrame];
    self.containerView.anchorViewSize = self.anchorView.frame.size;
    if ([self.contentView isKindOfClass:[UIView class]]) {
        [self.containerView setContentView:self.contentView];
       
        if ([self.contentView isKindOfClass:[UITableView class]] &&
            [(UITableView *)self.contentView numberOfRowsInSection:0] > 0) {
            [(UITableView *)self.contentView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationHeightExpansion ||
            self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeHeightExpansion) {
            self.contentView.alpha = 0;
        }
    }
    [self.containerView showAnimatedWithFrame:self.containerFrame completion:^(BOOL finished) {
        self.display = YES;
        if (finished) {
            if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationHeightExpansion ||
                self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeHeightExpansion) {
                self.contentView.alpha = 1;
            }
        }
    }];
}

- (void)dimissContainerViewAnimated {
    [self.containerView dismissAnimatedWithCompletion:^(BOOL finished) {
        if (finished) {
            [self.containerView removeFromSuperview];
        }
        self.display = NO;
    }];
}

#pragma mark - keyBoard

- (BOOL)anchorViewIsFirstResponder {
    UIView *currentResponderView = [self findFirstResponderForView:[self dropDownContainerView]];
    return [currentResponderView isEqual:self.anchorView];
}

- (void)addKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)handleKeyboardWillChangeFrame:(NSNotification *)notification {
    UIView *dropDownContainerView = [self dropDownContainerView];
    if (self.autoFitKeyBoardDisplay &&
        [self anchorViewIsFirstResponder] &&
        [self.anchorView isKindOfClass:[UIView class]] &&
        [dropDownContainerView isKindOfClass:[UIView class]]) {
        NSDictionary *userInfo = notification.userInfo;
        NSValue *keyboardFrameEndValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGFloat containerViewOffset;
        CGRect anchorViewWindowFrame = [self getWindowFrameForView:self.anchorView];
        CGFloat containerBottom = anchorViewWindowFrame.origin.y + anchorViewWindowFrame.size.height + self.marginToAnchorView + self.containerSize.height + self.marginToKeyBoard;
        if (containerBottom > kScreenHeight) {
            containerBottom = kScreenHeight;
        }
        if (containerBottom > [keyboardFrameEndValue CGRectValue].origin.y) {  // show
            containerViewOffset = [keyboardFrameEndValue CGRectValue].origin.y - containerBottom;
        } else {
            containerViewOffset = 0;
        }
        if (duration == 0) {
            duration = 0.25;
        }
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [UIView animateWithDuration:duration delay:0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
            dropDownContainerView.transform = CGAffineTransformMakeTranslation(0, containerViewOffset);
        } completion:nil];
    }
}

#pragma mark - tapAction

- (void)addTapGesture {
    if (_contentView != nil &&
        ![_contentView isKindOfClass:[UITableView class]] &&
        ![_contentView isKindOfClass:[UICollectionView class]]) {
        [_contentView setUserInteractionEnabled:YES];
        [_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapContent)]];
    }
}

- (void)handleTapContent {
    if (self.dismissMode == BRCDropDownDismissModeTapContent &&
        self.contentStyle != BRCDropDownContentStyleTable) {
        [self dismiss];
    }
}

#pragma mark - setter & getter

- (CGRect)containerFrame {
    CGFloat frameX = 0;
    CGFloat frameY = 0;
    CGFloat containerWidth = self.containerSize.width;
    CGFloat containerHeight = self.containerSize.height;
    CGFloat min_x = 0;
    CGFloat max_x = kScreenWidth;
    CGFloat min_y = 0;
    CGFloat max_y = kScreenHeight;
    UIView *dropDownContainerView = self.dropDownContainerView;
    if ([dropDownContainerView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *view = (UIScrollView *)dropDownContainerView;
        min_x = dropDownContainerView.frame.origin.x;
        min_y = dropDownContainerView.frame.origin.y;
        if (view.contentSize.width == 0) {
            max_x = min_x + view.frame.size.width;
        } else {
            max_x = min_x + view.contentSize.width;
        }
        if (view.contentSize.height == 0) {
            max_y = min_y + view.frame.size.height;
        } else {
            max_y = min_y + view.contentSize.height;
        }
    } else {
        min_x = dropDownContainerView.frame.origin.x;
        max_x = dropDownContainerView.frame.origin.x + dropDownContainerView.frame.size.width;
        min_y = dropDownContainerView.frame.origin.y;
        max_y = dropDownContainerView.frame.origin.y + dropDownContainerView.frame.size.height;
    }
    if (self.popUpPosition == BRCDropDownPopUpTop) {
        frameX = self.anchorViewLeft;
        frameY = self.anchorViewTop - containerHeight - self.marginToAnchorView;
        if (self.autoCutoffRelief) {
            if (frameY < min_y) {
                frameY = min_y;
                containerHeight = self.anchorViewTop - min_y;
            }
            if (self.contentAlignment == BRCDropDownContentAlignmentLeft) {
                if (frameX + containerWidth > max_x) {
                    containerWidth = max_x - frameX;
                }
            } else if (self.contentAlignment == BRCDropDownContentAlignmentRight){
                frameX = self.anchorViewRight;
                if (frameX - containerWidth < min_x) {
                    containerWidth = frameX - min_x;
                }
            }
        }
    } else if (self.popUpPosition == BRCDropDownPopUpBottom) {
        frameX = self.anchorViewLeft;
        frameY = self.anchorViewBottom + self.marginToAnchorView;
        if (self.autoCutoffRelief) {
            if (frameY + containerHeight > max_y) {
                containerHeight = max_y - frameY;
            }
            if (self.contentAlignment == BRCDropDownContentAlignmentLeft) {
                if (frameX + containerWidth > max_x) {
                    containerWidth = max_x - frameX;
                }
            } else if (self.contentAlignment == BRCDropDownContentAlignmentRight){
                frameX = self.anchorViewRight;
                if (frameX - containerWidth < min_x) {
                    containerWidth = frameX - min_x;
                }
            }
        }
    } else if (self.popUpPosition == BRCDropDownPopUpLeft) {
        frameX = self.anchorViewLeft - containerWidth - self.marginToAnchorView;
        frameY = self.anchorViewTop;
        if (self.autoCutoffRelief) {
            if (frameX < min_x) {
                frameX = min_x;
                containerWidth = self.anchorViewLeft - min_x - self.marginToAnchorView;
            }
            if (self.contentAlignment == BRCDropDownContentAlignmentLeft) {
                if (frameY + containerHeight > max_y) {
                    containerHeight = max_y - frameY;
                }
            } else if (self.contentAlignment == BRCDropDownContentAlignmentRight){
                frameY = self.anchorViewBottom;
                if (frameY - containerHeight < min_y) {
                    containerHeight = frameY - min_y;
                }
            }
        }
    } else if (self.popUpPosition == BRCDropDownPopUpRight) {
        frameX = self.anchorViewRight + self.marginToAnchorView;
        frameY = self.anchorViewTop;
        if (self.autoCutoffRelief) {
            if (frameX + containerWidth > max_x) {
                containerWidth = max_x - frameX;
            }
            if (self.contentAlignment == BRCDropDownContentAlignmentLeft) {
                if (frameY + containerHeight > max_y) {
                    containerHeight = max_y - frameY;
                }
            } else if (self.contentAlignment == BRCDropDownContentAlignmentRight){
                frameY = self.anchorViewBottom;
                if (frameY - containerHeight < min_y) {
                    containerHeight = frameY - min_y;
                }
            }
        }
    }
    CGRect frame = CGRectMake(frameX, frameY, MAX(containerWidth, 1), MAX(containerHeight,1));
    if (self.contentAlignment == BRCDropDownContentAlignmentCenter) {
        CGPoint centerPoint = self.anchorView.center;
        if (self.popUpPosition == BRCDropDownPopUpTop ||
            self.popUpPosition == BRCDropDownPopUpBottom) {
            frame = CGRectMake(centerPoint.x - (frame.size.width / 2), frame.origin.y, frame.size.width, frame.size.height);
        } else if (self.popUpPosition == BRCDropDownPopUpLeft ||
                   self.popUpPosition == BRCDropDownPopUpRight) {
            frame = CGRectMake(frame.origin.x, centerPoint.y - (frame.size.height / 2), frame.size.width, frame.size.height);
        }
    } else if (self.contentAlignment == BRCDropDownContentAlignmentRight) {
        if (self.popUpPosition == BRCDropDownPopUpTop ||
            self.popUpPosition == BRCDropDownPopUpBottom) {
            frame = CGRectMake(self.anchorViewRight - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
        } else if (self.popUpPosition == BRCDropDownPopUpLeft ||
                   self.popUpPosition == BRCDropDownPopUpRight) {
            frame = CGRectMake(frame.origin.x, self.anchorViewBottom - frame.size.height,  frame.size.width, frame.size.height);
        }
    }
    NSLog(@"containerFrame = %@",NSStringFromCGRect(frame));
    return frame;
}

- (void)updateContainerViewWithPopupFrame {
    if ([self autoFitContainerSize]) {
        if (self.popUpPosition == BRCDropDownPopUpTop ||
            self.popUpPosition == BRCDropDownPopUpBottom) {
            _containerSize = CGSizeMake(self.anchorView.frame.size.width, self.anchorView.frame.size.width);
        } else if (self.popUpPosition == BRCDropDownPopUpLeft ||
                   self.popUpPosition == BRCDropDownPopUpRight) {
            _containerSize = CGSizeMake(self.anchorView.frame.size.height, self.anchorView.frame.size.height);
        }
        return;
    }
    CGFloat containerWidth = _containerSize.width;
    CGFloat containerHeight = _containerSize.height;
    if (self.popUpPosition == BRCDropDownPopUpTop ||
        self.popUpPosition == BRCDropDownPopUpBottom) {
        if (containerWidth == 0) {
            containerWidth = self.anchorView.frame.size.width;
        }
        if (containerHeight == 0) {
            containerHeight = containerWidth;
        }
    } else if (self.popUpPosition == BRCDropDownPopUpLeft ||
               self.popUpPosition == BRCDropDownPopUpRight) {
        if (containerHeight == 0) {
            containerHeight = self.anchorView.frame.size.height;
        }
        if (containerWidth == 0) {
            containerWidth = containerHeight;
        }
    }
    _containerSize = CGSizeMake(containerWidth, containerHeight);
}

- (void)setContentAlignment:(BRCDropDownContentAlignment)contentAlignment {
    _contentAlignment = contentAlignment;
    self.containerView.alignmentStyle = contentAlignment;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    if (self.display) {
        return;
    }
    NSLog(@"anchorPoint = %@",NSStringFromCGPoint(anchorPoint));
    UIView *view = [UIView new];
    view.frame = CGRectMake(anchorPoint.x, anchorPoint.y, 0, 0);
    self.anchorView = view;
}

- (void)setContentView:(__kindof UIView *)contentView {
    _contentView = contentView;
    [self addTapGesture];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.containerView.cornerRadius = cornerRadius;
}

- (void)setArrowCustomPosition:(CGFloat)arrowCustomPosition {
    _arrowCustomPosition = arrowCustomPosition;
    self.containerView.arrowCustomPosition = arrowCustomPosition;
}

- (void)setArrowHeight:(CGFloat)arrowHeight {
    _arrowHeight = arrowHeight;
    self.containerView.arrowHeight = arrowHeight;
}

- (void)setArrowInset:(CGFloat)arrowInset {
    _arrowInset = arrowInset;
    self.containerView.arrowInset = arrowInset;
}

- (void)setArrowRoundTopRadius:(CGFloat)arrowRoundTopRadius {
    _arrowRoundTopRadius = arrowRoundTopRadius;
    self.containerView.arrowTopRadius = arrowRoundTopRadius;
}

- (void)setArrowRoundRadius:(CGFloat)arrowRoundRadius {
    _arrowRoundRadius = arrowRoundRadius;
    self.containerView.roundRadius = arrowRoundRadius;
}

- (void)setArrowStyle:(BRCDropDownArrowStyle)arrowStyle {
    _arrowStyle = arrowStyle;
    self.containerView.arrowStyle = arrowStyle;
}

- (void)setPopUpPosition:(BRCDropDownPopUpPosition)popUpPosition {
    _popUpPosition = popUpPosition;
    self.containerView.popUpPosition = popUpPosition;
}

- (void)setArrowPosition:(BRCDropDownArrowPosition)arrowPosition {
    _arrowPosition = arrowPosition;
    self.containerView.arrowPosition = arrowPosition;
}

- (void)setPopUpAnimationStyle:(BRCDropDownPopUpAnimation)popUpAnimationStyle {
    _popUpAnimationStyle = popUpAnimationStyle;
    self.containerView.popUpAnimationStyle = popUpAnimationStyle;
}

- (void)setContainerSize:(CGSize)containerSize {
    _containerSize = containerSize;
    _containerHeight = containerSize.height;
    _containerWidth = containerSize.width;
    if (!CGSizeEqualToSize(containerSize, CGSizeZero)) {
        self.autoFitContainerSize = NO;
    }
}

- (void)setContainerHeight:(CGFloat)containerHeight {
    _containerHeight = containerHeight;
    CGSize originSize = self.containerSize;
    self.containerSize = CGSizeMake(originSize.width, containerHeight);
}

- (void)setContainerWidth:(CGFloat)containerWidth {
    _containerWidth = containerWidth;
    CGSize originSize = self.containerSize;
    self.containerSize = CGSizeMake(containerWidth, originSize.height);
}

- (BOOL)autoCutoffRelief {
    if ([self anchorViewIsFirstResponder]) {
        return NO;
    }
    return _autoCutoffRelief;
}

- (CGFloat)anchorViewLeft {
    return CGRectGetMinX(self.anchorViewFrame);
}

- (CGFloat)anchorViewRight {
    return CGRectGetMaxX(self.anchorViewFrame);
}

- (CGFloat)anchorViewTop {
    return CGRectGetMinY(self.anchorViewFrame);
}

- (CGFloat)anchorViewBottom {
    return CGRectGetMaxY(self.anchorViewFrame);
}

- (CGRect)anchorViewFrame {
    if (self.contextStyle == BRCDropDownContextStyleWindow) {
        return [self getWindowFrameForView:self.anchorView];
    }
    return self.anchorView.frame;
}

#pragma mark - utils

- (UIView *)findFirstResponderForView:(UIView *)originView {
    if ([originView isFirstResponder]) {
        return originView;
    }

    for (UIView *subview in originView.subviews) {
        UIView *firstResponder = [self findFirstResponderForView:subview];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }

    return nil;
}

- (CGRect)getWindowFrameForView:(UIView *)view {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    #pragma clang diagnostic pop
}

- (UIView *)dropDownContainerView {
    if ([self.anchorView isKindOfClass:[UIView class]]) {
        if (self.contextStyle == BRCDropDownContextStyleViewController) {
            UIViewController *anchorVC = [self findViewControllerForView:self.anchorView];
            if ([anchorVC isKindOfClass:[UIViewController class]]) {
                return anchorVC.view;
            }
        } else if (self.contextStyle == BRCDropDownContextStyleSuperView){
            if ([self.anchorView.superview isKindOfClass:[UIView class]]) {
                return self.anchorView.superview;
            }
        } else if (self.contextStyle == BRCDropDownContextStyleWindow) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                return [UIApplication sharedApplication].keyWindow;
            #pragma clang diagnostic pop
        }
    }
    return nil;
}

- (UIViewController *)findViewControllerForView:(UIView *)originView {
    for (UIView *view = originView; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
   return nil;
}

#pragma mark - props

- (BRCBubbleBackgroundView *)containerView {
    if (!_containerView) {
        _containerView =  [[BRCBubbleBackgroundView alloc] init];
        _containerView.cornerRadius = self.cornerRadius;
        _containerView.arrowInset = self.arrowInset;
        _containerView.arrowStyle = self.arrowStyle;
        _containerView.popUpPosition = self.popUpPosition;
        _containerView.arrowPosition = self.arrowPosition;
        _containerView.popUpAnimationStyle = self.popUpAnimationStyle;
        _containerView.roundRadius = self.arrowRoundRadius;
        _containerView.arrowTopRadius = self.arrowRoundTopRadius;
        _containerView.backgroundColor = self.backgroundColor;
        _containerView.layer.zPosition = CGFLOAT_MAX;
    }
    return _containerView;
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(checkFrame)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink setPaused:YES];
    }
    return _displayLink;
}

@end

static NSString *const kBRCDropDownCellID = @"BRCDropDownCellID";

@implementation BRCDropDown (DropDownContent)

#pragma mark - public

- (void)setDataSourceArray:(NSArray *)array {
    if (![self.contentView isKindOfClass:[UITableView class]]) {
        return;
    }
    self.dataSource = array;
    [(UITableView *)self.contentView reloadData];
}

- (void)setDataSourceDict:(NSDictionary *)dict {
    if (![self.contentView isKindOfClass:[UITableView class]]) {
        return;
    }
    self.dataSource = dict;
    [(UITableView *)self.contentView reloadData];
}

- (void)setContentText:(NSString *)contentText {
    if (![self.contentView isKindOfClass:[UILabel class]]) {
        return;
    }
    [(UILabel *)self.contentView setText:contentText];
}

- (void)setContentImage:(UIImage *)image {
    if (![self.contentView isKindOfClass:[UIImageView class]]) {
        return;
    }
    [(UIImageView *)self.contentView setImage:image];
}

- (void)setContentImageUrl:(NSString *)imageUrl {
    if (![self.contentView isKindOfClass:[UIImageView class]]) {
        return;
    }
    if (self.webImageLoadBlock) {
        self.webImageLoadBlock(self.contentView, [NSURL URLWithString:imageUrl]);
    }
}

- (BOOL)autoFitContainerSize {
    if (CGSizeEqualToSize(self.containerSize, CGSizeZero)) {
        return YES;
    }
    return _autoFitContainerSize;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dismissMode == BRCDropDownDismissModeTapContent) {
        [self dismiss];
    }
    if ([self.dataSource isKindOfClass:[NSArray class]]) {
        if (indexPath.row < [self.dataSource count]) {
            id value = self.dataSource[indexPath.row];
            if ([value isKindOfClass:[BRCDropDownItem class]]) {
                if ([(BRCDropDownItem *)value clickBlock]) {
                    [value clickBlock](indexPath);
                    return;
                }
            }
        }
    } else if ([self.dataSource isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [(NSDictionary *)self.dataSource allKeys];
        if (indexPath.section < keys.count) {
            id key = keys[indexPath.section];
            if (key) {
                id values = self.dataSource[key];
                if ([values isKindOfClass:[NSArray class]] &&
                    indexPath.row < [values count]) {
                    id value = values[indexPath.row];
                    if ([value isKindOfClass:[BRCDropDownItem class]]) {
                        BRCDropDownItem *item = (BRCDropDownItem *)value;
                        if (item.clickBlock) {
                            item.clickBlock(indexPath);
                            return;
                        }
                    }
                }
            }
        }
    }
    if (self.onClickItem) self.onClickItem(indexPath);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.dataSource isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [(NSDictionary *)self.dataSource allKeys];
        if (section < keys.count) {
            id key = keys[section];
            if ([key isKindOfClass:[NSString class]]) {
                return key;
            }
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self.dataSource allKeys].count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [(NSDictionary *)self.dataSource allKeys];
        if (section < keys.count) {
            id key = keys[section];
            id value = self.dataSource[key];
            if ([value isKindOfClass:[NSArray class]]) {
                return [value count];
            }
        }
    }
    if ([self.dataSource isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self.dataSource count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBRCDropDownCellID forIndexPath:indexPath];
    cell.backgroundColor = self.backgroundColor;
    cell.textLabel.textColor = self.contentTextColor;
    cell.imageView.tintColor = self.contentTintColor;
    if ([self.dataSource isKindOfClass:[NSArray class]]) {
        id cellModel = self.dataSource[indexPath.row];
        if ([cellModel isKindOfClass:[NSString class]]) {
            cell.textLabel.text = cellModel;
        } else if ([cellModel isKindOfClass:[BRCDropDownItem class]]) {
            BRCDropDownItem *item = (BRCDropDownItem *)cellModel;
            cell.textLabel.text = item.itemText;
            if ([item.itemImage isKindOfClass:[UIImage class]]) {
                cell.imageView.image = item.itemImage;
            } else if ([item.itemImageUrl isKindOfClass:[NSString class]]) {
                if (self.webImageLoadBlock) {
                    self.webImageLoadBlock(self.contentView, [NSURL URLWithString:item.itemImageUrl]);
                }
            }
        }
    }
    if ([self.dataSource isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [(NSDictionary *)self.dataSource allKeys];
        if (indexPath.section < keys.count) {
            id key = keys[indexPath.section];
            if (key) {
                id values = self.dataSource[key];
                if ([values isKindOfClass:[NSArray class]] &&
                    indexPath.row < [values count]) {
                    id value = values[indexPath.row];
                    if ([value isKindOfClass:[NSString class]]) {
                        cell.textLabel.text = value;
                    } else if ([value isKindOfClass:[BRCDropDownItem class]]) {
                        BRCDropDownItem *item = (BRCDropDownItem *)value;
                        cell.textLabel.text = item.itemText;
                        if ([item.itemImage isKindOfClass:[UIImage class]]) {
                            cell.imageView.image = item.itemImage;
                        } else if ([item.itemImageUrl isKindOfClass:[NSString class]]) {
                            if (self.webImageLoadBlock) {
                                self.webImageLoadBlock(self.contentView, [NSURL URLWithString:item.itemImageUrl]);
                            }
                        }
                    }
                }
            }
        }
    }
    return cell;
}

#pragma mark - props

- (__kindof UIView *)contentView {
    if (!_contentView) {
        if (self.contentStyle == BRCDropDownContentStyleTable) {
            UITableView *tableView = [[UITableView alloc] init];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = self.backgroundColor;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBRCDropDownCellID];
            _contentView = tableView;
        } else if (self.contentStyle == BRCDropDownContentStyleText) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = self.contentTextColor;
            label.backgroundColor = self.backgroundColor;
            _contentView = label;
        } else if (self.contentStyle == BRCDropDownContentStyleImage) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = self.backgroundColor;
            _contentView = imageView;
        }
        [self addTapGesture];
    }
    return _contentView;
}

@end

@implementation BRCBubbleBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [super setBackgroundColor:[UIColor clearColor]];
        _arrowCustomPosition = 0;
        _arrowHeight = 10;
        _arrowInset = 20;
        _cornerRadius = 10;
        _roundRadius = 4;
        _arrowTopRadius = 4;
        _animationDuration = 0.2;
        _popUpAnimationStyle = BRCDropDownPopUpAnimationFade;
        [self.layer addSublayer:self.bubbleLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.arrowStyle == BRCDropDownArrowStyleNone) {
        self.contentView.frame = self.bounds;
    } else {
        if (self.popUpPosition == BRCDropDownPopUpTop) {
            self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.triangleHeight);
        } else if (self.popUpPosition == BRCDropDownPopUpLeft) {
            self.contentView.frame = CGRectMake(0, 0, self.frame.size.width - self.triangleHeight, self.frame.size.height);
        } else if (self.popUpPosition == BRCDropDownPopUpBottom) {
            self.contentView.frame = CGRectMake(0, self.triangleHeight, self.frame.size.width, self.frame.size.height - self.triangleHeight);
        } else if (self.popUpPosition == BRCDropDownPopUpRight) {
            self.contentView.frame = CGRectMake(self.triangleHeight, 0, self.frame.size.width - self.triangleHeight, self.frame.size.height);
        }
    }
}

- (void)updateBackgroundPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.popUpPosition == BRCDropDownPopUpBottom) {
        path = [self createBottomPath];
    } else if (self.popUpPosition == BRCDropDownPopUpTop) {
        path = [self createTopPath];
    } else if (self.popUpPosition == BRCDropDownPopUpLeft) {
        path = [self createLeftPath];
    } else if (self.popUpPosition == BRCDropDownPopUpRight){
        path = [self createRightPath];
    }
    self.bubbleLayer.path = path.CGPath;
}

- (UIBezierPath *)createTopPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat arrowY = self.frame.size.height - self.triangleHeight;
    if (self.arrowStyle == BRCDropDownArrowStyleNone) {
        [path moveToPoint:CGPointMake(self.cornerRadius,arrowY)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRightangle) {
        CGFloat startPointX = 0;
        CGFloat startPointX1 = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointX = self.arrowInset;
            startPointX1 = startPointX + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointX = self.frame.size.width / 2;
            startPointX1 = startPointX + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointX = self.frame.size.width - self.arrowInset - self.triangleHeight;
            startPointX1 = startPointX + self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(startPointX1, arrowY)];
        [path addLineToPoint:CGPointMake(startPointX, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(startPointX, arrowY)];
        [path addLineToPoint:CGPointMake(self.cornerRadius, arrowY)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleEquilateral) {
        CGFloat startPointX = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointX = self.arrowInset;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointX = self.frame.size.width / 2 - self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointX = self.frame.size.width - self.arrowInset - self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(startPointX + self.triangleHeight, arrowY)];
        [path addLineToPoint:CGPointMake(startPointX + self.triangleHeight / 2, self.frame.size.height)];
        [path addLineToPoint:CGPointMake(startPointX, arrowY)];
        [path addLineToPoint:CGPointMake(self.cornerRadius, arrowY)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
        CGFloat startPointX = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointX = self.arrowInset + (self.roundRadius * 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointX = self.frame.size.width / 2 - (self.triangleHeight / 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointX = self.frame.size.width - self.arrowInset - self.triangleHeight - (self.roundRadius * 2);
        }
        [path moveToPoint:CGPointMake(startPointX + self.triangleHeight + (self.roundRadius * 2), arrowY)];
        [path addCurveToPoint:CGPointMake(startPointX + self.triangleHeight / 2 , self.frame.size.height)
                controlPoint1:CGPointMake(startPointX + self.triangleHeight / 2 + self.roundRadius, arrowY)
                controlPoint2:CGPointMake(startPointX + self.triangleHeight / 2, self.frame.size.height + self.arrowTopRadius)];
        
        [path addCurveToPoint:CGPointMake(startPointX - (self.roundRadius * 2), arrowY)
                controlPoint1:CGPointMake(startPointX + self.triangleHeight / 2, self.frame.size.height + self.arrowTopRadius)
                controlPoint2:CGPointMake(startPointX + self.triangleHeight / 2 - self.roundRadius, arrowY)];
        
        [path addLineToPoint:CGPointMake(self.cornerRadius, arrowY)];
    }
    // 左下
    [path addArcWithCenter:CGPointMake(self.cornerRadius, arrowY - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:3 * M_PI_2
                  endAngle:M_PI
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(0, self.cornerRadius)];
    // 左上
    [path addArcWithCenter:CGPointMake(self.cornerRadius,self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:M_PI
                  endAngle:3 * M_PI_2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.cornerRadius, 0)];
    // 右上
    [path addArcWithCenter:CGPointMake(self.frame.size.width - self.cornerRadius,  self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:3 * M_PI_2
                  endAngle:0
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width, arrowY - self.cornerRadius)];
    // 右下
    [path addArcWithCenter:CGPointMake(self.frame.size.width - self.cornerRadius, arrowY - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:0
                  endAngle:3 * M_PI_2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.cornerRadius, arrowY)];
    [path closePath];
    return path;
}

- (UIBezierPath *)createBottomPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.arrowStyle == BRCDropDownArrowStyleNone) {
        [path moveToPoint:CGPointMake(self.cornerRadius, self.triangleHeight)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRightangle) {
        CGFloat startPointX = 0;
        CGFloat startPointX1 = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointX = self.arrowInset;
            startPointX1 = startPointX + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointX = self.frame.size.width / 2;
            startPointX1 = startPointX + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointX = self.frame.size.width - self.arrowInset - self.triangleHeight;
            startPointX1 = startPointX + self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(startPointX1, self.triangleHeight)];
        [path addLineToPoint:CGPointMake(startPointX, 0)];
        [path addLineToPoint:CGPointMake(startPointX, self.triangleHeight)];
        [path addLineToPoint:CGPointMake(self.cornerRadius, self.triangleHeight)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleEquilateral) {
        CGFloat startPointX = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointX = self.arrowInset + (self.roundRadius * 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointX = self.frame.size.width / 2 - (self.triangleHeight / 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointX = self.frame.size.width - self.arrowInset - self.triangleHeight - (self.roundRadius * 2);
        }
        [path moveToPoint:CGPointMake(startPointX + self.triangleHeight, self.triangleHeight)];
        [path addLineToPoint:CGPointMake(startPointX + self.triangleHeight / 2, 0)];
        [path addLineToPoint:CGPointMake(startPointX, self.triangleHeight)];
        [path addLineToPoint:CGPointMake(self.cornerRadius, self.triangleHeight)];
    }  else if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
        CGFloat startPointX = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointX = self.arrowInset + (self.roundRadius * 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointX = self.frame.size.width / 2 - (self.triangleHeight / 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointX = self.frame.size.width - self.arrowInset - self.triangleHeight - (self.roundRadius * 2);
        }
        
        [path moveToPoint:CGPointMake(startPointX + self.triangleHeight + (self.roundRadius * 2), self.triangleHeight)];
        
        [path addCurveToPoint:CGPointMake(startPointX + self.triangleHeight / 2 , 0)
                controlPoint1:CGPointMake(startPointX + self.triangleHeight / 2 + self.roundRadius, self.triangleHeight)
                controlPoint2:CGPointMake(startPointX + self.triangleHeight / 2,  -self.arrowTopRadius)];

        [path addCurveToPoint:CGPointMake(startPointX - (self.roundRadius * 2), self.triangleHeight)
                controlPoint1:CGPointMake(startPointX + self.triangleHeight / 2, -self.arrowTopRadius)
                controlPoint2:CGPointMake(startPointX + self.triangleHeight / 2 - self.roundRadius, self.triangleHeight)];
        
        [path addLineToPoint:CGPointMake(self.cornerRadius, self.triangleHeight)];
    }
    // 左上
    [path addArcWithCenter:CGPointMake(self.cornerRadius, self.triangleHeight + self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:M_PI_2
                  endAngle:M_PI
                 clockwise:NO];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height - self.cornerRadius)];
    // 左下
    [path addArcWithCenter:CGPointMake(self.cornerRadius, self.frame.size.height - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:M_PI
                  endAngle:M_PI_2
                 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.cornerRadius, self.frame.size.height)];
    // 右下
    [path addArcWithCenter:CGPointMake(self.frame.size.width - self.cornerRadius, self.frame.size.height - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:3 * M_PI_2
                  endAngle:M_PI * 2
                 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.triangleHeight + self.cornerRadius)];
    // 右上
    [path addArcWithCenter:CGPointMake(self.frame.size.width - self.cornerRadius, self.triangleHeight + self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:2 * M_PI
                  endAngle:2 * M_PI - M_PI_2
                 clockwise:NO];
    [path addLineToPoint:CGPointMake(self.arrowInset + self.triangleHeight, self.triangleHeight)];
    [path closePath];
    return path;
}

- (UIBezierPath *)createLeftPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat arrowX = self.frame.size.width -  self.triangleHeight;
    if (self.arrowStyle == BRCDropDownArrowStyleNone) {
        [path moveToPoint:CGPointMake(arrowX, self.cornerRadius)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRightangle) {
        CGFloat startPointY = 0;
        CGFloat startPointY1 = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointY = self.arrowInset;
            startPointY1 = self.arrowInset + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointY = self.frame.size.height / 2;
            startPointY1 = self.frame.size.height / 2 + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointY = self.frame.size.height - self.arrowInset - self.triangleHeight;
            startPointY1 = self.frame.size.height - self.arrowInset;
        }
        [path moveToPoint:CGPointMake(arrowX, startPointY1)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, startPointY)];
        [path addLineToPoint:CGPointMake(arrowX, startPointY)];
        [path addLineToPoint:CGPointMake(arrowX, self.cornerRadius)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleEquilateral) {
        CGFloat startPointY = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointY = self.arrowInset + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointY = self.frame.size.height / 2 + self.triangleHeight/2;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointY = self.frame.size.height - self.arrowInset - self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(arrowX, startPointY)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, startPointY - self.triangleHeight/2)];
        [path addLineToPoint:CGPointMake(arrowX, startPointY - self.triangleHeight)];
        [path addLineToPoint:CGPointMake(arrowX, self.cornerRadius)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
        CGFloat startPointY = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointY = self.arrowInset + self.triangleHeight + (self.roundRadius * 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointY = self.frame.size.height / 2 + self.triangleHeight/2;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointY = self.frame.size.height - self.arrowInset - self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(arrowX, (startPointY + self.roundRadius * 2))];
        
        [path addCurveToPoint:CGPointMake(self.frame.size.width, startPointY - self.triangleHeight/2)
                controlPoint1:CGPointMake(arrowX, (startPointY + self.roundRadius))
                controlPoint2:CGPointMake(self.frame.size.width + self.arrowTopRadius, startPointY - self.triangleHeight/2)];
        
        [path addCurveToPoint:CGPointMake(arrowX, startPointY - self.triangleHeight - (self.roundRadius * 2))
                controlPoint1:CGPointMake(self.frame.size.width + self.arrowTopRadius, startPointY - self.triangleHeight/2)
                controlPoint2:CGPointMake(arrowX, startPointY - self.triangleHeight - self.roundRadius)];
        
        [path addLineToPoint:CGPointMake(arrowX, self.cornerRadius)];
    }
    
    // 右上
    [path addArcWithCenter:CGPointMake(arrowX - self.cornerRadius, self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:0
                  endAngle:-M_PI_2
                 clockwise:NO];
    
    [path addLineToPoint:CGPointMake(self.cornerRadius, 0)];
    
    // 左上
    [path addArcWithCenter:CGPointMake(self.cornerRadius, self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:-M_PI_2
                  endAngle:-M_PI
                 clockwise:NO];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height - self.cornerRadius)];
    
    // 左下
    [path addArcWithCenter:CGPointMake(self.cornerRadius, self.frame.size.height - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:-M_PI
                  endAngle:-3 * M_PI_2
                 clockwise:NO];
    [path addLineToPoint:CGPointMake(arrowX - self.cornerRadius, self.frame.size.height)];
    
    // 右下
    [path addArcWithCenter:CGPointMake(arrowX-self.cornerRadius, self.frame.size.height - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:-3 * M_PI_2
                  endAngle:0
                 clockwise:NO];
    [path closePath];
    return path;
}

- (UIBezierPath *)createRightPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat arrowX = self.triangleHeight;
    if (self.arrowStyle == BRCDropDownArrowStyleNone) {
        [path moveToPoint:CGPointMake(arrowX, self.cornerRadius)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRightangle) {
        CGFloat startPointY = 0;
        CGFloat startPointY1 = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointY = self.arrowInset;
            startPointY1 = self.arrowInset + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointY = self.frame.size.height / 2;
            startPointY1 = self.frame.size.height / 2 + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight){
            startPointY = self.frame.size.height - self.arrowInset - self.triangleHeight;
            startPointY1 = self.frame.size.height - self.arrowInset;
        }
        [path moveToPoint:CGPointMake(arrowX, startPointY1)];
        [path addLineToPoint:CGPointMake(0, startPointY)];
        [path addLineToPoint:CGPointMake(arrowX, startPointY)];
        [path addLineToPoint:CGPointMake(arrowX, self.cornerRadius)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleEquilateral) {
        CGFloat startPointY = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointY = self.arrowInset + self.triangleHeight;
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointY = self.frame.size.height / 2 + self.triangleHeight / 2;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight){
            startPointY = self.frame.size.height - self.arrowInset - self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(arrowX, startPointY)];
        [path addLineToPoint:CGPointMake(0, startPointY - self.triangleHeight/2)];
        [path addLineToPoint:CGPointMake(arrowX, startPointY - self.triangleHeight)];
        [path addLineToPoint:CGPointMake(arrowX, self.cornerRadius)];
    } else if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
        CGFloat startPointY = 0;
        if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
            startPointY = self.arrowInset + self.triangleHeight + (self.roundRadius * 2);
        } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
            startPointY = self.frame.size.height / 2 + self.triangleHeight/2;
        } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
            startPointY = self.frame.size.height - self.arrowInset - self.triangleHeight;
        }
        [path moveToPoint:CGPointMake(arrowX, (startPointY + self.roundRadius * 2))];
        
        [path addCurveToPoint:CGPointMake(0, startPointY - self.triangleHeight/2)
                controlPoint1:CGPointMake(arrowX, (startPointY + self.roundRadius))
                controlPoint2:CGPointMake(-self.arrowTopRadius, startPointY - self.triangleHeight/2)];
        
        [path addCurveToPoint:CGPointMake(arrowX, startPointY - self.triangleHeight - (self.roundRadius * 2))
                controlPoint1:CGPointMake(-self.arrowTopRadius, startPointY - self.triangleHeight/2)
                controlPoint2:CGPointMake(arrowX, startPointY - self.triangleHeight - self.roundRadius)];
        
        [path addLineToPoint:CGPointMake(arrowX, self.cornerRadius)];
    }
    
    // 左上
    [path addArcWithCenter:CGPointMake(arrowX + self.cornerRadius, self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:M_PI
                  endAngle:3 * M_PI_2
                 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(self.frame.size.width - self.cornerRadius, 0)];
    
    // 右上
    [path addArcWithCenter:CGPointMake(self.frame.size.width - self.cornerRadius, self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:3 * M_PI_2
                  endAngle:0
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(self.frame.size.width , self.frame.size.height - self.cornerRadius)];
    
    // 右下
    [path addArcWithCenter:CGPointMake(self.frame.size.width - self.cornerRadius, self.frame.size.height - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:0
                  endAngle:M_PI_2
                 clockwise:YES];
    [path addLineToPoint:CGPointMake(arrowX + self.cornerRadius, self.frame.size.height)];
    
    // 右下
    [path addArcWithCenter:CGPointMake(arrowX + self.cornerRadius, self.frame.size.height - self.cornerRadius)
                    radius:self.cornerRadius
                startAngle:M_PI_2
                  endAngle:M_PI
                 clockwise:YES];
    [path closePath];
    return path;
}

- (void)showAnimatedWithFrame:(CGRect)frame completion:(void (^ __nullable)(BOOL finished))completion {
    self.frame = frame;
    self.layer.transform = CATransform3DIdentity;
    self.layer.opacity = 1;
    [self.layer removeAllAnimations];
    [self setUpArrowAnimationAnchorPoint];
    self.bubbleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self updateBackgroundPath];
    if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationNone) {
        completion(YES);
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFade) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *keyFrameAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity"];
        keyFrameAnimation.values = @[@0,@1];
        [self.layer addAnimation:keyFrameAnimation forKey:@"opacityAnimation"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationScale) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *keyFrameAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale"];
        keyFrameAnimation.values = @[@0,@1];
        [self.layer addAnimation:keyFrameAnimation forKey:@"scaleAnimation"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationBounce) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *keyFrameAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale"];
        keyFrameAnimation.values = @[@0.9,@1.1,@1.0];
        [self.layer addAnimation:keyFrameAnimation forKey:@"bounceAnimation"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeScale) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *scaleAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@0,@1];
        scaleAnimation.delegate = nil;
        CAKeyframeAnimation *opacityAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity"];
        opacityAnimation.delegate = nil;
        opacityAnimation.values = @[@0,@1];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[scaleAnimation,opacityAnimation];
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.duration = self.animationDuration;
        group.delegate = self;
        [self.layer addAnimation:group forKey:@"animations"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeBounce) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *scaleAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@0.9,@1.1,@1.0];
        scaleAnimation.delegate = nil;
        CAKeyframeAnimation *opacityAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity"];
        opacityAnimation.delegate = nil;
        opacityAnimation.values = @[@0,@1];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[scaleAnimation,opacityAnimation];
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.duration = self.animationDuration;
        group.delegate = self;
        [self.layer addAnimation:group forKey:@"animations"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationHeightExpansion) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *heightAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale.y"];
        heightAnimation.values = @[@0,@1.0];
        heightAnimation.delegate = self;
        [self.layer addAnimation:heightAnimation forKey:@"heightAnimation"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeHeightExpansion) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *scaleAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale.y"];
        scaleAnimation.values = @[@0,@1.0];
        scaleAnimation.delegate = nil;
        CAKeyframeAnimation *opacityAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity"];
        opacityAnimation.delegate = nil;
        opacityAnimation.values = @[@0,@1];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[scaleAnimation,opacityAnimation];
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.duration = self.animationDuration;
        group.delegate = self;
        [self.layer addAnimation:group forKey:@"animations"];
    }

}

- (void)dismissAnimatedWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [self.layer removeAllAnimations];
    if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationNone) {
        completion(YES);
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFade ||
               self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeHeightExpansion ||
               self.popUpAnimationStyle == BRCDropDownPopUpAnimationHeightExpansion) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *keyFrameAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity"];
        keyFrameAnimation.values = @[@1,@0];
        [self.layer addAnimation:keyFrameAnimation forKey:@"opacityAnimation"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationScale ||
               self.popUpAnimationStyle == BRCDropDownPopUpAnimationBounce) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *keyFrameAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale"];
        keyFrameAnimation.values = @[@1,@0];
        [self.layer addAnimation:keyFrameAnimation forKey:@"scaleAnimation"];
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeBounce ||
               self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeScale) {
        self.dismissAnimationFinishBlock = completion;
        CAKeyframeAnimation *scaleAnimation = [self createKeyFrameAnimationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@1,@0];
        scaleAnimation.delegate = nil;
        CAKeyframeAnimation *opacityAnimation = [self createKeyFrameAnimationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1,@0];
        opacityAnimation.delegate = nil;
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[scaleAnimation,opacityAnimation];
        group.duration = self.animationDuration;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.delegate = self;
        [self.layer addAnimation:group forKey:@"animations"];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.dismissAnimationFinishBlock) self.dismissAnimationFinishBlock(flag);
}

- (CAKeyframeAnimation *)createKeyFrameAnimationWithKeyPath:(NSString *)keyPath {
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    keyFrameAnimation.duration = self.animationDuration;
    keyFrameAnimation.delegate = self;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    return keyFrameAnimation;
}

#pragma mark - darkmode

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    self.bubbleLayer.fillColor = self.fillColor.CGColor;
}

#pragma mark - setter & getter

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.fillColor = backgroundColor;
    self.bubbleLayer.fillColor = backgroundColor.CGColor;
}

- (CGFloat)arrowInset {
    if (self.arrowPosition == BRCDropDownArrowPositionAnchorCenter) {
        CGFloat inset = 0;
        if (self.alignmentStyle == BRCDropDownContentAlignmentLeft) {
            switch (self.popUpPosition) {
                case BRCDropDownPopUpBottom:
                case BRCDropDownPopUpTop:
                    inset = (self.anchorViewSize.width / 2) - self.arrowHeight;
                    break;
                case BRCDropDownPopUpLeft:
                case BRCDropDownPopUpRight:
                    inset = (self.anchorViewSize.height / 2) - self.arrowHeight;
                    break;
            }
        } else if (self.alignmentStyle == BRCDropDownContentAlignmentRight) {
            switch (self.popUpPosition) {
                case BRCDropDownPopUpBottom:
                case BRCDropDownPopUpTop:
                    inset = (self.frame.size.width - self.anchorViewSize.width / 2) - self.arrowHeight;
                    break;
                case BRCDropDownPopUpLeft:
                case BRCDropDownPopUpRight:
                    inset = (self.frame.size.height - self.anchorViewSize.height / 2) - self.arrowHeight;
                    break;
            }
        } else if (self.alignmentStyle == BRCDropDownContentAlignmentCenter) {
            switch (self.popUpPosition) {
                case BRCDropDownPopUpBottom:
                case BRCDropDownPopUpTop:
                    inset = self.frame.size.width / 2 - self.arrowHeight;
                    break;
                case BRCDropDownPopUpLeft:
                case BRCDropDownPopUpRight:
                    inset = self.frame.size.height / 2 - self.arrowHeight;
                    break;
            }
        }
        if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
            inset -= self.roundRadius * 2;
        }
        return inset;
    } else if (self.arrowPosition == BRCDropDownArrowPositionCustom) {
        CGFloat inset = 0;
        switch (self.popUpPosition) {
            case BRCDropDownPopUpBottom:
            case BRCDropDownPopUpTop:
                inset = self.frame.size.width * self.arrowCustomPosition;
                break;
            case BRCDropDownPopUpLeft:
            case BRCDropDownPopUpRight:
                inset = self.frame.size.height * self.arrowCustomPosition;
                break;
        }
        if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
            inset -= self.roundRadius * 2;
        }
        return inset;
    }
    return _arrowInset;
}

- (CGFloat)triangleHeight {
    if (self.arrowStyle == BRCDropDownArrowStyleNone) {
        return 0;
    }
    return self.arrowHeight;
}

- (CGFloat)getArrowPosition {
    if (self.arrowPosition == BRCDropDownArrowPositionLeft ||
            self.arrowPosition == BRCDropDownArrowPositionAnchorCenter ||
            self.arrowPosition == BRCDropDownArrowPositionCustom) {
        if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
            return self.arrowInset + (self.roundRadius * 2);
        }
        return self.arrowInset;
    } else if (self.arrowPosition == BRCDropDownArrowPositionCenter) {
        switch (self.popUpPosition) {
            case BRCDropDownPopUpBottom:
            case BRCDropDownPopUpTop:
                return self.frame.size.width / 2;
            case BRCDropDownPopUpLeft:
            case BRCDropDownPopUpRight:
                return self.frame.size.height / 2;
        }
    } else if (self.arrowPosition == BRCDropDownArrowPositionRight) {
        switch (self.popUpPosition) {
            case BRCDropDownPopUpBottom:
            case BRCDropDownPopUpTop:
                if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
                    return self.frame.size.width - self.arrowInset - (self.roundRadius * 2);
                }
                return (self.frame.size.width - self.arrowInset);
            case BRCDropDownPopUpLeft:
            case BRCDropDownPopUpRight:
                if (self.arrowStyle == BRCDropDownArrowStyleRoundEquilateral) {
                    return self.frame.size.height - self.arrowInset - (self.roundRadius * 2);
                }
                return (self.frame.size.height - self.arrowInset);
        }
    }
    return 0;
}

- (void)setUpArrowAnimationAnchorPoint {
    if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationScale ||
        self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeScale ||
        self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeBounce ||
        self.popUpAnimationStyle == BRCDropDownPopUpAnimationBounce) {
        if (self.popUpPosition == BRCDropDownPopUpBottom) {
            self.layer.anchorPoint = CGPointMake((self.getArrowPosition / self.frame.size.width), 0);
        } else if (self.popUpPosition == BRCDropDownPopUpTop) {
            self.layer.anchorPoint = CGPointMake((self.getArrowPosition / self.frame.size.width), 1);
        } else if (self.popUpPosition == BRCDropDownPopUpLeft) {
            self.layer.anchorPoint = CGPointMake(1, (self.getArrowPosition / self.frame.size.height));
        } else if (self.popUpPosition == BRCDropDownPopUpRight) {
            self.layer.anchorPoint = CGPointMake(0, (self.getArrowPosition / self.frame.size.height));
        }
    } else if (self.popUpAnimationStyle == BRCDropDownPopUpAnimationFadeHeightExpansion ||
               self.popUpAnimationStyle == BRCDropDownPopUpAnimationHeightExpansion){
        self.layer.anchorPoint = CGPointMake(0.5, 0);
    } else {
        self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
}

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    _contentView.layer.cornerRadius = self.cornerRadius;
    _contentView.layer.cornerCurve = kCACornerCurveContinuous;
    _contentView.clipsToBounds = YES;
    [self addSubview:self.contentView];
    [self layoutIfNeeded];
}

- (void)setLayerShadow:(UIColor *)color
                offset:(CGSize)offset
                radius:(CGFloat)radius
               opacity:(CGFloat)opacity {
    _bubbleLayer.shadowOffset = offset;
    _bubbleLayer.shadowRadius = radius;
    _bubbleLayer.shadowColor = color.CGColor;
    _bubbleLayer.shadowOpacity = opacity;
}

#pragma mark - props

- (CAShapeLayer *)bubbleLayer {
    if (!_bubbleLayer) {
        _bubbleLayer = [[CAShapeLayer alloc] init];
    }
    return _bubbleLayer;
}

@end

    
