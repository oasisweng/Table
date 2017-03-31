//
//  DDetailViewController.h
//  Table
//
//  Created by Dingzhong Weng on 26/03/2017.
//  Copyright © 2017 DZW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDetailViewControllerDelegate <NSObject>

- (void) viewControllerDidDisappear: (UIViewController*)vc;

@end

@interface DDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *dismissButton;
@property (strong, nonatomic) id<DDetailViewControllerDelegate> delegate;

- (IBAction)unwindToMain:(id)sender;

@end
