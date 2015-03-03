//
//  ConnectionViewController.m
//  iGate
//
//  Created by Maxime Carrillo on 17/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//

#import "ConnexionViewController.h"
#import "iPadViewController.h"
#import "NetworkController.h"

@implementation ConnexionViewController


@synthesize port, host, status;
@synthesize connecter, segment;

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    if ([[NetworkController sharedInstance] isConnected]) {
        [status setText:@"Connecté"];
    }
    else {
        [status setText:@"Non connecté"];
  
    }
    
    
    
    host.hidden = YES;
    port.hidden = YES;
    
    // Load user defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"iGate.host"] != nil) {
        [host setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"iGate.host"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"iGate.port"] != nil) {
        [port setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"iGate.port"]];
    }
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 300, 250);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.view = nil;
}

- (IBAction)changeSegment:(id)sender {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    if(segment.selectedSegmentIndex == 0){
        
        host.hidden = YES;
        port.hidden = YES;
        [defaults setBool:YES forKey:@"iGate.auto"];
        [defaults synchronize];

        if (connecter.frame.origin.y != 128) {
            [UIView animateWithDuration:.1f animations:^{
                CGRect buttonFrame = connecter.frame;
                buttonFrame.origin.y -= 40;
                connecter.frame = buttonFrame;
                
                CGRect labelFrame = status.frame;
                labelFrame.origin.y -= 40;
                status.frame = labelFrame;
            }];
        }
		
	}
	else if(segment.selectedSegmentIndex == 1){
        [defaults setBool:NO forKey:@"iGate.auto"];
        [defaults synchronize];

        host.hidden = NO;
        port.hidden = NO;
        
        if (connecter.frame.origin.y != 168) {
            [UIView animateWithDuration:.1f animations:^{
                CGRect buttonFrame = connecter.frame;
                buttonFrame.origin.y += 40;
                connecter.frame = buttonFrame;
                
                CGRect labelFrame = status.frame;
                labelFrame.origin.y += 40;
                status.frame = labelFrame;
                
            }];
        }

        
// bouton connecter Y = 168 et label = 209
        
	}
    
    [[NetworkController sharedInstance] updateIP];
    
    
}

 
- (IBAction)doConnect:(id)sender {
    // Save user defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[host text] forKey:@"iGate.host"];
    [defaults setObject:[port text] forKey:@"iGate.port"];
    [defaults synchronize];
    
    [[self host] resignFirstResponder];
    [[self port] resignFirstResponder];
    [[NetworkController sharedInstance] updateIP];

    [[NetworkController sharedInstance] connect];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
