//
//  RubyCommand.h
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSNumber* CammondCode;
#define CAMM_EXIT @0
#define CAMM_SUCCESS @1
#define CAMM_EXPORT_XCODE @2
#define CAMM_EDIT_XCODE @3
#define CAMM_EXPORT_IPA @4

@interface PackCammond : NSObject
{
@private
    __block BOOL _isExporting;
    NSMutableDictionary *_cammondCode;
}

@end

NS_ASSUME_NONNULL_END
