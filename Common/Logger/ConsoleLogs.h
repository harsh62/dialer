//
//  ConsoleLogs.h
// iULTAMia
//
//  Created by Surbhi Jain on 04/06/14.
//  Copyright (c) 2014 Ulta,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG_LOG @"DebugLog"
#define INFO_LOG @"InfoLog"
#define ERROR_LOG @"ErrorLog"
#define ALL_LOG @"AllLog"



@interface ConsoleLogs : NSObject{
    
    BOOL stdErrRedirected;
    
}

@property (nonatomic,strong) NSDictionary *logLevelsDictionary;

+ (ConsoleLogs *)sharedInstance ;

@property (nonatomic, assign) BOOL stdErrRedirected;

- (void)turnOnLoggingToFileForApp:(BOOL)isAppLogs;
- (void)turnOffLoggingToFile;
- (NSString *)returnLogFileForApp:(BOOL)isAppLogs;


@end
