/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AudioEngine is the main controller class that creates the following objects:
                    AVAudioEngine       *_engine;
                    AVAudioPlayerNode   *_marimbaPlayer;
                    AVAudioPlayerNode   *_drumPlayer;
                    AVAudioUnitDelay    *_delay;
                    AVAudioUnitReverb   *_reverb;
                    AVAudioPCMBuffer    *_marimbaLoopBuffer;
                    AVAudioPCMBuffer    *_drumLoopBuffer;
                    
                    AVAudioPlayerNode *_hit0Player;
                    AVAudioPlayerNode *_hit1Player;
                    AVAudioPlayerNode *_hit2Player;
                    AVAudioPlayerNode *_hit3Player;
                    AVAudioPlayerNode *_hit4Player;
                    AVAudioPlayerNode *_hit5Player;
                    AVAudioPlayerNode *_hit6Player;
                    AVAudioPlayerNode *_hit7Player;
                    AVAudioPlayerNode *_hit8Player;
                    AVAudioPlayerNode *_hit9Player;
                    AVAudioPlayerNode *_hit10Player;
                    AVAudioPlayerNode *_hit11Player;
 
 
                 It connects all the nodes, loads the buffers as well as controls the AVAudioEngine object itself.
*/

@import Foundation;
@import AVFoundation;
// effect strip 1 - Marimba Player -> Delay -> Mixer
// effect strip 2 - Drum Player -> Distortion -> Mixer

@protocol AudioEngineDelegate <NSObject>

@optional
- (void)engineConfigurationHasChanged;
- (void)mixerOutputFilePlayerHasStopped;

@end

@interface AudioEngine : NSObject
@property (nonatomic,strong) AVAudioPlayerNode *mM1Player;
@property (nonatomic,strong) AVAudioPlayerNode *mM2Player;
@property (nonatomic,strong) AVAudioPlayerNode *mM3Player;


//new main melody and sub melody isPlaying
@property (nonatomic, readonly) BOOL mM1isPlaying;
@property (nonatomic, readonly) BOOL mM2isPlaying;
@property (nonatomic, readonly) BOOL mM3isPlaying;
@property (nonatomic, readonly) BOOL sM1isPlaying;
@property (nonatomic, readonly) BOOL sM2isPlaying;
@property (nonatomic, readonly) BOOL sM3isPlaying;
@property (nonatomic, readonly) BOOL sM4isPlaying;
@property (nonatomic, readonly) BOOL sM5isPlaying;


//new PlayerVolume
@property (nonatomic) float mM1PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float mM2PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float mM3PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float sM1PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float sM2PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float sM3PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float sM4PlayerVolume;       // 0.0 - 1.0
@property (nonatomic) float sM5PlayerVolume;       // 0.0 - 1.0




@property (nonatomic) float outputVolume;           // 0.0 - 1.0

@property (weak) id<AudioEngineDelegate> delegate;



// toogle new melody and touch/press  new effect
- (void)toogleMM1;
- (void)toogleMM2;
- (void)toogleMM3;
- (void)toogleSM1;
- (void)toogleSM2;
- (void)toogleSM3;
- (void)toogleSM4;
- (void)toogleSM5;

- (void)pressPE1:(float)volume;
- (void)pressPE2:(float)volume;
- (void)pressPE3:(float)volume;
- (void)touchTE1;
- (void)touchTE2;
- (void)touchTE3;
- (void)touchTE4;
- (void)touchTE5;
- (void)touchTE6;
- (void)touchTE7;




- (void)startRecordingMixerOutput;
- (void)stopRecordingMixerOutput;
- (void)playRecordedFile;
- (void)pausePlayingRecordedFile;
- (void)stopPlayingRecordedFile;

- (void)rotaryMM:(float)agVal;

@end
