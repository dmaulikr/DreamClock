//
//  FirstViewController.h
//  DreamClock
//
//  Created by Thomas Thornton on 12/1/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AlarmViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *setAlarmsButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelAlarmsButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton1;
@property (weak, nonatomic) IBOutlet UIButton *previewButton2;


- (IBAction)setAlarms:(id)sender;
- (IBAction)cancelAlarms:(id)sender;
- (IBAction)previewAlarm1:(id)sender;
- (IBAction)previewAlarm2:(id)sender;
- (IBAction)helpTapped:(id)sender;

@end