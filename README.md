# reacc-native-video-editing

## NOTE: This library is currently in a work in progress state.

React Native module for merge audio and video,trim video and change backgound audio with speed Filter For IOS only.

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
var VideoEditing = require('react-native-video-editing').Platform;

// options For Audio Video Motion Filter
const option = {
      video: {
        source: require('../videoplayer/mode.mp4'),
        motion: VideoEditing.FILTER_SPEED_2X_FAST,
      },
      audio: {
        source:require('../videoplayer/new.mp3')
      },
      videoQuality: VideoEditing.QUALITY_960x540,
      audioMatched:false,
    }

/**
 * The first arg is the options object for customization ,
 * The second and third arg is the callback which sends Error and Sucess.
 */

VideoEditing.videoMotionFilter(option,
      (error) => {
        console.log('Error: ' + results);
      },
      (results, file) => {
        console.log('Success : ' + results + " " + file);

        //navigate('Video', { uri: file })

      });
```
