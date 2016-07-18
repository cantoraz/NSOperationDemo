//
//  ConcurrentThreadedOperation.h
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/15/16.
//
//

#import <Foundation/Foundation.h>

@interface ConcurrentThreadedOperation : NSOperation

- (instancetype)initWithImageURL:(NSURL*)url;

@end
