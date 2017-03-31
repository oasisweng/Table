//
//  ViewController.m
//  Table
//
//  Created by Dingzhong Weng on 25/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize xAccelerometerLabel;
@synthesize yAccelerometerLabel;
@synthesize zAccelerometerLabel;
@synthesize xGyroLabel;
@synthesize yGyroLabel;
@synthesize zGyroLabel;
@synthesize xGravityLabel;
@synthesize yGravityLabel;
@synthesize zGravityLabel;
@synthesize xUserAccelerationLabel;
@synthesize yUserAccelerationLabel;
@synthesize zUserAccelerationLabel;
@synthesize yawLabel;
@synthesize rollLabel;
@synthesize pitchLabel;
@synthesize testImageView;
@synthesize connectedLabel;
@synthesize readingButton;
@synthesize advertisingButton;

@synthesize motionManager = _motionManager;

@synthesize peripheralManager = _peripheralManager;
@synthesize servUUID = _servUUID;
@synthesize serv = _serv;
@synthesize acceleCharUUID = _acceleCharUUID;
@synthesize acceleChar = _acceleChar;
@synthesize gyroCharUUID = _gyroCharUUID;
@synthesize gyroChar = _gyroChar;
@synthesize gravityCharUUID = _gravityCharUUID;
@synthesize gravityChar = _gravityChar;
@synthesize userAcceleCharUUID = _userAcceleCharUUID;
@synthesize userAcceleChar = _userAcceleChar;
@synthesize eulerAngleCharUUID = _eulerAngleCharUUID;
@synthesize eulerAngleChar = _eulerAngleChar;
@synthesize backgroundQueue = _backgroundQueue;

#define kSensorUpdateFrequency 0.2f
#define kStartReading @"start reading"
#define kStopReading @"stop reading"
#define kStartAdvertising @"start advertising"
#define kStopAdvertising @"stop advertising"
#define kAcceleCharUUID @"707A15FB-AB8D-41E0-835A-97896E23024B"
#define kGyroCharUUID @"6C220143-5453-4928-833F-A5671C6F2F26"
#define kGravityCharUUID @"0C0806CE-37E5-48AF-8D51-EBD38F5FFA20"
#define kUserAcceleCharUUID @"0A5CD7F5-8FBD-45FC-9C8C-F1BA30B25E32"
#define kEulerAngleCharUUID @"30600B19-B2A9-455C-99F8-2D3CE986DA7F"

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual: @"dvc"]){
        DDetailViewController *dvc = segue.destinationViewController;
        
        dvc.titleLabel.text = @"abc";
    }
}

-(IBAction)unwind:(UIStoryboardSegue*)unwindSegue{
    NSLog(@"unwinded from %@",unwindSegue.sourceViewController);
}

#pragma mark UI
-(void) updateAccelerometerLabelWithData:(CMAccelerometerData *)data{
    self.xAccelerometerLabel.text = [NSString stringWithFormat:@"%.1f",data.acceleration.x];
    self.yAccelerometerLabel.text = [NSString stringWithFormat:@"%.1f",data.acceleration.y];
    self.zAccelerometerLabel.text = [NSString stringWithFormat:@"%.1f",data.acceleration.z];
    self.yAccelerometerLabel.transform = CGAffineTransformMakeRotation([self rotationFromAccelerometerData:data]);
}

-(void) updateGyroLabelWithData:(CMGyroData *)data{
    self.xGyroLabel.text = [NSString stringWithFormat:@"%.1f",data.rotationRate.x];
    self.yGyroLabel.text = [NSString stringWithFormat:@"%.1f",data.rotationRate.y];
    self.zGyroLabel.text = [NSString stringWithFormat:@"%.1f",data.rotationRate.z];
    CGAffineTransform transform = CGAffineTransformMakeRotation([self rotationFromGyroData:data]);
    self.xGyroLabel.transform = transform;
    
}

