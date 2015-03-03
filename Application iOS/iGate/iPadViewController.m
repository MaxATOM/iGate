//
//  DeviceListingViewController.m
//  BluetoothScanner
//
//  Created by Michael Dorner on 12.10.13.
//  Copyright (c) 2013 Michael Dorner. All rights reserved.
//

#import "iPadViewController.h"
#import "BluetoothDevice.h"
#import "ConnexionViewController.h"
#import "NetworkController.h"
#import "BluetoothDevicesViewController.h"


@interface iPadViewController ()

@property (retain, nonatomic) NSMutableDictionary *currentAvailableDevices;

@end



@implementation iPadViewController
@synthesize bluetoothTableView;
@synthesize refreshButton, spinner, status;
@synthesize tmpBtAddress;
@synthesize bluetoothIsStarted, popOver, bluetoothScanner;
- (void)viewDidLoad
{
 
    status.text = @"Offline";
    
    [super viewDidLoad];
    
    [NetworkController sharedInstance].connectionOpenedBlock = ^(NetworkController* connection){
        
        NSLog(@">>> Connection opened <<<");
        status.text = @"Connected";
        [[NetworkController sharedInstance] sendMessage:@"iPad"];

    };
    
    // Disable input and hide keyboard when connection is closed.
    [NetworkController sharedInstance].connectionClosedBlock = ^(NetworkController* connection){
        
        NSLog(@">>> Connection closed <<<");
        status.text = @"Non connecté";
    };
    
    // Display error message and do nothing if connection fails.
    [NetworkController sharedInstance].connectionFailedBlock = ^(NetworkController* connection){
        NSLog(@">>> Connection FAILED <<<");
        status.text = @"La connexion à échoué";
    };
    
    // Append incoming message to the output text view.
    [NetworkController sharedInstance].messageReceivedBlock = ^(NetworkController* connection, NSString* message){
        NSLog(@"Message ! : %@",message);
    };
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate methods

- (void)addBluetoothDevice:(BluetoothDevice *)bluetoothDevice
{
    [self.currentAvailableDevices setObject:bluetoothDevice forKey:bluetoothDevice.address];
    [bluetoothTableView reloadData];
}

- (void)removeBluetoothDevice:(BluetoothDevice *)bluetoothDevice
{
    [self.currentAvailableDevices removeObjectForKey:bluetoothDevice.address];
    [bluetoothTableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.currentAvailableDevices allKeys] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeviceCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BluetoothDevice *bluetoothDevice = (BluetoothDevice*)[self.currentAvailableDevices allValues][indexPath.row];
    
    cell.textLabel.text = bluetoothDevice.name;
    cell.detailTextLabel.text = bluetoothDevice.address;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    refreshButton.alpha = 1;
    [spinner stopAnimating];
    UITableViewCell *cell = [self tableView:bluetoothTableView cellForRowAtIndexPath:indexPath];
    BluetoothDevice *bluetoothDevice = (BluetoothDevice *)[self.currentAvailableDevices objectForKey:cell.detailTextLabel.text];
    [bluetoothScanner stopScan];
     tmpBtAddress = [NSString stringWithFormat:@"%@//%@", bluetoothDevice.name, bluetoothDevice.address];
    for (NSIndexPath *indexPath in tableView.indexPathsForSelectedRows) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    NSString *messageAlert = [NSString stringWithFormat:@"Voulez-vous autoriser %@ (adresse : %@) à ouvrir le portail ?", bluetoothDevice.name, bluetoothDevice.address];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nouveau smartphone"
                                                      message:messageAlert
                                                     delegate:self
                                            cancelButtonTitle:@"Annuler"
                                            otherButtonTitles:@"Valider", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    [bluetoothTableView deselectRowAtIndexPath:[bluetoothTableView indexPathForSelectedRow] animated:YES];

    if([title isEqualToString:@"Valider"])
    {
        NSArray *subStrings = [tmpBtAddress componentsSeparatedByString:@"//"]; //or rather @" - "
        
        NSLog(@"On ajoute : %@ et %@", [subStrings objectAtIndex:0], [subStrings objectAtIndex:1]);
        [[NetworkController sharedInstance] sendMessage:[NSString stringWithFormat:@"[ADDBT]%@", tmpBtAddress]];
        NSMutableArray *tmpArrayBt = [[NSMutableArray alloc] init];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"iGate.BluetoothArray"] != nil) {
            tmpArrayBt = [[defaults objectForKey:@"iGate.BluetoothArray"] mutableCopy];
            [tmpArrayBt addObject:tmpBtAddress];
            tmpBtAddress = nil;
            [defaults setObject:tmpArrayBt forKey:@"iGate.BluetoothArray"];
            [defaults synchronize];

        }
        
        else {
            [tmpArrayBt addObject:tmpBtAddress];
            tmpBtAddress = nil;
            [defaults setObject:tmpArrayBt forKey:@"iGate.BluetoothArray"];
            [defaults synchronize];
        }
        

       
    }
    
}


- (IBAction)refreshBluetooth:(id)sender {
    
    spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(317, 216);
    spinner.hidesWhenStopped = YES;
    if (self.bluetoothScanner != nil) {
        NSLog(@"le scan existe deja");
        [bluetoothScanner restartScan];
        [bluetoothTableView reloadData];
    }
    else {
    self.bluetoothScanner = [[BluetoothScanner alloc] initWithDelegate:(id)self];
    self.currentAvailableDevices = [[NSMutableDictionary alloc] init];
    }
    
    [self.view addSubview:spinner];
    [self.view sendSubviewToBack:spinner];
    [self.view bringSubviewToFront:refreshButton];
    [spinner startAnimating];
    refreshButton.alpha = 0;
   
    
}

- (IBAction)startBT:(id)sender {
    
    [[NetworkController sharedInstance] sendMessage:@"scanBT"];
    bluetoothIsStarted = YES;
}
- (IBAction)openGate:(id)sender {
    
    [[NetworkController sharedInstance] sendMessage:@"open"];

}

- (IBAction)stopBT:(id)sender {
    
    [[NetworkController sharedInstance] sendMessage:@"stopBT"];
}

- (IBAction)autorizedDevices:(id)sender {
    
    UIButton *btn =sender;
    BluetoothDevicesViewController *btHisto =[[BluetoothDevicesViewController alloc] init];
    popOver =[[UIPopoverController alloc] initWithContentViewController:btHisto];
    [popOver setPopoverContentSize:CGSizeMake(309, 44)];
    [popOver presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

#pragma mark - Connexion socket



- (IBAction)connexionServer:(id)sender {
    
    [self performSegueWithIdentifier:@"segue" sender:self];

}

- (IBAction)simulation:(id)sender {
    
    NSString *messageAlert = [NSString stringWithFormat:@"Voulez-vous autoriser iPhone de Daniel à ouvrir le portail ?"];
    tmpBtAddress = [NSString stringWithFormat:@"iPhone de Daniel//00"];
    
    //    tmpBtAddress = [NSString stringWithFormat:@"NicoS4//00:00:46:66:28:01"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nouveau smartphone"
                                                      message:messageAlert
                                                     delegate:self
                                            cancelButtonTitle:@"Annuler"
                                            otherButtonTitles:@"Valider", nil];
    [message show];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [NetworkController sharedInstance].connectionOpenedBlock = nil;
    [NetworkController sharedInstance].connectionFailedBlock = nil;
    [NetworkController sharedInstance].connectionClosedBlock = nil;
    [NetworkController sharedInstance].messageReceivedBlock = nil;
}

@end
