//
//  YLoadModelDelegate.h
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol YLoadModel;

/**
 モデルのDelegate.
 データモデルのロード、変更のイベントを通知する為のDelete。
 */
@protocol YLoadModelDelegate <NSObject>

@optional

/**
 処理開始
 
 @param model   モデルオブジェクト
 */
- (void)modelDidStartLoad:(id<YLoadModel>)model;

/**
 処理終了

 @param model   モデルオブジェクト
 */
- (void)modelDidFinishLoad:(id<YLoadModel>)model;

/**
 処理終了直前
 このメソッドは、MainThreadで呼び出されない。

 @param model   モデルオブジェクト
 */
- (void)modelWillFinishLoad:(id<YLoadModel>)model;

/**
 エラー
 
 @param model   モデルオブジェクト
 @param error   エラーオブジェクト
 */
- (void)model:(id<YLoadModel>)model didFailLoadWithError:(NSError*)error;

/**
 キャンセル
 
 @param model   モデルオブジェクト
 */
- (void)modelDidCancelLoad:(id<YLoadModel>)model;

/**
 状態進行
 
 @param model   モデルオブジェクト
 @param percentage  進行割合
 */
- (void)modelDidProgressChanged:(id<YLoadModel>)model percentage:(NSInteger)percentage;

/**
 モデルが変更されたことを通知する
 
  */
- (void)modelDidChange:(id<YLoadModel>)model;

/**
 モデルが更新されたことを通知する
 NSFetchedResultsController使用時のUITableViewの更新の通知用
 */
- (void)model:(id<YLoadModel>)model didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 モデルが追加されたことを通知する
 NSFetchedResultsController使用時のUITableViewの行の挿入の通知用
 */
- (void)model:(id<YLoadModel>)model didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 モデルが削除された事を通知する
 NSFetchedResultsController使用時のUITableViewの行の削除の通知用。
 */
- (void)model:(id<YLoadModel>)model didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

/**
 * Informs the delegate that the model is about to begin a multi-stage update.
 *
 * Models should use this method to condense multiple updates into a single visible update.
 * This avoids having the view update multiple times for each change.  Instead, the user will
 * only see the end result of all of your changes when you call modelDidEndUpdates.
 */
- (void)modelDidBeginUpdates:(id<YLoadModel>)model;

/**
 * Informs the delegate that the model has completed a multi-stage update.
 *
 * The exact nature of the change is not specified, so the receiver should investigate the
 * new state of the model by examining its properties.
 */
- (void)modelDidEndUpdates:(id<YLoadModel>)model;

/**
 セクションの変更
 */
- (void)model:(id<YLoadModel>)model modelDidChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;

@end
