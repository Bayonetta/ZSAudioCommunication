##ZSAudioCommunication


由于google与apple互掐，所以很难找到通用的音频格式。

amr是android的默认录音格式，本身体积小，适合移动通讯，ios4.0以后由于apple不再支持amr文件的播放，所以本工程引入了开源库`libopencore-armnb`，进行wav到amr的格式转换。

本工程是对`TheAmazingAudioEngine`音频处理引擎的再次封装，使用便捷。


####WLAAudioController

* 使用`sharedInstance`来返回AEAudioController单例，用来初始化WLAPlayer, WLRecorder。

* 提供麦克风权限检测


####WLAPLayer


```c

@property (nonatomic, copy) NSString *audioFileName;

@property (nonatomic, copy) NSString *documentPath;

@property (nonatomic, copy) void(^playCompletionBlock)();

-(instancetype) initWithAudioController:(AEAudioController *)audioController;
   
-(void) playBegin;

-(void) playStop;

```

在`playCompletionBlock`中设置播放完毕后的操作，通常进行UI的更改


####WLARecorder

```objective-c

@property (nonatomic, copy) NSString *audioFileName;

@property (nonatomic, copy) NSString *documentPath;

- (instancetype)initWithAudioController:(AEAudioController *)audioController;

-(void)recordBegin;

-(void)recordEnd;

- (void)recordStop;

```