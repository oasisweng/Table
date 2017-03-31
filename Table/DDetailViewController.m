//
//  DDetailViewController.m
//  Table
//
//  Created by Dingzhong Weng on 26/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import "DDetailViewController.h"
#import "CoreMotion/CoreMotion.h"


@interface DDetailViewController ()

@end

@implementation DDetailViewController
@synthesize titleLabel;
@synthesize dismissButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startMotionDetection];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[self motionManager]stopDeviceMotionUpdates];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Segues
- (IBAction)unwindToMain:(id)sender {
    [self performSegueWithIdentifier:@"unwindToMain" sender:self];
}

#pragma mark UI
-(void) dismissIfNeededWithData:(CMDeviceMotion *)data{
    NSLog(@"%f",data.userAcceleration.x);
    if (data.userAcceleration.x < -1.5f){
        [self unwindToMain:self];
    }
}

#pragma mark Core Motion
-(CMMotionManager*)motionManager{
    CMMotionManager* motionManager = nil;
    id appDelegate = [[UIApplication sharedApplication]delegate];
    if ([appDelegate respondsToSelector:@selector(motionManager)]){
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

-(void) startMotionDetection {
    CMMotionManager *m = [self motionManager];
    if (m.isDeviceMotionAvailable){
        [m setDeviceMotionUpdateInterval:0.1f];
        [m startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissIfNeededWithData:motion];
            });
        }];
    }
}


@end
