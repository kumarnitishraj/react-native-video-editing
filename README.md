# reacc-native-video-editing

React Native module for mix audio and video with speed filter,trim video and speed Filter For IOS only.

## Install

`npm install react-native-video-editing --save`

## Mostly automatic installation

`react-native link react-native-video-editing`



### iOS - Manual linking (do not need this if `react-native link ...` is used)

1. In the XCode's "Project navigator", right click on your project's Libraries folder ➜ `Add Files to <...>`
2. Go to `node_modules` ➜ `react-native-video-editing`  ➜ select `RNAVEditing.xcodeproj`
3. Add `RNAVEditing.xcodeproj` to `Build Phases -> Link Binary With Libraries`
4. Compile and have fun

## Usage 

```javascript
import VideoEditing from 'react-native-video-editing';
// For ES 5
var VideoEditing = require('react-native-video-editing');

// options For Audio Video Motion Filter
const option = {
      video: {
        source: require('../videoplayer/mode.mp4'),
      },
      audio: {
        source:require('../videoplayer/new.mp3')
      },
      motion: VideoEditing.FILTER_SPEED_2X_FAST,
      videoQuality: VideoEditing.QUALITY_960x540,
      audioMatched:false,
    }

/**
 * The first arg is the options object for customization ,
 * The second and third arg is the callback which sends Error and Sucess.
 */

VideoEditing.videoMotionFilter(option).then((newSource)=>{
      console.log('Success : ' + newSource);
    }).catch((error)=>{
      console.log('Error: ' + error);
    })
```


## Options For  Video Speed Filter
### Function Name ``` videoMotionFilter```

Key | Default Value  | Detail
------ | ---- | ------- 
video | .... | Any Video File Path (Asset, Network, ...) 
audio | .... | Optional if you want to mix audio video with motion. Default It will take from video 
videoQuality | HIGH_QUALITY | LOW_QUALITY, MEDIUM_QUALITY, HIGH_QUALITY, QUALITY_640x480, QUALITY_960x540, QUALITY_1280x720
motion | noraml | FILTER_SPEED_2X_FAST, FILTER_SPEED_2X_SLOW, FILTER_SPEED_4X_FAST , Normal if you do not pass it.
audioMatched | true | true / false (Optional)
duration | video duration | 0.0 - ...  (in second )

## Options For  Audio Vedio Mixing
### Function Name ``` MergeAudioVideo ```

Key | Default Value  | Possiblity
------ | ---- | ------- 
video | .... | Any Video File Path (Asset, Network, ...) 
audio | .... | Any Video File Path (Asset, Network, ...) 
videoQuality | HIGH_QUALITY | LOW_QUALITY, MEDIUM_QUALITY, HIGH_QUALITY, QUALITY_640x480, QUALITY_960x540, QUALITY_1280x720
duration | video duration | 0.0 - ...  (in second )

## Options For  Audio Vedio Teriming
### Function Name ``` TrimAudioVideo ```

Key | Default Value  | Possiblity
------ | ---- | ------- 
video | .... | Any Video File Path (Asset, Network, ...) 
audio | .... | Any Video File Path (Asset, Network, ...) 
videoQuality | HIGH_QUALITY | LOW_QUALITY, MEDIUM_QUALITY, HIGH_QUALITY, QUALITY_640x480, QUALITY_960x540, QUALITY_1280x720
duration | video duration | 0.0 - ...  (in second )
VideoStartTime | 0.0 | Give Starting point. It should be in second.

## License

[MIT License](http://opensource.org/licenses/mit-license.html).

