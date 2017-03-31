//
//  ViewController.h
//  Table
//
//  Created by Dingzhong Weng on 25/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTableViewCell.h"
#import "DDetailViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBPeripheralManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *xAccelerometerLabel;
@property (strong, nonatomic) IBOutlet UILabel *yAccelerometerLabel;
@property (strong, nonatomic) IBOutlet UILabel *zAccelerometerLabel;
@property (strong, nonatomic) IBOutlet UILabel *xGyroLabel;
@property (strong, nonatomic) IBOutlet UILabel *yGyroLabel;
@property (strong, nonatomic) IBOutlet UILabel *zGyroLabel;
@property (strong, nonatomic) IBOutlet UILabel *xGravityLabel;
@property (strong, nonatomic) IBOutlet UILabel *yGravityLabel;
@property (strong, nonatomic) IBOutlet UILabel *zGravityLabel;
@property (strong, nonatomic) IBOutlet UILabel *xUserAccelerationLabel;
@property (strong, nonatomic) IBOutlet UILabel *yUserAccelerationLabel;
@property (strong, nonatomic) IBOutlet UILabel *zUserAccelerationLabel;
@property (strong, nonatomic) IBOutlet UILabel *yawLabel;
@property (strong, nonatomic) IBOutlet UILabel *rollLabel;
@property (strong, nonatomic) IBOutlet UILabel *pitchLabel;
@property (strong, nonatomic) IBOutlet UIImageView *testImageView;
@property (strong, nonatomic) IBOutlet UILabel *connectedLabel;
@property (strong, nonatomic) IBOutlet UIButton *readingButton;
@property (strong, nonatomic) IBOutlet UIButton *advertisingButton;



// motion
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) NSOperationQueue *backgroundQueue;

// bluetooth
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBUUID *servUUID;
@property (strong, nonatomic) CBMutableService *serv;
@property (strong, nonatomic) CBUUID *acceleCharUUID;
@property (strong, nonatomic) CBMutableCharacteristic *acceleChar;
@property (strong, nonatomic) CBUUID *gyroCharUUID;
@property (strong, nonatomic) CBMutableCharacteristic *gyroChar;
@property (strong, nonatomic) CBUUID *gravityCharUUID;
@property (strong, nonatomic) CBMutableCharacteristic *gravityChar;
@property (strong, nonatomic) CBUUID *userAcceleCharUUID;
@property (strong, nonatomic) CBMutableCharacteristic *userAcceleChar;
@property (strong, nonatomic) CBUUID *eulerAngleCharUUID;
@property (strong, nonatomic) CBMutableCharacteristic *eulerAngleChar;

- (IBAction)toggleReading:(id)sender;
- (IBAction)toggleAdvertising:(id)sender;

@end

