//
//  IntroductionViewController.m
//  AppFramework
//
//  Created by ABC on 7/26/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "IntroductionViewController.h"
#import "SkinManager.h"
#import <PureLayout.h>

@interface IntroductionViewController () <UIScrollViewDelegate>

@property (nonatomic,strong)    UIScrollView *imageScrollView;
@property (nonatomic, strong) UIButton *enterButton;

- (void)addSubviews;

-(void)tapDetected:(UITapGestureRecognizer *)gestureRecognizer;

@end

@implementation IntroductionViewController

#define kPageCount 4

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubviews];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Property

- (UIScrollView*)imageScrollView
{
    if (!_imageScrollView) {
        CGRect viewBoundsRect = [self.view bounds];
        _imageScrollView = [[UIScrollView alloc] initWithFrame:viewBoundsRect];
        [_imageScrollView setContentSize:CGSizeMake(viewBoundsRect.size.width * kPageCount, viewBoundsRect.size.height)];    // 多一个结束页
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.bounces = NO;
        [_imageScrollView setDelegate:self];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _imageScrollView;
}

- (UIButton *)enterButton {
    
    if (!_enterButton) {
        
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setBackgroundColor:UIColorFromRGB(0xff6866)];
        [_enterButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         _enterButton.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        _enterButton.layer.cornerRadius = 6.0f;
        [_enterButton addTarget:self action:@selector(tapDetected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _enterButton;
}

#pragma mark - Private Method

- (void)addSubviews
{
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    
    CGRect viewBoundsRect = [self.view bounds];
    
    NSString *imagePathFormat = @"introduction_page%d@2x";
//    if (Main_Screen_Height > 480.0f) {
//        imagePathFormat = @"introduction-568h_page%d@2x";
//    } else {
//        imagePathFormat = @"introduction_page%d@2x";
//    }
    
    for (NSInteger imgIndex = 0; imgIndex < kPageCount; imgIndex++) {
        
        UIView *subView;
        
        if (imgIndex == kPageCount - 1 ) {
            //最后一张图片添加点击事件
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
            singleTap.numberOfTapsRequired = 1;
           
            
            subView = [[UIView alloc] initWithFrame:CGRectMake(viewBoundsRect.size.width * imgIndex, viewBoundsRect.origin.y, viewBoundsRect.size.width, viewBoundsRect.size.height)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewBoundsRect.size.width, viewBoundsRect.size.height)];
            imageView.backgroundColor = [UIColor whiteColor];
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:imagePathFormat, imgIndex] ofType:@"png"];
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:singleTap];
            [imageView setImage:image];
            
            // self.enterButton.frame = CGRectMake(30.0f, Main_Screen_Height - 103.0f, Main_Screen_Width - 60.0f, 50.0f);
            
            [subView addSubview:imageView];
            // [subView addSubview:self.enterButton];
            
//            [self.imageScrollView addSubview:self.enterButton];
        }
        else {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewBoundsRect.size.width * imgIndex, viewBoundsRect.origin.y, viewBoundsRect.size.width, viewBoundsRect.size.height)];
            imageView.backgroundColor = [UIColor whiteColor];
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:imagePathFormat, imgIndex] ofType:@"png"];
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView setImage:image];
            
            subView = imageView;
        }
        
        
        [self.imageScrollView addSubview:subView];
    }
    
    [self.view addSubview:self.imageScrollView];
}


#pragma mark - Selector

-(void)tapDetected:(UITapGestureRecognizer *)gestureRecognizer
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(introductionViewDidFinish:)]){
        [self.delegate introductionViewDidFinish:self];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /*
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger index = (offset.x / bounds.size.width);
     */
}

@end
