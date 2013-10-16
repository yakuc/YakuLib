//
//  YOperation.h
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YOperationDelegate;
@class YOperation;

typedef void (^YOperationBlock)(YOperation* operation);
typedef void (^YOperationDidFailBlock)(YOperation* operation, NSError* error);
typedef void (^YOperationProgressChangedBlock)(YOperation* operation, NSInteger percentage);

@interface YOperation : NSOperation

@property (readwrite, weak) id<YOperationDelegate> delegate;
@property (readwrite, strong) NSError* lastError;
@property (readwrite, assign) NSInteger tag;
@property (nonatomic, assign, getter = isExecuting) BOOL executing;
@property (nonatomic, assign, getter = isFinished) BOOL finished;

@property (readwrite, copy) YOperationBlock didStartBlock;
@property (readwrite, copy) YOperationBlock didFinishBlock;
@property (readwrite, copy) YOperationDidFailBlock didFailWithErrorBlock;
@property (readwrite, copy) YOperationBlock willFinishBlock;
@property (readwrite, copy) YOperationProgressChangedBlock progressChangedBlock;

- (void)didStart;
- (void)didFinish;
- (void)didFailWithError:(NSError *)error;
- (void)willFinish;
- (void)completeOperation;
- (void)progressChanged:(NSInteger)percentage;

@end


@protocol YOperationDelegate <NSObject>
@optional

- (void)operationDidStart:(YOperation *)operation;
- (void)operationProgressChenged:(YOperation *)operation percentage:(NSInteger)percentage;
- (void)operationWillFinish:(YOperation *)operation;
- (void)operationDidFinish:(YOperation *)operation;
- (void)operationDidFail:(YOperation *)operation withError:(NSError *)error;

@end
