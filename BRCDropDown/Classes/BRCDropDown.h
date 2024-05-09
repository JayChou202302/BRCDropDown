//
//  BRCDropDown.h
//
//  Created by sunzhixiong on 2024/3/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BRCDropDownPopUpPosition) {
    BRCDropDownPopUpTop = 0,
    BRCDropDownPopUpBottom,
    BRCDropDownPopUpLeft,
    BRCDropDownPopUpRight
};

typedef NS_ENUM(NSInteger,BRCDropDownPopUpAnimation) {
    BRCDropDownPopUpAnimationNone = 0,
    BRCDropDownPopUpAnimationFade,
    BRCDropDownPopUpAnimationScale,
    BRCDropDownPopUpAnimationBounce,
    BRCDropDownPopUpAnimationFadeScale,
    BRCDropDownPopUpAnimationFadeBounce,
    BRCDropDownPopUpAnimationFadeHeightExpansion,
    BRCDropDownPopUpAnimationHeightExpansion,
};

typedef NS_ENUM(NSInteger,BRCDropDownContentStyle) {
    BRCDropDownContentStyleTable = 0,
    BRCDropDownContentStyleText,
    BRCDropDownContentStyleImage,
    BRCDropDownContentStyleCustom
};

typedef NS_ENUM(NSInteger,BRCDropDownContentAlignment) {
    BRCDropDownContentAlignmentLeft = 0,
    BRCDropDownContentAlignmentCenter,
    BRCDropDownContentAlignmentRight,
};

typedef NS_ENUM(NSInteger,BRCDropDownContextStyle) {
    BRCDropDownContextStyleWindow = 0,
    BRCDropDownContextStyleSuperView,
    BRCDropDownContextStyleViewController
};

typedef NS_ENUM(NSInteger,BRCDropDownDismissMode) {
    BRCDropDownDismissModeNone,
    BRCDropDownDismissModeTapContent,
};

typedef NS_ENUM(NSInteger,BRCDropDownArrowPosition) {
    BRCDropDownArrowPositionLeft = 0,
    BRCDropDownArrowPositionCenter,
    BRCDropDownArrowPositionRight,
    BRCDropDownArrowPositionAnchorCenter,
    BRCDropDownArrowPositionCustom
};

typedef NS_ENUM(NSInteger,BRCDropDownArrowStyle) {
    BRCDropDownArrowStyleNone = 0,
    BRCDropDownArrowStyleRightangle,
    BRCDropDownArrowStyleEquilateral,
    BRCDropDownArrowStyleRoundEquilateral
};

NS_ASSUME_NONNULL_BEGIN

@class BRCDropDownItem;

typedef void (^BRCDropDownItemClickBlock)(NSIndexPath *itemIndex);

@interface BRCDropDownItem : NSObject

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, strong) UIImage  *itemImage;
@property (nonatomic, strong) NSString *itemImageUrl;
@property (nonatomic, copy)   BRCDropDownItemClickBlock clickBlock;

- (instancetype)initWithText:(NSString *)text
                       image:(UIImage *)image
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

+ (instancetype)itemWithText:(NSString *)text
                       image:(UIImage *)image
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

- (instancetype)initWithText:(NSString *)text
                    imageUrl:(NSString *)imageUrl
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

+ (instancetype)itemWithText:(NSString *)text
                    imageUrl:(NSString *)imageUrl
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

- (instancetype)initWithText:(NSString *)text
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

+ (instancetype)itemWithText:(NSString *)text
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

- (instancetype)initWithImage:(UIImage *)image
                 onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

+ (instancetype)itemWithImage:(UIImage *)image
                 onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                    onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

+ (instancetype)itemWithImageUrl:(NSString *)imageUrl
                    onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

@end

@interface BRCDropDown : NSObject

#pragma mark - arrow custom
@property (nonatomic, assign) BRCDropDownArrowPosition  arrowPosition;
@property (nonatomic, assign) BRCDropDownArrowStyle     arrowStyle;
@property (nonatomic, assign) CGFloat                   arrowHeight;
@property (nonatomic, assign) CGFloat                   arrowRoundRadius;
@property (nonatomic, assign) CGFloat                   arrowRoundTopRadius;
@property (nonatomic, assign) CGFloat                   arrowInset;
@property (nonatomic, assign) CGFloat                   arrowCustomPosition;

