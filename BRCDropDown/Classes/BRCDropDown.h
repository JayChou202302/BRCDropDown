//
//  BRCDropDown.h
//
//  Created by sunzhixiong on 2024/3/15.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BRCDropDownPopUpPosition) {
    BRCDropDownPopUpTop = 0,    // Popup displays at the top
    BRCDropDownPopUpBottom,     // Popup displays at the bottom
    BRCDropDownPopUpLeft,       // Popup displays to the left
    BRCDropDownPopUpRight       // Popup displays to the right
};

typedef NS_ENUM(NSInteger, BRCDropDownPopUpAnimation) {
    BRCDropDownPopUpAnimationNone = 0,               // No animation
    BRCDropDownPopUpAnimationFade,                   // Fade animation
    BRCDropDownPopUpAnimationScale,                  // Scale animation
    BRCDropDownPopUpAnimationBounce,                 // Bounce animation
    BRCDropDownPopUpAnimationFadeScale,              // Fade and Scale animation
    BRCDropDownPopUpAnimationFadeBounce,             // Fade and Bounce animation
    BRCDropDownPopUpAnimationFadeHeightExpansion,    // Fade and Height Expansion animation
    BRCDropDownPopUpAnimationHeightExpansion         // Height Expansion animation
};

typedef NS_ENUM(NSInteger, BRCDropDownContentStyle) {
    BRCDropDownContentStyleTable = 0,    // Content style as table
    BRCDropDownContentStyleText,         // Content style as text
    BRCDropDownContentStyleImage,        // Content style as image
    BRCDropDownContentStyleCustom        // Custom content style
};

typedef NS_ENUM(NSInteger, BRCDropDownContentAlignment) {
    BRCDropDownContentAlignmentLeft = 0,     // Left alignment
    BRCDropDownContentAlignmentCenter,       // Center alignment
    BRCDropDownContentAlignmentRight         // Right alignment
};

typedef NS_ENUM(NSInteger, BRCDropDownContextStyle) {
    BRCDropDownContextStyleWindow = 0,           // Context as window
    BRCDropDownContextStyleSuperView,            // Context as superview
    BRCDropDownContextStyleViewController        // Context as view controller
};

typedef NS_ENUM(NSInteger, BRCDropDownDismissMode) {
    BRCDropDownDismissModeNone,          // No dismiss mode
    BRCDropDownDismissModeTapContent,    // Dismiss on tapping content
};

typedef NS_ENUM(NSInteger, BRCDropDownArrowPosition) {
    BRCDropDownArrowPositionLeft = 0,           // Arrow positioned to the left
    BRCDropDownArrowPositionCenter,             // Arrow positioned at the center
    BRCDropDownArrowPositionRight,              // Arrow positioned to the right
    BRCDropDownArrowPositionAnchorCenter,       // Arrow anchored at the center
    BRCDropDownArrowPositionCustom              // Custom arrow position
};

typedef NS_ENUM(NSInteger, BRCDropDownArrowStyle) {
    BRCDropDownArrowStyleNone = 0,              // No arrow
    BRCDropDownArrowStyleRightangle,            // Right-angle arrow
    BRCDropDownArrowStyleEquilateral,           // Equilateral triangle arrow
    BRCDropDownArrowStyleRoundEquilateral       // Round-edged equilateral triangle arrow
};

NS_ASSUME_NONNULL_BEGIN

@class BRCDropDownItem;

/**
 * Callback for handling item clicks in the dropdown
 */
typedef void (^BRCDropDownItemClickBlock)(NSIndexPath *itemIndex);

/**
 * Represents an individual item in the dropdown
 */
@interface BRCDropDownItem : NSObject

/// The text associated with the item
@property (nonatomic, strong) NSString *itemText;

/// The image associated with the item
@property (nonatomic, strong) UIImage *itemImage;

/// The URL of the image associated with the item
@property (nonatomic, strong) NSString *itemImageUrl;

/// Block to handle clicks on the item
@property (nonatomic, copy) BRCDropDownItemClickBlock clickBlock;

/// Initializes an item with text, image, and an optional click block
- (instancetype)initWithText:(NSString *)text
                       image:(UIImage *)image
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Creates an item with text, image, and an optional click block
+ (instancetype)itemWithText:(NSString *)text
                       image:(UIImage *)image
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Initializes an item with text, image URL, and an optional click block
- (instancetype)initWithText:(NSString *)text
                    imageUrl:(NSString *)imageUrl
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Creates an item with text, image URL, and an optional click block
+ (instancetype)itemWithText:(NSString *)text
                    imageUrl:(NSString *)imageUrl
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Initializes an item with text and an optional click block
- (instancetype)initWithText:(NSString *)text
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Creates an item with text and an optional click block
+ (instancetype)itemWithText:(NSString *)text
                onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Initializes an item with an image and an optional click block
- (instancetype)initWithImage:(UIImage *)image
                 onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Creates an item with an image and an optional click block
+ (instancetype)itemWithImage:(UIImage *)image
                 onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Initializes an item with an image URL and an optional click block
