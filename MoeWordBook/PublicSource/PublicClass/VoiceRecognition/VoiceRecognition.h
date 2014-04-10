//
//  VoiceRecognition.h
//  MoeWordBook
//
//  Created by LiuYuye on 14-2-2.
//
//
#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "Login.h"
@interface VoiceRecognition : NSObject<IFlySpeechRecognizerDelegate,IFlyDataUploaderDelegate>
{
    IFlySpeechRecognizer    * _iFlySpeechRecognizer;
    NSString                * _domain;
    bool                      _isCancel;
    IFlyDataUploader        * _uploader;
    NSString                * _result;
    Login                   * _login;
    
    id                        _className;
}
-(void) setGrammerId:(NSString*) id;
- (void) StartRecognition:(id)className;
-(void)recogniztionResult:(NSString *)resultStr;
@end
