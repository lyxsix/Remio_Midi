//
//  ViewController.m
//  Midi
//
//  Created by Felix on 15/5/21.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import "ViewController.h"
#import "MHRotaryKnob.h"
#import "AudioEngine.h"

@interface ViewController ()<AudioEngineDelegate>
{
    BOOL _isConnect;
    NSString* _msg;
}
@property (weak, nonatomic) IBOutlet MHRotaryKnob *rotaryKnob;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.aryDevices = [[NSMutableArray alloc] init];
    _isConnect = NO;
    [self searchDevices];
    
    _menuView.hidden = YES;
    _mainView.hidden = YES;
    _effectsView.hidden = YES;
    
    [self initMyknob];
    [self initAudio];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMT1:(id)sender {
    [engine toogleMM1];
    [_albumImage setImage:[UIImage imageNamed:@"black light-01"]];
    if (engine.mM2isPlaying) {
        [engine.mM2Player stop];
    }
    if (engine.mM3isPlaying) {
        [engine.mM3Player stop];
    }
}

- (IBAction)playMT2:(id)sender {
    [_albumImage setImage:[UIImage imageNamed:@"ttu-01"]];
    [engine toogleMM2];
    if (engine.mM1isPlaying) {
        [engine.mM1Player stop];
    }
    if (engine.mM3isPlaying) {
        [engine.mM3Player stop];
    }
}

- (IBAction)playMT3:(id)sender {
    [_albumImage setImage:[UIImage imageNamed:@"dph-01"]];
    [engine toogleMM3];
    if (engine.mM1isPlaying) {
        [engine.mM1Player stop];
    }
    if (engine.mM2isPlaying) {
        [engine.mM2Player stop];
    }
}

- (IBAction)toMTView:(id)sender {
    _mainView.hidden = NO;
    _effectsView.hidden = YES;
    [_mtBtn setEnabled:NO];
    [_mtBtn.titleLabel setAlpha:0.6];
    [_seBtn setEnabled:YES];
    [_seBtn.titleLabel setAlpha:0.9];
}

- (IBAction)toSEView:(id)sender {
    _mainView.hidden = YES;
    _effectsView.hidden = NO;
    [_mtBtn setEnabled:YES];
    [_mtBtn.titleLabel setAlpha:0.9];
    [_seBtn setEnabled:NO];
    [_seBtn.titleLabel setAlpha:0.6];
    
}

#pragma mark- Rotary

- (void)initMyknob{
    self.rotaryKnob.interactionStyle = MHRotaryKnobInteractionStyleRotating;
    self.rotaryKnob.scalingFactor = 1.5;
    self.rotaryKnob.maximumValue = 360;
    self.rotaryKnob.minimumValue = 0;
    self.rotaryKnob.value = 0;
    self.rotaryKnob.defaultValue = self.rotaryKnob.value;
    self.rotaryKnob.resetsToDefault = YES;
    self.rotaryKnob.backgroundColor = [UIColor clearColor];
    [self.rotaryKnob setKnobImage:[UIImage imageNamed:@"zz"] forState:UIControlStateNormal];
    [self.rotaryKnob setAlpha:0.8];
    self.rotaryKnob.knobImageCenter = CGPointMake(100, 100);
    [self.rotaryKnob addTarget:self action:@selector(rotaryKnobDidChange) forControlEvents:UIControlEventValueChanged];
    self.rotaryKnob.enabled = false;
}

- (IBAction)rotaryKnobDidChange
{
//    self.label.text = [NSString stringWithFormat:@"%.3f", self.rotaryKnob.value];
//    self.slider.value = self.rotaryKnob.value;
}


#pragma mark- DFBlunoDelegate

- (void)searchDevices{
    [self.aryDevices removeAllObjects];
    [self.blunoManager scan];
}

-(void)bleDidUpdateState:(BOOL)bleSupported
{
    if(bleSupported)
    {
        [self.blunoManager scan];
    }
}

-(void)didDiscoverDevice:(DFBlunoDevice*)dev
{
    BOOL bRepeat = NO;
    for (DFBlunoDevice* bleDevice in self.aryDevices)
    {
        if ([bleDevice isEqual:dev])
        {
            bRepeat = YES;
            break;
        }
    }
    if (!bRepeat)
    {
        [self.aryDevices addObject:dev];
    }
    //    [self.tbDevices reloadData];
}

-(void)readyToCommunicate:(DFBlunoDevice*)dev
{
    self.blunoDev = dev;
    _isConnect = YES;
    NSLog(@"Ble Connected");
}

-(void)didDisconnectDevice:(DFBlunoDevice*)dev
{
    _isConnect = NO;
}

-(void)didWriteData:(DFBlunoDevice*)dev
{
    
}

-(void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev
{
    _msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",_msg);
//    BOOL isa0 = ([_msg rangeOfString:@"a0"].location !=NSNotFound);
//    if (isa0) {
//        if (_audioPlayer) {
//            if ((_audioPlayer.volume -0.1)>0) {
//                _audioPlayer.volume -= 0.1;
//            }else{
//                _audioPlayer.volume = 0;
//            }
//            NSLog(@"_audioPlayer.volume %f",_audioPlayer.volume);
//        }
//    }
    
    NSRange rangeAg;
    rangeAg=[_msg rangeOfString:@"ag"];
    if (_msg.length>(rangeAg.location+4)) {
        NSString *strAg = [_msg substringWithRange:NSMakeRange(rangeAg.location+2,3)];
        float floatAg = [strAg floatValue];
        if (floatAg<360.0) {
            NSLog(@"floatA is %f",floatAg);
            _rotaryKnob.value = floatAg;
            [engine rotaryMM:floatAg];
        }
    }

    
}

- (IBAction)connectAction:(id)sender {
    NSInteger nCount = [self.aryDevices count];
    for (int i = 0; i < nCount; i++) {
        DFBlunoDevice* device   = [self.aryDevices objectAtIndex:i];
        NSLog(@"NO: %li Device Name is %@",(long)nCount,device.name);
        if ([device.name  isEqual: @"BlunoV2.0"]) {
            NSLog(@"Find device in aryDevices");
            if (self.blunoDev == nil)
            {
                self.blunoDev = device;
                [self.blunoManager connectToDevice:self.blunoDev];
            }
            else if ([device isEqual:self.blunoDev])
            {
                if (!self.blunoDev.bReadyToWrite)
                {
                    [self.blunoManager connectToDevice:self.blunoDev];
                }
            }
            else
            {
                if (self.blunoDev.bReadyToWrite)
                {
                    [self.blunoManager disconnectToDevice:self.blunoDev];
                    self.blunoDev = nil;
                }
                
                [self.blunoManager connectToDevice:device];
            }
            _connectView.hidden = YES;
            _mainView.hidden = NO;
            _menuView.hidden = NO;
        }
    }
}

#pragma mark AudioEngine
- (void)initAudio
{
    engine = [[AudioEngine alloc] init];
    engine.delegate = self;
    
    engine.mM1PlayerVolume = 1.0;
    engine.mM2PlayerVolume = 1.0;
    engine.mM3PlayerVolume = 1.0;
    engine.sM1PlayerVolume = 0.0;
    engine.sM2PlayerVolume = 0.0;
    engine.sM3PlayerVolume = 0.0;
    engine.sM4PlayerVolume = 0.0;
    engine.sM5PlayerVolume = 0.0;
    
    [engine toogleSM1];
    [engine toogleSM2];
    [engine toogleSM3];
    [engine toogleSM4];
    [engine toogleSM5];
}

@end
