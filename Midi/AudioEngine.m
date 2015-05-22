/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    AudioEngine is the main controller class that creates the following objects:
                    AVAudioEngine       *_engine;
                    AVAudioPlayerNode   *_aPlayer;
                    AVAudioPlayerNode   *_bPlayer;
                    AVAudioUnitDelay    *_delay;
                    AVAudioUnitReverb   *_reverb;
                    AVAudioPCMBuffer    *_aBuff;
                    AVAudioPCMBuffer    *_bBuff;
 
                 It connects all the nodes, loads the buffers as well as controls the AVAudioEngine object itself.
*/

#import "AudioEngine.h"

@import AVFoundation;
@import Accelerate;

#pragma mark AudioEngine class extensions

@interface AudioEngine() {
    AVAudioEngine       *_engine;
    
    //new PlayerNode and PCMBuffer
    AVAudioPlayerNode   *_mM1Player;
    AVAudioPlayerNode   *_mM2Player;
    AVAudioPlayerNode   *_mM3Player;
    AVAudioPlayerNode   *_sM1Player;
    AVAudioPlayerNode   *_sM2Player;
    AVAudioPlayerNode   *_sM3Player;
    AVAudioPlayerNode   *_sM4Player;
    AVAudioPlayerNode   *_sM5Player;

    AVAudioPCMBuffer    *_mM1Buff;
    AVAudioPCMBuffer    *_mM2Buff;
    AVAudioPCMBuffer    *_mM3Buff;
    AVAudioPCMBuffer    *_sM1Buff;
    AVAudioPCMBuffer    *_sM2Buff;
    AVAudioPCMBuffer    *_sM3Buff;
    AVAudioPCMBuffer    *_sM4Buff;
    AVAudioPCMBuffer    *_sM5Buff;
    
    
    // for the node tap
    NSURL               *_mixerOutputFileURL;
    AVAudioPlayerNode   *_mixerOutputFilePlayer;
    BOOL                _mixerOutputFilePlayerIsPaused;
    BOOL                _isRecording;
    

    
    //new ...
    AVAudioPlayerNode *_pE1Player;
    AVAudioPlayerNode *_pE2Player;
    AVAudioPlayerNode *_pE3Player;
    AVAudioPlayerNode *_tE1Player;
    AVAudioPlayerNode *_tE2Player;
    AVAudioPlayerNode *_tE3Player;
    AVAudioPlayerNode *_tE4Player;
    AVAudioPlayerNode *_tE5Player;
    AVAudioPlayerNode *_tE6Player;
    AVAudioPlayerNode *_tE7Player;
    
    AVAudioPCMBuffer *_pE1Buff;
    AVAudioPCMBuffer *_pE2Buff;
    AVAudioPCMBuffer *_pE3Buff;
    AVAudioPCMBuffer *_tE1Buff;
    AVAudioPCMBuffer *_tE2Buff;
    AVAudioPCMBuffer *_tE3Buff;
    AVAudioPCMBuffer *_tE4Buff;
    AVAudioPCMBuffer *_tE5Buff;
    AVAudioPCMBuffer *_tE6Buff;
    AVAudioPCMBuffer *_tE7Buff;
    
}

- (void)handleInterruption:(NSNotification *)notification;
- (void)handleRouteChange:(NSNotification *)notification;

@end

#pragma mark AudioEngine implementation

@implementation AudioEngine

