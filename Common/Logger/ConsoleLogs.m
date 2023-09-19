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

#define COUNT_OF_LOG_FILES 1

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

- (void)turnOnLoggingToFileForApp:(BOOL)isAppLogs
{
    stdErrRedirected = YES;
    savedStdErr = dup(STDERR_FILENO);
    
    //File Manager
    NSString *sharedContainerPathLocation = [[[NSFileManager defaultManager]
                                              containerURLForSecurityApplicationGroupIdentifier:
                                              @"group.YoBuDefaults"] path];
    NSString *directoryToCreate = isAppLogs? @"YoBuAppLogs" : @"YoBuWidgetLogs";
    NSString *dirPath = [sharedContainerPathLocation stringByAppendingPathComponent:directoryToCreate];
    
    BOOL isdir;
    NSError *error = nil;
    
    NSFileManager *mgr = [[NSFileManager alloc]init];
    
    if (![mgr fileExistsAtPath:dirPath isDirectory:&isdir]) { //create a dir only that does not exists
        if (![mgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        } else {
        }
    }
    
    //write the logs to the file
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *logPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"YoBuApp-%@.log",[formatter stringFromDate:[NSDate date]]]];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    
    //Clean up files
    [self cleanUpFiles:isAppLogs];
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


- (void)cleanUpFiles:(BOOL)isAppLogs {
    
    @try {
        NSError *error;
        NSString *sharedContainerPathLocation = [[[NSFileManager defaultManager]
                                                  containerURLForSecurityApplicationGroupIdentifier:
                                                  @"group.YoBuDefaults"] path];
        NSString *directoryToCreate = isAppLogs? @"YoBuAppLogs" : @"YoBuWidgetLogs";
        NSString *dirPath = [sharedContainerPathLocation stringByAppendingPathComponent:directoryToCreate];
        NSFileManager *fileManager = [[NSFileManager alloc] init];;
        NSArray *listOfFiles = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
        listOfFiles = [listOfFiles sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2];
        }];
        
        if (error==nil) {
            //Check if there are more than 3 files for logs
            if ([listOfFiles count] > COUNT_OF_LOG_FILES) {
                for (NSInteger i = 0; i < [listOfFiles count] - COUNT_OF_LOG_FILES  ; i++) {
                    
                    NSString *fileName = [listOfFiles objectAtIndex:i];
                    //Get the path of the file
                    NSString *fullPath = [dirPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
                    //Remove the item
                    [fileManager removeItemAtPath:fullPath error:nil];
                    
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

- (NSString *)returnLogFileForApp:(BOOL)isAppLogs{
    NSString *sharedContainerPathLocation = [[[NSFileManager defaultManager]
                                              containerURLForSecurityApplicationGroupIdentifier:
                                              @"group.YoBuDefaults"] path];
    NSString *directoryToCreate = isAppLogs? @"YoBuAppLogs" : @"YoBuWidgetLogs";
    NSString *dirPath = [sharedContainerPathLocation stringByAppendingPathComponent:directoryToCreate];
    NSFileManager *fileManager = [[NSFileManager alloc] init];;
    NSArray *listOfFiles = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    NSString *fullPath = @"";
    NSString *fileName;
    if(listOfFiles.count > 0){
        fileName = [listOfFiles objectAtIndex:0];
        fullPath = [dirPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    }
    return fullPath;
}


@end
