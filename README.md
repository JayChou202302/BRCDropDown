<p align='center'>
    <img src="https://jaychou202302.github.io/media/BRCDropDown/logo.gif"/>
</p>

<table>
    <thead>
        <tr>
            <th>PopUp</th>
            <th>DropDown</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCDropDown/1.GIF"/>
            </td>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCDropDown/2.GIF"/>
            </td>
        </tr>
    </tbody>
</table>

# BRCDropDown

[![CI Status](https://img.shields.io/travis/zhixiongsun/BRCDropDown.svg?style=flat)](https://travis-ci.org/zhixiongsun/BRCDropDown)
[![Version](https://img.shields.io/cocoapods/v/BRCDropDown.svg?style=flat)](https://cocoapods.org/pods/BRCDropDown)
[![License](https://img.shields.io/cocoapods/l/BRCDropDown.svg?style=flat)](https://cocoapods.org/pods/BRCDropDown)
[![Platform](https://img.shields.io/cocoapods/p/BRCDropDown.svg?style=flat)](https://cocoapods.org/pods/BRCDropDown)

A versatile, highly customizable dropdown menu library for iOS. With multiple styles, positions, and animation options, it lets you add engaging dropdown menus to your app with ease.

## Features

- **Arrow Position & Style**  
  Customize the arrow's position, shape, and roundness.

- **Pop-up Position & Animation**  
  Control where the dropdown appears and how it animates.

- **Content Styles & Alignment**  
  Choose from different content styles like text, image, table, or custom, and align them to your preference.

- **Flexible Context Style**  
  Display the dropdown within a window, superview, or view controller.

- **Automatic Dismiss Mode**  
  Automatically hide the dropdown after selection or tap.

## Usage

### Required parameters
1. `anchorView / anchorPoint` - the container position

### Available customizations - optional parameters

You can customize the dropdown menu using the following properties

#### Arrow Customization
1.`arrowPosition` - the position for arrow 
```objective-c
BRCDropDownArrowPositionLeft = 0,           // Arrow positioned to the left
BRCDropDownArrowPositionCenter,             // Arrow positioned at the center
BRCDropDownArrowPositionRight,              // Arrow positioned to the right
BRCDropDownArrowPositionAnchorCenter,       // Arrow anchored at the center
BRCDropDownArrowPositionCustom              // Custom arrow position
```
2.`arrowStyle` - the style for arrow
```objective-c
BRCDropDownArrowStyleNone = 0,              // No arrow
BRCDropDownArrowStyleRightangle,            // Right-angle arrow
BRCDropDownArrowStyleEquilateral,           // Equilateral triangle arrow
BRCDropDownArrowStyleRoundEquilateral       // Round-edged equilateral triangle arrow
```
3.`arrowHeight` - arrow size
4.`arrowRoundRadius` - the radius for RoundEquilateral style
5.`arrowRoundTopRadius` - the arrow top radius for RoundEquilateral style
6.`arrowInset` - the arrow inset to container edge
7.`arrowCustomPosition` - the custom position for arrow , it's percentage

#### Popup Customization
1.`popUpPosition`
```objective-c
BRCDropDownPopUpTop = 0,    // Popup displays at the top
BRCDropDownPopUpBottom,     // Popup displays at the bottom
BRCDropDownPopUpLeft,       // Popup displays to the left
BRCDropDownPopUpRight       // Popup displays to the right
```
2.`popUpAnimationStyle`
```objective-c
BRCDropDownPopUpAnimationNone = 0,               // No animation
BRCDropDownPopUpAnimationFade,                   // Fade animation
BRCDropDownPopUpAnimationScale,                  // Scale animation
BRCDropDownPopUpAnimationBounce,                 // Bounce animation
BRCDropDownPopUpAnimationFadeScale,              // Fade and Scale animation
BRCDropDownPopUpAnimationFadeBounce,             // Fade and Bounce animation
BRCDropDownPopUpAnimationFadeHeightExpansion,    // Fade and Height Expansion animation
BRCDropDownPopUpAnimationHeightExpansion         // Height Expansion animation
```
3.`animationDuration` 

#### Style
1.`contextStyle` - define context type
```objective-c
BRCDropDownContextStyleWindow = 0,           // Context as window
BRCDropDownContextStyleSuperView,            // Context as superview
BRCDropDownContextStyleViewController        // Context as view controller
```
2.`contentStyle` - define content type
```objective-c
BRCDropDownContentStyleTable = 0,    // Content style as table
BRCDropDownContentStyleText,         // Content style as text
BRCDropDownContentStyleImage,        // Content style as image
BRCDropDownContentStyleCustom        // Custom content style
```
3.`contentAlignment` - define container alignment
```objective-c
BRCDropDownContentAlignmentLeft = 0,     // Left alignment
BRCDropDownContentAlignmentCenter,       // Center alignment
BRCDropDownContentAlignmentRight         // Right alignment
```
4.`dismissMode` - define container dismissmode
```objective-c
BRCDropDownDismissModeNone,          // No dismiss mode
BRCDropDownDismissModeTapContent,    // Dismiss on tapping content
```

#### Behavior Flags
1.`autoFitKeyBoardDisplay` - when you used in textInput, this will auto fit keyBoard appear and disappear
2.`autoCutoffRelief` - this will help you to cut off container offscreen size
3.`autoFitContainerSize` - if you don't want to set containerSize, this will help you auto set containerSize from anchorview frame

#### CallBack
1.`onClickItem` - this will not effect in custom content
2.`webImageLoadBlock` - this define container display webImage method

#### Display
1.`showAndAutoDismissAfterDelay:` - show container and dissmiss after seconds delay
2.`show` - show container
3.`dismiss` - dismiss container
4.`toggleDisplay` - toggles the container's display state.

#### Initialization
1.`initWithAnchorPoint:` - Initialize with achor point 
2.`initWithAnchorView:` - Initialize with achor view 

### Basic Example

```objective-c
#import "BRCDropDown.h"

// Create a dropdown with anchor view
BRCDropDown *dropDown = [[BRCDropDown alloc] initWithAnchorView:anchorView];

// Configure items
BRCDropDownItem *item1 = [BRCDropDownItem itemWithText:@"Item 1" onClickBlock:^(NSIndexPath *index) {
    NSLog(@"Item 1 selected");
}];

BRCDropDownItem *item2 = [BRCDropDownItem itemWithText:@"Item 2" onClickBlock:^(NSIndexPath *index) {
    NSLog(@"Item 2 selected");
}];

// Add items to the dropdown
[dropDown setDataSourceArray:@[item1, item2]];

// Customize appearance
dropDown.popUpPosition = BRCDropDownPopUpBottom;
dropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
dropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
dropDown.arrowPosition = BRCDropDownArrowPositionCenter;
dropDown.containerSize = CGSizeMake(100,200);

// Show dropdown
[dropDown show];
```
If you want see more example,you can download this project, we provide more useful example for you


## Installation

### CocoaPods

Add the following line to your `Podfile`:

```ruby
pod 'BRCDropDown', '~> 1.0'
```

# Requirements
-  iOS 13.0
-  Xcode 12+

## Author

zhixiongsun, sunzhixiong91@gmail.com

## License

BRCDropDown is available under the MIT license. See the LICENSE file for more info.
