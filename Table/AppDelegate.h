//
//  AppDelegate.h
//  Table
//
//  Created by Dingzhong Weng on 25/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) CMMotionManager *motionManager;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

