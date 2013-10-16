//
//  YLoadModel.h
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YLoadModelDelegate.h"

typedef enum {
    YURLRequestCachePolicyNone    = 0,
    YURLRequestCachePolicyMemory  = 1,
    YURLRequestCachePolicyDisk    = 2,
    YURLRequestCachePolicyNetwork = 4,
    YURLRequestCachePolicyNoCache = 8,
    YURLRequestCachePolicyEtag    = 16 | YURLRequestCachePolicyDisk,
    YURLRequestCachePolicyLocal
    = (YURLRequestCachePolicyMemory | YURLRequestCachePolicyDisk),
    YURLRequestCachePolicyDefault
    = (YURLRequestCachePolicyMemory | YURLRequestCachePolicyDisk
       | YURLRequestCachePolicyNetwork),
} YURLRequestCachePolicy;

@class YLoadModel;

typedef void (^YBasicBlock)(YLoadModel *model);
typedef void (^YErrorBlock)(YLoadModel *model, NSError* error);

/**
 * Viewのモデルプロトコル
 */
@protocol YLoadModel <NSObject>

@optional
/**
 * 通知用の Delegateオブジェクト.
 * delegateは、YViewModelDelegateプロトコルのオブジェクト
 */
@property(nonatomic, weak) id<YLoadModelDelegate>delegate;

/**
 * 読み込み時間
 */
@property(nonatomic, strong) NSDate* loadedTime;

/**
 * データがすべてロード済であるかどうか
 */
- (BOOL)isLoaded;

/**
 * データをロード中であるかどうか
 */
- (BOOL)isLoading;

/**
 * 追加で読み込むデータがあるかどうか
 */
- (BOOL)isLoadingMore;

/**
 * データが古いかどうか
 */
- (BOOL)isOutdated;

/**
 * データのロード
 *
 * @param cachePolicy   キャシュポリシー
 * @param more  追加読み込みを行うかどうか
 */
- (void)load:(YURLRequestCachePolicy)cachePolicy more:(BOOL)more;

/**
 * ロードのキャンセル
 */
- (void)cancel;

/**
 * モデルデータの無効化
 */
- (void)invalidate:(BOOL)erase;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * モデルオブジェクト
 */
@interface YLoadModel : NSObject <YLoadModel>

/**
 * 通知用のDelegate
 */
@property(nonatomic, assign) id<YLoadModelDelegate>delegate;

/**
 * 読み込み時間
 */
@property(nonatomic, strong) NSDate* loadedTime;

/**
 * ロード開始（メインスレッドで呼び出される）
 */
@property (readwrite, copy) YBasicBlock didStartLoadBlock;

/**
 * ロード終了直前(メインスレッドで呼び出されない）
 */
@property (readwrite, copy) YBasicBlock willFinishLoadBlock;

/**
 * ロード終了（メインスレッドで呼び出される）
 */
@property (readwrite, copy) YBasicBlock didFinishLoadBlock;

/**
 エラー（メインスレッドで呼び出される）
 */
@property (readwrite, copy) YErrorBlock didFailLoadWithErrorBlock;

/**
 ロード中かどうか
 */
@property (nonatomic, assign, getter = isLoading) BOOL loading;

/**
 * データがロード済であるかどうか
 */
@property (nonatomic, assign, getter = isLoaded) BOOL loaded;


/**
 * 追加で読み込むデータがあるかどうか
 */
@property (nonatomic, assign, getter = isLoadingMore) BOOL loadingMore;

/**
 * データが古いかどうか
 */
@property (nonatomic, assign, getter = isOutdated) BOOL outdated;

/**
 * delegateのmodelDidStartLoad:を呼び出す
 */
- (void)didStartLoad;

/**
 * delegateのmodelWillFinishLoad:を呼び出す
 */
- (void)willFinishLoad;

/**
 * delegateのmodelDidFinishLoadを呼び出す
 */
- (void)didFinishLoad;

/**
 * delegateのmodel:didFailLoadWithErrorを呼び出す
 */
- (void)didFailLoadWithError:(NSError*)error;

/**
 * delegateのmodelDidCancelLoadを呼び出す
 */
- (void)didCancelLoad;

/**
 delegateのmodelDidBeginUpdates:を呼び出す
 */
- (void)beginUpdates;

/**
 delegateの modelDidEndUpdates:を呼び出す
 */
- (void)endUpdates;

/**
 delegate の modelDidUpdateObject atIndexPath:(NSIndexPath*)indexPathを呼び出す。
 */
- (void)didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 delegate の modelDidInsefrtObject atIndexPath:(NSIndexPath*)indexPathを呼び出す。
 */
- (void)didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 delegate の modelDidDeleteObject atIndexPath:(NSIndexPath*)indexPathを呼び出す。
 */
- (void)didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 delegate のmodelDidChangeを呼び出す
 */
- (void)didChange;

/**
 delegate のmodelDidProgressChangedを呼び出す
 */
-(void)didProgressChanged:(NSInteger)percentage;

/**
 Delegateのクリア
 */
- (void)clearDelegates;

/**
 ロードのキャンセル
 */
- (void)cancel;

@end
