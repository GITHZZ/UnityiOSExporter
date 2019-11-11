//
//  RubyCommand.h
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSNumber* CammondResult;
#define CAMM_EXIT               @100
#define CAMM_SUCCESS            @101
#define CAMM_CONTINUE           @102
#define CAMM_BREAK              @103

typedef NSNumber* CammondCode;
#define CODE_EXPORT_XCODE       @1
#define CODE_EDIT_XCODE         @2
#define CODE_EXPORT_IPA         @4
#define CODE_GEN_RESFOLDER      @8
#define CODE_RUN_CUSTOM_SHELL   @16
#define CODE_ACTIVE_WND_TOP     @32
#define CODE_BACKUP_XCODE       @64


NS_ASSUME_NONNULL_BEGIN

@interface PackCammond : NSObject
{
@private
    __block BOOL _isExporting;
    NSMutableDictionary *_cammondCode;
}
@end

NS_ASSUME_NONNULL_END
