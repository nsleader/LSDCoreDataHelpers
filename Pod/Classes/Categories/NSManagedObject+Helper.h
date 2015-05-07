//
//  NSManagedObject+Helper.h
//  News18
//
//  Created by IVAN CHIRKOV on 17.01.15.
//  Copyright (c) 2015 IVAN CHIRKOV. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)

/**
 *  Create a managed object in context.
 *
 *  @param context  The managed object context.
 *  @return         The managed object.
 */
+ (instancetype)createInContext : (NSManagedObjectContext *)ctx;



/**
 *  Deleting an entity from the context in which it was created.
 */
- (void)deleteEntity;



/**
 *  Deleting an entity from the context.
 *
 *  @param context  The context from which the entity is removed
 */
- (void)deleteEntityInContext : (NSManagedObjectContext *)ctx;



/**
 *  Obtain a managed object from context where key = value.
 *
 *  @param field    The field of managed object.
 *  @param value    The value corresponds to the key.
 *  @param context  The managed object context.
 *
 *  @discussion     If many objects, it returns the first one.
 *  @return         The first matching managed object.
 */
+ (instancetype)firstObjectWithField : (NSString *)key
                               value : (id)value
                           inContext : (NSManagedObjectContext *)ctx;

+ (instancetype)firstObjectWithPredicate : (NSPredicate *)predicate
                               inContext : (NSManagedObjectContext *)ctx;

/**
 *  Obtain a managed objects from context where key = value.
 *
 *  @param field    The field of managed object.
 *  @param value    The value corresponds to the key.
 *  @param context  The managed object context.
 *
 *  @return         The managed objects.
 */
+ (NSArray *)objectsWithField : (NSString *)key
                        value : (id)value
                    inContext : (NSManagedObjectContext *)ctx;


/**
 *  Obtain all managed objects from context.
 *
 *  @param ctx The managed object context.
 *
 *  @return The managed objects.
 */
+ (NSArray *)objectsInContext : (NSManagedObjectContext *)ctx;


+ (NSArray *)objectsWithPredicate : (NSPredicate *)predicate
                        inContext : (NSManagedObjectContext *)ctx;

@end
