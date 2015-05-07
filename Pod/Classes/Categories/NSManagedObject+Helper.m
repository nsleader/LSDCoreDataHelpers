//
//  NSManagedObject+Helper.m
//  News18
//
//  Created by IVAN CHIRKOV on 17.01.15.
//  Copyright (c) 2015 IVAN CHIRKOV. All rights reserved.
//

#import "NSManagedObject+Helper.h"

@implementation NSManagedObject (Helper)

+ (instancetype)createInContext : (NSManagedObjectContext *)ctx
{
    NSAssert(ctx, @"Nil managed object context!");
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName : NSStringFromClass([self class])
                                                            inManagedObjectContext : ctx];
    return entity;
}

- (void)deleteEntity
{
    [self deleteEntityInContext:nil];
}

- (void)deleteEntityInContext : (NSManagedObjectContext *)ctx
{
    if (!ctx) {
        ctx = [self managedObjectContext];
    }
    [ctx deleteObject:self];
}

+ (instancetype)firstObjectWithField : (NSString *)key
                               value : (id)value
                           inContext : (NSManagedObjectContext *)ctx
{
    id news = [[self objectsWithField : key
                                value : value
                            inContext : ctx] firstObject];
    return news;
}

+ (NSArray *)objectsWithField : (NSString *)key
                        value : (id)value
                    inContext : (NSManagedObjectContext *)ctx
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    
    NSError *error;
    return [ctx executeFetchRequest:request error:&error];
}

+ (NSArray *)objectsInContext : (NSManagedObjectContext *)ctx
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    NSError *error;
    return [ctx executeFetchRequest:request error:&error];
}

+ (instancetype)firstObjectWithPredicate : (NSPredicate *)predicate
                               inContext : (NSManagedObjectContext *)ctx
{
    return [[self objectsWithPredicate:predicate inContext:ctx] firstObject];
}

+ (NSArray *)objectsWithPredicate : (NSPredicate *)predicate
                        inContext : (NSManagedObjectContext *)ctx
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    request.predicate = predicate;
    NSError *error;
    return [ctx executeFetchRequest:request error:&error];
}

@end
