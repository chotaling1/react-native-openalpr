//
//  PlateScanner.m
//  RNOpenAlpr
//
//  Created by Evan Rosenfeld on 2/24/17.
//  Copyright © 2017 CarDash. All rights reserved.
//

#import "OpenALPR.h"
#import <openalpr/alpr.h>
#import "OpenALPRResult.h"
#import "OpenALPRResults.h"
static OpenALPR *scanner;
@implementation OpenALPR {
    alpr::Alpr* delegate;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanner = [[self class] new];
    });
    return scanner;
}

- (instancetype) init {
    if (self = [super init]) {
        delegate = new alpr::Alpr(
          [@"us" UTF8String],
          [[[NSBundle mainBundle] pathForResource:@"openalpr.conf" ofType:nil] UTF8String],
          [[[NSBundle mainBundle] pathForResource:@"runtime_data" ofType:nil] UTF8String]
        );
        delegate->setTopN(1);
        
        if (delegate->isLoaded() == false) {
            NSLog(@"Error initializing OpenALPR library");
            delegate = nil;
        }
        if (!delegate) self = nil;
    }
    return self;
    
}

- (void) setCountry:(NSString *)country {
    delegate->setCountry([country UTF8String]);
}

- (OpenALPRResults *)scanImage:(NSString *)filePath
{
    OpenALPRResults *results = [OpenALPRResults init];
    if (delegate->isLoaded() == false) {
        NSError *error = [NSError errorWithDomain:@"alpr" code:-100
                                         userInfo:[NSDictionary dictionaryWithObject:@"Error loading OpenALPR" forKey:NSLocalizedDescriptionKey]];
        results.isError = YES;
        return results;
    }
    
    std::string src = std::string([filePath UTF8String]);
    std::vector<alpr::AlprRegionOfInterest> regionsOfInterest;
    alpr::AlprResults alprResults = delegate->recognize(src);
    
    if (alprResults.plates.size() > 0) {
        NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
        for (alpr::AlprPlateResult alprResult : alprResults.plates)
        {
            OpenALPRResult *plate = [OpenALPRResult new];
            plate.plate = @(alprResult.bestPlate.characters.c_str());
            plate.confidence = alprResult.bestPlate.overall_confidence;
            
            
            NSMutableArray *pointsArr = [NSMutableArray array];
            for (int j = 0; j < 4; j++) {
                [pointsArr addObject:[NSValue valueWithCGPoint:CGPointMake(alprResult.plate_points[j].x, alprResult.plate_points[j].y)]];
            }
            plate.points = pointsArr;
            
            // NSLog(@"\n\n\ncols: %d\nrows: %d\npoint0.x: %d\npoint0.y: %d", colorImage.cols, colorImage.rows, alprResult.plate_points[0].x,
            //   alprResult.plate_points[0].y);
            
            [resultsArray addObject:plate];
        }
        
        results.Plates = [NSArray arrayWithArray:resultsArray];
        
        results.isError = NO;
        
        return results;
    } else {
        results.isError = YES;
        return results;
    }
    
    
}

@end
