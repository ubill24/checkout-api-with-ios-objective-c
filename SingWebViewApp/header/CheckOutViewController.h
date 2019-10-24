//
//  CheckOutViewController.h
//  SingWebViewApp
//
//  Created by Youra Dev on 9/24/19.
//  Copyright © 2019 Youra Dev. All rights reserved.
//

#ifndef CheckOutViewController_h
#define CheckOutViewController_h
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface  CheckOutViewController : UIViewController <WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *webview;
@property (nonatomic, assign) NSString  *baseUrl;

@end



#endif /* CheckOutViewController_h */
