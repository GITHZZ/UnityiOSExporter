//
//  LuaDefine.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef LuaDefine_h
#define LuaDefine_h


#define LOG_TXT_FILE "/logFile.txt"

union LuaVal
{
    int num;
    int boolean;
    double doub;
    const char* str;
};

struct dict_node
{
    char* key;
    union LuaVal val;
    struct dict_node* next;
};

struct list_node
{
    struct dict_node* data;
    struct list_node* next;
};

#endif /* LuaDefine_h */
