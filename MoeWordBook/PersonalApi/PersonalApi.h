//
//  PersonalApi.h
//  iword
//
//  Created by crysnova 01 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AppDelegate.h"

@interface PersonalApi : NSObject

//jesson  添加按钮
+(CCMenuItemSprite *)addButton:(NSString *)Nimage andHimage:(NSString*)Himage Sel:(SEL)fun Target:(id)target Position:(CGPoint)p Tag:(int)btntag;

+(void)unitMenuButton:(NSString *)Nimage andHimage:(NSString *)Himage Sel:(SEL)fun Target:(id)target Position:(CGPoint)p Tag:(int)btntag;

+(AppController *)getAppInstance;

//----------
//创建一个cocos2d的按钮
+(CCMenuItemSprite *)loadButton:(NSString *)image1 otherImage:(NSString *)image2 Sel:(SEL)fun target:(id)aTarget;//制作一个button

+(CCSprite *)addSprite:(NSString *)Image Position:(CGPoint)p Target:(id)object;//加载一个精灵到屏幕

+(CCMenuItemSprite *)addCCButton:(NSString *)image1 Image:(NSString *)image2 Sel:(SEL)fun FunTarget:(id)target1 AddTarget:(id)target2 Position:(CGPoint)p AddArray:(NSMutableArray *)array;//制作button

+(CCMenuItemSprite *)addCCButton:(NSString *)image Sel:(SEL)fun Menu:(CCMenu *)menu Position:(CGPoint)p ResArr:(NSMutableArray *)ResArr;//制作button(推荐)

+(id)addSpriteButton:(CGPoint)aPosition TextureName:(NSString *)textureName Target:(id)aTarget Menu:(CCMenu *)menu ResArr:(NSMutableArray *)resArray Fun:(SEL)fun Return:(int)spriteOrButton;//做一个带button的Sprite spriteOrButton的0返回sprite而1返回button

+(NSMutableArray *)addSpriteButton:(CGPoint)aPosition TextureName:(NSString *)textureName Menu:(CCMenu *)menu ResArr:(NSMutableArray *)resArray Fun:(SEL)fun;//做一个带button的Sprite spriteOrButton的0返回sprite而1返回button






/////////////////////////添加batchNode////////////////////////////////////////////////////////////////////////////////////////////////////
+(CCSpriteBatchNode *)addBatchNode:(NSString *)image Plist:(NSString *)name AddTarget:(id)target;//添加batchNode到缓存（分开plist和图片命名的）

+(CCSpriteBatchNode *)addBatchNode:(NSString *)imageAndPlistName AddTarget:(id)target; //添加batchNode到缓存（推荐）






///////////////////////////精灵的Image传递////////////////////////////////////////////////////////////////////////////////////////////////////////////
+(CCSprite *)sendTextureImage:(CCSprite *)sprite1 To:(CCSprite *)sprite2 Target:(id)target;//让一个精灵显示另外一个精灵的图片view1.image = view2.image 

+(void)spriteChangeTexture:(NSString *)textureName For:(CCSprite *)aSprite; //  改变sprite的名字

+(CCSprite *)sendTextureImageTo:(CCSprite *)sprite1;//以一个精灵来初始化另外一个精灵

+(CCSprite *)sendC2DButtonImage:(CCMenuItemSprite *)itemSprite To:(CCSprite *)sprite;//把一个button的image提取出来给一个精灵




///////////////////////////UI控件和cocos2dtexture之间转换/////////////////////////////////////////////////////////////////////////////////
//与Ui控件做交互
+(UIImage *) convertSpriteToImage:(CCSprite *)sprite; //sprite转image


+(CCSprite *) convertImageToSprite:(UIImage *) image; //iamge转sprite





////////////////////////////播放背景音乐音效////////////////////////////////////////////////////////////////////////////////////////////////////////////
//音频（不推荐）
+(void)playBackSound:(NSString *)soundName;

+(void)playSoundEffect:(NSString *)effectName;





/////////////////////////随机变量范围获取////////////////////////////////////////////////////////////////////////////////////////////////////////////
//随机变量范围获取
+(NSMutableArray *)var:(float)numbers Range:(NSRange)aRange;






///////////////////////播放动画序列帧////////////////////////////////////////////////////////////////////////////////////////////////////////////
//检测序列帧有多少
+(int)getSequenceFrameNum:(NSString *)firstFrameName;
//播放序列动画//次数等于－1的时候为无限循环

+(void)playSequenceFrame:(NSString *)firstFrameName Times:(int)times Delay:(float)delay Sprite:(CCSprite *)aSprite ToHead:(BOOL)ToHead;//toHead是否回到第一帧

//逆着播动画
+(void)playSequenceFrameInverse:(NSString *)firstFrameName Times:(int)times Delay:(float)delay Sprite:(CCSprite *)aSprite ToHead:(BOOL)ToHead;


+(void)ChangeSize:(id)animaObj Scale:(float)s Delay:(ccTime)t Repeat:(BOOL)repeat;//扩大缩小动画


+(void)ChangeColor:(id)animaObj ToColor:(ccColor3B)c Delay:(ccTime)t Repeat:(BOOL)repeat;//改变颜色

+(void)Move:(id)animaObj Position:(CGPoint)p Delay:(ccTime)t Target:(id)aTarget;//移动动画




//////////////////////////根据一个精灵的大小，设定一个他的可交互区域后面的changeRect中的四个数字分别代表要加或者减少多少交互区域////////////////////////////////////////////////////
//根据一个精灵的大小，设定一个他的可交互区域后面的changeRect中的四个数字分别代表要加或者减少多少交互区域
+(CGRect)creatNewRect:(CCSprite *)aSprite ChangeNum:(CGRect)changeRect;




//////////////////数组传递CGPoint和接受////////////////////////////////////////////////////////////////////////////////////////////////////////

+(NSMutableArray *)pointToArray:(NSMutableArray *)pointArray Point:(CGPoint )aPoint;

+(CGPoint)getPoint:(NSMutableArray *)pointArray Index:(int)indexNum;

//////////////////粒子效果////////////////////////////////////////////////////////////////////////////////////////////////////////
+(void)particle_Over:(NSString *)particleName Target:(CCMenuItemSprite *)aTarget;//粒子特效

+(void)CreateFolderToSandBox:(NSString *) folderName;

+(void)writeFileToSandBox:(NSString *) fileName Data:(NSData *)aData FolderName:(NSString *) folderName;

+(BOOL)isExistFileInSandBox:(NSString *) fileName FolderName:(NSString *) folderName;

+(BOOL)isConnectionAvailable;

+(NSString*)currntNetworkType;

@end