-(void) updateDeviceMontionLabelWithData:(CMDeviceMotion*)data{
    //Update Gravity labels
    self.xGravityLabel.text = [NSString stringWithFormat:@"%.1f",data.gravity.x];
    self.yGravityLabel.text = [NSString stringWithFormat:@"%.1f",data.gravity.y];
    self.zGravityLabel.text = [NSString stringWithFormat:@"%.1f",data.gravity.z];
    CGAffineTransform transform = CGAffineTransformMakeRotation([self rotationFromDeviceMotionData:data]);
    self.zGravityLabel.transform = transform;
    self.testImageView.transform = transform;
    
    //Update User Acceleration labels
    self.xUserAccelerationLabel.text = [NSString stringWithFormat:@"%.1f",data.userAcceleration.x];
    self.yUserAccelerationLabel.text = [NSString stringWithFormat:@"%.1f",data.userAcceleration.y];
    self.zUserAccelerationLabel.text = [NSString stringWithFormat:@"%.1f",data.userAcceleration.z];
    
    //Update Euler Angle labels
    self.yawLabel.text = [NSString stringWithFormat:@"%.1f",data.attitude.yaw];
    self.rollLabel.text = [NSString stringWithFormat:@"%.1f",data.attitude.roll];
    self.pitchLabel.text = [NSString stringWithFormat:@"%.1f",data.attitude.pitch];
}

-(double) rotationFromDeviceMotionData:(CMDeviceMotion *)data{
    return atan2(data.gravity.x,data.gravity.y) - M_PI;
}

-(double) rotationFromAccelerometerData:(CMAccelerometerData *)data{
    return atan2(data.acceleration.x,data.acceleration.y) - M_PI;
}

-(double) rotationFromGyroData:(CMGyroData *)data{
    return atan2(data.rotationRate.x,data.rotationRate.y) - M_PI;
}

#pragma mark Core Motion
-(CMMotionManager*)motionManager{
    if (_motionManager == nil){
        id appDelegate = [[UIApplication sharedApplication]delegate];
        if ([appDelegate respondsToSelector:@selector(motionManager)]){
            _motionManager = [appDelegate motionManager];
        }
    }
    
    return _motionManager;
}

-(NSOperationQueue*)backgroundQueue{
    if (_backgroundQueue == nil){
        _backgroundQueue = [[NSOperationQueue alloc]init];
    }
    
    return _backgroundQueue;
}

-(void) startMotionDetection {
    CMMotionManager *m = [self motionManager];
    if (m.isAccelerometerAvailable && !m.isAccelerometerActive){
        [m setAccelerometerUpdateInterval:kSensorUpdateFrequency];
        [m startAccelerometerUpdatesToQueue:[self backgroundQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            if (error == nil){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self updateAccelerometerLabelWithData:accelerometerData];
                }];
                
                [self updateCharacteristic:[self acceleChar] with:[self dataFromAcceleration:accelerometerData.acceleration]];
                
            } else {
                NSLog(@"Accelerometer reading has error %@",[error localizedDescription]);
            }
        }];
    }
    
    if (m.isGyroAvailable && !m.isGyroActive){
        [m setGyroUpdateInterval:kSensorUpdateFrequency];
        [m startGyroUpdatesToQueue:[self backgroundQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            if (error == nil){
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self updateGyroLabelWithData:gyroData];
                }];
                
                [self updateCharacteristic:[self gyroChar] with:[self dataFromRotationRate:gyroData.rotationRate]];
            } else {
                NSLog(@"Gyro reading has error %@",[error localizedDescription]);
            }
        }];
    }
    
    if (m.isDeviceMotionAvailable && !m.isDeviceMotionActive){
        [m setDeviceMotionUpdateInterval:kSensorUpdateFrequency];
        [m startDeviceMotionUpdatesToQueue:[self backgroundQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (error == nil){
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self updateDeviceMontionLabelWithData:motion];
                }];
                
                [self updateCharacteristic:[self gravityChar] with:[self dataFromAcceleration:motion.gravity]];
                [self updateCharacteristic:[self userAcceleChar] with:[self dataFromAcceleration:motion.userAcceleration]];
                [self updateCharacteristic:[self eulerAngleChar] with:[self dataFromAttitude:motion.attitude]];
            } else {
                NSLog(@"Device motion reading has error %@",[error localizedDescription]);
            }
        }];
    }
}

