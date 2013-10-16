//
//  YOperation.m
//
//  Created by Nobukatsu Yakushiji on 2012/10/17.
//  Copyright (c) 2012年 K.K. All rights reserved.
//

#import "YOperation.h"

@implementation YOperation

@synthesize delegate = _delegate;
@synthesize tag = _tag;
@synthesize lastError = _lastError;

@synthesize didStartBlock         = _didStartBlock;
@synthesize didFinishBlock        = _didFinishBlock;
@synthesize didFailWithErrorBlock = _didFailWithErrorBlock;
@synthesize willFinishBlock       = _willFinishBlock;

- (id)init
{
    self = [super init];
    if (self) {
        self.executing = NO;
        self.finished = NO;
    }
    return self;
}

- (void)dealloc {
    _didStartBlock = nil;
    _didFinishBlock = nil;
    _didFailWithErrorBlock = nil;
    _willFinishBlock = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didStart {
	[self performSelectorOnMainThread: @selector(onMainThreadOperationDidStart)
                           withObject: nil
                        waitUntilDone: [NSThread isMainThread]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinish {
	[self performSelectorOnMainThread: @selector(onMainThreadOperationDidFinish)
                           withObject: nil
                        waitUntilDone: [NSThread isMainThread]];
    [self completeOperation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailWithError:(NSError *)error {
    self.lastError = error;
    
	[self performSelectorOnMainThread: @selector(onMainThreadOperationDidFailWithError:)
                           withObject: error
                        waitUntilDone: [NSThread isMainThread]];
    [self completeOperation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willFinish {
    if ([self.delegate respondsToSelector:@selector(operationWillFinish:)]) {
        [self.delegate operationWillFinish:self];
    }
    
    if (nil != self.willFinishBlock) {
        self.willFinishBlock(self);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)progressChanged:(NSInteger)percentage
{
    [self performSelectorOnMainThread: @selector(onMainThreadOperationProgressChanged:)
                           withObject: [NSNumber numberWithInt:percentage]
                        waitUntilDone: [NSThread isMainThread]];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Main Thread


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onMainThreadOperationDidStart {
    if ([self.delegate respondsToSelector:@selector(operationDidStart:)]) {
        [self.delegate operationDidStart:self];
    }
    
    if (nil != self.didStartBlock) {
        self.didStartBlock(self);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onMainThreadOperationDidFinish {
    if ([self.delegate respondsToSelector:@selector(operationDidFinish:)]) {
        [self.delegate operationDidFinish:self];
    }
    
    if (nil != self.didFinishBlock) {
        self.didFinishBlock(self);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onMainThreadOperationDidFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(operationDidFail:withError:)]) {
        [self.delegate operationDidFail:self withError:error];
    }
    
    if (nil != self.didFailWithErrorBlock) {
        self.didFailWithErrorBlock(self, error);
    }
}

- (void)onMainThreadOperationProgressChanged:(NSNumber*)percentage
{
    if ([self.delegate respondsToSelector:@selector(operationProgressChenged:percentage:)]) {
        [self.delegate operationProgressChenged:self percentage:[percentage integerValue]];
    }
    
    if (nil != self.progressChangedBlock) {
        self.progressChangedBlock(self, [percentage integerValue]);
    }
}

#pragma mark - Operatin 

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key {
    if ([key isEqualToString:@"isExecuting"] ||
        [key isEqualToString:@"isFinished"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

// YES を返さないとメインスレッド以外で動かなくなる
- (BOOL)isConcurrent {
    return YES;
}

- (void)start {
    // タスクを起動する前に、キャンセルされていないかどうか確認する。
    if ([self isCancelled])
    {
        // キャンセルされていれば、オペレーションを完了状態に移行する。
        [self completeOperation];        
        return;
    }
    
    // キャンセルされていなければ、タスクの実行を開始する。
    self.executing = YES;
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
}

- (void)main {
    @try {
        // オペレーション本来の処理をここで実行する。 [self completeOperation];
    }
    @catch(...) {
        // 例外を再スローしない。 }
    }
}

- (void)completeOperation {
     self.executing = NO;
     self.finished = YES;
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
    
}

@end
