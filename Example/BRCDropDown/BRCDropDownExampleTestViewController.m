//
//  BRCDropDownExampleTestViewController.m
//  BRCDropDown_Example
//
//  Created by sunzhixiong on 2024/5/9.
//  Copyright © 2024 zhixiongsun. All rights reserved.
//

#import "BRCDropDownExampleTestViewController.h"
#import <BRCDropDown/BRCDropDown.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>
#import "BRCToast.h"
#import "BRCImageCollectionCell.h"

@interface BRCDropDownExampleTestViewController ()
<
UICollectionViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) BRCDropDown *dropDown;
@property (nonatomic, strong) NSMutableArray<BRCDropDown *>  *dropDownArray;
@property (nonatomic, strong) UIView *lastView;

@end

@implementation BRCDropDownExampleTestViewController

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0,100, 0);
    scrollView.contentSize =  [UIScreen mainScreen].bounds.size;
    scrollView.delegate = self;
    [scrollView setAlwaysBounceVertical:YES];
    UIView *contentView = [UIView new];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
    }];
    self.view = scrollView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.dropDownArray enumerateObjectsUsingBlock:^(BRCDropDown * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dismiss];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BRCDropDown";
    _dropDownArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self setUpViews];
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

- (UIBarButtonItem *)setRightNavigationBarItem1WithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCDropDown *buttonDropDown))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpDropDownWithPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - dropSize.width - 10, 100 - 10) size:CGSizeMake(dropSize.width, dropSize.height) forItem:item dropStyle:dropStyle];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    return item;
}

- (UIBarButtonItem *)setRightNavigationBarItem2WithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCDropDown *buttonDropDown))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpDropDownWithPoint:CGPointMake([UIScreen mainScreen].bounds.size.width - dropSize.width - 60, 100 - 10) size:CGSizeMake(dropSize.width, dropSize.height) forItem:item dropStyle:dropStyle];
    return item;
}

- (void)setLeftNavigationBarItemWithImageName:(NSString *)imageName
                                     dropStyle:(void (^)(BRCDropDown *buttonDropDown))dropStyle
                                      dropSize:(CGSize)dropSize{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:imageName] menu:nil];
    item.tintColor = [UIColor blackColor];
    [self setUpDropDownWithPoint:CGPointMake(10, 100 - 10) size:CGSizeMake(dropSize.width, dropSize.height) forItem:item dropStyle:dropStyle];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}

