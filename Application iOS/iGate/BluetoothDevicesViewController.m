//
//  BluetoothDevicesViewController.m
//  iGate
//
//  Created by Maxime Carrillo on 22/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//

#import "BluetoothDevicesViewController.h"
#import "NetworkController.h"

@interface BluetoothDevicesViewController ()

@end

@implementation BluetoothDevicesViewController

@synthesize btArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"iGate.BluetoothArray"] != nil) {
        NSArray *tmpArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"iGate.BluetoothArray"];
        btArray = [tmpArray mutableCopy];

    }
    
    else {
        btArray = [[NSMutableArray alloc] init];
    }
    [self.tableView reloadData];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.preferredContentSize=self.tableView.contentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (btArray.count != 0) {
    return btArray.count;
    }
    else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (btArray.count != 0) {
        cell.textLabel.text= [btArray objectAtIndex:indexPath.row];

    }
    
    else {
        cell.textLabel.text = @"Aucun Smartphone autorisé";
    }

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (btArray.count != 0) {
        return YES;
    }
    else {
        return NO;
    }}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[NetworkController sharedInstance] sendMessage:[NSString stringWithFormat:@"[REMOVEBT]%@", [btArray objectAtIndex:indexPath.row]]];
        [btArray removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults  standardUserDefaults] setObject:btArray forKey:@"iGate.BluetoothArray"];
        [self.tableView reloadData];
    }   
    
}


@end
