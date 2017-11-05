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




### Options

option | iOS  | Android | Info
------ | ---- | ------- | ----
title | OK | OK | Specify `null` or empty string to remove the title
cancelButtonTitle | OK | OK |
customButtons | OK | OK | An array containing objects with the name and title of buttons
videoQuality | OK |  OK | 'low', 'medium', or 'high' on iOS, 'low' or 'high' on Android
durationLimit | OK | OK | Max video trimming time, in seconds
noData | OK | OK | If true, disables the base64 `data` field from being generated (greatly improves performance on large videos)
storageOptions | OK | OK | If this key is provided, the video will get saved in the Documents directory on iOS, and the Videos directory on Android (rather than a temporary directory)
storageOptions.path | OK | - | If set, will save video at /Documents/[path] rather than the root
storageOptions.cameraRoll | OK | - | If true, the trimmed video will be saved to the iOS Camera roll.

### The Response Object

key | iOS | Android | Description
------ | ---- | ------- | ----------------------
didCancel | OK | OK | Informs you if the user cancelled the process
error | OK | OK | Contains an error message, if there is one
data | OK | OK | The base64 encoded video data
uri | OK | OK | The uri to the local file asset on the device
origURL | OK | - | The URL of the original asset in library, if it exists
width | OK | OK | Video dimensions
height | OK | OK | Video dimensions
fileSize | OK | OK | The file size
type | - | OK | The file type
fileName | - | OK | The file name
path | - | OK | The file path
