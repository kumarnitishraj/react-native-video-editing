

#import "RNAVEditing.h"
#if __has_include("RCTUtils.h")
#import "RCTUtils.h"
#else
#import <React/RCTUtils.h>

#endif

#if __has_include("RCTConvert.h")
#import "RCTConvert.h"
#else
#import <React/RCTConvert.h>

#endif


@implementation RNAVEditing


@synthesize videoAsset,audioAsset;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(audioVideoSpeedFilter:(NSDictionary *)videoObject
                  audioObject:(NSDictionary *)audioObject
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback){
  
  AVMutableComposition* mixComposition = [AVMutableComposition composition];
  AVURLAsset *videoAsset = [self uriSource:videoObject];
  //NSLog(@"%@",videoObject[@"motion"]);
  
  CMTime duration;
  if ([videoObject[@"duration"] doubleValue] == 0.0) {
    duration = videoAsset.duration;
  }else{
    duration = CMTimeMakeWithSeconds([videoObject[@"duration"] doubleValue], 600);
  }
    //slow down whole video by 2.0
  double videoScaleFactor = 2.0;
  CMTime videoDuration = videoAsset.duration;
  
  
  

  //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object
  
  AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
  AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
  
  

  CMTime start = CMTimeMakeWithSeconds([videoObject[@"VideoStartTime"] doubleValue], 600);
  CMTimeRange videoRange = CMTimeRangeMake(start, duration);
  
  [a_compositionVideoTrack insertTimeRange:videoRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
  
  //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
  AVURLAsset *audioAsset = [self uriSource:audioObject];
  start = CMTimeMakeWithSeconds([audioObject[@"AudioStartTime"] doubleValue], 600);
  CMTimeRange AudioRange = CMTimeRangeMake(start, duration);
  AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
  [b_compositionAudioTrack insertTimeRange:AudioRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
  /// ---------------------------- Filter Time ----------------------
  double a_durarion = CMTimeGetSeconds(duration);
  
  CMTime filterVideoMotion = CMTimeMake(videoDuration.value, videoDuration.timescale);
  if([videoObject[@"motion"] intValue] == -2){
    duration = CMTimeMakeWithSeconds(a_durarion * 2.0, 600);
    filterVideoMotion = CMTimeMake(videoDuration.value*videoScaleFactor, videoDuration.timescale);
  }
  else if ([videoObject[@"motion"] intValue] == 2){
    duration = CMTimeMakeWithSeconds(a_durarion / 2.0, 600);
    filterVideoMotion = CMTimeMake(videoDuration.value/videoScaleFactor, videoDuration.timescale);
  }
  else if ([videoObject[@"motion"] intValue] == 4){
    duration = CMTimeMakeWithSeconds(a_durarion / 4.0, 600);
    filterVideoMotion = CMTimeMake(videoDuration.value/videoScaleFactor, videoDuration.timescale);
  }
  
  //// ----------------------------- Filter Time -----------------------
  [a_compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
                                    toDuration:filterVideoMotion];
  
  [a_compositionVideoTrack setPreferredTransform:videoAssetTrack.preferredTransform];
  
  
  
  //----------------  Audio Section -------------
  
  
  //audioMatched
  if ([videoObject[@"audioMatched"] boolValue]){
    [b_compositionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
                                 toDuration:filterVideoMotion];
  }
  
  
  //decide the path where you want to store the final video created with audio and video merge.
  NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = [dirPaths objectAtIndex:0];
  NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo1.mov"]];
  NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
  if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
    [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
  
  //Now create an AVAssetExportSession object that will save your final video at specified path.
  AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
  _assetExport.outputFileType = @"com.apple.quicktime-movie";
  _assetExport.outputURL = outputFileUrl;
  //_assetExport.videoComposition = videoComposition;
  
  [_assetExport exportAsynchronouslyWithCompletionHandler:
   ^(void) {
     
     dispatch_async(dispatch_get_main_queue(), ^{
       [self exportDidFinish:_assetExport errorCallback:failureCallback callback:successCallback];
     });
   }
   ];
}


RCT_EXPORT_METHOD(videoTriming:(NSDictionary *)videoObject
                  audioObject:(NSDictionary *)audioObject
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback){
  
  NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
  
 
  AVURLAsset *videoAsset = [self uriSource:videoObject];
  
  CMTime duration;
  if ([videoObject[@"duration"] doubleValue] == 0.0) {
    duration = videoAsset.duration;
  }else{
    duration = CMTimeMakeWithSeconds([videoObject[@"Duration"] doubleValue], 600);
  }
  
  CMTime start = CMTimeMakeWithSeconds([videoObject[@"VideoStartTime"] doubleValue], 600);
  CMTimeRange videoRange = CMTimeRangeMake(start, duration);
  
  AVURLAsset *audioAsset = [self uriSource:audioObject];
  start = CMTimeMakeWithSeconds([audioObject[@"AudioStartTime"] doubleValue], 600);
  CMTimeRange AudioRange = CMTimeRangeMake(start, duration);
  
  
  AVMutableComposition* mixComposition = [AVMutableComposition composition];
  
  //slow down whole video by 2.0
  double videoScaleFactor = 2.0;
  CMTime videoDuration = videoAsset.duration;
  
  //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
  AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
  [b_compositionAudioTrack insertTimeRange:AudioRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];

  
  //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object.
  AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
  AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
  [a_compositionVideoTrack insertTimeRange:videoRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
  
  [a_compositionVideoTrack setPreferredTransform:videoAssetTrack.preferredTransform];
  

 
  
  //decide the path where you want to store the final video created with audio and video merge.
  NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = [dirPaths objectAtIndex:0];
  NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"FinalVideo1.mov"]];
  NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
  if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
    [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
  
  //Now create an AVAssetExportSession object that will save your final video at specified path.
  AVAssetExportSession* _assetExport;
  
  switch([videoObject[@"videoQuality"] intValue]){
    case 1  :
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetLowQuality];
      break;
    case 2  :
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
      break;
    case 3  :
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
      break;
    case 4  :
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset1280x720];
      break;
    case 5  :
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset960x540];
      break;
    case 6  :
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset640x480];
      break;
      
      /* you can have any number of case statements */
    default : /* Optional */
      _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
  }
  _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
  _assetExport.outputURL = outputFileUrl;
  
  if([videoObject[@"videoFileLimit"] intValue] != 0){
    _assetExport.fileLengthLimit = [videoObject[@"videoFileLimit"] intValue];
  }
  
  
  
  [_assetExport exportAsynchronouslyWithCompletionHandler:
   ^(void) {
     
     dispatch_async(dispatch_get_main_queue(), ^{
       [self exportDidFinish:_assetExport errorCallback:failureCallback callback:successCallback];
     });
   }
   ];
}

