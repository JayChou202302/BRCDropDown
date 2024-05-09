//
//  BRCViewController.m
//  BRCDropDown
//
//  Created by zhixiongsun on 05/01/2024.
//  Copyright (c) 2024 zhixiongsun. All rights reserved.
//

#import "BRCDropDownRootViewController.h"
#import <BRCDropDown/BRCDropDown.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import "BRCToast.h"
#import "BRCDropDownInputTestViewController.h"

@interface BRCDropDownRootViewController ()
<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray<BRCDropDown *>  *dropDownArray;
@property (nonatomic, strong) BRCDropDown                     *menuDropDpwn;

@end

@implementation BRCDropDownRootViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.menuDropDpwn showAndAutoDismissAfterDelay:2.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dropDownArray enumerateObjectsUsingBlock:^(BRCDropDown * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dismiss];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *tabArray = @[@"house",@"person.3.fill"];
    NSArray *tabTitleArray = @[@"常用样式",@"下拉框"];
    NSArray *vcArray = @[
        @"BRCDropDownExampleTestViewController",
        @"BRCDropDownInputTestViewController",
    ];
    NSInteger width = [UIScreen mainScreen].bounds.size.width / tabArray.count;
    CGFloat size = 34;
    CGFloat leftMargin = width - ((width - size) / 2);
    NSArray *xArray = @[
        @(width / 2),
        @(width * 1.5)
    ];
    NSMutableArray *array = [NSMutableArray array];
    self.dropDownArray = [NSMutableArray array];
    [tabArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __kindof UIViewController *vc;
        vc = [NSClassFromString(vcArray[idx]) new];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.tabBarItem.image = [UIImage systemImageNamed:obj];
        vc.tabBarItem.title = tabTitleArray[idx];
        [array addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
        BRCDropDown *dropDown = [[BRCDropDown alloc] initWithAnchorPoint:CGPointMake([xArray[idx] floatValue], [UIScreen mainScreen].bounds.size.height - 100 + 20)];
        dropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
        dropDown.popUpPosition = BRCDropDownPopUpTop;
        dropDown.containerSize = CGSizeMake(200,200);
        dropDown.cornerRadius = 10;
        dropDown.contentAlignment = BRCDropDownContentAlignmentCenter;
        dropDown.arrowPosition = BRCDropDownArrowPositionCenter;
        dropDown.contentStyle = BRCDropDownContentStyleText;
        dropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
        [(UILabel *)dropDown.contentView setTextAlignment:NSTextAlignmentCenter];
        [dropDown setContentText:[NSString stringWithFormat:@"选中了第%ld个Tab栏",idx]];
        [self.dropDownArray addObject:dropDown];
    }];
    self.viewControllers = [array copy];
    self.delegate = self;
}

- (void)setRightNavigationBarItemWithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCDropDown *buttonDropDown))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpDropDownWithPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - dropSize.width - 10, 100 - 10) size:CGSizeMake(dropSize.width, dropSize.height) forItem:item dropStyle:dropStyle];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}

- (void)setUpDropDownWithPoint:(CGPoint)point
                          size:(CGSize)size
                       forItem:(UIBarButtonItem *)item
                     dropStyle:(void (^)(BRCDropDown *dropDown))dropStyle{
    BRCDropDown *buttonDropDown = [BRCDropDown dropDownWithAnchorPoint:point];
    buttonDropDown.cornerRadius = 6;
    buttonDropDown.arrowHeight = 5;
    buttonDropDown.arrowInset = 12;
    buttonDropDown.arrowRoundTopRadius = 8;
    buttonDropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
    buttonDropDown.arrowPosition = BRCDropDownArrowPositionRight;
    buttonDropDown.popUpPosition = BRCDropDownPopUpBottom;
    buttonDropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
    buttonDropDown.containerSize = size;
    dropStyle(buttonDropDown);
    [self.dropDownArray addObject:buttonDropDown];
    item.actionBlock = ^(id _Nonnull) {
        [buttonDropDown toggleDisplay];
    };
}

#pragma mark - UITabBarDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSInteger index = self.selectedIndex;
    [self.dropDownArray enumerateObjectsUsingBlock:^(BRCDropDown * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [obj showAndAutoDismissAfterDelay:1.5];
        } else {
            [obj dismiss];
        }
    }];
}

#pragma mark - props

- (BRCDropDown *)menuDropDpwn {
    if (!_menuDropDpwn) {
        CGFloat width = 200;
        BRCDropDown *buttonDropDown = [BRCDropDown dropDownWithAnchorPoint:CGPointMake(([UIScreen mainScreen].bounds.size.width - width) / 2, 90)];
        buttonDropDown.cornerRadius = 6;
        buttonDropDown.arrowHeight = 5;
        buttonDropDown.arrowInset = 12;
        buttonDropDown.arrowRoundTopRadius = 8;
        buttonDropDown.contentStyle = BRCDropDownContentStyleText;
        buttonDropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
        buttonDropDown.arrowPosition = BRCDropDownArrowPositionCenter;
        buttonDropDown.popUpPosition = BRCDropDownPopUpBottom;
        buttonDropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
        buttonDropDown.containerSize = CGSizeMake(200, 100);
        [(UILabel *)buttonDropDown.contentView setNumberOfLines:0];
        [(UILabel *)buttonDropDown.contentView setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [buttonDropDown setContentText:@"你好,我是一个功能完善,高度定制化的DropDown/PopUp组件,很高兴认识你!"];
        _menuDropDpwn = buttonDropDown;
        [self.dropDownArray addObject:_menuDropDpwn];
    }
    return _menuDropDpwn;
}


@end
