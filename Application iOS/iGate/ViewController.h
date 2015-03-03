//
//  ViewController.h
//  iGate
//
//  Created by Maxime Carrillo on 17/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//


// Import the library
#import <UIKit/UIKit.h>

// Définition du type de classe
@interface ViewController : UIViewController

// Création et propriétés de chaque objet
// nonatomic : utilisable depuis plusieurs fonctions en même temps
// strong : géré par l'ARC
@property(nonatomic, strong) IBOutlet UITextField *host;
@property(nonatomic, strong) IBOutlet UITextField *port;

@property(nonatomic, strong) IBOutlet UIButton *connect;
@property(nonatomic, strong) IBOutlet UIButton *boutonOuvrir;
@property(nonatomic, strong) IBOutlet UIButton *boutonFermer;

@property(nonatomic, strong) IBOutlet UILabel *statut;

// Création des fonctions (méthodes d'instance)
- (IBAction)doConnect:(id)sender;
- (IBAction)openGate:(id)sender;
- (IBAction)closeGate:(id)sender;

@end



