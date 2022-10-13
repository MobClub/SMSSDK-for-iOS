//
//  SMSDemoPolicyWebVC.m
//  SMSSDKDemo
//
//  Created by Brilance on 2020/2/7.
//  Copyright © 2020年 youzu. All rights reserved.
//

#import "SMSDemoPolicyWebVC.h"
#import <WebKit/WebKit.h>

@interface SMSDemoPolicyWebVC ()

@end

@implementation SMSDemoPolicyWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebView *webView = [[WKWebView alloc] init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:webView];
    
    UIView *containtView = self.view;
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containtView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    
    [containtView addConstraint:bottom];
    [containtView addConstraint:top];
    [containtView addConstraint:left];
    [containtView addConstraint:right];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
