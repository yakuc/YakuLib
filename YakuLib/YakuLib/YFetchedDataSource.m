//
//  YFetchedDataSource.m
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import "YFetchedDataSource.h"

@interface YFetchedDataSource()

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation YFetchedDataSource

@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize entityName = _entityName;
@synthesize sortDescriptors = _sortDescriptors;
@synthesize predicate = _predicate;

/*! 初期化 */
-(id)initWithManagedObjectContext:(NSManagedObjectContext*) managedObjectContext
            entityName:(NSString*)entityName
              criteria:(NSString*)criteria
             arguments:(NSArray*)arguments
       sortDescriptors:(NSArray*)sortDescriptors
{
    self = [super init];
    if (self) {
        self.entityName = entityName;
        self.cacheName = entityName;
        self.managedObjectContext = managedObjectContext;
        [self setPredicateWithCriteria:criteria arguments:arguments];
        self.sortDescriptors = sortDescriptors;
    }
    return self;
}

/*! predicateの設定 */
- (void)setPredicateWithCriteria:(NSString*)criteria arguments:(NSArray*)arguments
{
    if (criteria == nil) {
        self.predicate = nil;
        return;
    }
    self.predicate = [NSPredicate predicateWithFormat:criteria argumentArray:arguments];
}

/*! Fetch開始 */
- (void)performFetch
{
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[self.fetchedResultsController sections] count];
    
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue or if necessary create a RecipeTableViewCell, then set its recipe to the recipe for the current row.
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // 保存
        NSError* error = nil;
        [context save:&error];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            return;
        }
        NSManagedObjectContext *parent = context.parentContext;
        if (parent != nil) {
            [parent performBlock:^{
                NSError *parentError = nil;
                [parent save:&parentError];
                if (parentError) {
                    NSLog(@"Error: %@", error.localizedDescription);
                    return;
                }
            }];
        }
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSManagedObjectContext*)managedObjectContext
{
    return _managedObjectContext;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (self.entityName == nil) {
        return nil;
    }
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {

        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        if (self.sortDescriptors != nil) {
            [fetchRequest setSortDescriptors:self.sortDescriptors];
        }
        
        // 検索条件
        if (self.predicate != nil) {
            [fetchRequest setPredicate:self.predicate];
            [NSFetchedResultsController deleteCacheWithName:self.cacheName];
        }
        if (self.fetchBatchSize != 0) {
            [fetchRequest setFetchBatchSize:self.fetchBatchSize];
        }
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:self.sectionNameKeyPath
                                                                                   cacheName:self.cacheName];
        _fetchedResultsController.delegate = self;
    }
	
	return _fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [super beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
            [super didInsertObject:[self objectAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
			break;
			
		case NSFetchedResultsChangeDelete:
            [super didDeleteObject:nil atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeUpdate:
            [super didUpdateObject:[self objectAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
            [super didDeleteObject:[self objectAtIndexPath:indexPath] atIndexPath:indexPath];
            [super didInsertObject:[self objectAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if ([self.delegate respondsToSelector:@selector(model:modelDidChangeSection:atIndex:forChangeType:)]) {
        [self.delegate model:self modelDidChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    }
//	switch(type) {
//		case NSFetchedResultsChangeInsert:
//			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//			
//		case NSFetchedResultsChangeDelete:
//			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//			break;
//	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    
    [super endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}
@end
