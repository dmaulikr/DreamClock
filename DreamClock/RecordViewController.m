//
//  SecondViewController.m
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
    NSTimeInterval thisDuration;
    
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
        
        NSLog(@"recorder url %@", recorder.url);

        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [recordButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        // Keeping track of record time
        lastDate = [[NSDate alloc]init];
        
    } else {
        
        // Pause recording
        [recorder pause];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
        
        // Keeping track of record time
        thisDuration = thisDuration - [lastDate timeIntervalSinceNow];
        NSLog(@"%f", thisDuration);
        
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
    
}

- (IBAction)stopTapped:(id)sender {
    
    if (recorder.recording) {
        
        // Keeping track of record time
        thisDuration = thisDuration - [lastDate timeIntervalSinceNow];
        NSLog(@"%f", thisDuration);
        
    }
    
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
    
    [[DreamStore sharedStore]createDreamWithName:name duration:[NSNumber numberWithDouble:thisDuration] audioData:[NSData dataWithContentsOfURL:recorder.url]];
    
    thisDuration = 0.0;

}

- (IBAction)playTapped:(id)sender {
    
    if (!recorder.recording) {
        
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //Disable Stop/Play button
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject], @"newDream.aac", nil];
    
    NSURL *outputFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Set up the audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc]initWithURL:outputFileUrl settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if (recorder.recording) {
        thisDuration = thisDuration - [lastDate timeIntervalSinceNow];
        
        [recorder stop];
        
        [[DreamStore sharedStore]createDreamWithName:@"Untitled Dream" duration:[NSNumber numberWithDouble:thisDuration] audioData:[NSData dataWithContentsOfURL:recorder.url]];

        thisDuration = 0.0;
        
    } else if (player.playing) {
        
        [player stop];
        
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    [super viewWillDisappear:YES];
    
}

@end