#pragma mark - popup custom
@property (nonatomic, assign) BRCDropDownPopUpPosition  popUpPosition;
@property (nonatomic, assign) BRCDropDownPopUpAnimation popUpAnimationStyle;
@property (nonatomic, assign) CGFloat                   animationDuration;

#pragma mark - style
@property (nonatomic, assign) BRCDropDownContextStyle       contextStyle;
@property (nonatomic, assign) BRCDropDownContentStyle       contentStyle;
@property (nonatomic, assign) BRCDropDownContentAlignment   contentAlignment;
@property (nonatomic, assign) BRCDropDownDismissMode        dismissMode;

@property (nonatomic, strong) UIColor                   *backgroundColor;
@property (nonatomic, strong) UIColor                   *contentTextColor;
@property (nonatomic, strong) UIColor                   *contentTintColor;
@property (nonatomic, assign) CGFloat                   borderWidth;
@property (nonatomic, assign) CGFloat                   cornerRadius;

@property (nonatomic, assign) CGSize                    containerSize;
@property (nonatomic, assign) CGFloat                   containerHeight;
@property (nonatomic, assign) CGFloat                   containerWidth;

@property (nonatomic, strong) UIColor                   *shadowColor;
@property (nonatomic, assign) CGSize                    shadowOffset;
@property (nonatomic, assign) CGFloat                   shadowRadius;
@property (nonatomic, assign) CGFloat                   shadowOpacity;

@property (nonatomic, assign) CGFloat                   marginToAnchorView;
@property (nonatomic, assign) CGFloat                   marginToKeyBoard;

@property (nonatomic, assign) BOOL                      autoFitKeyBoardDisplay;
@property (nonatomic, assign) BOOL                      autoCutoffRelief;
@property (nonatomic, assign) BOOL                      autoFitContainerSize;
@property (nonatomic, assign) BOOL                      autoHandlerDismiss;
@property (nonatomic, strong) __kindof UIView           *contentView;

#pragma mark - callback
@property (nonatomic, copy) BRCDropDownItemClickBlock   onClickItem;
@property (nonatomic, copy) void (^webImageLoadBlock)(UIImageView *imageView,NSURL * imageUrl);

#pragma mark - init
- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint;
- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint contentStyle:(BRCDropDownContentStyle)style;
+ (instancetype)dropDownWithAnchorPoint:(CGPoint)anchorPoint;
+ (instancetype)dropDownWithAnchorPoint:(CGPoint)anchorPoint contentStyle:(BRCDropDownContentStyle)style;

- (instancetype)initWithAnchorView:(UIView *)anchorView;
- (instancetype)initWithAnchorView:(UIView *)anchorView contentStyle:(BRCDropDownContentStyle)style;
+ (instancetype)dropDownWithAnchorView:(UIView *)anchorView;
+ (instancetype)dropDownWithAnchorView:(UIView *)anchorView contentStyle:(BRCDropDownContentStyle)style;

#pragma mark - control
- (void)showAndAutoDismissAfterDelay:(NSTimeInterval)delay;
- (void)show;
- (void)dismiss;
- (void)toggleDisplay;

#pragma mark - method
- (void)setAnchorPoint:(CGPoint)anchorPoint;
- (void)setAnchorView:(UIView *)anchorView;

@end

@interface BRCDropDown (DropDownContent)
<
UITableViewDelegate,
UITableViewDataSource
>

#pragma mark - table

- (void)setDataSourceArray:(NSArray *)array;
- (void)setDataSourceDict:(NSDictionary *)dict;

#pragma mark - text

- (void)setContentText:(NSString *)contentText;

#pragma mark - image

- (void)setContentImage:(UIImage *)image;
- (void)setContentImageUrl:(NSString *)imageUrl;

@end

NS_ASSUME_NONNULL_END
