//
//  TestEntity.h
//  LSDCoreDataHelpers
//
//  Created by IVAN CHIRKOV on 07.05.15.
//  Copyright (c) 2015 nsleader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * eId;
@property (nonatomic, retain) NSString * name;

@end
