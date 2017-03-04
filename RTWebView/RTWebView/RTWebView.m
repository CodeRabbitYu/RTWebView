//
//  RTWebView.m
//  RTWebView
//
//  Created by Rabbit on 2017/3/2.
//  Copyright © 2017年 Rabbit. All rights reserved.
//

#import "RTWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface RTWebView()<WKNavigationDelegate,WKScriptMessageHandler,UIWebViewDelegate,RTWebViewDelegate>

/** UIWebView */
@property(nonatomic, copy) UIWebView *rt_webView;
/** WKWebView */
@property(nonatomic, strong) WKWebView *rt_wkWebView;
/** NSMutableURLRequest */
@property(nonatomic, strong) NSMutableURLRequest *rt_request;
/** RTWebViewDelegate */
@property (nonatomic,assign) id<RTWebViewDelegate> rt_delegate;
/** Frame */
@property(nonatomic, assign) CGRect rt_frame;
/** HTMLString */
@property(nonatomic, strong) NSString *rt_HTMLString;

@end

@implementation RTWebView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    RTLog(@"SDK_VERSION : %f",SDK_VERSION);
    if (self) {
        self.rt_frame = frame;
        [self Initialize];
        [self InitializeWebView];
    }
    return self;
}

- (void)dealloc{
    _rt_webView = nil;
    _rt_wkWebView = nil;
    _rt_delegate = nil;
}

- (void)setRequest:(NSMutableURLRequest *)request{
    if (request) {
        self.rt_request = request;
    }else {
        RTLog(@"请输入Request");
    }
}

- (void)setDelegate:(id<RTWebViewDelegate>)delegate{
    if (delegate) {
        self.rt_delegate = delegate;
    }
}

- (void)setHTMLString:(NSString *)HTMLString{
    if (HTMLString){
        self.rt_HTMLString = HTMLString;
    }
}

- (void)Initialize{
    
}

// 初始化设置
- (void)InitializeWebView{
    if (SDK_VERSION >= 8.0) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        //通过JS与webView内容交互
        config.userContentController = [WKUserContentController new];
        _rt_wkWebView = [[WKWebView alloc] initWithFrame:self.rt_frame configuration:config];
        [self addSubview:_rt_wkWebView];
        self.rt_wkWebView.navigationDelegate = self;
        self.rt_wkWebView.backgroundColor = [UIColor whiteColor];
        
    } else {
        _rt_webView = [[UIWebView alloc] initWithFrame:self.rt_frame];
        [self addSubview:_rt_webView];
        self.rt_webView.delegate = self;
        self.rt_webView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)loadRequest{
    
    if (self.rt_request) {
        if (SDK_VERSION >= 8.0) {
            if (self.rt_request.URL.isFileURL) {
                NSString *url = [NSString stringWithContentsOfFile:self.rt_request.URL.path encoding:NSUTF8StringEncoding error:nil];
                [self.rt_wkWebView loadHTMLString:url baseURL:nil];
            }else{
                [self.rt_wkWebView loadRequest:self.rt_request];
            }
        }else{
            [self.rt_webView loadRequest:self.rt_request];
        }
    }
    
    if(self.rt_HTMLString){
        [self.rt_wkWebView removeFromSuperview];
        
        _rt_webView = [[UIWebView alloc] initWithFrame:self.rt_frame];
        [self addSubview:_rt_webView];
        self.rt_webView.delegate = self;
        
        NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
        NSString *path = [mainBundleDirectory  stringByAppendingPathComponent:self.rt_HTMLString];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.rt_webView loadRequest:request];
    }
    
    
    
    
    
    
}

#pragma mark - UIWebView Delegate
/**
 *  当网页视图被指示载入内容而得到通知
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.rt_delegate rtWebView:self shouldStartLoadWithRequest:request navigationType:(RTWebViewNavigationType)navigationType];
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebViewDidStartLoad:)]) {
        [self.rt_delegate rtWebViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebViewDidFinishLoad:)]) {
        [self.rt_delegate rtWebViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebView:didLoadFailedWithError:)]) {
        [self.rt_delegate rtWebView:self didLoadFailedWithError:error];
    }
}

#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebView:shouldStartLoadWithRequest:navigationType:)]) {
        if ([self.rt_delegate rtWebView:self shouldStartLoadWithRequest:navigationAction.request navigationType:(RTWebViewNavigationType)navigationAction.navigationType]) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebViewDidStartLoad:)]) {
        [self.rt_delegate rtWebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.rt_delegate respondsToSelector:@selector(rtWebViewDidFinishLoad:)]) {
        [self.rt_delegate rtWebViewDidFinishLoad:self];
    }
}

//  请求开始时发生错误
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    RTLog(@"didFailProvisionalNavigation  Error:%@",error);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.rt_delegate respondsToSelector:@selector(rtWebView:didLoadFailedWithError:)]) {
            [self.rt_delegate rtWebView:self didLoadFailedWithError:error];
        }
    });
}

//  请求期间发生错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    RTLog(@"didFailNavigation   Error:%@",error);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.rt_delegate respondsToSelector:@selector(rtWebView:didLoadFailedWithError:)]) {
            [self.rt_delegate rtWebView:self didLoadFailedWithError:error];
        }
        
    });
}

#pragma mark   wkWebView   js  called oc  (ScriptMessage Handler)
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    RTLog(@"message.body : %@ \nmessage.name:%@",message.body,message.name);
    if ([self.delegate respondsToSelector:@selector(rtWebView:didCalledJSFunctionName:andParam:)]) {
        [self.delegate rtWebView:self didCalledJSFunctionName:message.name andParam:message.body];
    }
}

@end
