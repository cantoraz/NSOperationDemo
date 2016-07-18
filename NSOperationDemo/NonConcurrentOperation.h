//
//  NonConcurrentOperation.h
//  NSOperationDemo
//
//  Created by Cantoraz Chou on 7/14/16.
//
//

#import <Foundation/Foundation.h>

@interface NonConcurrentOperation : NSOperation

- (instancetype)initWithImageURL:(NSURL*)url;

@end
