//
//  AppDelegateCoreData.m
//  https://github.com/tirupati17/AppDelegateCoreData
//
//  Created by Tirupati Balan on 21/05/14.
//  Copyright (c) 2014 CelerApps. All rights reserved.
//

#import "AppDelegateCoreData.h"
#import <CoreData/CoreData.h>

@implementation AppDelegateCoreData

@synthesize dataBaseStorageName = _dataBaseStorageName;
@synthesize dataBaseExtension = _dataBaseExtension;
@synthesize dataBaseType = _dataBaseType;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

AppDelegateCoreData *appDelegateCoreData = nil;

+ (AppDelegateCoreData *)initalizeAppDelegateCoreData {
    if (appDelegateCoreData)
        return appDelegateCoreData;

    appDelegateCoreData = [[AppDelegateCoreData alloc] initWithStorageName:CORE_DATA_DATABASE_NAME atDatabaseExtension:CORE_DATA_DATABASE_EXTENSION];

    return appDelegateCoreData;
}

- (id)initWithStorageName:(NSString *)dataBaseStorageNameObj atDatabaseExtension:(NSString *)databaseExtensionObj {
    if (self = [super init]) {
        self.dataBaseStorageName = [[NSString alloc] initWithString:dataBaseStorageNameObj];
        self.dataBaseExtension = [[NSString alloc] initWithString:databaseExtensionObj];
    }
    return self;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FailedBankCD" withExtension:@"momd"];
//    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CORE_DATA_DATABASE_NAME withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", CORE_DATA_DATABASE_NAME, CORE_DATA_DATABASE_EXTENSION]];

    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

- (id)insertObjectForEntity:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:self.managedObjectContext];
}

- (id)fetchRequestForEntity:(NSString *)entityName {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (id)fetchObjectForEntity:(NSString *)entityName atKey:(NSString *)key atValue:(NSString *)value {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@==%@", key, value];
    [fetchRequest setPredicate:predicate];

    [fetchRequest setEntity:entity];

    NSArray *objectArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([objectArray count]) {
        return [objectArray objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObject *)managedObjectFromStructure:(NSDictionary *)structureDictionary
                       withManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSString *objectName = [structureDictionary objectForKey:@"ManagedObjectName"];
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:objectName inManagedObjectContext:moc];
    [managedObject setValuesForKeysWithDictionary:structureDictionary];

    for (NSString *relationshipName in [[[managedObject entity] relationshipsByName] allKeys]) {
        NSRelationshipDescription *description = [[[managedObject entity] relationshipsByName] objectForKey:relationshipName];
        if (![description isToMany]) {
            NSDictionary *childStructureDictionary = [structureDictionary objectForKey:relationshipName];
            NSManagedObject *childObject = [self managedObjectFromStructure:childStructureDictionary withManagedObjectContext:moc];
            [managedObject setValue:childObject forKey:relationshipName];
            continue;
        }
        NSMutableSet *relationshipSet = [managedObject mutableSetValueForKey:relationshipName];
        NSArray *relationshipArray = [structureDictionary objectForKey:relationshipName];
        for (NSDictionary *childStructureDictionary in relationshipArray) {
            NSManagedObject *childObject = [self managedObjectFromStructure:childStructureDictionary withManagedObjectContext:moc];
            [relationshipSet addObject:childObject];
        }
    }
    return managedObject;
}

- (NSManagedObject *)managedObjectsFromJSONStructure:(NSString *)json
                            withManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSError *error = nil;
    JSONDecoder *decode = [JSONDecoder decoder];
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *structureDictionary = [decode objectWithData:jsonData];
    NSAssert2(error == nil, @"Failed to deserialize\n%@\n%@", [error localizedDescription], json);
    return [self managedObjectFromStructure:structureDictionary withManagedObjectContext:moc];
}

@end
