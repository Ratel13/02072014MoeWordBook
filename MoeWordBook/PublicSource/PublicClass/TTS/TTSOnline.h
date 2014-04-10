//
//  VoiceRecognition.h
//  MoeWordBook
//
//  Created by LiuYuye on 14-2-2.
//
//

#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "Definition.h"


@interface TTSOnline : NSObject<IFlySpeechSynthesizerDelegate>
{
    IFlySpeechSynthesizer       * _iFlySpeechSynthesizer;
    
    bool                          _isSpeakStarted;
    bool                          _isViewDidDisappear;
    bool                          _hasError;
    bool                          _isCancel;
    
    NSString                    * _aTTSText;
    id                            _className;
}

@property(nonatomic,retain)NSString                    * aTTSText;
@property(nonatomic,retain)id                          className;

- (id) initWithLanguage:(NSString* ) language Text:(NSString *)aText;
- (void) StartTTS:(id)className;
@end
