//
//  YXHelpViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/9.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXHelpViewController.h"
#import <WebKit/WebKit.h>
@interface YXHelpViewController ()<WKNavigationDelegate>
@property (nonatomic,weak) WKWebView *wkWebView;
@property (nonatomic,weak) UIActivityIndicatorView *IndicatorView;
@end

@implementation YXHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
}
- (void)initActivityIndicatorView{
    UIActivityIndicatorView   *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                        initWithFrame : CGRectMake(0.0f, 0.0f, 140.0f, 140.0f)] ;
    [activityIndicatorView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview :activityIndicatorView];
    self.IndicatorView = activityIndicatorView;
    [self.IndicatorView startAnimating];
}
- (void)loadWebView{
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, navHight, SCREEN_WIDTH, SCREEN_HEIGHT - navHight)];
    wkWebView.navigationDelegate = self;
    [self.view addSubview:wkWebView];
    self.wkWebView = wkWebView;
    
    [self initActivityIndicatorView];
    
    NSString *urlStr = @"";//@"http://192.168.0.222:8080/demo.html";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.wkWebView loadRequest:request];
}
#pragma mark - leftAcion
- (void)leftItemBarButton
{
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)cancle:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - WKwebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.IndicatorView stopAnimating];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    [self.IndicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
//    NSString *urlString = [navigationResponse.response.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSArray *urlComps = [urlString componentsSeparatedByString:@"?"];
//    if (urlComps.count == 2) {
//        NSString *content = urlComps[1];
//        if ([content rangeOfString:@"img"].location != NSNotFound) {
//            NSArray *contentArray = [(NSString *)[urlComps objectAtIndex:1] componentsSeparatedByString:@"&"];
//            NSString *number = [contentArray[0] componentsSeparatedByString:@"="][1];
//            NSArray *arrFucnameAndParameter = [(NSString*)contentArray[1]
//                                               componentsSeparatedByString:@"="];
//            NSArray *urlArray = [(NSString *)arrFucnameAndParameter[1] componentsSeparatedByString:@","];
//            [self showBigView:urlArray withNumber:[number integerValue]];
//            decisionHandler(WKNavigationResponsePolicyCancel);
//        }
//        else{
//            decisionHandler(WKNavigationResponsePolicyAllow);
//        }
//    }
//    else{
//        decisionHandler(WKNavigationResponsePolicyAllow);
//    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSString *urlString = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if ([urlString rangeOfString:@"tel"].location != NSNotFound) {
//        NSArray *telArray = [urlString componentsSeparatedByString:@":"];
//        if (telArray.count == 2) {
//            UIWebView *webView = [[UIWebView alloc]init];
//            webView.delegate = self;
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telArray[1]]];
//            [webView loadRequest:[NSURLRequest requestWithURL:url]];
//            [self.view addSubview:webView];
//        }
//    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
