//
//  FBWebViewController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBWebViewController.h"
#import <WebKit/WebKit.h>

@interface FBWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation FBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.navTitle;
    
    WKWebView *webView = [[WKWebView alloc] init];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    // 创建 UIProgressView
   self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + 44, self.view.frame.size.width, 2)];
   [self.view addSubview:self.progressView];
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(StatusBarHeight + 44);
//        make.left.offset(0);
//        make.right.offset(0);
//        make.height.offset(0);
//    }];

   // 监听 WKWebView 的 estimatedProgress 属性
   [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

// KVO 监听 estimatedProgress 属性的变化
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
   if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
       [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
   }
}

// WKNavigationDelegate 代理方法，当页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
   self.progressView.hidden = NO;
}

// WKNavigationDelegate 代理方法，当页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   self.progressView.hidden = YES;
}

// 移除 KVO 监听
- (void)dealloc {
   [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
