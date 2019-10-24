//
//  CheckOutViewController.m
//  SingWebViewApp
//
//  Created by Youra Dev on 9/24/19.
//  Copyright © 2019 Youra Dev. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "CheckOutViewController.h"
#import "success.h"
#import "cancel.h"
#import "error.h"
#import "pay_later.h"

@interface CheckOutViewController ()

@end

@implementation CheckOutViewController
@synthesize baseUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Check Out";
    // Do any additional setup after loading the view, typically from a nib.
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [userContentController addScriptMessageHandler: self name:@"myOwnJSHandler"];
    configuration.userContentController = userContentController;
    
    CGRect frame = CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    _webview = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    // afer get url
//    NSURL *candidatesURL = [NSURL URLWithString:[self.baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *getUrl = [NSURL URLWithString:self.baseUrl];
       NSLog(@"%@",getUrl);
    NSURL *url = getUrl;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [_webview loadRequest:urlRequest];
    [self.view addSubview:_webview];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
                                                            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *messageCode = [json valueForKeyPath:@"code"];
   NSLog(@"======== JSON..... %@",json);
    if([messageCode isEqualToString:@"SUCCESS"]){
           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
           SuccessController *myNewVC = (SuccessController*)[storyboard instantiateViewControllerWithIdentifier:@"SuccessController"];
        myNewVC.messageData = json;
           [self.navigationController pushViewController:myNewVC animated:YES];
    }else if([messageCode isEqualToString:@"PENDING"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                  PayLaterController *myNewVC = (PayLaterController*)[storyboard instantiateViewControllerWithIdentifier:@"PayLaterController"];
                  [self.navigationController pushViewController:myNewVC animated:YES];
    }else if([messageCode isEqualToString:@"400"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                  ErrorController *myNewVC = (ErrorController*)[storyboard instantiateViewControllerWithIdentifier:@"ErrorController"];
                  [self.navigationController pushViewController:myNewVC animated:YES];
    }else if([messageCode isEqualToString:@"499"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                  ErrorController *myNewVC = (ErrorController*)[storyboard instantiateViewControllerWithIdentifier:@"ErrorController"];
                  [self.navigationController pushViewController:myNewVC animated:YES];
    }else if([messageCode isEqualToString:@"CANCEL"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
                  CancelController *myNewVC = (CancelController*)[storyboard instantiateViewControllerWithIdentifier:@"CancelController"];
                  [self.navigationController pushViewController:myNewVC animated:YES];
    }else{
        NSLog(@"message else");
    }
}



@end
