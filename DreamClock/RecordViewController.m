//
//  RecordViewController.h
//  DreamClock
//
//  Created by Thomas Thornton on 12/1/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import "RecordViewController.h"
#import "DreamStore.h"
#import "Dream.h"

@interface RecordViewController () {
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    NSDate *lastDate;
    
}

@end


@implementation RecordViewController

@synthesize recordButton, stopButton, playButton;

- (IBAction)recordTapped:(id)sender {
    
    // Removeable: Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {
        
        //NSLog(@"recorder url %@", recorder.url);

        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        
        if (recorder.recording) {
            NSLog(@"recorder is recording");
        }
        
        [recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        // Keeping track of record time
        lastDate = [[NSDate alloc]init];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
        
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
    
}

- (IBAction)stopTapped:(id)sender {
    
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name your dream"
                                                    message:@"  "
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = @"Untitled Dream";
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *name = [alertView textFieldAtIndex:0].text;
    
    AVURLAsset *thisasset = [AVURLAsset assetWithURL:recorder.url];
    
    [[DreamStore sharedStore]createDreamWithName:name duration:[NSNumber numberWithDouble:CMTimeGetSeconds(thisasset.duration)] audioData:[NSData dataWithContentsOfURL:recorder.url]];
    
}

- (IBAction)playTapped:(id)sender {
    
    if (!recorder.recording) {
        
        //NSLog(@"play tapped, recorder not recording, url is %@", recorder.url);
        
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:recorder.url error:nil];
        
        [player setDelegate:self];
        [player prepareToPlay];
        [player play];
        
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Disable Stop/Play button
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject], @"newDream.aac", nil];
    
    NSURL *outputFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVEncoderBitRateKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc]initWithURL:outputFileUrl settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    
    
    
    
    // DO NOT SET UP ANOTHER AUDIO SESSION : Set up the audio session
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"will dissapear recording view");
    
    if (recorder.recording) {
        [recorder stop];
        
        AVURLAsset *thisasset = [AVURLAsset assetWithURL:recorder.url];
        
        [[DreamStore sharedStore]createDreamWithName:@"Untitled Dream" duration:[NSNumber numberWithDouble:CMTimeGetSeconds(thisasset.duration)] audioData:[NSData dataWithContentsOfURL:recorder.url]];
        
    } else if (player.playing) {
        
        [player stop];
        
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [super viewWillDisappear:YES];

    
    
    
    //    recorder = nil;
    //    player = nil;
    
    //    [recordButton setEnabled:YES];
    //    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    //
    //    [stopButton setEnabled:NO];
    //    [playButton setEnabled:NO];
    
//    NSLog(@"is it here");
//    BOOL success = [audioSession setActive:NO error:nil];
//    NSLog(success ? @"Success!" : @"Not a sucess!");
    
}

@end
