//
//  LuaDictionary.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef LuaDictionary_h
#define LuaDictionary_h

#include <stdio.h>
#include "LuaDefine.h"

void lua_dic_put_data(char *key, union LuaVal value);
union LuaVal lua_dic_get_data(char* key);
void cleanDict();

#endif /* LuaDictionary_h */
