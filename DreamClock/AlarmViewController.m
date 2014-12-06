//
//  FirstViewController.m
//  DreamClock
//
//  Created by Thomas Thornton on 12/1/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController () {
    
    AVAudioPlayer *player;
    
}

@end


@implementation AlarmViewController

@synthesize setAlarmsButton, cancelAlarmsButton, previewButton1, previewButton2;

- (IBAction)setAlarms:(id)sender {
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
        
        NSDate *date = self.datePicker.date;
        
        // Zero out seconds for the notification alert time
        NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
        NSDate *zeroDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
        
        if ([zeroDate timeIntervalSinceNow] < 0.0) {
            
            // Make alarm tomorrow, if the alarm is in the past for the current day
            int daysToAdd = 1;
            NSDate *addedDate = [zeroDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            zeroDate = addedDate;
            
        }
       
        NSDate *finalDate = zeroDate;
        
        // Create and schedule the two wake up phase notifications
        
        UILocalNotification *reflectNotif = [[UILocalNotification alloc]init];
        
        reflectNotif.fireDate = [finalDate dateByAddingTimeInterval:-60*3];
        reflectNotif.alertBody = @"Wake Up Phase 1: Dream Reflection";
        reflectNotif.timeZone = [NSTimeZone defaultTimeZone];
        reflectNotif.soundName = @"alarmSound1.caf";
        
        UILocalNotification *recordNotif = [[UILocalNotification alloc]init];
        
        recordNotif.fireDate = finalDate;
        recordNotif.alertBody = @"Wake Up Phase 2: Dream Recording";
        recordNotif.timeZone = [NSTimeZone defaultTimeZone];
        recordNotif.soundName = @"alarmSound1.caf";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:reflectNotif];
        [[UIApplication sharedApplication] scheduleLocalNotification:recordNotif];
        
        
        //format for printing
        NSString *dateString = [NSDateFormatter localizedStringFromDate:finalDate
         dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
         NSString *dateString2 = [NSDateFormatter localizedStringFromDate:[finalDate dateByAddingTimeInterval:-60*3]
         dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
         NSLog(@"%@, %@",dateString, dateString2);
        
        [setAlarmsButton setEnabled:NO];
        [cancelAlarmsButton setEnabled:YES];
        
    }
}

- (IBAction)cancelAlarms:(id)sender {
    
    // Cancel any previous alarms
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    [setAlarmsButton setEnabled:YES];
    [cancelAlarmsButton setEnabled:NO];
    
}

- (IBAction)previewAlarm1:(id)sender {
    
    if (!player.playing) {
        
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/alarmSound1.caf", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        
        // Create audio player object and initialize with URL to sound
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        
        [player setDelegate:self];
        [player play];
        
        [previewButton1 setTitle:@"Stop" forState:UIControlStateNormal];
        [previewButton2 setEnabled:NO];
        
    } else {
        
        [player stop];
        [previewButton1 setTitle:@"Preview" forState:UIControlStateNormal];
        [previewButton2 setEnabled:YES];
        
    }
    
}

- (IBAction)previewAlarm2:(id)sender {
    
    if (!player.playing) {
        
        // Construct URL to sound file
        NSString *path = [NSString stringWithFormat:@"%@/alarmSound2.caf", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        
        // Create audio player object and initialize with URL to sound
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        
        [player setDelegate:self];
        [player play];
        
        [previewButton2 setTitle:@"Stop" forState:UIControlStateNormal];
        [previewButton1 setEnabled:NO];
        
    } else {
        
        [player stop];
        [previewButton2 setTitle:@"Preview" forState:UIControlStateNormal];
        [previewButton1 setEnabled:YES];
        
    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [previewButton1 setEnabled:YES];
    [previewButton2 setEnabled:YES];
    
}

- (IBAction)helpTapped:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DreamClock"
                                                    message:@"DreamClock works with two phases of alarms. \n\nWake Up Phase 1 - Dream Reflection:  While laying in bed, listen to the spoken instructions. Think back and become aware of the dreams that filled your mind while you slept.\n\nWake Up Phase 2 - Dream Recording: Unlock your iPhone, tap record, and talk about the dreams you rememered. Closing your eyes while speaking can help with dream recollection."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"view will apear");
    
    if ([[[UIApplication sharedApplication]scheduledLocalNotifications]count] == 0) {
        
        [setAlarmsButton setEnabled:YES];
        [cancelAlarmsButton setEnabled:NO];
        
    } else {
        
        [setAlarmsButton setEnabled:NO];
        [cancelAlarmsButton setEnabled:YES];
        
    }
    
    [super viewWillAppear:animated];
    
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    
    [previewButton1 setEnabled:YES];
    [previewButton2 setEnabled:YES];
    [previewButton1 setTitle:@"Preview" forState:UIControlStateNormal];
    [previewButton2 setTitle:@"Preview" forState:UIControlStateNormal];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"view will dissapear");
    
    [super viewWillDisappear:YES];
    
    if (player.playing) {
        
        [player stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
    }
}

@end
