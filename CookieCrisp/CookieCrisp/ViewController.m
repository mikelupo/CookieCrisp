//
//  ViewController.m
//  CookieCrisp
//
//  Created by Michael Lupo on 10/24/18.
//  Copyright © 2018 Michael Lupo. All rights reserved.
//

#import "ViewController.h"
#import "SessionDelegate.h"

@interface ViewController ()
@property (nonatomic, nullable, strong, readwrite) SessionDelegate	*theDelegate;
@end

@implementation ViewController
@synthesize textFieldURL;
@synthesize cookieNameTextField;
@synthesize cookieValueTextField;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.theDelegate = [[SessionDelegate alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)onGoButtonClicked:(UIButton *)sender {
	NSString * myString = self.textFieldURL.text;
	NSLog(@"%@", myString);

	//Configure a NSURL Session and execute it.
	NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
	//[VocServiceFactory setupSessionConfiguration:sessionConfig];

	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self.theDelegate delegateQueue:nil];
	__block NSURL *url_A = [NSURL URLWithString:@"http://www.html-kit.com/tools/cookietester"];
	NSMutableURLRequest *request_A = [NSMutableURLRequest requestWithURL:url_A];

	request_A.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;

	NSURLSessionDataTask *dataTask = [session dataTaskWithRequest: request_A];
	[dataTask resume];
	[session finishTasksAndInvalidate];

	NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
	for (NSHTTPCookie *cookie in cookies) {
		NSLog(@"Cookie is: %@=%@; %@; %@; %@; %@", cookie.name, cookie.value, cookie.domain, cookie.path, cookie.expiresDate, cookie.sessionOnly?@"Session":@"Permanent");
	}



}
- (IBAction)onSetCookieButtonPressed:(UIButton *)sender {

	NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

	NSURLSession *sessionA = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self.theDelegate delegateQueue:nil];
	__block NSURL *url_A = [NSURL URLWithString:self.textFieldURL.text];
	NSMutableURLRequest *request_A = [NSMutableURLRequest requestWithURL:url_A];
//Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*;q=0.8
//																					  Accept-Encoding: gzip, deflate
//																					  Accept-Language: en-US,en;q=0.9
//																					  Cache-Control: max-age=0
//																					  Connection: keep-alive
//																					  Content-Length: 58
//																					  Content-Type: application/x-www-form-urlencoded
//																					  Host: www.html-kit.com
//																					  Origin: http://www.html-kit.com
//																					  Referer: http://www.html-kit.com/tools/cookietester/
//																					  Upgrade-Insecure-Requests: 1
//																					  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36
	NSDictionary *requestHeaders = @{@"Content-Type": @"application/x-www-form-urlencoded",
									 @"Accept": @"text/html,application/xhtml+xml,application/xml",
									 @"Cache-Control": @"max-age=0",
									 @"Connection" : @"keep-alive",
									 @"Host": url_A.host,
									 @"referer": [url_A absoluteString],
									 @"Upgrade-Insecure-Requests":@"1"
									 };
	[request_A setAllHTTPHeaderFields:requestHeaders];

	request_A.cachePolicy=NSURLRequestReloadIgnoringLocalCacheData;
	request_A.HTTPMethod = @"POST";

	NSMutableDictionary *mapData = [[NSMutableDictionary alloc] init];
	[mapData setObject:self.cookieNameTextField.text forKey:@"cn"];
	[mapData setObject:self.cookieValueTextField.text forKey:@"cv"];

	NSError * error;
	NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
	[request_A setHTTPBody:postData];

	NSURLSessionDataTask *dataTask = [sessionA dataTaskWithRequest:request_A completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if(error) {
			NSLog(@"LOSER! %@", [error description]);
		}
	}];
	
	[dataTask resume];
	//[sessionA finishTasksAndInvalidate];

	NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
	for (NSHTTPCookie *cookie in cookies) {
		NSLog(@"Cookie is: %@=%@; %@; %@; %@; %@", cookie.name, cookie.value, cookie.domain, cookie.path, cookie.expiresDate, cookie.sessionOnly?@"Session":@"Permanent");
	}
}

@end
