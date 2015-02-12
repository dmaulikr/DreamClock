//
//  ThirdViewController.m
//  DreamClock
//
//  Created by Thomas Thornton on 12/1/14.
//  Copyright (c) 2014 ThomasApps. All rights reserved.
//

#import "DreamsTableViewController.h"
#import "Dream.h"
#import "DreamStore.h"

@interface DreamsTableViewController () {
    
    AVAudioPlayer *player;
    NSIndexPath *dreamIndexPath;
    BOOL beenSelected;

}

@end


@implementation DreamsTableViewController

@synthesize playButton, editButton;

-(IBAction)playTapped:(id)sender{
    
    if (beenSelected == true) {
        
        if (!player.playing) {
            
            NSArray *dreams = [[DreamStore sharedStore]allDreams];
            Dream *dream = dreams[dreamIndexPath.row];
            
            player = [[AVAudioPlayer alloc]initWithData:dream.audioData error:nil];
            
            [player setDelegate:self];
            [player play];
            
            [playButton setTitle:@"Stop" forState:UIControlStateNormal];

        } else {
            
            [player stop];
            
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setActive:NO error:nil];
            
            [playButton setTitle:@"Play" forState:UIControlStateNormal];
            
        }
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setActive:NO error:nil];
    //
    
}

-(IBAction)editTapped:(id)sender {
    NSArray *dreams = [[DreamStore sharedStore]allDreams];
    Dream *dream = dreams[dreamIndexPath.row];
    
    if (beenSelected) {
    
        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle:@"Rename your dream"
                                                    message:@"  "
                                                    delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.text = dream.name;
        [textField selectAll:textField.text];
        [alert show];
    
    }
}

- (IBAction)deleteTapped:(id)sender {
    
    if (beenSelected) {
    
    UIAlertView *alert = [[UIAlertView alloc]   initWithTitle:@"Confirm deletion of dream"
                                                      message:@"  "
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertActionStyleDefault;
    [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSArray *dreams = [[DreamStore sharedStore]allDreams];
    Dream *dream = dreams[dreamIndexPath.row];
    
    if ([alertView.title isEqualToString:@"Rename your dream"]) {
        
        NSString *name = [alertView textFieldAtIndex:0].text;
        
        if (!([name isEqualToString:@""] || buttonIndex != 1)) {
            
            dream.name = name;
            
            [self.tableView reloadData];
        }

    } else {
        
        if (buttonIndex == 1) {
            
            NSLog(@"deleting it %@", dream.name);
            
            [[DreamStore sharedStore]removeDream:dream];
            
            [self.tableView reloadData];
            
        } else {
            
            NSLog(@"NOT deleting it %@", dream.name);
        }
        
    }
    
    //beenSelected = false;
}


- (instancetype)init {
    
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
    
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[DreamStore sharedStore]allDreams]count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create instance of UITableViewCell with default
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    
    //Set text to name
    NSArray *dreams = [[DreamStore sharedStore]allDreams];
    Dream *dream = dreams[indexPath.row];
    
    cell.textLabel.text = [dream name];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:dream.dateCreated
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    NSInteger durationInteger = [dream.duration integerValue];

    //    NSInteger durationInteger = (NSInteger)(dream.audioData.length / 100.0)/(140.0);
  //  NSInteger durationInteger = (NSInteger)(dream.audioData.length / 13702.0);
//    NSLog(@"dream data %@ %1d %f %f", dream.name, (long)dream.audioData.length, dream.audioData.length / 100.0, (dream.audioData.length / 100.0)/(140.0) );
    
    NSInteger seconds = durationInteger % 60;
    NSInteger minutes = (durationInteger / 60) % 60;
    NSInteger hours = (durationInteger / 3600);
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    
//    NSLog(@"duration string: %@", durationString);
    
    NSMutableString *subtitleMutableString = [[NSMutableString alloc]init];
    [subtitleMutableString appendString:dateString];
    [subtitleMutableString appendString:@", "];
    [subtitleMutableString appendString:durationString];
    
    cell.detailTextLabel.text = subtitleMutableString;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!beenSelected) {
        beenSelected = true;
    }
    
    dreamIndexPath = indexPath;
    
    [self playTapped:nil];
    
    
//    NSArray *dreams = [[DreamStore sharedStore]allDreams];
//    Dream *dream = dreams[dreamIndexPath.row];
    
//    if (player.playing) {
//        
//        [player stop];
//        
//    } else {
//        
//        player = [[AVAudioPlayer alloc]initWithData:dream.audioData error:nil];
//        [player setDelegate:self];
//        [player play];
//        
//    }
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    beenSelected = false;
    
    
    
    
    //NSLog(@"loaded for dreams");
    
    //NSLog(@"files contents:");
    //NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // create directory named "test"
    //[[NSFileManager defaultManager] createDirectoryAtPath:[documentDirPath stringByAppendingPathComponent:@"test"] withIntermediateDirectories:YES attributes:nil error:nil];
    // retrieved all directories
    //NSLog(@"%@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirPath error:nil]);
    
    // Set the audio file
    //NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject], @"My.m4a", nil];
    //NSURL *outputFileUrl = [NSURL fileURLWithPathComponents:pathComponents];
    
    // DO NOT SET UP ANOTHER AUDIO SESSION :  Set up the audio session
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    if (player.playing) {
        
        [player stop];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
    }
    
    beenSelected = false;
    
    //    player = nil;
    
}

@end
