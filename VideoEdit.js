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
  getVideoQuality: function (quality = this.HIGH_QUALITY){
    return quality;
  },
  getVideoFileLimit:function(limit = 0){
    if(limit === 0){
      return 0
    }
    return 1024*1024*limit;
  },
  MergeAudioVideo: function(option, onError, onSucess) {
    /* --- Getting Audio Video Object form Option --- */
    const video_object = this.getVideoObject(option);
    const audio_object = this.getAudioObject(option);
    /* --- Getting outPut video File size and quality */
    const videoQuality = this.getVideoQuality(option.videoQuality);
    const videoFileLimit = this.getVideoFileLimit(option.videoFileSizeLimit);
    

    /* Video Object Filter */
    let videoObject = this.urlFilter(video_object.source);
    Object.assign(videoObject,{
      VideoStartTime:0.0,
      duration:0.0,
      videoFileLimit,
      videoQuality
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
  TrimAudioVideo: function(option, onError, onSucess)  {
      const video_object = this.getVideoObject(option);
      //console.log(videoObject);
      const audio_object = this.getAudioObject(option);

      let duration = this.duration(video_object.duration,audio_object.duration);

      /* --- Getting outPut video File size and quality */
      const videoQuality = this.getVideoQuality(option.videoQuality);
      const videoFileLimit = this.getVideoFileLimit(option.videoFileSizeLimit);

      /* Video Object Filter */
      let videoObject = this.urlFilter(video_object.source);
      console.log(videoObject);
      Object.assign(videoObject,{
        VideoStartTime:this.startTime(video_object.startTime),
        duration,
        videoQuality,
        videoFileLimit
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
  getVideoObject:function(option){
    return option.video;
  },
  getAudioObject:function(option){
    if(option.audio){
      return option.audio;
    }
    else{
      let audio = {
        source:option.video.source,
        audioMatched:true,
      }
      return audio;
    }
  },
  videoMotionFilter: function(option, onError, onSucess)  {

    const video_object = this.getVideoObject(option);
    //console.log(videoObject);
    const audio_object = this.getAudioObject(option);
    //console.log(this.getAudioMatched(videoObject,audioObject));

      let duration = this.duration(video_object.duration,audio_object.duration);

      /* --- Getting outPut video File size and quality */
      const videoQuality = this.getVideoQuality(option.videoQuality);
      const videoFileLimit = this.getVideoFileLimit(option.videoFileSizeLimit);

      /* Video Object Filter */
      let videoObject = this.urlFilter(video_object.source);

      Object.assign(videoObject,{
        VideoStartTime:this.startTime(video_object.startTime),
        motion:this.getMotion(video_object.motion),
        duration:duration,
        audioMatched: this.getAudioMatched(option.audioMatched),
        videoQuality,
        videoFileLimit
      })

      /* Audio Object Filter */
      let audioObject = this.urlFilter(audio_object.source);
      Object.assign(audioObject,{
        AudioStartTime:this.startTime(audio_object.startTime),
      })
      console.log(videoObject);
      console.log(audioObject);
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
  getAudioMatched: function (audioMatched = true){
    return audioMatched;
  },
  Add:function(){
    return 78;
  }
};
//
VideoEditing.FILTER_SPEED_2X_FAST = 2;
VideoEditing.FILTER_SPEED_2X_SLOW = -2;
VideoEditing.FILTER_SPEED_4X_FAST = 4;

VideoEditing.LOW_QUALITY = 1;
VideoEditing.MEDIUM_QUALITY = 2;
VideoEditing.HIGH_QUALITY = 3;

VideoEditing.QUALITY_640x480 = 6;
VideoEditing.QUALITY_960x540 = 5;
VideoEditing.QUALITY_1280x720 = 4;

module.exports = VideoEditing;