- (instancetype)init
{
    if (self = [super init]) {
        // create the various nodes
        
        /*  AVAudioPlayerNode supports scheduling the playback of AVAudioBuffer instances,
            or segments of audio files opened via AVAudioFile. Buffers and segments may be
            scheduled at specific points in time, or to play immediately following preceding segments. */
        

        
        _mM1Player = [[AVAudioPlayerNode alloc] init];
        _mM2Player = [[AVAudioPlayerNode alloc] init];
        _mM3Player = [[AVAudioPlayerNode alloc] init];
        _sM1Player = [[AVAudioPlayerNode alloc] init];
        _sM2Player = [[AVAudioPlayerNode alloc] init];
        _sM3Player = [[AVAudioPlayerNode alloc] init];
        _sM4Player = [[AVAudioPlayerNode alloc] init];
        _sM5Player = [[AVAudioPlayerNode alloc] init];
        
        _pE1Player = [[AVAudioPlayerNode alloc] init];
        _pE2Player = [[AVAudioPlayerNode alloc] init];
        _pE3Player = [[AVAudioPlayerNode alloc] init];
        _tE1Player = [[AVAudioPlayerNode alloc] init];
        _tE2Player = [[AVAudioPlayerNode alloc] init];
        _tE3Player = [[AVAudioPlayerNode alloc] init];
        _tE4Player = [[AVAudioPlayerNode alloc] init];
        _tE5Player = [[AVAudioPlayerNode alloc] init];
        _tE6Player = [[AVAudioPlayerNode alloc] init];
        _tE7Player = [[AVAudioPlayerNode alloc] init];
        
        /*  A delay unit delays the input signal by the specified time interval
            and then blends it with the input signal. The amount of high frequency
            roll-off can also be controlled in order to simulate the effect of
            a tape delay. */
        
        
        /*  A reverb simulates the acoustic characteristics of a particular environment.
            Use the different presets to simulate a particular space and blend it in with
            the original signal using the wetDryMix parameter. */

        _mixerOutputFilePlayer = [[AVAudioPlayerNode alloc] init];
        
        _mixerOutputFileURL = nil;
        _mixerOutputFilePlayerIsPaused = NO;
        _isRecording = NO;
        
        // create an instance of the engine and attach the nodes
        [self createEngineAndAttachNodes];
        
        NSError *error;
        
        

        
        
        /**----------load _mM1 buff----------*/
        
        NSURL *mM1URL=[self readAudioURL:@"mM1"];
        AVAudioFile *mM1File = [[AVAudioFile alloc] initForReading:mM1URL error:&error];
        _mM1Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[mM1File processingFormat] frameCapacity:(AVAudioFrameCount)[mM1File length]];
        NSAssert([mM1File readIntoBuffer:_mM1Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _mM2 buff----------*/
        
        NSURL *mM2URL=[self readAudioURL:@"mM2"];
        AVAudioFile *mM2File = [[AVAudioFile alloc] initForReading:mM2URL error:&error];
        _mM2Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[mM2File processingFormat] frameCapacity:(AVAudioFrameCount)[mM2File length]];
        NSAssert([mM2File readIntoBuffer:_mM2Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _mM3 buff----------*/
        
        NSURL *mM3URL=[self readAudioURL:@"mM3"];
        AVAudioFile *mM3File = [[AVAudioFile alloc] initForReading:mM3URL error:&error];
        _mM3Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[mM3File processingFormat] frameCapacity:(AVAudioFrameCount)[mM3File length]];
        NSAssert([mM3File readIntoBuffer:_mM3Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _sM1 buff----------*/
        
        NSURL *sM1URL=[self readAudioURL:@"sM1"];
        AVAudioFile *sM1File = [[AVAudioFile alloc] initForReading:sM1URL error:&error];
        _sM1Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[sM1File processingFormat] frameCapacity:(AVAudioFrameCount)[sM1File length]];
        NSAssert([sM1File readIntoBuffer:_sM1Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _sM2 buff----------*/
        
        NSURL *sM2URL=[self readAudioURL:@"sM2"];
        AVAudioFile *sM2File = [[AVAudioFile alloc] initForReading:sM2URL error:&error];
        _sM2Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[sM2File processingFormat] frameCapacity:(AVAudioFrameCount)[sM2File length]];
        NSAssert([sM2File readIntoBuffer:_sM2Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _sM3 buff----------*/
        
        NSURL *sM3URL=[self readAudioURL:@"sM3"];
        AVAudioFile *sM3File = [[AVAudioFile alloc] initForReading:sM3URL error:&error];
        _sM3Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[sM3File processingFormat] frameCapacity:(AVAudioFrameCount)[sM3File length]];
        NSAssert([sM3File readIntoBuffer:_sM3Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _sM4 buff----------*/
        
        NSURL *sM4URL=[self readAudioURL:@"sM4"];
        AVAudioFile *sM4File = [[AVAudioFile alloc] initForReading:sM4URL error:&error];
        _sM4Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[sM4File processingFormat] frameCapacity:(AVAudioFrameCount)[sM4File length]];
        NSAssert([sM4File readIntoBuffer:_sM4Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _sM5 buff----------*/
        
        NSURL *sM5URL=[self readAudioURL:@"sM5"];
        AVAudioFile *sM5File = [[AVAudioFile alloc] initForReading:sM5URL error:&error];
        _sM5Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[sM5File processingFormat] frameCapacity:(AVAudioFrameCount)[sM5File length]];
        NSAssert([sM5File readIntoBuffer:_sM5Buff error:&error], @"couldn't read marimbaLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _pE1 buff----------*/
        NSURL *pE1URL = [self readAudioURL:@"pE1"];
        AVAudioFile *pE1File = [[AVAudioFile alloc] initForReading:pE1URL error:&error];
        _pE1Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[pE1File processingFormat] frameCapacity:(AVAudioFrameCount)[pE1File length]];
        NSAssert([pE1File readIntoBuffer:_pE1Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _pE2 buff----------*/
        NSURL *pE2URL = [self readAudioURL:@"pE2"];
        AVAudioFile *pE2File = [[AVAudioFile alloc] initForReading:pE2URL error:&error];
        _pE2Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[pE2File processingFormat] frameCapacity:(AVAudioFrameCount)[pE2File length]];
        NSAssert([pE2File readIntoBuffer:_pE2Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _pE3 buff----------*/
        NSURL *pE3URL = [self readAudioURL:@"pE3"];
        AVAudioFile *pE3File = [[AVAudioFile alloc] initForReading:pE3URL error:&error];
        _pE3Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[pE3File processingFormat] frameCapacity:(AVAudioFrameCount)[pE3File length]];
        NSAssert([pE3File readIntoBuffer:_pE3Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE1 buff----------*/
        NSURL *tE1URL = [self readAudioURL:@"tE1"];
        AVAudioFile *tE1File = [[AVAudioFile alloc] initForReading:tE1URL error:&error];
        _tE1Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE1File processingFormat] frameCapacity:(AVAudioFrameCount)[tE1File length]];
        NSAssert([tE1File readIntoBuffer:_tE1Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE2 buff----------*/
        NSURL *tE2URL = [self readAudioURL:@"tE2"];
        AVAudioFile *tE2File = [[AVAudioFile alloc] initForReading:tE2URL error:&error];
        _tE2Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE2File processingFormat] frameCapacity:(AVAudioFrameCount)[tE2File length]];
        NSAssert([tE2File readIntoBuffer:_tE2Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE3 buff----------*/
        NSURL *tE3URL = [self readAudioURL:@"tE3"];
        AVAudioFile *tE3File = [[AVAudioFile alloc] initForReading:tE3URL error:&error];
        _tE3Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE3File processingFormat] frameCapacity:(AVAudioFrameCount)[tE3File length]];
        NSAssert([tE3File readIntoBuffer:_tE3Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE4 buff----------*/
        NSURL *tE4URL = [self readAudioURL:@"tE4"];
        AVAudioFile *tE4File = [[AVAudioFile alloc] initForReading:tE4URL error:&error];
        _tE4Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE4File processingFormat] frameCapacity:(AVAudioFrameCount)[tE4File length]];
        NSAssert([tE4File readIntoBuffer:_tE4Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE5 buff----------*/
        NSURL *tE5URL = [self readAudioURL:@"tE5"];
        AVAudioFile *tE5File = [[AVAudioFile alloc] initForReading:tE5URL error:&error];
        _tE5Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE5File processingFormat] frameCapacity:(AVAudioFrameCount)[tE5File length]];
        NSAssert([tE5File readIntoBuffer:_tE5Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE6 buff----------*/
        NSURL *tE6URL = [self readAudioURL:@"tE6"];
        AVAudioFile *tE6File = [[AVAudioFile alloc] initForReading:tE6URL error:&error];
        _tE6Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE6File processingFormat] frameCapacity:(AVAudioFrameCount)[tE6File length]];
        NSAssert([tE6File readIntoBuffer:_tE6Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        /**----------load _tE7 buff----------*/
        NSURL *tE7URL = [self readAudioURL:@"tE7"];
        AVAudioFile *tE7File = [[AVAudioFile alloc] initForReading:tE7URL error:&error];
        _tE7Buff = [[AVAudioPCMBuffer alloc] initWithPCMFormat:[tE7File processingFormat] frameCapacity:(AVAudioFrameCount)[tE7File length]];
        NSAssert([tE7File readIntoBuffer:_tE7Buff error:&error], @"couldn't read drumLoopFile into buffer, %@", [error localizedDescription]);
        
        // sign up for notifications from the engine if there's a hardware config change
        [[NSNotificationCenter defaultCenter] addObserverForName:AVAudioEngineConfigurationChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            // if we've received this notification, something has changed and the engine has been stopped
            // re-wire all the connections and start the engine
            NSLog(@"Received a %@ notification!", AVAudioEngineConfigurationChangeNotification);
            NSLog(@"Re-wiring connections and starting once again");
            [self makeEngineConnections];
            [self startEngine];
            
            // post notification
            if ([self.delegate respondsToSelector:@selector(engineConfigurationHasChanged)]) {
                [self.delegate engineConfigurationHasChanged];
            }
        }];
        
        // AVAudioSession setup
        [self initAVAudioSession];
        
        // make engine connections
        [self makeEngineConnections];
        
        // start the engine
        [self startEngine];
    }
    return self;
}

- (NSURL *)readAudioURL:(NSString *)audioID{
    NSURL *audioURL;
    NSString *audioFile;
    NSString *audioName;
    if ([audioID isEqual:@"mM1"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"mM2"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"mM3"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"sM1"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"sM2"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"sM3"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"sM4"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"sM5"]){
        audioName = @"guitdo.wav";
    }else if([audioID isEqual:@"pE1"]){
        audioName = @"bass_guitar1.wav";
    }else if([audioID isEqual:@"pE2"]){
        audioName = @"bass_guitar2.wav";
    }else if([audioID isEqual:@"pE3"]){
        audioName = @"bass_guitar3.wav";
    }else if([audioID isEqual:@"tE1"]){
        audioName = @"bass_guitar4.wav";
    }else if([audioID isEqual:@"tE2"]){
        audioName = @"bass_guitar5.wav";
    }else if([audioID isEqual:@"tE3"]){
        audioName = @"electric_guitar.wav";
    }else if([audioID isEqual:@"tE4"]){
        audioName = @"electric_guitar1.wav";
    }else if([audioID isEqual:@"tE5"]){
        audioName = @"electric_guitar2.wav";
    }else if([audioID isEqual:@"tE6"]){
        audioName = @"electric_guitar3.wav";
    }else if([audioID isEqual:@"tE7"]){
        audioName = @"electric_guitar4.wav";
    }else {
        audioName = @"guitdo.wav";
    }
    audioFile=[[NSBundle mainBundle] pathForResource:audioName ofType:nil];
    audioURL = [NSURL fileURLWithPath:audioFile];
    
    return audioURL;

}

- (void)createEngineAndAttachNodes
{
    /*  An AVAudioEngine contains a group of connected AVAudioNodes ("nodes"), each of which performs
		an audio signal generation, processing, or input/output task.
		
		Nodes are created separately and attached to the engine.

		The engine supports dynamic connection, disconnection and removal of nodes while running,
		with only minor limitations:
		- all dynamic reconnections must occur upstream of a mixer
		- while removals of effects will normally result in the automatic connection of the adjacent
			nodes, removal of a node which has differing input vs. output channel counts, or which
			is a mixer, is likely to result in a broken graph. */

    _engine = [[AVAudioEngine alloc] init];
    
    /*  To support the instantiation of arbitrary AVAudioNode subclasses, instances are created
		externally to the engine, but are not usable until they are attached to the engine via
		the attachNode method. */
    
    //old ...

    
    
    
    //new ...
    [_engine attachNode:_mM1Player];
    [_engine attachNode:_mM2Player];
    [_engine attachNode:_mM3Player];
    [_engine attachNode:_sM1Player];
    [_engine attachNode:_sM2Player];
    [_engine attachNode:_sM3Player];
    [_engine attachNode:_sM4Player];
    [_engine attachNode:_sM5Player];
    
    [_engine attachNode:_mixerOutputFilePlayer];
    

    
    //new ...
    [_engine attachNode:_pE1Player];
    [_engine attachNode:_pE2Player];
    [_engine attachNode:_pE3Player];
    [_engine attachNode:_tE1Player];
    [_engine attachNode:_tE2Player];
    [_engine attachNode:_tE3Player];
    [_engine attachNode:_tE4Player];
    [_engine attachNode:_tE5Player];
    [_engine attachNode:_tE6Player];
    [_engine attachNode:_tE7Player];

    
    
}

- (void)makeEngineConnections
{
    /*  The engine will construct a singleton main mixer and connect it to the outputNode on demand,
		when this property is first accessed. You can then connect additional nodes to the mixer.
		
		By default, the mixer's output format (sample rate and channel count) will track the format 
		of the output node. You may however make the connection explicitly with a different format. */
    
    // get the engine's optional singleton main mixer node
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    
    // establish a connection between nodes
    
    /*  Nodes have input and output buses (AVAudioNodeBus). Use connect:to:fromBus:toBus:format: to
        establish connections betweeen nodes. Connections are always one-to-one, never one-to-many or
		many-to-one.
	
		Note that any pre-existing connection(s) involving the source's output bus or the
		destination's input bus will be broken.
    
        @method connect:to:fromBus:toBus:format:
        @param node1 the source node
        @param node2 the destination node
        @param bus1 the output bus on the source node
        @param bus2 the input bus on the destination node
        @param format if non-null, the format of the source node's output bus is set to this
            format. In all cases, the format of the destination node's input bus is set to
            match that of the source node's output bus. */
    

    
    [_engine connect:_mM1Player to:mainMixer format:_mM1Buff.format];
    [_engine connect:_mM2Player to:mainMixer format:_mM2Buff.format];
    [_engine connect:_mM3Player to:mainMixer format:_mM3Buff.format];
    [_engine connect:_sM1Player to:mainMixer format:_sM1Buff.format];
    [_engine connect:_sM2Player to:mainMixer format:_sM2Buff.format];
    [_engine connect:_sM3Player to:mainMixer format:_sM3Buff.format];
    [_engine connect:_sM4Player to:mainMixer format:_sM4Buff.format];
    [_engine connect:_sM5Player to:mainMixer format:_sM5Buff.format];
    [_engine connect:_pE1Player to:mainMixer format:_pE1Buff.format];
    [_engine connect:_pE2Player to:mainMixer format:_pE2Buff.format];
    [_engine connect:_pE3Player to:mainMixer format:_pE3Buff.format];
    [_engine connect:_tE1Player to:mainMixer format:_tE1Buff.format];
    [_engine connect:_tE2Player to:mainMixer format:_tE2Buff.format];
    [_engine connect:_tE3Player to:mainMixer format:_tE3Buff.format];
    [_engine connect:_tE4Player to:mainMixer format:_tE4Buff.format];
    [_engine connect:_tE5Player to:mainMixer format:_tE5Buff.format];
    [_engine connect:_tE6Player to:mainMixer format:_tE6Buff.format];
    [_engine connect:_tE7Player to:mainMixer format:_tE7Buff.format];
    
    // node tap player
    [_engine connect:_mixerOutputFilePlayer to:mainMixer format:[mainMixer outputFormatForBus:0]];
}

- (void)startEngine
{
    // start the engine
    
    /*  startAndReturnError: calls prepare if it has not already been called since stop.
	
		Starts the audio hardware via the AVAudioInputNode and/or AVAudioOutputNode instances in
		the engine. Audio begins flowing through the engine.
	
        This method will return YES for sucess.
     
		Reasons for potential failure include:
		
		1. There is problem in the structure of the graph. Input can't be routed to output or to a
			recording tap through converter type nodes.
		2. An AVAudioSession error.
		3. The driver failed to start the hardware. */
    
    NSError *error;
    NSAssert([_engine startAndReturnError:&error], @"couldn't start engine, %@", [error localizedDescription]);
}



//new ...
- (void)toogleMM1
{
    if (!self.mM1isPlaying) {
        [_mM1Player scheduleBuffer:_mM1Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_mM1Player play];
    } else
        [_mM1Player stop];
}

- (void)toogleMM2
{
    if (!self.mM2isPlaying) {
        [_mM2Player scheduleBuffer:_mM2Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_mM2Player play];
    } else
        [_mM2Player stop];
}

- (void)toogleMM3
{
    if (!self.mM3isPlaying) {
        [_mM3Player scheduleBuffer:_mM3Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_mM3Player play];
    } else
        [_mM3Player stop];
}

- (void)toogleSM1
{
    if (!self.sM1isPlaying) {
        [_sM1Player scheduleBuffer:_sM1Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_sM1Player play];
    } else
        [_sM1Player stop];
}

- (void)toogleSM2
{
    if (!self.sM2isPlaying) {
        [_sM2Player scheduleBuffer:_sM2Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_sM2Player play];
    } else
        [_sM2Player stop];
}

- (void)toogleSM3
{
    if (!self.sM3isPlaying) {
        [_sM3Player scheduleBuffer:_sM3Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_sM3Player play];
    } else
        [_sM3Player stop];
}

- (void)toogleSM4
{
    if (!self.sM4isPlaying) {
        [_sM4Player scheduleBuffer:_sM4Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_sM4Player play];
    } else
        [_sM4Player stop];
}

- (void)toogleSM5
{
    if (!self.sM5isPlaying) {
        [_sM5Player scheduleBuffer:_sM5Buff atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        [_sM5Player play];
    } else
        [_sM5Player stop];
}




- (void)pressPE1:(float)volume
{
    [_pE1Player scheduleBuffer:_pE1Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    _pE1Player.volume = volume;
    [_pE1Player play];
}

- (void)pressPE2:(float)volume
{
    [_pE2Player scheduleBuffer:_pE2Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    _pE2Player.volume = volume;
    [_pE2Player play];
}

- (void)pressPE3:(float)volume
{
    [_pE3Player scheduleBuffer:_pE3Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    _pE3Player.volume = volume;
    [_pE3Player play];
}

- (void)touchTE1
{
    [_tE1Player scheduleBuffer:_tE1Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE1Player play];
}

- (void)touchTE2
{
    [_tE2Player scheduleBuffer:_tE2Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE2Player play];
}

- (void)touchTE3
{
    [_tE3Player scheduleBuffer:_tE3Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE3Player play];
}

- (void)touchTE4
{
    [_tE4Player scheduleBuffer:_tE4Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE4Player play];
}

- (void)touchTE5
{
    [_tE5Player scheduleBuffer:_tE5Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE5Player play];
}

- (void)touchTE6
{
    [_tE6Player scheduleBuffer:_tE6Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE6Player play];
}

- (void)touchTE7
{
    [_tE7Player scheduleBuffer:_tE7Buff atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    [_tE7Player play];
}

- (void)startRecordingMixerOutput
{
    // install a tap on the main mixer output bus and write output buffers to file
    
    /*  The method installTapOnBus:bufferSize:format:block: will create a "tap" to record/monitor/observe the output of the node.
	
        @param bus
            the node output bus to which to attach the tap
        @param bufferSize
            the requested size of the incoming buffers. The implementation may choose another size.
        @param format
            If non-nil, attempts to apply this as the format of the specified output bus. This should
            only be done when attaching to an output bus which is not connected to another node; an
            error will result otherwise.
            The tap and connection formats (if non-nil) on the specified bus should be identical. 
            Otherwise, the latter operation will override any previously set format.
            Note that for AVAudioOutputNode, tap format must be specified as nil.
        @param tapBlock
            a block to be called with audio buffers

		Only one tap may be installed on any bus. Taps may be safely installed and removed while
		the engine is running. */
    
    NSError *error;
    if (!_mixerOutputFileURL) _mixerOutputFileURL = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"mixerOutput.caf"]];
    
    AVAudioMixerNode *mainMixer = [_engine mainMixerNode];
    AVAudioFile *mixerOutputFile = [[AVAudioFile alloc] initForWriting:_mixerOutputFileURL settings:[[mainMixer outputFormatForBus:0] settings] error:&error];
    NSAssert(mixerOutputFile != nil, @"mixerOutputFile is nil, %@", [error localizedDescription]);
    
    if (!_engine.isRunning) [self startEngine];
    [mainMixer installTapOnBus:0 bufferSize:4096 format:[mainMixer outputFormatForBus:0] block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        NSError *error;
        
        // as AVAudioPCMBuffer's are delivered this will write sequentially. The buffer's frameLength signifies how much of the buffer is to be written
        // IMPORTANT: The buffer format MUST match the file's processing format which is why outputFormatForBus: was used when creating the AVAudioFile object above
        NSAssert([mixerOutputFile writeFromBuffer:buffer error:&error], @"error writing buffer data to file, %@", [error localizedDescription]);
    }];
    _isRecording = true;
}

- (void)stopRecordingMixerOutput
{
    // stop recording really means remove the tap on the main mixer that was created in startRecordingMixerOutput
    if (_isRecording) {
        [[_engine mainMixerNode] removeTapOnBus:0];
        _isRecording = NO;
    }
}

- (void)playRecordedFile
{
    if (_mixerOutputFilePlayerIsPaused) {
        [_mixerOutputFilePlayer play];
    }
    else {
        if (_mixerOutputFileURL) {
            NSError *error;
            AVAudioFile *recordedFile = [[AVAudioFile alloc] initForReading:_mixerOutputFileURL error:&error];
            NSAssert(recordedFile != nil, @"recordedFile is nil, %@", [error localizedDescription]);
            [_mixerOutputFilePlayer scheduleFile:recordedFile atTime:nil completionHandler:^{
                _mixerOutputFilePlayerIsPaused = NO;
                
                // the data in the file has been scheduled but the player isn't actually done playing yet
                // calculate the approximate time remaining for the player to finish playing and then dispatch the notification to the main thread
                AVAudioTime *playerTime = [_mixerOutputFilePlayer playerTimeForNodeTime:_mixerOutputFilePlayer.lastRenderTime];
                double delayInSecs = (recordedFile.length - playerTime.sampleTime) / recordedFile.processingFormat.sampleRate;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSecs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(mixerOutputFilePlayerHasStopped)])
                        [self.delegate mixerOutputFilePlayerHasStopped];
                    [_mixerOutputFilePlayer stop];
                });
            }];
            [_mixerOutputFilePlayer play];
            _mixerOutputFilePlayerIsPaused = NO;
        }
    }
}

- (void)stopPlayingRecordedFile
{
    [_mixerOutputFilePlayer stop];
    _mixerOutputFilePlayerIsPaused = NO;
}

- (void)pausePlayingRecordedFile
{
    [_mixerOutputFilePlayer pause];
    _mixerOutputFilePlayerIsPaused = YES;
}



//new ...
- (BOOL)isMM1isPlaying
{
    return _mM1Player.isPlaying;
}

- (BOOL)isMM2isPlaying
{
    return _mM2Player.isPlaying;
}

- (BOOL)isMM3isPlaying
{
    return _mM3Player.isPlaying;
}

- (BOOL)isSM1isPlaying
{
    return _sM1Player.isPlaying;
}

- (BOOL)isSM2isPlaying
{
    return _sM2Player.isPlaying;
}

- (BOOL)isSM3isPlaying
{
    return _sM3Player.isPlaying;
}

- (BOOL)isSM4isPlaying
{
    return _sM4Player.isPlaying;
}

- (BOOL)isSM5isPlaying
{
    return _sM5Player.isPlaying;
}



//new ...

- (void)setMM1PlayerVolume:(float)mM1PlayerVolume
{
    _mM1Player.volume = mM1PlayerVolume;
}

- (float)mM1PlayerVolume
{
    return _mM1Player.volume;
}

- (void)setMM2PlayerVolume:(float)mM2PlayerVolume
{
    _mM2Player.volume = mM2PlayerVolume;
}

- (float)mM2PlayerVolume
{
    return _mM2Player.volume;
}

- (void)setMM3PlayerVolume:(float)mM3PlayerVolume
{
    _mM3Player.volume = mM3PlayerVolume;
}

- (float)mM3PlayerVolume
{
    return _mM3Player.volume;
}

- (void)setSM1PlayerVolume:(float)sM1PlayerVolume
{
    _sM1Player.volume = sM1PlayerVolume;
}

- (float)sM1PlayerVolume
{
    return _sM1Player.volume;
}

- (void)setSM2PlayerVolume:(float)sM2PlayerVolume
{
    _sM2Player.volume = sM2PlayerVolume;
}

- (float)sM2PlayerVolume
{
    return _sM2Player.volume;
}

- (void)setSM3PlayerVolume:(float)sM3PlayerVolume
{
    _sM3Player.volume = sM3PlayerVolume;
}

- (float)sM3PlayerVolume
{
    return _sM3Player.volume;
}

- (void)setSM4PlayerVolume:(float)sM4PlayerVolume
{
    _sM4Player.volume = sM4PlayerVolume;
}

- (float)sM4PlayerVolume
{
    return _sM4Player.volume;
}

- (void)setSM5PlayerVolume:(float)sM5PlayerVolume
{
    _sM5Player.volume = sM5PlayerVolume;
}

- (float)sM5PlayerVolume
{
    return _sM5Player.volume;
}


- (void)setOutputVolume:(float)outputVolume
{
    _engine.mainMixerNode.outputVolume = outputVolume;
}

- (float)outputVolume
{
    return _engine.mainMixerNode.outputVolume;
}


//Rotary MM(Music melody)

- (void)rotaryMM:(float)agVal
{
    float rNum = fmodf(agVal, 60.0);
    float playID = floorf(agVal/60.0);
    float percent = (30.0-rNum)/30.0;
    NSLog(@"playID:%f, percent:%f",playID,percent);
    if (playID == 0) {
        [self setSM1PlayerVolume:percent];
        [self setSM2PlayerVolume:0];
        [self setSM3PlayerVolume:0];
        [self setSM4PlayerVolume:0];
        [self setSM5PlayerVolume:0];
    }else if (playID == 1){
        [self setSM1PlayerVolume:0];
        [self setSM2PlayerVolume:percent];
        [self setSM3PlayerVolume:0];
        [self setSM4PlayerVolume:0];
        [self setSM5PlayerVolume:0];
    }else if (playID == 2){
        [self setSM1PlayerVolume:0];
        [self setSM2PlayerVolume:0];
        [self setSM3PlayerVolume:percent];
        [self setSM4PlayerVolume:0];
        [self setSM5PlayerVolume:0];
    }else if (playID == 3){
        [self setSM1PlayerVolume:0];
        [self setSM2PlayerVolume:0];
        [self setSM3PlayerVolume:0];
        [self setSM4PlayerVolume:percent];
        [self setSM5PlayerVolume:0];
    }else if (playID == 4){
        [self setSM1PlayerVolume:0];
        [self setSM2PlayerVolume:0];
        [self setSM3PlayerVolume:0];
        [self setSM4PlayerVolume:0];
        [self setSM5PlayerVolume:percent];
    }else{
        [self setSM1PlayerVolume:0];
        [self setSM2PlayerVolume:0];
        [self setSM3PlayerVolume:0];
        [self setSM4PlayerVolume:0];
        [self setSM5PlayerVolume:0];
    }
}


#pragma mark AVAudioSession

- (void)initAVAudioSession
{
    // For complete details regarding the use of AVAudioSession see the AVAudioSession Programming Guide
    // https://developer.apple.com/library/ios/documentation/Audio/Conceptual/AudioSessionProgrammingGuide/Introduction/Introduction.html
    
    // Configure the audio session
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    NSError *error;
    
    // set the session category
    bool success = [sessionInstance setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (!success) NSLog(@"Error setting AVAudioSession category! %@\n", [error localizedDescription]);
    
    double hwSampleRate = 44100.0;
    success = [sessionInstance setPreferredSampleRate:hwSampleRate error:&error];
    if (!success) NSLog(@"Error setting preferred sample rate! %@\n", [error localizedDescription]);
    
    NSTimeInterval ioBufferDuration = 0.0029;
    success = [sessionInstance setPreferredIOBufferDuration:ioBufferDuration error:&error];
    if (!success) NSLog(@"Error setting preferred io buffer duration! %@\n", [error localizedDescription]);
    
    // add interruption handler
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:sessionInstance];
    
    // we don't do anything special in the route change notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:sessionInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset:)
                                                 name:AVAudioSessionMediaServicesWereResetNotification
                                               object:sessionInstance];
    
    // activate the audio session
    success = [sessionInstance setActive:YES error:&error];
    if (!success) NSLog(@"Error setting session active! %@\n", [error localizedDescription]);
}

- (void)handleInterruption:(NSNotification *)notification
{
    UInt8 theInterruptionType = [[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] intValue];
    
    NSLog(@"Session interrupted > --- %s ---\n", theInterruptionType == AVAudioSessionInterruptionTypeBegan ? "Begin Interruption" : "End Interruption");
    
    if (theInterruptionType == AVAudioSessionInterruptionTypeBegan) {
        // the engine will pause itself
    }
    if (theInterruptionType == AVAudioSessionInterruptionTypeEnded) {
        // make sure to activate the session
        NSError *error;
        bool success = [[AVAudioSession sharedInstance] setActive:YES error:&error];
        if (!success) NSLog(@"AVAudioSession set active failed with error: %@", [error localizedDescription]);
        
        // start the engine once again
        [self startEngine];
    }
}

- (void)handleRouteChange:(NSNotification *)notification
{
    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    
    NSLog(@"Route change:");
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"     NewDeviceAvailable");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"     OldDeviceUnavailable");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"     CategoryChange");
            NSLog(@" New Category: %@", [[AVAudioSession sharedInstance] category]);
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            NSLog(@"     Override");
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            NSLog(@"     WakeFromSleep");
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            NSLog(@"     NoSuitableRouteForCategory");
            break;
        default:
            NSLog(@"     ReasonUnknown");
    }
    
    NSLog(@"Previous route:\n");
    NSLog(@"%@", routeDescription);
}

- (void)handleMediaServicesReset:(NSNotification *)notification
{
    // if we've received this notification, the media server has been reset
    // re-wire all the connections and start the engine
    NSLog(@"Media services have been reset!");
    NSLog(@"Re-wiring connections and starting once again");
    
    [self createEngineAndAttachNodes];
    [self makeEngineConnections];
    [self startEngine];
    
    // post notification
    if ([self.delegate respondsToSelector:@selector(engineConfigurationHasChanged)]) {
        [self.delegate engineConfigurationHasChanged];
    }
}



@end
