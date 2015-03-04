//
//  ConsoleLogs.m
// iULTAMia
//
//  Created by Surbhi Jain on 04/06/14.
//  Copyright (c) 2014 Ulta,Inc. All rights reserved.
//

#import "ConsoleLogs.h"
#import "Logging.h"

#define  SHOW_CONSOLE_LOGS YES

#define APP_FILE_MGR [NSFileManager defaultManager]


@implementation ConsoleLogs
@synthesize logLevelsDictionary;

#define COUNT_OF_LOG_FILES 3

+ (ConsoleLogs *)sharedInstance {
    
    static ConsoleLogs *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

@synthesize stdErrRedirected;


static int savedStdErr = 0;

- (void)turnOnLoggingToFile
{
    stdErrRedirected = YES;
    savedStdErr = dup(STDERR_FILENO);
    
    //File Manager
    NSString *sharedContainerPathLocation = [[[NSFileManager defaultManager]
                                              containerURLForSecurityApplicationGroupIdentifier:
                                              @"group.YoBuDefaults"] path];
    NSString *directoryToCreate = @"Logs";
    NSString *dirPath = [sharedContainerPathLocation stringByAppendingPathComponent:directoryToCreate];
    
    BOOL isdir;
    NSError *error = nil;
    
    NSFileManager *mgr = [[NSFileManager alloc]init];
    
    if (![mgr fileExistsAtPath:dirPath isDirectory:&isdir]) { //create a dir only that does not exists
        if (![mgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"error while creating dir: %@", error.localizedDescription);
        } else {
            NSLog(@"dir was created....");
        }
    }
    
    //write the logs to the file
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *logPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ULTA-%@.log",[formatter stringFromDate:[NSDate date]]]];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    
    //Clean up files
    [self cleanUpFiles];
}

+(void)createDirAtSharedContainerPath
{

}



- (void)turnOffLoggingToFile
{
    if (stdErrRedirected)
    {
        stdErrRedirected = NO;
        fflush(stderr);
        
        dup2(savedStdErr, STDERR_FILENO);
        close(savedStdErr);
        savedStdErr = 0;
    }
}


- (void)cleanUpFiles {
    
    @try {
        NSString *path = [self getLogsDirectory];
        NSError *error;
        NSArray *listOfFiles = [APP_FILE_MGR contentsOfDirectoryAtPath:path error:&error];
        
        listOfFiles = [listOfFiles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2];
        }];
        
        if (error==nil) {
            //Check if there are more than 3 files for logs
            if ([listOfFiles count] > COUNT_OF_LOG_FILES) {
                for (NSInteger i = 0; i < [listOfFiles count] - COUNT_OF_LOG_FILES  ; i++) {
                    
                    NSString *fileName = [listOfFiles objectAtIndex:i];
                    //Get the path of the file
                    NSString *fullPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
                    //Remove the item
                    [APP_FILE_MGR removeItemAtPath:fullPath error:nil];
                    
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        // Log Exception Here
        LogError(@"Exception Name: %@ ---> Reason of exception:%@  ----> Debug Reason :%@",exception.name,exception.reason,exception.debugDescription);
    }
    @finally {
        //
    }
}

/*
 ***********************************************
 This method is used to get the path of the log
 direcory created in caches folder
 ***********************************************
 */
-(NSString *)getLogsDirectory {
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachesDirectory = [cachesDirectory stringByAppendingPathComponent:@"ULTALogs"];
    
    return cachesDirectory;
    
    
}


/*
 ***********************************************
 This method checks if the log level exist in
 the user slected log level or not
 ***********************************************
 */
- (BOOL)isLogTypeEnabled:(NSString*)log {
    
    //Show logs if |All| level is set
    if ([[self.logLevelsDictionary objectForKey:ALL_LOG]boolValue]) {
        
        return YES;
    }
    
    if ([[self.logLevelsDictionary objectForKey:log]boolValue]) {
        
        return YES;
    }
    
    
    
    return NO;
}


/*
 ***********************************************
 This method displays the logs corresponding to
 the selected log level if user has opted for
 showing the logs.
 ***********************************************
 */
- (void)printConsoleLogsOfType:(NSString*)logType withValue:(NSString*)value {
    
    @synchronized(self) {
        if (SHOW_CONSOLE_LOGS && [self isLogTypeEnabled:logType]) {
            if ([logType isEqualToString:DEBUG_LOG]) {
                LogDebug(@"%@",value);
            }
            else if ([logType isEqualToString:INFO_LOG]) {
                LogInfo(@"%@",value);
            }
            else if ([logType isEqualToString:ERROR_LOG]) {
                LogError(@"%@",value);
            }
        }
    }
}


@end
