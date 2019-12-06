//
//  HSYCollectionViewController.m
//  HSYImageZoomToolsKit_Example
//
//  Created by anmin on 2019/12/4.
//  Copyright © 2019 317398895@qq.com. All rights reserved.
//

#import "HSYCollectionViewController.h"
#import "HSYImageZoomView.h"
#import <HSYMethodsToolsKit/UIView+Frame.h>
#import <HSYMacroKit/HSYToolsMacro.h>
#import <HSYToolsClassKit/HSYGestureTools.h>
#import <ReactiveObjC.h>

@class HSYUICollectionViewCell;
@protocol HSYUICollectionViewCellDelegate <NSObject>

- (void)delegate:(HSYUICollectionViewCell *)cell imageViews:(NSArray<UIImageView *> *)imageViews withIndex:(NSInteger)index;

@end

@interface HSYUICollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<HSYUICollectionViewCellDelegate>delegate;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;

@end

@implementation HSYUICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageViews = [[NSMutableArray alloc] init];
        CGFloat x = 0.0f;
        for (NSInteger i = 0; i < 7; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 40, 40)];
            imageView.userInteractionEnabled = YES;
            x = imageView.right + 10.0f;
            [self.contentView addSubview:imageView];
            [self.imageViews addObject:imageView];
        }
        
        @weakify(self);
        for (UIImageView *imageView in self.imageViews) {
            [HSYGestureTools hsy_tapGesture:imageView touchTapGestureBlock:^(UIGestureRecognizer * _Nonnull gesture, UIView * _Nonnull touchView, CGPoint location) {
                @strongify(self);
                if (self.delegate && [self.delegate respondsToSelector:@selector(delegate:imageViews:withIndex:)]) {
                    [self.delegate delegate:self imageViews:self.imageViews withIndex:[self.imageViews indexOfObject:imageView]];
                }
            }];
        }
    }
    return self;
}

@end

@interface HSYCollectionViewController () <HSYUICollectionViewCellDelegate>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation HSYCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(IPHONE_WIDTH, 40.0);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    if (self = [super initWithCollectionViewLayout:flowLayout]) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    self.collectionViewLayout.
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.collectionView registerClass:[HSYUICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)datas
{
    if (!_datas) {
        _datas = @[@[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], @[@"icon_home_search", @"icon_home_salary_sign", @"icon_home_remuneration", @"icon_home_more", @"icon_home_ recharge", @"icon_home_ lease", @"icon_home_ evection"], ];
    }
    return _datas;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datas[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSYUICollectionViewCell *cell = (HSYUICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *datas = self.datas[indexPath.section];
    for (UIImageView *imageView in cell.imageViews) {
        imageView.image = [UIImage imageNamed:datas[[cell.imageViews indexOfObject:imageView]]];
        imageView.highlightedImage = [UIImage imageNamed:datas[[cell.imageViews indexOfObject:imageView]]];
    }
    cell.delegate = self;
    return cell;
} 

#pragma mark - HSYUICollectionViewCellDelegate

- (void)delegate:(HSYUICollectionViewCell *)cell imageViews:(NSArray<UIImageView *> *)imageViews withIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    UIView *view = cell.contentView;
    NSMutableArray *datas = self.datas[indexPath.section];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSString *name in datas) {
        [list addObject:@{name : cell.imageViews[[datas indexOfObject:name]]}];
    }
    HSYImageZoomArgument *argument = [HSYImageZoomArgument hsy_toZoomArguments:@{@{@"" : @{@(index) : view}} : list}];
    [HSYImageZoomView hsy_imageZoom:argument];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
