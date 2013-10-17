//
//  NSManagedObject+YakuLib.h
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (YakuLib)

- (NSString*)jsonStringValue;
- (NSData*)jsonData;
- (NSDictionary *)propertiesDictionary:(BOOL)recursive;

@end
