//
//  loadAll.m
//  libAllFramework
//
//  Created by ppd-0202000710 on 2019/11/27.
//  Copyright © 2019 FengYang. All rights reserved.
//

#import "loadAll.h"
#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>

@implementation loadAll

static NSDictionary *FYLoadLibsInDirectoryWithLoadedDylibPaths(NSString *directoryPath, NSArray *loadedDylibPaths)
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSFileManager *fm = NSFileManager.defaultManager;
    for (NSString *fileName in [fm contentsOfDirectoryAtPath:directoryPath error:nil]) {
        NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
        if ([fileName hasSuffix:@".framework"]) {
            NSBundle *bundle = [NSBundle bundleWithPath:filePath];
            if (bundle.isLoaded) {
                    NSLog(@"loadFramework: : %@ load bundle success", fileName);
            } else {
                if ([bundle load]) {
                    NSLog(@"loadFramework: : %@ load bundle success", fileName);
                } else {
                    NSLog(@"loadFramework: : %@ load bundle failed", fileName);
                }
            }
            dic[fileName] = @"";
        } else if ([fileName hasSuffix:@".bundle"] ||
                   [fileName hasSuffix:@".momd"] ||
                   [fileName hasSuffix:@".strings"] ||
                   [fileName hasSuffix:@".appex"] ||
                   [fileName hasSuffix:@".app"] ||
                   [fileName hasSuffix:@".lproj"] ||
                   [fileName hasSuffix:@".storyboardc"]) {
            dic[fileName] = @"";
        }
        else {
            BOOL isDirectory;
            [fm fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (isDirectory) {
                dic[fileName] = FYLoadLibsInDirectoryWithLoadedDylibPaths(filePath, loadedDylibPaths);
            } else {
                if ([fileName hasSuffix:@".dylib"]) {
                    if ([loadedDylibPaths containsObject:filePath]) {
                        NSLog(@"loadFramework: : %@ load bundle success", fileName);
                    } else {
                        if (dlopen(filePath.UTF8String, RTLD_GLOBAL | RTLD_LAZY)) {
                            NSLog(@"loadFramework: : %@ load bundle success", fileName);
                        } else {
                            NSLog(@"loadFramework: : %@ load bundle failed", fileName);
                        }
                    }
                }
                dic[fileName] = @"";
            }
        }
    }

    return dic;
}

+ (void)load{
    @autoreleasepool
    {
        NSString *appID = NSBundle.mainBundle.bundleIdentifier;
        if (!appID) {
            appID = NSProcessInfo.processInfo.processName;//A Fix By https://github.com/radj
            NSLog(@"loadFramework: : Process has no bundle ID, use process name instead: %@", appID);
        }
        NSLog(@"loadFramework: :  %@ detected", appID);

        [NSBundle allFrameworks]; // 这句执行完所需framework应该都加载了

        NSMutableArray *loadedDylibPaths = [[NSMutableArray alloc] init];
        NSString *appPath = NSBundle.mainBundle.bundlePath;
        uint32_t count = _dyld_image_count();
        NSLog(@"loadFramework: : 一共有%d个image", count);
        for (uint32_t i = 0; i < count; i++) {
            NSString *dylibPath = @(_dyld_get_image_name(i));
            if ([dylibPath hasPrefix:appPath]) {
                [loadedDylibPaths addObject:dylibPath];
            }
        }
        NSDictionary *dic = FYLoadLibsInDirectoryWithLoadedDylibPaths(appPath, loadedDylibPaths);
        NSLog(@"loadFramework: : File list\n%@", [dic.description stringByReplacingOccurrencesOfString:@" = \"\"" withString:@""]);
    }
}

@end

