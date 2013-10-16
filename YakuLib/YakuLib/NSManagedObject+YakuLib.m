//
//  NSManagedObject+Ylib.m
//
//  Created by Nobukatsu Yakushiji on 2012/09/30.
//  Copyright (c) 2012年 Nobukatsu Yakushiji All rights reserved.
//

#import "NSManagedObject+YakuLib.h"

@implementation NSManagedObject (YakuLib)

- (NSDictionary *)propertiesDictionary:(BOOL)recursive
{
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    for (id property in [[self entity] properties])
    {
        if ([property isKindOfClass:[NSAttributeDescription class]])
        {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)property;
            NSString *name = [attributeDescription name];
            id value = [self valueForKey:name];
            if ([value isKindOfClass:[NSDate class]]) {
                value = [formatter stringFromDate:value];
            } else if ([value isKindOfClass:[NSData class]]) {
                continue;
            }
            
            [properties setValue:value forKey:name];
        }
        
        if ([property isKindOfClass:[NSRelationshipDescription class]] && recursive)
        {
            NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)property;
            NSString *name = [relationshipDescription name];
            
            if ([relationshipDescription isToMany])
            {
                NSMutableArray *arr = [properties valueForKey:name];
                if (!arr)
                {
                    arr = [[NSMutableArray alloc] init];
                    [properties setValue:arr forKey:name];
                }
                
                for (NSManagedObject *o in [self mutableSetValueForKey:name])
                    [arr addObject:[o propertiesDictionary:NO]];
            }
            else
            {
                NSManagedObject *o = [self valueForKey:name];
                [properties setValue:[o propertiesDictionary:NO] forKey:name];
            }
        }
    }
    
    return properties;
}

- (NSString *)jsonStringValue
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self propertiesDictionary:NO]
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return retStr;
}

- (NSData*)jsonData
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self propertiesDictionary:NO]
                                                   options:NSJSONWritingPrettyPrinted error:&error];
    return data;
}

@end