- (void)stopMotionDetection{
    CMMotionManager *mm = [self motionManager];
    if ([mm isAccelerometerActive]){
        [mm stopAccelerometerUpdates];
    }
    if ([mm isDeviceMotionActive]){
        [mm stopDeviceMotionUpdates];
    }
    if ([mm isGyroActive]){
        [mm stopGyroUpdates];
    }
}

- (NSData *)dataFromAttitude:(CMAttitude*)attitude{
    double attitudeReading[3] = {attitude.yaw,attitude.roll,attitude.pitch};
    
    return [NSData dataWithBytes:&attitudeReading length:sizeof(double)*3];
}

- (NSData *)dataFromAcceleration:(CMAcceleration)acceleration{
    double acceleReading[3] = {acceleration.x,acceleration.y,acceleration.z};
    
    return [NSData dataWithBytes:&acceleReading length:sizeof(double)*3];
}

- (NSData *)dataFromRotationRate:(CMRotationRate)rotationRate{
    double rrReading[3] = {rotationRate.x,rotationRate.y,rotationRate.z};
    
    return [NSData dataWithBytes:&rrReading length:sizeof(double)*3];
}


#pragma mark Core Bluetooth
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if (peripheral.state == CBManagerStatePoweredOn){
        // enable advertising when the phone is connected to the device
        [self.advertisingButton setEnabled:true];
        [peripheral addService:[self serv]];
    }
    
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary<NSString *,id> *)dict {
    NSArray *adversitingData = dict[CBPeripheralManagerRestoredStateAdvertisementDataKey];
    NSArray *services = dict[CBPeripheralManagerRestoredStateServicesKey];
    
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error{
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
    
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {
    
    for (CBCharacteristic *characteristic in [self serv].characteristics){
        if ([request.characteristic.UUID isEqual:characteristic.UUID]){
            if (request.offset > characteristic.value.length) {
                [[self peripheralManager] respondToRequest:request
                                                withResult:CBATTErrorInvalidOffset];
                return;
            }
            
            request.value = [characteristic.value
                             subdataWithRange:NSMakeRange(request.offset,
                                                          characteristic.value.length - request.offset)];
            
            [[self peripheralManager] respondToRequest:request withResult:CBATTErrorSuccess];
            return;
        }
    }
    
    [[self peripheralManager] respondToRequest:request withResult:CBATTErrorAttributeNotFound];
    
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    
    NSLog(@"Central subscribed to characteristic %@", characteristic);
}

-(IBAction)toggleReading:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:kStartReading]){
        //start reading
        [self startMotionDetection];
        [button setTitle:kStopReading forState:UIControlStateNormal];
    } else if ([title isEqualToString:kStopReading]){
        //stop reading
        [self stopMotionDetection];
        [button setTitle:kStartReading forState:UIControlStateNormal];
    } else {
        //fix the naming issue
        [button setTitle:kStartReading forState:UIControlStateNormal];
    }
}

- (IBAction)toggleAdvertising:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:kStartAdvertising]){
        //start advertising
        [[self peripheralManager] startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : @[[self serv].UUID]}];
        [button setTitle:kStopAdvertising forState:UIControlStateNormal];
    } else if ([title isEqualToString:kStopAdvertising]){
        //stop advertising
        [[self peripheralManager] stopAdvertising];
        [button setTitle:kStartAdvertising forState:UIControlStateNormal];
    } else {
        //fix the naming issue
        [button setTitle:kStartAdvertising forState:UIControlStateNormal];
    }
}

