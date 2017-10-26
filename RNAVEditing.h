

#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <RCTBridgeModule.h>
#endif

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>  

@interface RNAVEditing : NSObject<RCTBridgeModule>

- (void)exportDidFinish:(AVAssetExportSession*)session;

- (void)audioVideoEdit:(AVURLAsset *) videoAsset
      videoRange:(CMTimeRange ) videoRange
      audioAsset:(AVURLAsset *) audioAsset
      AudioRange:(CMTimeRange ) AudioRange
        duration:(CMTime) duration
         errorCallback:(RCTResponseSenderBlock)failureCallback
              callback:(RCTResponseSenderBlock)successCallback;
-(void)MergeVideo:(NSDictionary *)videoObject
      audioObject:(NSDictionary *)audioObject
    errorCallback:(RCTResponseSenderBlock)failureCallback
         callback:(RCTResponseSenderBlock)successCallback;


@property(nonatomic,retain)AVURLAsset* videoAsset;
@property(nonatomic,retain)AVURLAsset* audioAsset;

@end
