/**
 * @providesModule RNAVEditing
 * @flow

 react-native-rnavediting
 deleteItem
 */
'use strict';
import { NativeModules } from 'react-native';
//var RNAVEditing = require('react-native').NativeModules.RNAVEditing;
var resolveAssetSource = require("react-native/Libraries/Image/resolveAssetSource");

const RNAVEditing = NativeModules.RNAVEditing;

/**
 * High-level docs for the RNAVEditing iOS API can be written here.
 */

const VideoEditing = {
  deleteItem: function(path){
    let srcObject = this.urlFilter(path);
    console.log('working finre');
    console.log(srcObject)
    RNAVEditing.deleteItem(srcObject);
  },
  urlFilter: function(src)  {
    const source = resolveAssetSource(src) || {};

    let uri = source.uri || '';
    if (uri && uri.match(/^\//)) {
      uri = `file://${uri}`;
    }

    const isNetwork = !!(uri && uri.match(/^https?:/));
    const isAsset = !!(uri && uri.match(/^(assets-library|file|content|ms-appx|ms-appdata):/));
    const srcObject = {
      isNetwork:isNetwork,
      isAsset:isAsset,
      uri:uri,
    }
    return srcObject;
  },
  MergeAudioVideo: function(video_object, audio_object, onError, onSucess) {
    /* Video Object Filter */
    let videoObject = this.urlFilter(video_object.source);
    Object.assign(videoObject,{
      VideoStartTime:0.0,
      duration:0.0
    })

    /* Audio Object Filter */
    let audioObject = this.urlFilter(audio_object.source);
    Object.assign(audioObject,{
      AudioStartTime:0.0,
    })

    return RNAVEditing.videoTriming(videoObject, audioObject,
      (onError)=>{
      onError(onError)
    },
    (results, file) => {
          onSucess(results,file)
        }
  );
  },
  TrimAudioVideo: function(video_object, audio_object, onError, onSucess)  {
      let duration = this.duration(video_object.duration,audio_object.duration);

      /* Video Object Filter */
      let videoObject = this.urlFilter(video_object.source);
      console.log(videoObject);
      Object.assign(videoObject,{
        VideoStartTime:this.startTime(video_object.startTime),
        duration:duration,
      })

      /* Audio Object Filter */
      let audioObject = this.urlFilter(audio_object.source);
      Object.assign(audioObject,{
        AudioStartTime:this.startTime(audio_object.startTime),
      })

      return RNAVEditing.videoTriming(videoObject, audioObject,
        (onError)=>{
        onError(onError)
      },
      (results, file) => {
            onSucess(results,file)
          }
    );
  },
  videoMotionFilter: function(video_object, audio_object, onError, onSucess)  {
      let duration = this.duration(video_object.duration,audio_object.duration);

      /* Video Object Filter */
      let videoObject = this.urlFilter(video_object.source);
      console.log(videoObject);
      Object.assign(videoObject,{
        VideoStartTime:this.startTime(video_object.startTime),
        motion:this.getMotion(video_object.motion),
        duration:duration,
        audioMatched:this.getAudioMatched(video_object.audioMatched)
      })

      /* Audio Object Filter */
      let audioObject = this.urlFilter(audio_object.source);
      Object.assign(audioObject,{
        AudioStartTime:this.startTime(audio_object.startTime),
      })

      return RNAVEditing.audioVideoSpeedFilter(videoObject, audioObject,
        (onError)=>{
        onError(onError)
      },
      (results, file) => {
            onSucess(results,file)
          }
    );
  },
  duration: function(videoDuration = 0.0, audioDuration = 0.0) {
    let duration = 0.0;
    if (videoDuration > audioDuration){
      duration = videoDuration;
    }else {
      duration = audioDuration;
    }
    return duration;
  },
  startTime:function(time = 0.0){
    return time;
  },
  getMotion:function(motion = 0){
    return motion;
  },
  getAudioMatched:function(audioMatched = false){
    return audioMatched;
  },
  Add:function(){
    return 78;
  }
};
//
VideoEditing.FILTER_SPEED_2X_FAST = 2;
VideoEditing.FILTER_SPEED_2X_SLOW = -2;
// VideoEditing.LIBRARY = RNAVEditing.NSLibraryDirectory;
// VideoEditing.CACHES = RNAVEditing.NSCachesDirectory;

module.exports = VideoEditing;
