//
//  YFetchedDataSource.h
//
//  Created by Nobukatsu Yakushiji on 13/10/01.
//  Copyright (c) 2013 Nobukatsu Yakushiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLoadModel.h"

/**
 * FetchedDataSource
 *
 * NSFetchedResultsControllerを使用するモデルクラス
 */
@interface YFetchedDataSource : YLoadModel <UITableViewDataSource, NSFetchedResultsControllerDelegate>

/**
 * entity name
 */
@property(nonatomic, copy) NSString* entityName;
/**
 * Sordescriptiorの配列
 */
@property(nonatomic, strong) NSArray* sortDescriptors;
/**
 * 検索条件を指定するNSPredicateオブジェクト
 */
@property(nonatomic, strong) NSPredicate* predicate;
/**
 * FetchedResultsController
 */
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, assign) NSUInteger fetchBatchSize;
@property(nonatomic, copy) NSString* sectionNameKeyPath;
@property(nonatomic, copy) NSString* cacheName;

/*! 初期化 */
-(id)initWithManagedObjectContext:(NSManagedObjectContext*) managedObjectContext
                       entityName:(NSString*)entityName
                         criteria:(NSString*)criteria
                        arguments:(NSArray*)arguments
                  sortDescriptors:(NSArray*)sortDescriptors;

/*! セルの値の設定 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
/*! Fetch開始 */
- (void)performFetch;
/*! predicateの設定 */
- (void)setPredicateWithCriteria:(NSString*)criteria arguments:(NSArray*)arguments;

/**
 indexPathで指定した行のデータを返す
 */
- (id)objectAtIndexPath:(NSIndexPath*)path;

@end
