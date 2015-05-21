//
//  ViewController.m
//  Midi
//
//  Created by Felix on 15/5/21.
//  Copyright (c) 2015年 wewing. All rights reserved.
//

#import "ViewController.h"
#import "MHRotaryKnob.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MHRotaryKnob *rotaryKnob;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initMyknob];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMyknob{
    self.rotaryKnob.interactionStyle = MHRotaryKnobInteractionStyleRotating;
    self.rotaryKnob.scalingFactor = 1.5;
    self.rotaryKnob.maximumValue = 999;
    self.rotaryKnob.minimumValue = 0;
    self.rotaryKnob.value = 499;
    self.rotaryKnob.defaultValue = self.rotaryKnob.value;
    self.rotaryKnob.resetsToDefault = YES;
    self.rotaryKnob.backgroundColor = [UIColor clearColor];
    [self.rotaryKnob setKnobImage:[UIImage imageNamed:@"Knob"] forState:UIControlStateNormal];
    self.rotaryKnob.knobImageCenter = CGPointMake(100, 100);
    [self.rotaryKnob addTarget:self action:@selector(rotaryKnobDidChange) forControlEvents:UIControlEventValueChanged];
//    self.rotaryKnob.enabled = false;
}

- (IBAction)rotaryKnobDidChange
{
//    self.label.text = [NSString stringWithFormat:@"%.3f", self.rotaryKnob.value];
//    self.slider.value = self.rotaryKnob.value;
}


- (IBAction)connectAction:(id)sender {
}
@end