- (void)setNavigationBar {
    UIBarButtonItem *rightItem1 = [self setRightNavigationBarItem1WithImageName:@"wake.circle" dropStyle:^(BRCDropDown *buttonDropDown) {
        buttonDropDown.popUpPosition = BRCDropDownPopUpBottom;
        buttonDropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
        buttonDropDown.arrowPosition = BRCDropDownArrowPositionRight;
        [(UITableView *)buttonDropDown.contentView setShowsVerticalScrollIndicator:NO];
        [buttonDropDown setDataSourceDict:@{
            @"常用" : @[
                [BRCDropDownItem itemWithText:@"按钮1" image:[UIImage systemImageNamed:@"moon.circle"] onClickBlock:^(NSIndexPath * _Nonnull itemIndex) {
                    [BRCToast show:@"Talk to the Moon"];
                }],
                [BRCDropDownItem itemWithText:@"按钮2" image:[UIImage systemImageNamed:@"mail.stack"] onClickBlock:^(NSIndexPath * _Nonnull itemIndex) {
                    [BRCToast show:@"Talk to the Mail"];
                }],
            ],
            @"聊天" : @[
                [BRCDropDownItem itemWithText:@"发起聊天" image:[UIImage systemImageNamed:@"bubble.left.and.text.bubble.right"] onClickBlock:^(NSIndexPath * _Nonnull itemIndex) {
                    [BRCToast show:@"发起聊天......"];
                }],
                [BRCDropDownItem itemWithText:@"添加朋友" image:[UIImage systemImageNamed:@"person.badge.plus"] onClickBlock:^(NSIndexPath * _Nonnull itemIndex) {
                    [BRCToast show:@"添加朋友....."];
                }],
            ]
        }];
    } dropSize:CGSizeMake(150, 200)];
    
    UIBarButtonItem *rightItem2 = [self setRightNavigationBarItem2WithImageName:@"swift"
                                       dropStyle:^(BRCDropDown *buttonDropDown)  {
        buttonDropDown.contentStyle = BRCDropDownContentStyleText;
        [(UILabel *)buttonDropDown.contentView setNumberOfLines:0];
        [(UILabel *)buttonDropDown.contentView setFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]];
        [buttonDropDown setContentText:@"Swift is a powerful and intuitive programming language for all Apple platforms. It’s easy to get started using Swift, with a concise-yet-expressive syntax and modern features you’ll love. Swift code is safe by design and produces software that runs lightning-fast."];
    } dropSize:CGSizeMake(200, 200)];
    
    [self.navigationItem setRightBarButtonItems:@[rightItem1,rightItem2] animated:YES];
    
    [self setLeftNavigationBarItemWithImageName:@"photo.stack" dropStyle:^(BRCDropDown *buttonDropDown) {
        buttonDropDown.webImageLoadBlock = ^(UIImageView * _Nonnull imageView, NSURL * _Nonnull imageUrl) {
            [imageView sd_setImageWithURL:imageUrl];
        };
        buttonDropDown.contentStyle = BRCDropDownContentStyleImage;
        buttonDropDown.arrowPosition = BRCDropDownArrowPositionLeft;
        [(UIImageView *)buttonDropDown.contentView setContentMode:UIViewContentModeScaleAspectFit];
        [buttonDropDown setContentImageUrl:@"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"];
    } dropSize:CGSizeMake(200, 200)];
}

- (void)setUpViews {
    [self addPopupTest1Button];
    [self addPopupTest2Button];
    [self addPopupTest3Button];
    [self.lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.lessThanOrEqualTo(self.view);
    }];
}

#pragma mark - test1

- (NSArray *)topViewList {
    return @[
        @{
            @"image" : [UIImage systemImageNamed:@"doc.on.doc.fill"],
            @"text"  : @"添加",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"arrowshape.turn.up.right.fill"],
            @"text"  : @"转发",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"cube.fill"],
            @"text"  : @"收藏",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"trash.fill"],
            @"text"  : @"删除",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"blinds.vertical.closed"],
            @"text"  : @"多选",
        },
    ];
}

- (NSArray *)bottomViewList {
    return @[
        @{
            @"image" : [UIImage systemImageNamed:@"quote.bubble.fill"],
            @"text"  : @"引用",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"bell.fill"],
            @"text"  : @"提醒",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"line.3.crossed.swirl.circle.fill"],
            @"text"  : @"翻译",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"magnifyingglass.circle.fill"],
            @"text"  : @"搜一搜",
        },
        @{
            @"image" : [UIImage systemImageNamed:@"sun.max.circle.fill"],
            @"text"  : @"手电",
        },
    ];
}

- (UIView *)test1ContentView {
    UIView *view = [UIView new];
    UIStackView *topView = [[UIStackView alloc] init];
    topView.axis = UILayoutConstraintAxisHorizontal;
    topView.alignment = UIStackViewAlignmentCenter;
    topView.distribution = UIStackViewDistributionFillEqually;
    [[self topViewList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage  *image = obj[@"image"];
        NSString *text = obj[@"text"];
        void (^onTap)(void) = obj[@"onTap"];
        [self addButtonToStackView:topView image:image text:text onTap:^{
            if (onTap) {
                onTap();
            } else {
                [BRCToast show:@"点击～"];
            }
        }];
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor systemGray5Color];
    
    UIStackView *bottomView = [[UIStackView alloc] init];
    bottomView.axis = UILayoutConstraintAxisHorizontal;
    bottomView.alignment = UIStackViewAlignmentCenter;
    bottomView.distribution = UIStackViewDistributionFillEqually;
    [[self bottomViewList] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage  *image = obj[@"image"];
        NSString *text = obj[@"text"];
        void (^onTap)(void) = obj[@"onTap"];
        [self addButtonToStackView:bottomView image:image text:text onTap:^{
            if (onTap) {
                onTap();
            } else {
                [BRCToast show:@"点击～"];
            }
        }];
    }];
    
    [view addSubview:topView];
    [view addSubview:lineView];
    [view addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(20);
        make.leading.trailing.equalTo(view).inset(20);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.leading.trailing.equalTo(topView);
        make.height.equalTo(@1);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.bottom.equalTo(view).offset(-20);
        make.leading.trailing.equalTo(topView);
    }];
    return view;
}

