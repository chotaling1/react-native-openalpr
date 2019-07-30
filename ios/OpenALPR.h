//
//  PlateScanner.h
//  RNOpenAlpr
//
//  Created by Evan Rosenfeld on 2/24/17.
//  Copyright © 2017 CarDash. All rights reserved.
//

#import "OpenALPRResults.h"
#import <Foundation/Foundation.h>
#import "OpenALPRResult.h"
#ifdef __cplusplus
#include "opencv2/highgui/highgui.hpp"
#import <opencv2/videoio/cap_ios.h>
using namespace cv;
#endif

@interface OpenALPR : NSObject

typedef void(^onPlateScanSuccess)(OpenALPRResult *);
typedef void(^onPlateScanFailure)(NSError *);

+ (instancetype)sharedInstance;
- (void) setCountry:(NSString *)country;
- (OpenALPRResults *)scanImage:(NSString *)filePath;
@end
