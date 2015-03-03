//
//  ConnectionViewController.h
//  iGate
//
//  Created by Maxime Carrillo on 17/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnexionViewController : UIViewController {
 
    IBOutlet UIButton *connecter;
    IBOutlet UILabel *status;
    IBOutlet UISegmentedControl *segment;

    
    
}


@property (retain, nonatomic) IBOutlet UITextField *port;
@property (retain, nonatomic) IBOutlet UITextField *host;
@property (retain, nonatomic) IBOutlet UIButton *connecter;
@property(nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;
- (IBAction)changeSegment:(id)sender;
- (IBAction)doConnect:(id)sender;
- (IBAction)cancel:(id)sender;


@end
