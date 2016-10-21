//
//  LuaException.c
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/6.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#include "LuaException.h"

const char* get_err_string(lua_State* L)
{
    const char* err = luaL_tolstring(L, -1, 0);
    lua_pop(L, -1);
    return err;
}

const char* get_error_description(lua_State* L, int code)
{
    const char* errStr = NULL;
    
    switch (code)
    {
        case LUA_DLL_OK:
            break;
        case LUA_DLL_ERROR:
            errStr = get_err_string(L);
            break;
        case LUA_DLL_UNKNOW_FAIL:
            errStr = "发生未知错误";
            break;
        case LUA_DLL_UNEXPECTED:
            errStr = "程序异常";
            break;
        case LUA_DLL_MEMORY_OUT:
            errStr = "内存不足";
            break;
        default:
            break;
    }
    
    return errStr;
}
