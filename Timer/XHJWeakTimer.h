//
//  XHJWeakTimer.h
//  XHJWeakTimer
//
//  Created by xiaohongjun on 16/9/10.
//  Copyright © 2016年 xiaohongjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHJWeakTimer : NSObject

@property (nonatomic, assign) NSTimeInterval interval;

- (instancetype)initWithTarget:(id)target selector:(SEL)selector interval:(NSTimeInterval)interval repeat:(BOOL)repeat info:(id)info;

- (void)invalidate;

- (void)fire;
@end
