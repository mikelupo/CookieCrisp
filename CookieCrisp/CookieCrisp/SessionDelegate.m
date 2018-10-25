//
//  SessionDelegate.m
//  CookieCrisp
//
//  Created by Michael Lupo on 10/24/18.
//  Copyright © 2018 Michael Lupo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionDelegate.h"

@implementation SessionDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
	NSLog(@"Did receive response on File Download.");
	completionHandler(NSURLSessionResponseAllow);

}

-(void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
	NSLog(@"Data Length %lu", (unsigned long)data.length);
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
	NSLog(@"Session Task didCompleteWithError.");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
	NSLog(@"You were redirected. New request is: %@ ", request.URL );
	NSLog(@"New HTTP Headers are: %@", request.allHTTPHeaderFields);
	completionHandler(request);
}

//Per Brian S, this prevents APPLE from caching the response.
//Always include this in our delegate methods for testing (unless you specificaly want this)
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler
{
	completionHandler(NULL);
}

@end
