##ZSAudioCommunication

本工程是对[TheAmazingAudioEngine](http://theamazingaudioengine.com/)音频处理引擎的再次封装，使用便捷。

由于Google与Apple常年互掐，所以很难找到通用的音频格式。

amr是Android的默认录音格式，本身体积小，适合移动通讯，由于iOS4.0以后由于Apple不再支持amr文件的播放，所以本工程引入了开源库`libopencore-armnb`，进行wav到amr的格式转换。

##使用

![](https://github.com/Bayonetta/ZSAudioCommunication/blob/master/art/audio1.png?raw=true)
![](https://github.com/Bayonetta/ZSAudioCommunication/blob/master/art/audio2.png?raw=true)
![](https://github.com/Bayonetta/ZSAudioCommunication/blob/master/art/audio3.png?raw=true)

####WLAAudioController

* 使用`sharedInstance`来返回AEAudioController单例，用来初始化WLAPlayer, WLRecorder。

* 提供麦克风权限检测


####WLAPLayer


```objective-c

@property (nonatomic, copy) NSString *audioFileName;

@property (nonatomic, copy) NSString *documentPath;

@property (nonatomic, copy) void(^playCompletionBlock)();

- (instancetype) initWithAudioController:(AEAudioController *)audioController;
   
- (void) playBegin;

- (void) playStop;

```

在`playCompletionBlock`中设置播放完毕后的操作，通常进行UI的更改


####WLARecorderPressView
 
 * 已将recorder封装，通过longPress触发录音操作。
 
 * 设置delegate，开放`pressBegan`、`pressMove`、`pressEnd`接口，进行ui定制
 
 * 初始化时需调用`setup:(UIView *)parentView`
 
 
 
####WLAFormatConverter
 
```objective-c
+ (BOOL)convertWaveToAmr:(NSString *)wavePath AmrFilePath:(NSString *)amrPath;

+ (BOOL)convertAmrToWave:(NSString *)amrPath WaveFilePath:(NSString *)wavePath;
```


对应amr与wav音频文件的格式转换


##特点

* 操作便捷，转换延时小

* 支持听筒与扬声器的自动转换

