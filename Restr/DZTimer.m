//
//  DZTimer.m
//  TimerDemo
//
//  Created by Dima Zudochkin on 18/11/13.
//  Copyright (c) 2013 Dmitry Zudochkin. All rights reserved.
//

#import "DZTimer.h"
#import "DZWindowController.h"

@implementation DZTimer

@synthesize window;
@synthesize wc;

+ (DZTimer *)sharedInstance
{
    static DZTimer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"DZTimer initialization");
        sharedInstance = [[DZTimer alloc] init];
        sharedInstance->settings = [Settings sharedInstance];
        // Do any other initialisation stuff here
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSLog(@"Settings was loaded");
    }
    
    return self;
}

- (void)restartTimer
{
    NSLog(@"Timer was restarted!");
    if (currentTimer) {
        [currentTimer invalidate];
        currentTimer = nil;
    }
    
    [settings sync];
    
    NSLog(@"settings shortBreaksEveryValues = %@", [settings shortBreaksEveryValues][[settings shortBreaksEveryValue]]);
    shortBreaksEveryValue = [[settings shortBreaksEveryValues][[settings shortBreaksEveryValue]] intValue];// * 60 for minutes;
    shortBreaksForValue = [[settings shortBreaksForValues][[settings shortBreaksForValue]] intValue];
    
    
    NSLog(@"everyValue = %ld, forValue = %ld", (long)shortBreaksEveryValue, (long)shortBreaksForValue);
    [self startFirstTimer];
}

- (void)startFirstTimer
{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:shortBreaksEveryValue target:self selector:@selector(stopFirstTimer) userInfo:nil repeats:NO];
}

- (void)startSecondTimer
{
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:shortBreaksForValue target:self selector:@selector(stopSecondTimer) userInfo:nil repeats:NO];
}

- (void)stopFirstTimer
{
    NSLog(@"begin showing message");
    wc = [[DZWindowController alloc] initWithWindowNibName:@"DZWindowController"];
    
    [wc showWindow:self];
    
    [self startSecondTimer];
}

- (void)stopSecondTimer
{
    [wc close];
    NSLog(@"stop showing message");
    [self startFirstTimer];
}
@end
