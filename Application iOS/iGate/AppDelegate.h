//
//  AppDelegate.h
//  iGate
//
//  Created by Maxime Carrillo on 17/01/2014.
//  Copyright (c) 2014 Maxime Carrillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    UILabel *status;
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UILabel *status;


@end
