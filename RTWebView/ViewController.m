//
//  ViewController.m
//  RTWebView
//
//  Created by Rabbit on 2017/3/2.
//  Copyright © 2017年 Rabbit. All rights reserved.
//

#import "ViewController.h"
#import "RTWebView.h"
@interface ViewController ()<RTWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    RTWebView *webView = [[RTWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.delegate = self;
    
    webView.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    webView.HTMLString = @"官方客服11.html";
    
    [webView loadRequest];
    
    webView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:webView];
    
}

- (BOOL)rtWebView:(RTWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(RTWebViewNavigationType)navigationType{
    RTLog(@"是否加载网络");
    return YES;
}
- (void)rtWebViewDidStartLoad:(RTWebView *)webView{
    RTLog(@"已经开始加载页面的代理回调方法");
}
- (void)rtWebViewDidFinishLoad:(RTWebView *)webView{
    RTLog(@"页面已经加载完成的代理回调方法");
}



@end