- (void)addPopupTest1Button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor systemGreenColor];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.layer.cornerCurve = kCACornerCurveContinuous;
    [button setTitle:@"示例1" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    BRCDropDown *dropDown = [BRCDropDown dropDownWithAnchorView:button contentStyle:BRCDropDownContentStyleCustom];
    dropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
    dropDown.contentAlignment = BRCDropDownContentAlignmentLeft;
    dropDown.arrowPosition = BRCDropDownArrowPositionAnchorCenter;
    dropDown.popUpPosition = BRCDropDownPopUpTop;
    dropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
    dropDown.containerSize = CGSizeMake(300, 150);
    [dropDown setContentView:[self test1ContentView]];
    [self.dropDownArray addObject:dropDown];
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [dropDown toggleDisplay];
    }] forControlEvents:UIControlEventTouchUpInside];
    [self addLabelWithText:@"1.示例样式1" withTopSpace:10];
    [self addButton:button withTopSpace:160 isRight:NO];
}

#pragma mark - test2

- (NSArray *)imageArray {
    return @[
        @"https://is1-ssl.mzstatic.com/image/thumb/Features/v4/b7/3a/0a/b73a0aa8-394c-a08d-4e25-88ee7612a41b/c9430441-b1be-43e4-bbba-f443c1422852.png/548x1186.jpg",
        @"https://is1-ssl.mzstatic.com/image/thumb/Features122/v4/ef/50/3f/ef503fb5-7ad5-ce94-76ae-5d211988b343/906ae116-b969-4f9e-a9f3-e3e6a5a492b2.png/548x1186.jpg",
        @"https://www.apple.com/v/home/bm/images/heroes/apple-vision-pro-enhanced/hero_apple_vision_pro_enhanced_endframe__b917czne63hy_small_2x.jpg",
        @"https://www.apple.com/v/home/bm/images/heroes/mothers-day-2024/hero_md24__e3yulubypvki_small_2x.jpg",
        @"https://www.apple.com/v/home/bm/images/heroes/apple-event-may/hero_1_apple_event_may__b3bo6rpkqhle_small_2x.jpg",
        @"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"
    ];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageArray].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BRCImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < [self imageArray].count) {
        NSString *imageUrl = [self imageArray][indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        cell.imageView.clipsToBounds = YES;
    }
    return cell;
}

- (UIView *)test2ContentView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    collectionView.dataSource = self;
    [collectionView registerClass:[BRCImageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    collectionView.backgroundColor = [UIColor systemGray6Color];
    return collectionView;
}

- (void)addPopupTest2Button {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = [UIColor systemGreenColor];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    button.layer.cornerCurve = kCACornerCurveContinuous;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"示例2" forState:UIControlStateNormal];
    BRCDropDown *dropDown = [BRCDropDown dropDownWithAnchorView:button contentStyle:BRCDropDownContentStyleCustom];
    dropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
    dropDown.contentAlignment = BRCDropDownContentAlignmentRight;
    dropDown.arrowPosition = BRCDropDownArrowPositionAnchorCenter;
    dropDown.popUpPosition = BRCDropDownPopUpTop;
    dropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
    dropDown.containerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3 / 4, 120);
    [dropDown setContentView:[self test2ContentView]];
    [self.dropDownArray addObject:dropDown];
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [dropDown toggleDisplay];
    }] forControlEvents:UIControlEventTouchUpInside];
    [self addLabelWithText:@"2.示例样式2" withTopSpace:10];
    [self addButton:button withTopSpace:130 isRight:YES];
}

