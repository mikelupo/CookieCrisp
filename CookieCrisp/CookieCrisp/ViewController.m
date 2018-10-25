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

	/* Configure session, choose between:
	 * defaultSessionConfiguration
	 * ephemeralSessionConfiguration
	 * backgroundSessionConfigurationWithIdentifier:
	 And set session-wide properties, such as: HTTPAdditionalHeaders,
	 HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
	 */
	NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

	/* Create session, and optionally set a NSURLSessionDelegate. */
	NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self.theDelegate delegateQueue:nil];

	/* Create the Request:
	 Request (POST http://www.html-kit.com/tools/cookietester)
	 */

	NSURL* URL = [NSURL URLWithString:@"http://www.html-kit.com/tools/cookietester"];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
	request.HTTPMethod = @"POST";

	// Headers

	[request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"Band=StraightAhead" forHTTPHeaderField:@"Cookie"];

	// Form URL-Encoded Body

	NSDictionary* bodyParameters = @{
									 @"cn": self.cookieNameTextField.text,
									 @"cv": self.cookieValueTextField.text,
									 };
	request.HTTPBody = [NSStringFromQueryParameters(bodyParameters) dataUsingEncoding:NSUTF8StringEncoding];

	/* Start a new Task */
	NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;

		if (error) {
			// Failure situation.
			NSLog(@"Doh! URL Session POST Task Failed: %@", [error localizedDescription]);
		}
	}];
	[task resume];
	[session finishTasksAndInvalidate];


	NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
	for (NSHTTPCookie *cookie in cookies) {
		NSLog(@"Cookie is: %@=%@; %@; %@; %@; %@", cookie.name, cookie.value, cookie.domain, cookie.path, cookie.expiresDate, cookie.sessionOnly?@"Session":@"Permanent");
	}
}

- (IBAction)doGetRequest:(UIButton *)sender {

	/* Configure session, choose between:
	 * defaultSessionConfiguration
	 * ephemeralSessionConfiguration
	 * backgroundSessionConfigurationWithIdentifier:
	 And set session-wide properties, such as: HTTPAdditionalHeaders,
	 HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
	 */
	NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

	/* Create session, and optionally set a NSURLSessionDelegate. */
	NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self.theDelegate delegateQueue:nil];

	/* Create the Request:
	 Request (POST http://www.html-kit.com/tools/cookietester)
	 */

	NSURL* URL = [NSURL URLWithString:@"http://www.html-kit.com/tools/cookietester"];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
	request.HTTPMethod = @"GET";

	/* Start a new Task */
	NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;

		if (error) {
			// Failure situation.
			NSLog(@"Doh! URL Session GET Task Failed: %@", [error localizedDescription]);
		}
	}];
	[task resume];
	[session finishTasksAndInvalidate];
}

/*
 * Utils: Add this section before your class implementation
 */

- (IBAction)doClearCookies:(UIButton *)sender {
	NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
	for (NSHTTPCookie *cookie in cookies) {
		NSLog(@"Clearing Cookie: %@=%@; %@; %@; %@; %@", cookie.name, cookie.value, cookie.domain, cookie.path, cookie.expiresDate, cookie.sessionOnly?@"Session":@"Permanent");
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
}

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
	NSMutableArray* parts = [NSMutableArray array];
	[queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
		NSString *part = [NSString stringWithFormat: @"%@=%@",
						  [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
						  [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
						  ];
		[parts addObject:part];
	}];
	return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
	NSString* URLString = [NSString stringWithFormat:@"%@?%@",
						   [URL absoluteString],
						   NSStringFromQueryParameters(queryParameters)
						   ];
	return [NSURL URLWithString:URLString];
}



@end
