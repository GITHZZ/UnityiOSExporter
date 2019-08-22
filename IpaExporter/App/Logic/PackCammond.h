//
//  RubyCommand.h
//  IpaExporter
//
//  Created by 4399 on 5/28/19.
//  Copyright © 2019 何遵祖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define COMM_SUCCESS 1
#define COMM_EXIT 0

@interface PackCammond : NSObject
{
@private
    __block BOOL _isExporting;
    NSSet *_commFunc;
}

@end

NS_ASSUME_NONNULL_END
