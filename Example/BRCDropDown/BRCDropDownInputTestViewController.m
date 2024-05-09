//
//  BRCDropDownInputTestViewController.m
//  BRCDropDown_Example
//
//  Created by sunzhixiong on 2024/5/9.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "BRCDropDownInputTestViewController.h"
#import <BRCDropDown/BRCDropDown.h>
#import <Masonry/Masonry.h>
#import <YYKit/YYKitMacro.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>

@interface BRCDropDownInputTestViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UITextField *inputTextField1;
@property (nonatomic, strong) BRCDropDown *textFieldDropDown;
@property (nonatomic, strong) BRCDropDown *textFieldDropDown1;
@property (nonatomic, strong) NSMutableArray<BRCDropDown *> *dropDownManager;

@end

@implementation BRCDropDownInputTestViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.inputTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.inputTextField resignFirstResponder];
    [self.dropDownManager enumerateObjectsUsingBlock:^(BRCDropDown * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dismiss];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    self.title = @"BRCDropDown";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"sun.min"] menu:nil];
    item.tintColor = [UIColor blackColor];
    item.actionBlock = ^(id _Nonnull obj) {
        BRCDropDownInputTestViewController *vc = [BRCDropDownInputTestViewController new];
        [self presentViewController:vc animated:YES completion:nil];
    };
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}

- (void)setUpViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.leading.trailing.equalTo(self.view).inset(20);
        make.height.equalTo(@40);
    }];
    [self.view addSubview:self.inputTextField1];
    [self.inputTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(300);
        make.leading.trailing.equalTo(self.view).inset(20);
        make.height.equalTo(@40);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.inputTextField) {
        [self.textFieldDropDown show];
        [self.textFieldDropDown setDataSourceArray:[self originDataSource]];
    } else if (textField == self.inputTextField1) {
        [self.textFieldDropDown1 show];
        [self.textFieldDropDown1 setDataSourceArray:[self dataSource]];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.inputTextField) {
        [self.textFieldDropDown dismiss];
    } else if (textField == self.inputTextField1) {
        [self.textFieldDropDown1 dismiss];
    }
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField == self.inputTextField) {
        [self.textFieldDropDown show];
        [self.textFieldDropDown setDataSourceArray:[self originDataSource]];
    } else if (textField == self.inputTextField1) {
        [self.textFieldDropDown1 show];
        [self.textFieldDropDown1 setDataSourceArray:[self dataSource]];
    }
}

#pragma mark - props

- (NSMutableArray<BRCDropDown *> *)dropDownManager {
    if (!_dropDownManager) {
        _dropDownManager = [NSMutableArray array];
    }
    return _dropDownManager;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.placeholder = @"输入一些........";
        _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField.backgroundColor = [UIColor whiteColor];
    }
    return _inputTextField;
}

- (UITextField *)inputTextField1 {
    if (!_inputTextField1) {
        _inputTextField1 = [[UITextField alloc] init];
        _inputTextField1.delegate = self;
        _inputTextField1.placeholder = @"输入一些........";
        _inputTextField1.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField1.backgroundColor = [UIColor whiteColor];
    }
    return _inputTextField1;
}

- (BRCDropDown *)textFieldDropDown {
    if (!_textFieldDropDown) {
        _textFieldDropDown = [[BRCDropDown alloc] initWithAnchorView:self.inputTextField];
        _textFieldDropDown.contextStyle = BRCDropDownContextStyleViewController;
        _textFieldDropDown.arrowStyle = BRCDropDownArrowStyleNone;
        _textFieldDropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationHeightExpansion;
        _textFieldDropDown.containerHeight = 200;
        _textFieldDropDown.animationDuration = 0.7;
        @weakify(self)
        [_textFieldDropDown setOnClickItem:^(NSIndexPath * _Nonnull itemIndex) {
            @strongify(self)
            if (itemIndex.row < self.originDataSource.count) {
                self.inputTextField.text = self.originDataSource[itemIndex.item];
                [self.inputTextField resignFirstResponder];
            }
        }];
        [_textFieldDropDown setDataSourceArray:self.originDataSource];
        [self.dropDownManager addObject:_textFieldDropDown];
    }
    return _textFieldDropDown;
}

- (BRCDropDown *)textFieldDropDown1 {
    if (!_textFieldDropDown1) {
        _textFieldDropDown1 = [[BRCDropDown alloc] initWithAnchorView:self.inputTextField1];
        _textFieldDropDown1.contextStyle = BRCDropDownContextStyleViewController;
        _textFieldDropDown1.arrowStyle = BRCDropDownArrowStyleNone;
        _textFieldDropDown1.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeHeightExpansion;
        _textFieldDropDown1.containerHeight = 200;
        _textFieldDropDown1.animationDuration = 0.7;
        @weakify(self)
        [_textFieldDropDown1 setOnClickItem:^(NSIndexPath * _Nonnull itemIndex) {
            @strongify(self)
            if (itemIndex.row < self.dataSource.count) {
                self.inputTextField1.text = self.dataSource[itemIndex.item];
                [self.inputTextField1 resignFirstResponder];
            }
        }];
        [_textFieldDropDown1 setDataSourceArray:self.dataSource];
        [self.dropDownManager addObject:_textFieldDropDown1];
    }
    return _textFieldDropDown1;
}

- (NSArray *)originDataSource {
    return @[
        @"周杰伦",
        @"Jaychou",
        @"最伟大的作品",
        @"十二新作",
        @"十一月的肖邦",
        @"等你下课",
        @"2004无与伦比演唱会",
        @"青花瓷",
        @"周杰伦的床边故事",
        @"说好不哭",
        @"莫名其妙爱上你",
        @"跨时代",
        @"霍元甲",
        @"稻香",
        @"三年二班",
        @"地表最强演唱会",
        @"魔杰座",
        @"惊叹号",
        @"手写的从前",
        @"阳光宅男",
        @"一路向北",
        @"不能说的秘密",
        @"头文字D",
        @"彩虹",
        @"给我一首歌的时间",
        @"龙战骑士",
        @"发如雪",
        @"晴天",
        @"千里之外",
        @"本草纲目",
        @"九州天空城"
    ];
}

- (NSArray *)dataSource {
    NSArray *origin = [self originDataSource];
    UITextField *view = nil;
    if ([self.inputTextField isFirstResponder]) {
        view = self.inputTextField;
    }
    if ([self.inputTextField1 isFirstResponder]) {
        view = self.inputTextField1;
    }
    return [origin filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *_Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ([evaluatedObject containsString:view.text]) {
            return YES;
        }
        return NO;
    }]];
}

@end
