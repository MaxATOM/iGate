//
//  iPadViewController.h
//  iGate
//
//  Created by Maxime Carrillo on 17/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothScanner.h"

@interface iPadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BluetoothScannerProtocol, UIAlertViewDelegate> {
    
    IBOutlet UITableView *bluetoothTableView;
    IBOutlet UIButton *refreshButton;
    UIActivityIndicatorView *spinner;
    IBOutlet UILabel *status;
    NSString *tmpBtAddress;
    BOOL bluetoothIsStarted;
    BluetoothScanner *bluetoothScanner;

}

@property (nonatomic, retain) IBOutlet UITableView *bluetoothTableView;
@property (retain, nonatomic) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UILabel *status;
@property (nonatomic, retain) NSString *tmpBtAddress;
@property (nonatomic) BOOL bluetoothIsStarted;
@property(nonatomic,retain)  UIPopoverController *popOver;
@property (retain, nonatomic) BluetoothScanner *bluetoothScanner;

- (IBAction)connexionServer:(id)sender;
- (IBAction)simulation:(id)sender;
- (IBAction)refreshBluetooth:(id)sender;
- (IBAction)startBT:(id)sender;
- (IBAction)stopBT:(id)sender;
- (IBAction)autorizedDevices:(id)sender;

@end
