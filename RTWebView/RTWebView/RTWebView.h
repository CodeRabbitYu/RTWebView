//
//  RTWebView.h
//  RTWebView
//
//  Created by Rabbit on 2017/3/2.
//  Copyright © 2017年 Rabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTWebViewDelegate;

/**
 *  系统版本
 *
 */
#define  SDK_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]
/**
 *  日志输出
 *
 */
#ifdef DEBUG // 调试状态, 打开LOG功能
#define RTLog(fmt, ...) NSLog((@"[%@ Line %d] \n"fmt "\n\n"), [[NSString stringWithFormat:@"%s",__FILE__] lastPathComponent], __LINE__, ##__VA_ARGS__);
#else // 发布状态, 关闭LOG功能
#define RTLog(...)
#endif

typedef NS_ENUM(NSInteger, RTWebViewNavigationType) {
    RTWebViewNavigationTypeLinkClicked,
    RTWebViewNavigationTypeFormSubmitted,
    RTWebViewNavigationTypeBackForward,
    RtWebViewNavigationTypeReload,
    RTWebViewNavigationTypeFormResubmitted,
    RTWebViewNavigationTypeOther
};

@interface RTWebView : UIView

/** 网络请求 */
@property (nonatomic,strong) NSMutableURLRequest *request;
/** 加载本地html */
@property(nonatomic, strong) NSString *HTMLString;
/** RTWebViewDelegate */
@property (nonatomic,assign) id<RTWebViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)loadRequest;


@end

@protocol RTWebViewDelegate <NSObject>

@optional

/**
 *  是否允许加载请求页面的代理回调方法
 *
 *  @param webView        显示页面的web控件
 *  @param request        请求封装对象
 *  @param navigationType 导航类型
 *
 *  @return 是否允许加载的布尔值
 */
- (BOOL)rtWebView:(RTWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(RTWebViewNavigationType)navigationType;

/**
 *  已经开始加载页面的代理回调方法
 *
 *  @param webView 显示页面的web控件
 */
- (void)rtWebViewDidStartLoad:(RTWebView *)webView;

/**
 *  页面已经加载完成的代理回调方法
 *
 *  @param webView 显示页面的web控件
 */
- (void)rtWebViewDidFinishLoad:(RTWebView *)webView;

/**
 *  页面加载失败的代理回调方法
 *
 *  @param webView 显示页面的web控件
 *  @param error   加载失败的错误信息
 */
- (void)rtWebView:(RTWebView *)webView  didLoadFailedWithError:(NSError *)error;
/**
 *  html页面调用了之前注册的js，会触发的客户端回调方法
 *
 *  @param webController 显示页面的web控件
 *  @param functionName  html触发的js的名字
 *  @param jsonString    由html传递过来的json参数
 */
- (void)rtWebView:(RTWebView *)webController didCalledJSFunctionName:(NSString *)functionName andParam:(id)jsonString;

@end