//RCT_EXPORT_METHOD(transcodeItem:(NSDictionary *)videoObject){
//  AVURLAsset *videoAsset = [self uriSource:videoObject];
//  // see if it's possible to export at the requested quality
//  NSArray *compatiblePresets = [AVAssetExportSession
//                                exportPresetsCompatibleWithAsset:videoAsset];
//  
//}

RCT_EXPORT_METHOD(deleteItem:(NSDictionary *)videoObject){
  
  NSURL *videourl = [self uriNSURL:videoObject];
  
  NSArray * arr = @[videourl];
  
  
  PHFetchResult *asset = [PHAsset fetchAssetsWithALAssetURLs:(NSArray<NSURL *> *) arr options:nil];
  NSLog(@"Working Fine");
  NSLog(@"%@",asset);
  
  [asset enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSLog(@"Working Fine");
    NSLog(@"%@",[obj class]);
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
      BOOL req = [obj canPerformEditOperation:PHAssetEditOperationDelete];
      if (req) {
        NSLog(@"true");
        [PHAssetChangeRequest deleteAssets:@[obj]];
      }
    } completionHandler:^(BOOL success, NSError *error) {
      NSLog(@"Finished Delete asset. %@", (success ? @"Success." : error));
      if (success) {
        NSLog(@"true");
      }
    }];
  }];
}


- (void)exportDidFinish:(AVAssetExportSession*)session
          errorCallback:(RCTResponseSenderBlock)failureCallback
               callback:(RCTResponseSenderBlock)successCallback
{
  NSURL *outputURL;
  if(session.status == AVAssetExportSessionStatusCompleted){
    outputURL = session.outputURL;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
      [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                  completionBlock:^(NSURL *assetURL, NSError *error){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      if (error) {
                                        NSLog(@"%@",error);
                                        failureCallback(@[error]);
                                      }else{
                                        NSLog(@"%@",outputURL);
                                        NSLog(@"VIdeo has been saved");
                                        successCallback(@[@"merge video complete", outputURL.absoluteString]);
                                        
                                        //[self loadMoviePlayer:outputURL];
                                      }
                                    });
                                  }];
      NSLog(@"%@",outputURL);
    }
  }
  
  
}


- (AVURLAsset*)uriSource:(NSDictionary *)pathObject
{
  bool isNetwork = [RCTConvert BOOL:pathObject[@"isNetwork"]];
  bool isAsset = [RCTConvert BOOL:pathObject[@"isAsset"]];
  NSString *uri = pathObject[@"uri"];
  NSString *type = pathObject[@"type"];
  
  NSURL *url = (isNetwork || isAsset) ?
  [NSURL URLWithString:uri] :
  [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:uri ofType:type]];
  AVURLAsset *asset;
  if (isAsset || isNetwork) {
    asset = [[AVURLAsset alloc]initWithURL:url options:nil];
    
  }
  
  return asset;
}

- (NSURL*)uriNSURL:(NSDictionary *)pathObject
{
  bool isNetwork = [RCTConvert BOOL:pathObject[@"isNetwork"]];
  bool isAsset = [RCTConvert BOOL:pathObject[@"isAsset"]];
  NSString *uri = pathObject[@"uri"];
  NSString *type = pathObject[@"type"];
  
  NSURL *url = (isNetwork || isAsset) ?
  [NSURL URLWithString:uri] :
  [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:uri ofType:type]];
  
  return url;
}

@end

