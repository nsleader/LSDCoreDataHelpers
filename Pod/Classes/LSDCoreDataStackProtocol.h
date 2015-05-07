//
//  LSDCoreDataStackProtocol.h
//  News18
//
//  Created by IVAN CHIRKOV on 18.01.15.
//  Copyright (c) 2015 IVAN CHIRKOV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@protocol LSDCoreDataStackProtocol <NSObject>

/**
 *  Setup core data stack.
 *  @discussion This method should be called before mainCtx/backgroundCtx.
 *
 *  @param modelName Name of model.
 */
- (void)setupWithModelName : (NSString *)modelName;

/**
 *  Main queue concurrency type context.
 */
- (NSManagedObjectContext *)mainCtx;

/**
 *  Private queue concurrency type.
 */
- (NSManagedObjectContext *)backgroundCtx;

@end