- (instancetype)initWithImageUrl:(NSString *)imageUrl
                    onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

/// Creates an item with an image URL and an optional click block
+ (instancetype)itemWithImageUrl:(NSString *)imageUrl
                    onClickBlock:(nullable BRCDropDownItemClickBlock)onClickBlock;

@end

/**
 * Represents the dropdown menu's appearance and behavior.
 */
@interface BRCDropDown : NSObject

#pragma mark - Arrow Customization

/**
 * The position of the arrow.
 * Default is `BRCDropDownArrowPositionLeft`.
 */
@property (nonatomic, assign) BRCDropDownArrowPosition arrowPosition;

/**
 * The style of the arrow.
 * Default is `BRCDropDownArrowStyleRoundEquilateral`.
 */
@property (nonatomic, assign) BRCDropDownArrowStyle arrowStyle;

/**
 * The height of the arrow.
 * Default is 10.
 */
@property (nonatomic, assign) CGFloat arrowHeight;

/**
 * The radius of the arrow's round corners.
 * Default is 4.
 */
@property (nonatomic, assign) CGFloat arrowRoundRadius;

/**
 * The radius of the arrow's top round corners.
 * Default is 4.
 */
@property (nonatomic, assign) CGFloat arrowRoundTopRadius;

/**
 * The inset of the arrow from its default position.
 * Default is 15.
 */
@property (nonatomic, assign) CGFloat arrowInset;

/**
 * The custom position of the arrow.
 * Default is 0.
 */
@property (nonatomic, assign) CGFloat arrowCustomPosition;

#pragma mark - Popup Customization

/**
 * The position where the popup will appear.
 * Default is `BRCDropDownPopUpBottom`.
 */
@property (nonatomic, assign) BRCDropDownPopUpPosition popUpPosition;

/**
 * The animation style for the popup.
 * Default is `BRCDropDownPopUpAnimationFadeBounce`.
 */
@property (nonatomic, assign) BRCDropDownPopUpAnimation popUpAnimationStyle;

/**
 * The duration of the popup animation.
 * Default is 0.4 seconds.
 */
@property (nonatomic, assign) CGFloat animationDuration;

#pragma mark - Style

/**
 * The style of the context in which the dropdown is displayed.
 * Default is `BRCDropDownContextStyleViewController`.
 */
@property (nonatomic, assign) BRCDropDownContextStyle contextStyle;

/**
 * The style of the dropdown content.
 * Default is `BRCDropDownContentStyleTable`.
 */
@property (nonatomic, assign) BRCDropDownContentStyle contentStyle;

/**
 * The alignment of the dropdown content.
 * Default is `BRCDropDownContentAlignmentLeft`.
 */
@property (nonatomic, assign) BRCDropDownContentAlignment contentAlignment;

/**
 * The mode used to dismiss the dropdown.
 * Default is `BRCDropDownDismissModeTapContent`.
 */
@property (nonatomic, assign) BRCDropDownDismissMode dismissMode;

/**
 * The background color of the dropdown.
 * Default is `[UIColor systemGray6Color]`.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 * The text color of the content.
 * Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *contentTextColor;

/**
 * The tint color of the content.
 * Default is `[UIColor blackColor]`.
 */
@property (nonatomic, strong) UIColor *contentTintColor;

/**
 * The corner radius of the dropdown.
 * Default is 10.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 * The size of the dropdown container.
 * Default is `CGSizeZero`.
 */
@property (nonatomic, assign) CGSize containerSize;

/**
 * The height of the dropdown container.
 * Default is 0.
 */
@property (nonatomic, assign) CGFloat containerHeight;

/**
 * The width of the dropdown container.
 * Default is 0.
 */
@property (nonatomic, assign) CGFloat containerWidth;

/**
 * The color of the dropdown's shadow.
 * Default is `[[UIColor grayColor] colorWithAlphaComponent:0.5]`.
 */
@property (nonatomic, strong) UIColor *shadowColor;

/**
 * The offset of the dropdown's shadow.
 * Default is `CGSizeZero`.
 */
@property (nonatomic, assign) CGSize shadowOffset;

/**
 * The radius of the dropdown's shadow.
 * Default is 8.
 */
@property (nonatomic, assign) CGFloat shadowRadius;

/**
 * The opacity of the dropdown's shadow.
 * Default is 1.0.
 */
@property (nonatomic, assign) CGFloat shadowOpacity;

/**
 * The margin between the dropdown and its anchor view.
 * Default is 5.
 */
@property (nonatomic, assign) CGFloat marginToAnchorView;

/**
 * The margin between the dropdown and the keyboard.
 * Default is 10.
 */
@property (nonatomic, assign) CGFloat marginToKeyBoard;

#pragma mark - Behavior Flags

/**
 * Automatically fits the display when the keyboard is shown.
 * Default is YES.
 */
@property (nonatomic, assign) BOOL autoFitKeyBoardDisplay;

/**
 * Automatically prevents content cutoff.
 * Default is YES.
 */
@property (nonatomic, assign) BOOL autoCutoffRelief;

