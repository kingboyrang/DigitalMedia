//
//  BasicViewController.m
//  HsinchuElderly
//
//  Created by aJia on 2014/5/7.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "BasicViewController.h"
#import "UIButton+TPCategory.h"
@interface BasicViewController (){
    AnimateLoadView *_loadView;
    AnimateErrorView *_errorView;
    AnimateErrorView *_successView;
}
- (UIBarButtonItem*)barBackButtonItem;
- (void)buttonBackClick:(id)sender;
@end

@implementation BasicViewController

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
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count>1) {
            self.navigationItem.leftBarButtonItem=[self barBackButtonItem];
        }
    }
}
- (UIBarButtonItem*)barBackButtonItem{
    UIButton *btn=[UIButton buttonWithImageName:@"back.png" target:self action:@selector(buttonBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return barBtn;
}
- (float)topHeight{
    float h=0;
    if (self.tabBarController) {
        h+=44;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        if (self.navigationController) {
            h+=64;
        }
    }else{
       if (self.navigationController) {
         h+=44;
       }
    }
    return h;
}
- (BOOL)hasNewWork{
    return YES;
    //return [NetWorkConnection IsEnableConnection];
}
- (void)buttonBackClick:(id)sender{
    if (![self backPrevViewController]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)backPrevViewController{
    return YES;
}
- (NSString*)deviceImageName:(NSString*)name forType:(NSString*)type{
    if (DeviceIsPad) {
      return  [NSString stringWithFormat:@"%@@2x.%@",name,type];
    }
    return [NSString stringWithFormat:@"%@.%@",name,type];
}
- (UIImage*)deviceImageWithName:(NSString*)name forType:(NSString*)type{
    return [UIImage imageNamed:[self deviceImageName:name forType:type]];
}
#pragma mark 动画提示
-(AnimateErrorView*) errorView {
    
    if (!_errorView) {
        _errorView=[[AnimateErrorView alloc] initWithFrame:CGRectMake(0,4, self.view.bounds.size.width, 40)];
        _errorView.backgroundColor=[UIColor redColor];
        [_errorView setErrorImage:[UIImage imageNamed:@"notice_error_icon.png"]];
    }
    return _errorView;
}

-(AnimateLoadView*) loadingView {
    if (!_loadView) {
        _loadView=[[AnimateLoadView alloc] initWithFrame:CGRectMake(0,4, self.view.bounds.size.width, 40)];
    }
    return _loadView;
}
-(AnimateErrorView*) successView {
    if (!_successView) {
        _successView=[[AnimateErrorView alloc] initWithFrame:CGRectMake(0, 4, self.view.bounds.size.width, 40)];
        _successView.backgroundColor=[UIColor colorFromHexRGB:@"51c345"];
        [_successView setErrorImage:[UIImage imageNamed:@"notice_success_icon.png"]];
    }
    return _successView;
}
-(void) showLoadingAnimatedWithTitle:(NSString*)title{
    [self showLoadingAnimated:^(AnimateLoadView *errorView) {
        errorView.labelTitle.text=title;
    }];
}
-(void) showLoadingAnimated:(void (^)(AnimateLoadView *errorView))process{
    AnimateLoadView *loadingView = [self loadingView];
    if (process) {
        process(loadingView);
    }
    [self.view addSubview:loadingView];
    CGRect r=loadingView.frame;
    r.origin.y=2;
    [loadingView.activityIndicatorView startAnimating];
    [UIView animateWithDuration:0.5f animations:^{
        loadingView.frame=r;
    }];
}

-(void) hideLoadingViewAnimated:(void (^)(AnimateLoadView *hideView))complete{
    
    AnimateLoadView *loadingView = [self loadingView];
    CGRect r=loadingView.frame;
    r.origin.y=-r.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        loadingView.frame=r;
    } completion:^(BOOL finished) {
        [loadingView.activityIndicatorView stopAnimating];
        [loadingView removeFromSuperview];
        if (complete) {
            complete(loadingView);
        }
    }];
}


-(void) showErrorViewAnimated:(void (^)(AnimateErrorView *errorView))process{
    AnimateErrorView *errorView = [self errorView];
    if (process) {
        process(errorView);
    }
    [self.view addSubview:errorView];
    CGRect r=errorView.frame;
    r.origin.y=2;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    }];
}
-(void) hideErrorViewAnimatedWithDuration:(NSTimeInterval)duration completed:(void (^)(AnimateErrorView *errorView))complete{
    
    AnimateErrorView *errorView = [self errorView];
    CGRect r=errorView.frame;
    r.origin.y=-r.size.height;
    [UIView animateWithDuration:duration animations:^{
        errorView.frame=r;
    } completion:^(BOOL finished) {
        if (finished) {
            [errorView removeFromSuperview];
            if (complete) {
                complete(errorView);
            }
        }
    }];
}
-(void) hideErrorViewAnimated:(void (^)(AnimateErrorView *errorView))complete{
    [self hideErrorViewAnimatedWithDuration:0.5f completed:complete];
}
-(void) showErrorViewWithHide:(void (^)(AnimateErrorView *errorView))process completed:(void (^)(AnimateErrorView *errorView))complete{
    [self showErrorViewAnimated:process];
    //设置延迟执行时间为1秒
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hideErrorViewAnimated:complete];
    });
}
-(void) hideLoadingFailedWithTitle:(NSString*)title completed:(void (^)(AnimateErrorView *errorView))complete{
    [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
        [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
            errorView.labelTitle.text=title;
        } completed:complete];
    }];
}
-(void) showSuccessViewAnimated:(void (^)(AnimateErrorView *errorView))process{
    AnimateErrorView *errorView = [self successView];
    if (process) {
        process(errorView);
    }
    [self.view addSubview:errorView];
    CGRect r=errorView.frame;
    r.origin.y=2;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    }];
}
-(void) hideSuccessViewAnimated:(void (^)(AnimateErrorView *errorView))complete{
    AnimateErrorView *errorView = [self successView];
    CGRect r=errorView.frame;
    r.origin.y=-r.size.height;
    [UIView animateWithDuration:0.5f animations:^{
        errorView.frame=r;
    } completion:^(BOOL finished) {
        [errorView removeFromSuperview];
        if (complete) {
            complete(errorView);
        }
    }];
}
-(void) showSuccessViewWithHide:(void (^)(AnimateErrorView *errorView))process completed:(void (^)(AnimateErrorView *errorView))complete{
    [self showSuccessViewAnimated:process];
    //设置延迟执行时间为1秒
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime =
    dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self hideSuccessViewAnimated:complete];
    });
    
}
-(void) hideLoadingSuccessWithTitle:(NSString*)title completed:(void (^)(AnimateErrorView *errorView))complete{
    [self hideLoadingViewAnimated:^(AnimateLoadView *hideView) {
        [self showSuccessViewAnimated:^(AnimateErrorView *errorView) {
            errorView.labelTitle.text=title;
        }];
        [self performSelector:@selector(hideSuccessViewAnimated:) withObject:complete afterDelay:1.0f];
    }];
}
- (void) showErrorNetWorkNotice:(void (^)(void))dismissError{
    
    [self showErrorViewWithHide:^(AnimateErrorView *errorView) {
        errorView.labelTitle.text=@"網絡未連接,請檢查!";
    } completed:nil];
}
- (void) showMessageWithTitle:(NSString*)title{
    [self showMessageWithTitle:title innerView:self.view dismissed:nil];
}
- (void) showMessageWithTitle:(NSString*)title innerView:(UIView*)view dismissed:(void(^)())completed{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
