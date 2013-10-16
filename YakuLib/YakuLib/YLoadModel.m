//
//  YLoadModel.m
//  
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import "YLoadModel.h"
#import <objc/message.h>

static NSString * const kModelLoadedTimeKey = @"modelLoadedTime";

@interface YLoadModel()

- (void)onMainThreadDidStartLoad;
- (void)onMainThreadDidFinishLoad;
- (void)onMainThreadDidFailLoadWithError:(NSError*)error;

@end

@implementation YLoadModel

@synthesize didStartLoadBlock = _didStartLoadBlock;
@synthesize didFinishLoadBlock = _didFinishLoadBlock;
@synthesize willFinishLoadBlock = _willFinishLoadBlock;
@synthesize didFailLoadWithErrorBlock = _didFailLoadWithErrorBlock;
@synthesize loadedTime = _loadedTime;
@synthesize delegate = _delegate;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(YURLRequestCachePolicy)cachePolicy more:(BOOL)more {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)cancel {
    [self didCancelLoad];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)invalidate:(BOOL)erase {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didStartLoad {
	[self performSelectorOnMainThread: @selector(onMainThreadDidStartLoad)
                           withObject: nil
                        waitUntilDone: [NSThread isMainThread]];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onMainThreadDidStartLoad {
    self.loading = YES;
    self.loaded = NO;
    
    if (nil != self.didStartLoadBlock) {
        self.didStartLoadBlock(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(modelDidStartLoad:)]) {
            [self.delegate modelDidStartLoad:self];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willFinishLoad {
    if (nil != self.willFinishLoadBlock) {
        self.willFinishLoadBlock(self);
    } else {
        if ([self.delegate respondsToSelector:@selector(modelWillFinishLoad:)]) {
            [self.delegate modelWillFinishLoad:self];            
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFinishLoad {
	[self performSelectorOnMainThread: @selector(onMainThreadDidFinishLoad)
                           withObject: nil
                        waitUntilDone: [NSThread isMainThread]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onMainThreadDidFinishLoad {
    self.loaded = YES;
    self.loading = NO;
    
    if (nil != self.didFinishLoadBlock) {
        self.didFinishLoadBlock(self);
    } else {
        [self.delegate modelDidFinishLoad:self];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didFailLoadWithError:(NSError*)error {
	[self performSelectorOnMainThread: @selector(onMainThreadDidFailLoadWithError:)
                           withObject: error
                        waitUntilDone: [NSThread isMainThread]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onMainThreadDidFailLoadWithError:(NSError*)error {
    self.loaded = NO;
    self.loading = NO;

    if (nil != self.didFailLoadWithErrorBlock) {
        self.didFailLoadWithErrorBlock(self, error);
    } else {
        [self.delegate model:self didFailLoadWithError:error];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didCancelLoad {
    if ([self.delegate respondsToSelector:@selector(modelDidCancelLoad:)]) {
        [self.delegate modelDidCancelLoad:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beginUpdates {
    if ([self.delegate respondsToSelector:@selector(modelDidBeginUpdates:)]) {
        [self.delegate modelDidBeginUpdates:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)endUpdates {
    if ([self.delegate respondsToSelector:@selector(modelDidEndUpdates:)]) {
        [self.delegate modelDidEndUpdates:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([self.delegate respondsToSelector:@selector(model:didUpdateObject:atIndexPath:)]) {
        [self.delegate model:self didUpdateObject:object atIndexPath:indexPath];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([self.delegate respondsToSelector:@selector(model:didInsertObject:atIndexPath:)]) {
        [self.delegate model:self didInsertObject:object atIndexPath:indexPath];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
    if ([self.delegate respondsToSelector:@selector(model:didDeleteObject:atIndexPath:)]) {
        [self.delegate model:self didDeleteObject:object atIndexPath:indexPath];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didChange {
    if ([self.delegate respondsToSelector:@selector(modelDidChange:)]) {
        [self.delegate modelDidChange:self];
    }
}

/**
 delegate のmodelDidProgressChangedを呼び出す
 */
-(void)didProgressChanged:(NSInteger)percentage
{
    [self performSelectorOnMainThread: @selector(onMainThreadDidProgressChanged:)
                           withObject: [NSNumber numberWithInt:percentage]
                        waitUntilDone: [NSThread isMainThread]];
}

-(void)onMainThreadDidProgressChanged:(NSNumber*)percentage
{
    if ([self.delegate respondsToSelector:@selector(modelDidProgressChanged:percentage:)]) {
        [self.delegate modelDidProgressChanged:self percentage:[percentage integerValue]];
    }    
}

- (void)clearDelegates {
    self.delegate = nil;
    self.didStartLoadBlock = nil;
    self.didFinishLoadBlock = nil;
    self.didFinishLoadBlock = nil;
    self.willFinishLoadBlock = nil;
}

- (NSDate*)loadedTime
{
    if (_loadedTime == nil) {
        NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
        NSString *key = [NSString stringWithFormat:@"%@-LoadedTime", [[self class] description]];
        _loadedTime = [defaults objectForKey:key];
    }
    return _loadedTime;
}

- (void)setLoadedTime:(NSDate *)loadedTime
{
    if ([_loadedTime isEqualToDate:loadedTime]) {
        return;
    }
    _loadedTime = loadedTime;
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-LoadedTime", [[self class] description]];
    [defaults setObject:loadedTime forKey:key];
}

@end
