//
//  VoiceRecognition.m
//  MoeWordBook
//
//  Created by LiuYuye on 14-2-2.
//
//

#import "TTSOnline.h"
#import "iflyMSC/IFlySpeechError.h"

#import <QuartzCore/QuartzCore.h>

@implementation TTSOnline

@synthesize aTTSText = _aTTSText;
@synthesize className = _className;
/*
_pickerViewArray = [[NSArray alloc] initWithObjects:@"小燕 (中英文普通话)",@"小雨 中英文(普通话)",@"凯瑟琳 英文(青年女声)",
                    @"亨利 英文(青年男声)",@"玛丽 英文(青年女声)",@"小研 中英文(普通话)",@"小琪 中英文(普通话)",@"小峰 中英文(普通话)",@"小梅 中英文(粤语)",
                    @"小莉 中英文(台湾普通话)",@"小蓉 汉语(四川话)",@"小芸 汉语(东北话)",@"小坤 汉语(河南话)",@"小强 汉语(湖南话)",@"小莹 汉语(陕西话)",
                    @"小新 汉语(普通话)",@"楠楠 汉语(普通话)",@"老孙 汉语(普通话)",nil];


_VoiceNamearray = [[NSArray alloc] initWithObjects:@"xiaoyan",@"xiaoyu",@"Catherine",
                   @"henry",@"vimary",@"vixy",@"vixq",@"vixf",@"vixm",
                   @"vixl",@"vixr",@"vixyun",@"vixk",@"vixqa",@"vixying",
                   @"vixx",@"vinn",@"vils",nil];
*/
- (id) initWithLanguage:(NSString* ) language Text:(NSString *)aText;
{
    self.aTTSText = aText;
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID];
    _iFlySpeechSynthesizer = [[IFlySpeechSynthesizer createWithParams:initString delegate:self] retain];
    _iFlySpeechSynthesizer.delegate = self;
    
    // 设置语音合成的参数
    [_iFlySpeechSynthesizer setParameter:@"speed" value:@"50"];//合成的语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"volume" value:@"50"];//合成的音量;取值范围 0~100
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [_iFlySpeechSynthesizer setParameter:@"voice_name" value:language];
    [_iFlySpeechSynthesizer setParameter:@"sample_rate" value:@"8000"];//音频采样率,目前支持的采样率有 16000 和 8000;
    
    [initString release];
    
    return self;
}



- (void) dealloc
{
    
    [_iFlySpeechSynthesizer setDelegate:nil];

    [_iFlySpeechSynthesizer release];
    /*
    [_aTTSText release];
    _aTTSText = nil;
    
    [_className release];
    _className = nil;
    */
    [super dealloc];
    
}

#pragma mark - Button Handler
/*
 * @开始播放
 */
- (void) StartTTS:(id)className
{
    self.className = className;
    _hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    NSLog(@"正在缓冲...");
    _isCancel = NO;
    [_iFlySpeechSynthesizer startSpeaking:self.aTTSText];
}

/*
 * @ 暂停播放
 */
- (void) onPause:(id) sender
{
    if (_hasError) {
        return;
    }
    [_iFlySpeechSynthesizer pauseSpeaking];
}

/*
 * @恢复播放
 */
- (void) onResume:(id) sender
{
    if (_hasError) {
        return;
    }
    [_iFlySpeechSynthesizer resumeSpeaking];
}

/*
 * @取消播放
 */
- (void) onCancel:(id) sender
{
    [_iFlySpeechSynthesizer stopSpeaking];
}

#pragma mark - IFlySpeechSynthesizerDelegate

/**
 * @fn      onSpeakBegin
 * @brief   开始播放
 *
 * @see
 */
- (void) onSpeakBegin
{
    _isCancel = NO;
    NSLog(@"开始播放");
}

/**
 * @fn      onBufferProgress
 * @brief   缓冲进度
 *
 * @param   progress            -[out] 缓冲进度
 * @param   msg                 -[out] 附加信息
 * @see
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"bufferProgress:%d,message:%@",progress,msg);
}

/**
 * @fn      onSpeakProgress
 * @brief   播放进度
 *
 * @param   progress            -[out] 播放进度
 * @see
 */
- (void) onSpeakProgress:(int) progress
{
    NSLog(@"play progress:%d",progress);
}

/**
 * @fn      onSpeakPaused
 * @brief   暂停播放
 *
 * @see
 */
- (void) onSpeakPaused
{
    NSLog(@"播放暂停");
  
}

/**
 * @fn      onSpeakResumed
 * @brief   恢复播放
 *
 * @see
 */
- (void) onSpeakResumed
{
    NSLog(@"播放继续");
}

/**
 * @fn      onCompleted
 * @brief   结束回调
 *
 * @param   error               -[out] 错误对象
 * @see
 */
- (void) onCompleted:(IFlySpeechError *) error
{
    NSString *text ;
    if (_isCancel) {
        
        text = @"合成已取消";
    }
    else if (error.errorCode ==0 ) {
        text = @"合成结束";
        //_resultView.text = _result;
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        _hasError = YES;
        NSLog(@"%@",text);
    }

}


/**
 * @fn      onSpeakCancel
 * @brief   正在取消
 *
 * @see
 */
- (void) onSpeakCancel
{
    if (_isViewDidDisappear) {
        return;
    }
    _isCancel = YES;
    NSLog(@"正在取消...");
}

@end