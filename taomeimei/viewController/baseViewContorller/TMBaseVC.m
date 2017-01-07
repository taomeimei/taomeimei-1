//
//  TMBaseViewController.m
//  taomeimei
//
//  Created by 刘冬 on 2017/1/4.
//  Copyright © 2017年 刘冬. All rights reserved.
//

#import "TMBaseVC.h"
#import "TMBaseTabbarVC.h"
@interface TMBaseVC ()

@end

@implementation TMBaseVC{
    UITapGestureRecognizer *mTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 10;
    self.pageIndex = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickGoBack:)];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideZJTbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark public
- (void)keyboardWillHide:(NSNotification *) notification {
    [self.view removeGestureRecognizer:mTap];
    mTap = nil;
}
- (void)keyboardWillShow:(NSNotification *) notification {
    if (mTap == nil) {
        mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allTFResignFirstResponder)];
        mTap.delegate = (id)self;
        [self.view addGestureRecognizer:mTap];
    }
}
-(void)hideZJTbar{
    if ([self.tabBarController isKindOfClass:[TMBaseTabbarVC class]]) {
        TMBaseTabbarVC *tempVC = (TMBaseTabbarVC *)self.tabBarController;
        self.tabBarController.tabBar.hidden = YES;
        tempVC.mBarView.hidden =YES;
        self.tabBarController.tabBar.hidden = YES;
    }
}
-(void)unHideZJTbar{
    if ([self.tabBarController isKindOfClass:[TMBaseTabbarVC class]]) {
        TMBaseTabbarVC *tempVC = (TMBaseTabbarVC *)self.tabBarController;
        tempVC.mBarView.hidden =NO;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark event response
-(void)onclickGoBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  收起所有键盘
 */
-(void)allTFResignFirstResponder{
    LDLOG(@"收起所有的键盘");
    for (id temp in self.view.subviews) {
        if ([temp isKindOfClass:[UITextField class]]) {
            UITextField *tempTF = (UITextField *)temp;
            [tempTF resignFirstResponder];
        }else if ([temp isKindOfClass:[UITextView class]]){
            UITextView *tempTF = (UITextView *)temp;
            [tempTF resignFirstResponder];
        }else{
            if([temp isKindOfClass:[UIView class]]){
                UIView *tempView = (UIView *)temp;
                if (tempView.subviews.count>0) {
                    for (id temp1 in tempView.subviews) {
                        if ([temp1 isKindOfClass:[UITextField class]]) {
                            UITextField *tempTF = (UITextField *)temp1;
                            [tempTF resignFirstResponder];
                        }
                        if ([temp1 isKindOfClass:[UITextView class]]) {
                            UITextView *tempTF = (UITextView *)temp1;
                            [tempTF resignFirstResponder];
                        }
                    }
                }
            }
        }
    }
}
@end