/**
 * Automatically adjusts the container size to fit content.
 * Default is YES.
 */
@property (nonatomic, assign) BOOL autoFitContainerSize;

/**
 * The content view of the dropdown.
 */
@property (nonatomic, strong) __kindof UIView *contentView;

#pragma mark - Callback

/**
 * Block to handle item clicks.
 */
@property (nonatomic, copy) BRCDropDownItemClickBlock onClickItem;

/**
 * Block to load images asynchronously.
 */
@property (nonatomic, copy) void (^webImageLoadBlock)(UIImageView *imageView, NSURL *imageUrl);

#pragma mark - Initialization

/**
 * Initializes the dropdown with a given anchor point.
 *
 * @param anchorPoint The point to anchor the dropdown.
 * @return An instance of `BRCDropDown`.
 */
- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint;

/**
 * Initializes the dropdown with a given anchor point and content style.
 *
 * @param anchorPoint The point to anchor the dropdown.
 * @param style The content style of the dropdown.
 * @return An instance of `BRCDropDown`.
 */
- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint contentStyle:(BRCDropDownContentStyle)style;

/**
 * Creates and returns a dropdown with a given anchor point.
 *
 * @param anchorPoint The point to anchor the dropdown.
 * @return An instance of `BRCDropDown`.
 */
+ (instancetype)dropDownWithAnchorPoint:(CGPoint)anchorPoint;

/**
 * Creates and returns a dropdown with a given anchor point and content style.
 *
 * @param anchorPoint The point to anchor the dropdown.
 * @param style The content style of the dropdown.
 * @return An instance of `BRCDropDown`.
 */
+ (instancetype)dropDownWithAnchorPoint:(CGPoint)anchorPoint contentStyle:(BRCDropDownContentStyle)style;

/**
 * Initializes the dropdown with a given anchor view.
 *
 * @param anchorView The view to anchor the dropdown.
 * @return An instance of `BRCDropDown`.
 */
- (instancetype)initWithAnchorView:(UIView *)anchorView;

/**
 * Initializes the dropdown with a given anchor view and content style.
 *
 * @param anchorView The view to anchor the dropdown.
 * @param style The content style of the dropdown.
 * @return An instance of `BRCDropDown`.
 */
- (instancetype)initWithAnchorView:(UIView *)anchorView contentStyle:(BRCDropDownContentStyle)style;

/**
 * Creates and returns a dropdown with a given anchor view.
 *
 * @param anchorView The view to anchor the dropdown.
 * @return An instance of `BRCDropDown`.
 */
+ (instancetype)dropDownWithAnchorView:(UIView *)anchorView;

/**
 * Creates and returns a dropdown with a given anchor view and content style.
 *
 * @param anchorView The view to anchor the dropdown.
 * @param style The content style of the dropdown.
 * @return An instance of `BRCDropDown`.
 */
+ (instancetype)dropDownWithAnchorView:(UIView *)anchorView contentStyle:(BRCDropDownContentStyle)style;

#pragma mark - Control

/**
 * Shows the dropdown and automatically dismisses it after a specified delay.
 *
 * @param delay The delay in seconds before the dropdown is dismissed.
 */
- (void)showAndAutoDismissAfterDelay:(NSTimeInterval)delay;

/**
 * Shows the dropdown.
 */
- (void)show;

/**
 * Dismisses the dropdown.
 */
- (void)dismiss;

/**
 * Toggles the dropdown's display state.
 */
- (void)toggleDisplay;

#pragma mark - Methods

/**
 * Sets the anchor point of the dropdown.
 *
 * @param anchorPoint The point to anchor the dropdown.
 */
- (void)setAnchorPoint:(CGPoint)anchorPoint;

/**
 * Sets the anchor view of the dropdown.
 *
 * @param anchorView The view to anchor the dropdown.
 */
- (void)setAnchorView:(UIView *)anchorView;

@end

/**
 * Extension for managing dropdown content like tables, text, and images.
 */
@interface BRCDropDown (DropDownContent)
<UITableViewDelegate, UITableViewDataSource>

#pragma mark - Table

/**
 * Sets the dropdown's data source using an array.
 *
 * @param array The array of data to be displayed in the dropdown.
 */
- (void)setDataSourceArray:(NSArray *)array;

/**
 * Sets the dropdown's data source using a dictionary.
 *
 * @param dict The dictionary of data to be displayed in the dropdown.
 */
- (void)setDataSourceDict:(NSDictionary *)dict;

#pragma mark - Text

/**
 * Sets the dropdown's content text.
 *
 * @param contentText The text to be displayed in the dropdown.
 */
- (void)setContentText:(NSString *)contentText;

#pragma mark - Image

/**
 * Sets the dropdown's content image.
 *
 * @param image The image to be displayed in the dropdown.
 */
- (void)setContentImage:(UIImage *)image;

/**
 * Sets the dropdown's content image using a URL.
 *
 * @param imageUrl The URL of the image to be displayed in the dropdown.
 */
- (void)setContentImageUrl:(NSString *)imageUrl;

@end


NS_ASSUME_NONNULL_END
