//
//  Json.m
//  meteroid
//
//  Copyright (C) 2013  Gerrit Giehl <r4mp@chaosdorf.de>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "Json.h"

@implementation Json

- (id)jsonPostRequest:(NSData *)jsonRequestData methodename:(NSString *)tmpMethodename hostname:(NSString *)tmpHostname port:(int)tmpPort useSsl:(BOOL)tmpSsl
{
    NSString *http = @"http://";
    NSString *https = @"https://";
    
    if((tmpMethodename == nil) || (tmpHostname == nil) || (tmpPort == 0)) {
        NSLog(@"Hostname: %@, Port: %d, Methodname: %@", tmpHostname, tmpPort, tmpMethodename);
        return nil;
    }
    
    NSMutableString *msUrl = [[NSMutableString alloc] init];
    
    if(tmpSsl == TRUE) {
        [msUrl appendString: https];
    } else {
        [msUrl appendString: http];
    }
    
    NSString *newHostname = [tmpHostname copy];
    
    if ([tmpHostname hasPrefix:http]) {
        newHostname = [tmpHostname substringFromIndex:[http length]];
    }
    
    if ([tmpHostname hasPrefix:https]) {
        newHostname = [tmpHostname substringFromIndex:[https length]];
    }
    
    url = [[Url alloc] init];
    
    [msUrl appendString: [url encodeToPercentEscapeString:newHostname]];
    [msUrl appendString: @":"];
    [msUrl appendString: [NSString stringWithFormat:@"%d", tmpPort]];
    [msUrl appendString: @"/"];
    [msUrl appendString: tmpMethodename ]; //[url encodeToPercentEscapeString:tmpMethodename]]; <-- Escaped auch die '/', wenn diese gewollt sind
    
    // the request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: msUrl] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    
    if(jsonRequestData != nil)
    {
        // bind request with jsonRequestData
        [request setHTTPMethod:@"POST"]; // n.b. it's a post request. not get!
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonRequestData length]] forHTTPHeaderField:@"Content-Length"]; // set jsonRequestData length
        [request setHTTPBody:jsonRequestData]; // set jsonRequestData into body
    }
    
    // send sync request
    NSURLResponse* response = nil;
    NSError* error = nil;
    
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error == nil) {
        return result;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
    
    return nil;
}

@end
