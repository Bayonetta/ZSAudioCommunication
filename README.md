##ZSAudioCommunication


由于google与apple互掐，所以很难找到通用的音频格式。

amr是android的默认录音格式，本身体积小，适合移动通讯，ios4.0以后由于apple不再支持amr文件的播放，所以本工程引入了开源库`libopencore-armnb`，进行wav到amr的格式转换。

本工程是对`TheAmazingAudioEngine`音频处理引擎的再次封装，使用便捷。
