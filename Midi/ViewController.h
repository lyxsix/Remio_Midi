//
//  ViewController.h
//  Midi
//
//  Created by Felix on 15/5/21.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"

@interface ViewController : UIViewController<DFBlunoDelegate>
@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;

@property (strong, nonatomic) IBOutlet UIView *connectView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *effectsView;
@property (strong, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) IBOutlet UIButton *mtBtn;
@property (strong, nonatomic) IBOutlet UIButton *seBtn;


- (IBAction)connectAction:(id)sender;
- (IBAction)playMT1:(id)sender;
- (IBAction)playMT2:(id)sender;
- (IBAction)playMT3:(id)sender;

- (IBAction)toMTView:(id)sender;
- (IBAction)toSEView:(id)sender;

@end

