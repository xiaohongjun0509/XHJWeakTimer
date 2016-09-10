//
//  XHJWeakTimer.m
//  XHJWeakTimer
//
//  Created by xiaohongjun on 16/9/10.
//  Copyright © 2016年 xiaohongjun. All rights reserved.
//

#import "XHJWeakTimer.h"

@interface XHJWeakTimer ()
{
    __weak id _target;//weak reference to target to avoid retain cycle.
    BOOL _repeat;
    SEL _selector;
    NSTimeInterval _interval;
    NSTimeInterval _delay;
    id _selectorInfo;
    dispatch_source_t _timer;
}
@end


@implementation XHJWeakTimer
- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                      interval:(NSTimeInterval)interval
                        repeat:(BOOL)repeat
                          info:(id)info{
    if (self = [super init]) {
        self = [self initWithTarget:target selector:selector interval:interval delay:0 repeat:repeat
                              info:info];
    }
    return self;
}

- (instancetype)initWithTarget:(id)target
                      selector:(SEL)selector
                      interval:(NSTimeInterval)interval
                         delay:(NSTimeInterval)delay
                        repeat:(BOOL)repeat
                          info:(id)info{
    if (self = [super init]) {
        _target = target;
        _selector = selector;
        _interval = interval;
        _selectorInfo = info;
        _repeat = repeat;
        _delay = delay;
        [self setupTimerSource];
    }
    return self;
}

- (void)setupTimerSource{
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC, _delay * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [self execute];
    });
}

- (void)fire{
    dispatch_resume(_timer);
}
- (void)execute{
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (_target && _repeat) {
        [_target performSelector:_selector withObject:_selectorInfo];
    }else{
        [_target performSelector:_selector withObject:_selectorInfo];
        dispatch_source_cancel(_timer);
    }
}

- (void)invalidate{
    dispatch_source_cancel(_timer);
}
@end
