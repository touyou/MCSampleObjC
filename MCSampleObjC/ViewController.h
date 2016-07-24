//
//  ViewController.h
//  MCSampleObjC
//
//  Created by 藤井陽介 on 2016/07/24.
//  Copyright © 2016年 touyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *chatView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

@property MCPeerID *mPeerID;
@property MCSession *mSession;
@property MCBrowserViewController *mBrowser;
@property MCAdvertiserAssistant *mAssistant;

- (IBAction)sendChat:(id)sender;
- (IBAction)showBrowser:(id)sender;
- (void)updateChat:(NSString*)text fromPeer:(MCPeerID*)peerID;
@end

