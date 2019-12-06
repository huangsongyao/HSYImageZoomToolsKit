//
//  HSYViewController.m
//  HSYImageZoomToolsKit
//
//  Created by 317398895@qq.com on 12/03/2019.
//  Copyright (c) 2019 317398895@qq.com. All rights reserved.
//

#import "HSYViewController.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYToolsClassKit/HSYGestureTools.h>
#import "HSYImageZoomView.h"
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYMethodsToolsKit/UINavigationBar+NavigationItem.h>
#import "HSYCollectionViewController.h"

@interface HSYViewController ()

@end

@implementation HSYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *imgNames = @[@"WechatIMG34.jpeg", @"WechatIMG35.jpeg", @"WechatIMG36.jpeg"];
    CGSize size = CGSizeMake(40.0, 40.0f);
    CGFloat x = 0.0f;
    NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:imgNames.count];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:imgNames.count];
    for (NSString *name in imgNames) {
        UIImage *image = [UIImage imageNamed:name];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image highlightedImage:image];
        imageView.userInteractionEnabled = YES;
        imageView.size = size;
        imageView.origin = CGPointMake(x, 110.0);
        [self.view addSubview:imageView];
        [imageViews addObject:imageView];
        [list addObject:@{name : imageView}];
        x = imageView.right + 10.0f;
    }
    
    for (UIImageView *imageView in imageViews) {
        [HSYGestureTools hsy_tapGesture:imageView touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
            //@{@{@"默认占位图" : @{@(初始选中的项所在的index) : UIImageView的superview}} : @[@{@"UIImage对应的远端url地址A" : UIImage对象AA或者@"空字符串"}, @{@"UIImage对应的远端url地址B" : UIImage对象BB或者@"空字符串"}, ... ]}
            NSNumber *index = @([imageViews indexOfObject:imageView]);
            UIView *view = imageView.superview;
            HSYImageZoomArgument *argument = [HSYImageZoomArgument hsy_toZoomArguments:@{@{@"" : @{index : view}} : list}];
            [HSYImageZoomView hsy_imageZoom:argument];
        }];
    }
    
    self.navigationItem.leftBarButtonItems = [UINavigationBar hsy_titleNavigationItems:@[@{@{@(2121) : [UIFont systemFontOfSize:15]} : @{@"list" : HSY_RGB(51,51,51)}}] leftEdgeInsets:0.0 subscribeNext:^(UIButton * _Nonnull button, NSInteger tag) {
        HSYCollectionViewController *vc = [[HSYCollectionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
