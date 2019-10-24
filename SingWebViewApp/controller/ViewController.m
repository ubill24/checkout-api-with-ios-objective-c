//
//  ViewController.m
//  SingWebViewApp
//
//  Created by Youra Dev on 9/24/19.
//  Copyright © 2019 Youra Dev. All rights reserved.
//

#import "ViewController.h"
#import "CheckOutViewController.h"
@interface ViewController ()

@property NSString *CHECKOUT_URL;

@end

@implementation ViewController
- (IBAction)api_token:(UITextField *)sender {
}
- (IBAction)amount:(id)sender {
}


- ( void )viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Confirm Order";
}

- (IBAction)CheckOutOrder:(id)sender {
    [self handleCheckout];
}

- ( void )handleCheckout
{
    NSString *TOKEN = @"a8024ffe355342ef890fcebed5ad3009";
    NSString *BASE_URL= @"https://checkoutapi-demo.bill24.net/transaction/init";
    NSDictionary *jsonBodyDict = @{@"description": @"Description" ,@"currency": @"USD", @"amount":@100, @"reference_id": @"YOURA869718501", @"webview": @true, @"pay_later_url": @"https://checkoutapi-demo.bill24.net/checkout/pay-later"};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // insert whatever URL you would like to connect to
    [request setURL:[NSURL URLWithString:BASE_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:TOKEN forHTTPHeaderField:@"token"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request completionHandler:^( NSData *data, NSURLResponse *response, NSError *error )
                                  {
                                      dispatch_async( dispatch_get_main_queue(),
                                                     ^{
                                                         // parse returned data
                                                         NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                                         NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                                                         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          self.CHECKOUT_URL = [json valueForKeyPath:@"data.payment_url"];
                                          [self navigateToMyNewViewController];
                                                         NSLog(@"%@",[json valueForKeyPath:@"data.payment_url"]);
                                          
                                                                                             } );
                                  }];
    
    [task resume];
    
   
}

- (void)navigateToMyNewViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"bundle:nil];
    CheckOutViewController *myNewVC = (CheckOutViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CheckOutViewController"];
    myNewVC.baseUrl =self.CHECKOUT_URL;
    [self.navigationController pushViewController:myNewVC animated:YES];
}

- ( NSURLSession * )getURLSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
                  ^{
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      session = [NSURLSession sessionWithConfiguration:configuration];
                  } );
    
    return session;
}


- ( void )didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
