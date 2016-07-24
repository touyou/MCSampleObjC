//
//  ViewController.m
//  MCSampleObjC
//
//  Created by 藤井陽介 on 2016/07/24.
//  Copyright © 2016年 touyou. All rights reserved.
//

#import "ViewController.h"

static NSString *const kServiceType = @"LCOC-Chat";

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // セッションの設定
    _mPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    _mSession = [[MCSession alloc] initWithPeer:_mPeerID];
    _mSession.delegate = self;
    // ブラウザの設定
    _mBrowser = [[MCBrowserViewController alloc] initWithServiceType:kServiceType session:_mSession];
    _mBrowser.delegate = self;
    // アシスタントの設定
    _mAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:kServiceType discoveryInfo:nil session:_mSession];
    [_mAssistant start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: 送信
- (IBAction)sendChat:(id)sender {
    NSData *msg = [_messageField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    [_mSession sendData:msg toPeers:_mSession.connectedPeers withMode:MCSessionSendDataUnreliable error:&error];
    if (error != nil) {
        NSLog(@"Error sending data:%@",error.localizedDescription);
    }
    [self updateChat:_messageField.text fromPeer:_mPeerID];
    _messageField.text = @"";
}

// MARK: 更新
- (void)updateChat:(NSString *)text fromPeer:(MCPeerID *)peerID {
    NSString *name;
    if (peerID == _mPeerID) {
        name = @"Me";
    } else {
        name = peerID.displayName;
    }
    NSString *msg = [NSString stringWithFormat:@"%1$@: %2$@\n", name, text];
    _chatView.text = [NSString stringWithFormat:@"%1$@%2$@", _chatView.text, msg];
}

// MARK: ブラウザの表示
- (IBAction)showBrowser:(id)sender {
    [self presentViewController:_mBrowser animated:true completion:nil];
}

// MARK: - MCBrowserViewControllerDelegate
// MARK: 完了が押された時
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissViewControllerAnimated:true completion:nil];
}
// MARK: キャンセルが押された時
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissViewControllerAnimated:true completion:nil];
}

// MARK: - MCSessionDelegate
// MARK: データを受信した時
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    dispatch_sync(dispatch_get_main_queue(), ^(){
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self updateChat:msg fromPeer:peerID];
    });
}

// MARK: データを受信し始めた
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {}

// MARK: データを受信し終わった
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {}

// MARK: ストリームが確立
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {}

// MARK: 他のpeerの状態が変化
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {}
@end
