//
//  HJPlayerView.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/11/9.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJPlayerView.h"

@implementation HJPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    [layer setVideoGravity: AVLayerVideoGravityResize];
    return [layer player];
}

- (void)setPlayer:(AVPlayer *)player {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
    [layer setVideoGravity: AVLayerVideoGravityResize];
    [layer setPlayer:player];
}

@end
