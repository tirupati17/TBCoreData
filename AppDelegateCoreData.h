//
//  AppDelegateCoreData.h
//  https://github.com/tirupati17/AppDelegateCoreData
//
//  Created by Tirupati Balan on 21/05/14.
//  Copyright (c) 2014 CelerApps. All rights reserved.
//

#import "AppDelegate.h" //Your AppDelegate Header

#define CORE_DATA_DATABASE_NAME @"Model"
#define CORE_DATA_DATABASE_EXTENSION @"sqlite"

@interface AppDelegateCoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *dataBaseStorageName;
@property (nonatomic, strong) NSString *dataBaseExtension;
@property (nonatomic, strong) NSString *dataBaseType;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (id)initWithStorageName:(NSString *)dataBaseStorageNameObj atDatabaseExtension:(NSString *)databaseExtensionObj;

//Fetch list of entry from database
- (id)fetchRequestForEntity:(NSString *)entityName;

//Fetch list of entry with key-value parameter option
- (id)fetchObjectForEntity:(NSString *)entityName
                     atKey:(NSString *)key
                   atValue:(NSString *)value;

//Insert new entry in database
- (id)insertObjectForEntity:(NSString *)entityName;

//Extra
- (NSString *)jsonStructureFromManagedObjects:(NSArray*)managedObjects;
- (NSArray *)managedObjectsFromJSONStructure:(NSString*)json withManagedObjectContext:(NSManagedObjectContext*)moc;

//Call this in application:didFinishLaunchingWithOptions:

+ (AppDelegateCoreData *)initalizeAppDelegateCoreData;

extern AppDelegateCoreData *appDelegateCoreData;

@end