-(BOOL)updateCharacteristic:(CBMutableCharacteristic*)characteristic with:(NSData *)value{
    BOOL success = [[self peripheralManager] updateValue:value forCharacteristic:characteristic onSubscribedCentrals:nil];
    
    if (!success){
        NSLog(@"Failed to update %@ for characteristic %@ due to a full transmit queue", value.description, characteristic.UUID);
    }
    
    return success;
}


-(CBPeripheralManager *)peripheralManager{
    if (_peripheralManager == nil){
        _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:@{CBPeripheralManagerOptionRestoreIdentifierKey:@"PeripheralManager"}];
    }
    
    return _peripheralManager;
}

-(CBUUID *)acceleCharUUID{
    if (_acceleCharUUID == nil){
        _acceleCharUUID = [CBUUID UUIDWithString:kAcceleCharUUID];
    }
    
    return _acceleCharUUID;
}

-(CBUUID *)gyroCharUUID{
    if (_gyroCharUUID == nil){
        _gyroCharUUID = [CBUUID UUIDWithString:kGyroCharUUID];
    }
    
    return _gyroCharUUID;
}

-(CBUUID *)gravityCharUUID{
    if (_gravityCharUUID == nil){
        _gravityCharUUID = [CBUUID UUIDWithString:kGravityCharUUID];
    }
    
    return _gravityCharUUID;
}

-(CBUUID *)userAcceleCharUUID{
    if (_userAcceleCharUUID == nil){
        _userAcceleCharUUID = [CBUUID UUIDWithString:kUserAcceleCharUUID];
    }
    
    return _userAcceleCharUUID;
}

-(CBUUID *)eulerAngleCharUUID{
    if (_eulerAngleCharUUID == nil){
        _eulerAngleCharUUID = [CBUUID UUIDWithString:kEulerAngleCharUUID];
    }
    
    return _eulerAngleCharUUID;
}

-(CBUUID *)servUUID{
    if (_servUUID == nil){
        _servUUID = [CBUUID UUIDWithString:@"AC6BE6E9-3252-4BE8-ACCA-18661B05B9DC"];
    }
    
    return _servUUID;
}

-(CBMutableCharacteristic *)acceleChar{
    if (_acceleChar == nil){
        _acceleChar= [[CBMutableCharacteristic alloc]initWithType:[self acceleCharUUID] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
    };
    
    return _acceleChar;
}

-(CBMutableCharacteristic *)gyroChar{
    if (_gyroChar == nil){
        _gyroChar = [[CBMutableCharacteristic alloc]initWithType:[self gyroCharUUID] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
    };
    
    return _gyroChar;
}

-(CBMutableCharacteristic *)gravityChar{
    if (_gravityChar == nil){
        _gravityChar = [[CBMutableCharacteristic alloc]initWithType:[self gravityCharUUID] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
    };
    
    return _gravityChar;
}

-(CBMutableCharacteristic *)userAcceleChar{
    if (_userAcceleChar == nil){
        _userAcceleChar = [[CBMutableCharacteristic alloc]initWithType:[self userAcceleCharUUID] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
    };
    
    return _userAcceleChar;
}

-(CBMutableCharacteristic *)eulerAngleChar{
    if (_eulerAngleChar == nil){
        _eulerAngleChar = [[CBMutableCharacteristic alloc]initWithType:[self eulerAngleCharUUID] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotifyEncryptionRequired value:nil permissions:CBAttributePermissionsReadEncryptionRequired];
    };
    
    return _eulerAngleChar;
}


-(CBMutableService *)serv{
    if (_serv == nil){
        _serv= [[CBMutableService alloc]initWithType:[self servUUID] primary:YES];
        _serv.characteristics = @[[self acceleChar]];
    }
    return _serv;
}

@end
