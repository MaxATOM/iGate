//
//  ViewController.m
//  iGate
//
//  Created by Maxime Carrillo on 17/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//

#import "ViewController.h"
#import "NetworkController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize port, host, connect, statut;
@synthesize boutonOuvrir,boutonFermer;

#pragma mark - View controller lifecycle

// Fonction exécuté lorsque l'appli est lancé
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Mise à jour du statut
    [statut setText:@"Non connecté"];
    
    // Chargement de l'adresse IP et du Port sauvegardé
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:@"iGate.host"] != nil)
        host.text = [defaults objectForKey:@"iGate.host"];

    if ([defaults objectForKey:@"iGate.port"] != nil)
        port.text = [defaults objectForKey:@"iGate.port"];

    // Masquage des boutons car on est déconnecté
    boutonOuvrir.hidden = YES;
    boutonFermer.hidden = YES;
    
}

// Fonction lorsqu'on appuie sur le bouton ouvrir
- (IBAction)openGate:(id)sender {
    
    // Message d'ouverture du portail
    [[NetworkController sharedInstance] sendMessage:@"open"];

}

// Fonction lorsqu'on appuie sur le bouton fermer
- (IBAction)closeGate:(id)sender {
    
    // Message de fermeture du portail
    [[NetworkController sharedInstance] sendMessage:@"close"];

}

- (IBAction)doConnect:(id)sender {


    // Sauvegarde de l'adresse IP et du Port
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[host text] forKey:@"iGate.host"];
    [defaults setObject:[port text] forKey:@"iGate.port"];
    [defaults setBool:NO forKey:@"iGate.auto"];
    [defaults synchronize];
    
    // Masquage du clavier
    [[self host] resignFirstResponder];
    [[self port] resignFirstResponder];
    
    // Mise à jour du status
    [statut setText:@"Connexion en cours…"];
    
    // Démarrage du NetworkController
    [[NetworkController sharedInstance] updateIP];
    [[NetworkController sharedInstance] connect];
    
    [NetworkController sharedInstance].connectionOpenedBlock = ^(NetworkController* connection){
        
        // Connexion effectué, mise à jour du statut
        statut.text = @"Connecté";

        // Affichage des boutons ouvrir et fermer
        boutonOuvrir.hidden = NO;
        boutonFermer.hidden = NO;
        
    };
    
    [NetworkController sharedInstance].connectionClosedBlock = ^(NetworkController* connection){
        
        // Connexion fermé
        statut.text = @"Non connecté";
    };
    
    [NetworkController sharedInstance].connectionFailedBlock = ^(NetworkController* connection){

        // Connexion echoué
        statut.text = @"La connexion à échoué";
    };
    

    [NetworkController sharedInstance].messageReceivedBlock = ^(NetworkController* connection, NSString* message){
        
        //Réception d'un message externe
        NSLog(@"Message ! : %@",message);
    };
}

@end
