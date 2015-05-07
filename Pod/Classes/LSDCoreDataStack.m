//
//  LSDCoreDataStack.m
//  FreshCards
//
//  Created by IVAN CHIRKOV.
//  Copyright (c) 2015 IVAN CHIRKOV. All rights reserved.
//

#import "LSDCoreDataStack.h"
#import <CoreData/CoreData.h>

static NSString * const kDefaultStoreFileName = @"CoreData";


@interface LSDCoreDataStack ()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, copy) NSString *modelName;

@end

@implementation LSDCoreDataStack

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName : NSManagedObjectContextDidSaveNotification
                                                          object : nil
                                                           queue : nil
                                                      usingBlock : ^(NSNotification *note) {
                                                          NSManagedObjectContext *moc = note.object;
                                                          if (moc.concurrencyType == NSMainQueueConcurrencyType) {
                                                              [self.backgroundManagedObjectContext performBlock:^{
                                                                  [self.backgroundManagedObjectContext mergeChangesFromContextDidSaveNotification:note];
                                                              }];
                                                          } else {
                                                              [self.managedObjectContext performBlock:^{
                                                                  [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
                                                              }];
                                                          }
                                                      }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - LSDCoreDataStackProtocol

- (void)setupWithModelName : (NSString *)modelName
{
    self.modelName = modelName;
    [self mainCtx];
    [self backgroundManagedObjectContext];
}

- (NSManagedObjectContext *)mainCtx
{
    if (!_managedObjectContext) {
        _managedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
    }
    return _managedObjectContext;
}

- (NSManagedObjectContext *)backgroundCtx
{
    if (!_backgroundManagedObjectContext) {
        _backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
    }
    return _backgroundManagedObjectContext;
}

#pragma mark - Helpers

+ (NSString *)defaultStoreName;
{
    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    if (defaultName == nil)
    {
        defaultName = kDefaultStoreFileName;
    }
    return defaultName;
}

- (NSManagedObjectContext *)setupManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError* error;
    [managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                  configuration:nil
                                                                            URL:[self persistentStoreURL]
                                                                        options:[self persistentStoreOptions]
                                                                          error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"[LSDCoreDataStack] ERROR: %@", error.localizedDescription);
#endif
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName ?: [LSDCoreDataStack defaultStoreName]
                                                  withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSURL *)persistentStoreURL
{
    return [[self appLibraryDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", _modelName ?: [LSDCoreDataStack defaultStoreName]]];
}

- (NSDictionary *)persistentStoreOptions
{
    return @{
             NSInferMappingModelAutomaticallyOption         : @YES,
             NSMigratePersistentStoresAutomaticallyOption   : @YES,
             NSSQLitePragmasOption: @{ @"synchronous"       : @"OFF" }
             };
}

- (NSURL *)appLibraryDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