#pragma mark - test3

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.dropDown dismiss];
}

- (void)handlerLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    CGPoint gesturePoint = [gesture locationInView:[UIApplication sharedApplication].delegate.window];
    self.dropDown.arrowCustomPosition = (gesturePoint.x / 320);
    [self.dropDown setAnchorPoint:CGPointMake(20 + 150, gesturePoint.y)];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.dropDown show];
    }
}

- (void)addPopupTest3Button {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView setUserInteractionEnabled:YES];
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://www.apple.com/v/home/bm/images/promos/iphone-15-pro/promo_iphone15pro__e48p7n5x3nsm_small_2x.jpg"]];
    imageView.layer.cornerRadius = 10;
    imageView.layer.cornerCurve = kCACornerCurveContinuous;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlerLongPressGesture:)];
    longPressGesture.minimumPressDuration = 0.5;
    [imageView addGestureRecognizer:longPressGesture];
    [self addLabelWithText:@"3.示例样式3" withTopSpace:10];
    [self addSubView:imageView topSpace:10
               width:[UIScreen mainScreen].bounds.size.width/2 height:200 isCenter:NO isRight:NO];
}

- (void)addButtonToStackView:(UIStackView *)stackView
                       image:(UIImage *)image
                        text:(NSString *)text
                       onTap:(void (^)(void))onTap{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFont:[UIFont systemFontOfSize:13.0]];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        if (onTap) onTap();
    }] forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
//    [button setTitle:text forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stackView addArrangedSubview:button];
}

- (void)addLabelWithText:(NSString *)text withTopSpace:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label topSpace:space width:[UIScreen mainScreen].bounds.size.width - 40 height:30 isCenter:NO isRight:NO];
}

- (void)addButton:(UIView *)button withTopSpace:(CGFloat)space isRight:(BOOL)isRight{
    [self addSubView:button topSpace:space width:[UIScreen mainScreen].bounds.size.width / 2 height:50 isCenter:NO isRight:isRight];
}

- (void)addSubView:(UIView *)view
          topSpace:(CGFloat)space
             width:(CGFloat)width
            height:(CGFloat)height
          isCenter:(BOOL)isCenter
           isRight:(BOOL)isRight{
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView == nil) {
            make.top.equalTo(self.view).offset(0);
        } else {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        }
        if (isCenter) {
            make.centerX.equalTo(self.view);
        } else if (isRight){
            make.trailing.equalTo(self.view).offset(-20);
        } else {
            make.leading.equalTo(self.view).offset(20);
        }
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
    self.lastView = view;
}

#pragma mark - props

- (BRCDropDown *)dropDown {
    if (!_dropDown) {
        _dropDown = [BRCDropDown dropDownWithAnchorPoint:CGPointZero];
        _dropDown.arrowStyle = BRCDropDownArrowStyleRoundEquilateral;
        _dropDown.contentAlignment = BRCDropDownContentAlignmentCenter;
        _dropDown.arrowPosition = BRCDropDownArrowPositionCustom;
        _dropDown.popUpPosition = BRCDropDownPopUpTop;
        _dropDown.contextStyle = BRCDropDownContextStyleWindow;
        _dropDown.popUpAnimationStyle = BRCDropDownPopUpAnimationFadeBounce;
        _dropDown.containerSize = CGSizeMake(300, 150);
        _dropDown.marginToAnchorView = 0;
        [_dropDown setContentStyle:BRCDropDownContentStyleText];
        [(UILabel *)_dropDown.contentView setText:@"跟随手指"];
        [self.dropDownArray addObject:_dropDown];
    }
    return _dropDown;
}

@end

