//
//  VideoTableViewCell.m
//  Demo
//
//  Created by ruanqiaohua on 16/6/14.
//  Copyright © 2016年 ruanqiaohua. All rights reserved.
//

#import "VideoTableViewCell.h"
#import <AVKit/AVKit.h>

@interface VideoTableViewCell ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, copy) void(^playingCb)();
@end

@implementation VideoTableViewCell

- (void)loadVideoWithUrlString:(NSString *)urlString Cb:(void (^)())cb {
    
    NSURL *sourceMovieURL = [NSURL URLWithString:urlString];
    
    AVAsset *movieAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    CGFloat width = Screen_W-16;
    _playerLayer.frame = CGRectMake(0, 0, width, width/16*9);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_playerView.layer addSublayer:_playerLayer];
    [_player seekToDate:[NSDate date]];
    
    if (cb) {
        _playingCb = cb;
    }
}

- (void)pausePlayer {
    
    if (_player) {
        [_player pause];
        [_playBtn setHidden:NO];
    }
}

- (void)stopPlayer {
    
    if (_player) {
        [_player pause];
        _player = nil;
    }
    if (_playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    [_playBtn setHidden:NO];
}

- (IBAction)playBtnAction:(UIButton *)sender {
    [_player play];
    [sender setHidden:YES];
    if (_playingCb) {
        _playingCb();
    }
}

@end
