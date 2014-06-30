Introduction
===================

Integrate core data into existing project with minimum effort.

Getting Started
===================

Git submodule
-------------------

- Add the AppDelegateCoreData code into your project.
- If your project doesn't use ARC, add the -fobjc-arc compiler flag to AppDelegateCoreData.m in your target's Build Phases » Compile    Sources section.
- Add the <CoreData/CoreData.h> frameworks into your project.

Configuration
-------------------

- AppDelegateCoreData provides class methods to configure its behavior. 
- Call `[AppDelegateCoreData initalizeAppDelegateCoreData]`. A good place to do this is at the beginning of your app delegate's application:didFinishLaunchingWithOptions: method.

#### Insert example: ####
```
User *userManageObject = [appDelegateCoreData insertObjectForEntity:@"User"];
userManageObject.email = @"test@email.com";
[appDelegateCoreData saveContext];
```
####Simple fetch example:####
```
NSArray *userManageObjectArray = [appDelegateCoreData fetchObjectForEntity:@"User"];
NSLog(@"%@", userManageObjectArray);                                                           
```
####Fetch example with key-value example:####
```
User *userManageObject = [appDelegateCoreData fetchObjectForEntity:@"User"
                                                             atKey:@"email"
                                                           atValue:@"test@email.com"];
NSLog(@"%@", userManageObject.sessionKey);                                                           
```



