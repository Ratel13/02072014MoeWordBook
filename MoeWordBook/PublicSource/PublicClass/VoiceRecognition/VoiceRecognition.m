//
//  VoiceRecognition.m
//  MoeWordBook
//
//  Created by LiuYuye on 14-2-2.
//
//

#import "VoiceRecognition.h"

#import <QuartzCore/QuartzCore.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "Definition.h"
#import "iflyMSC/IFlyUserWords.h"
#import "RecognizerFactory.h"

@implementation VoiceRecognition

static NSString * _grammerId;

-(void) setGrammerId:(NSString*) id
{
    [_grammerId release];
    _grammerId = [id retain];
    [_iFlySpeechRecognizer setParameter:@"grammarID" value:_grammerId];
}

- (id) init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    // 创建识别对象
    _iFlySpeechRecognizer = [[RecognizerFactory CreateRecognizer:self Domain:@"sms"] retain];
    _uploader = [[IFlyDataUploader alloc] initWithDelegate:nil pwd:nil params:nil delegate:self];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [self didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    if(![Login isLogin])
    {
        [_login Login];
    }
    [self viewDidLoad];
}


- (void)viewDidUnload
{
    [self viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
    [_uploader setDelegate:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer release];
    [_domain release];
    
    [_uploader release];
    [_result release];
    [super dealloc];
}

#pragma mark - Button Handler
/*
 * @开始录音
 */
- (void) StartRecognition:(id)className
{
    _className = className;
    bool ret = [_iFlySpeechRecognizer startListening];
    if (ret) {
        _isCancel = NO;
    }
    else
    {
        NSLog(@"启动识别服务失败，请稍后重试");
        /***
         [_popUpView setText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束
         [self.view addSubview:_popUpView];
         ***/
    }
    
}

-(void) startListening
{
    [_iFlySpeechRecognizer startListening];
}

/*
 * @ 暂停录音
 */
- (void) onBtnStop:(id) sender
{
    [_iFlySpeechRecognizer stopListening];
}


/*
 * @取消识别
 */
- (void) onBtnCancel:(id) sender
{
    _isCancel = YES;
    [_iFlySpeechRecognizer cancel];
}

-(void) onUploadContact:(id)sender
{
    [_iFlySpeechRecognizer stopListening];
    // 获取联系人
    IFlyContact *iFlyContact = [[IFlyContact alloc] init];
    NSString *contact = [iFlyContact contact];
#define CONTACT @"subject=uup,dtt=contact"
    [self showPopup];
    [iFlyContact release];
    
}

- (void) onUploadUserWord:(id)sender
{
    [_iFlySpeechRecognizer stopListening];
#define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"德国盐猪手\",\"1912酒吧街\",\"清蒸鲈鱼\",\"挪威三文鱼\",\"黄埔军校\",\"横沙牌坊\",\"科大讯飞\"]}]}"
    
#define PARAMS @"sub=iat,dtt=userword"
#define NAME @"userwords"
    [self showPopup];
    IFlyUserWords *iFlyUserWords = [[[IFlyUserWords alloc] initWithJson:USERWORDS]autorelease];
    [_uploader uploadData:NAME params:PARAMS data:[iFlyUserWords toString]];
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    if (_isCancel) {
        /***[_popUpView removeFromSuperview];***/
        return;
    }
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    NSLog(@"%@",vol);
    /***[_popUpView setText: vol];***/
    /***[self.view addSubview:_popUpView];***/
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    NSLog(@"正在录音");
    /***[_popUpView setText: @"正在录音"];
     
     [self.view addSubview:_popUpView];***/
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    NSLog(@"停止录音");
    /***
     [_popUpView setText: @"停止录音"];
     [self.view addSubview:_popUpView];
     ***/
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    if (_isCancel) {
        text = @"识别取消";
    }
    else if (error.errorCode ==0 ) {
        if (_result.length==0) {
            text = @"无识别结果";
        }
        else
        {
            text = @"识别成功";
        }
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    /***
     [_popUpView setText: text];
     [self.view addSubview:_popUpView];
     ***/
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    [_className recogniztionResult:result];
    NSLog(@"转写结果：%@",result);
    _result = [result retain];
    [self performSelector:@selector(StartRecognition:) withObject:_className afterDelay:0.1];
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    NSLog(@"识别取消");
}

-(void) showPopup
{
    NSLog(@"正在上传...");
    /***
     [_popUpView setText: @"正在上传..."];
     [self.view addSubview:_popUpView];***/
}

#pragma mark - IFlyDataUploaderDelegate
- (void) onEnd:(IFlyDataUploader*) uploader grammerID:(NSString *)grammerID error:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if (![error errorCode]) {
        NSLog(@"上传成功");
        /***
         [_popUpView setText: @"上传成功"];
         [self.view addSubview:_popUpView];***/
    }
    else {
        NSLog(@"上传失败");
        /***
         [_popUpView setText: @"上传失败"];
         [self.view addSubview:_popUpView];***/
        
    }
    [self setGrammerId:grammerID];
    
}

@end