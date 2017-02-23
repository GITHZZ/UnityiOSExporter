//
//  LuaDLL.c
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#include <objc/runtime.h>
#include <objc/message.h>


#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "LuaDLL.h"
#include "lfs.h"
#include "LuaDefine.h"
#include "CustomLog.h"

void print_lua_log(const char *s)
{
    lua_show_log(s);
}

void check_version(lua_State* L)
{
    luaL_checkversion(L);
}

char* combine_string(const char *s1, const char *s2)
{
    char* result = malloc(strlen(s1) + strlen(s2) + 1);
    if(result == NULL) exit(1);
    
    strcpy(result, s1);
    strcat(result, s2);
    
    return result;
}

lua_State* open_lua(const char* logFilePath)
{
    /*
    //创建和重定向log输出
    char* path = combine_string(logFilePath, LOG_TXT_FILE);
    FILE* stream = freopen(path, "w", stdout); // 重定向
    if(stream == NULL)
        printf("重定向出错");
    */
    
    lua_State* L = luaL_newstate();

    if(L == NULL)
    {
        //初始化虚拟机堆栈错误,内存不足
        exit(EXIT_FAILURE);
    }

    //关联lfs库
    luaL_requiref(L, "lfs", luaopen_lfs, 1);
    return L;
}

void close_lua(lua_State* L)
{
    if(L != NULL)
        lua_close(L);
}

int open_lua_libs(lua_State* L)
{
    int iError = LUA_DLL_OK;
    if(L)
    {
        TRY
        {
            luaL_openlibs(L);
        }
        CATCH
        {
            iError = LUA_DLL_UNEXPECTED;
        }
        END_TRY;
    }
    
    return iError;
}

int load_lua_file(lua_State *L, const char *filePath)
{
    TRY
    {
        int loadState = luaL_loadfile(L, filePath);
        if(loadState != LUA_OK)
        {
            return LUA_DLL_ERROR;
        }
    }
    CATCH
    {
        return LUA_DLL_UNEXPECTED;
    }
    END_TRY;
    
    return LUA_DLL_OK;
}

int do_lua_file(lua_State* L, const char* filePath)
{
    int code = load_lua_file(L, filePath);
    if(code == LUA_DLL_OK)
    {
        int callState = lua_pcall(L, 0, LUA_MULTRET, 0);
        if(callState != LUA_OK)
        {
            return LUA_DLL_ERROR;
        }
    }
    else
    {
        return code;
    }
    
    return LUA_DLL_OK;
}

int load_lua_string(lua_State* L, const char* content)
{
    int loadState = luaL_loadstring(L, content);
    if(loadState != LUA_OK)
    {
        return LUA_DLL_ERROR;
    }
    
    return LUA_DLL_OK;
}

int do_lua_string(lua_State* L, const char* content)
{
    int code = load_lua_string(L, content);
    if(code == LUA_DLL_OK)
    {
        int callState = lua_pcall(L, 0, LUA_MULTRET, 0);
        if(callState != LUA_OK)
        {
            return LUA_DLL_ERROR;
        }
    }
    else
    {
        return code;
    }
    
    return LUA_DLL_OK;
}

void push_lua_string_args(lua_State *L, int count, const char* args1, ...)
{
    //定义参数列表
    va_list ap;
    //初始化参数列表
    va_start(ap, args1);
    lua_pushstring(L, args1);
    
    int i = 1;
    //获取参数值
    while (i < count)
    {
        char* args = va_arg(ap, char*);
        lua_pushstring(L, args);
        i++;
    }
    
    
    va_end(ap);
}

void push_lua_boolean_args(lua_State *L, int count, int args1, ...)
{
    //定义参数列表
    va_list ap;
    //初始化参数列表
    va_start(ap, args1);
    lua_pushboolean(L, args1);
    
    int i = 1;
    //获取参数值
    while (i < count)
    {
        int args = va_arg(ap, int);
        lua_pushboolean(L, args);
        i++;
    }
    
    va_end(ap);
}

int start_call_lua_func(lua_State *L, int nargs, int nresults, int errfunc)
{
    int s = lua_pcall(L, nargs, nresults, errfunc);
    if(s != LUA_OK){
        return LUA_DLL_ERROR;
    }
    
    lua_pop(L, 1);
    return LUA_DLL_OK;
}

int get_call_lua_func(lua_State *L, const char *name)
{
    int s = lua_getglobal(L, name);
    if (s != LUA_OK)
        return LUA_DLL_ERROR;
    
    return LUA_DLL_OK;
}


//调用lua主入口
int start_call_lua_main(lua_State *L, int nargs)
{
    int s = lua_pcall(L, nargs, 1, 0);
    if(s != LUA_OK){
        return LUA_DLL_ERROR;
    }
    
    int luaResult = (int)lua_tonumber(L, -1);
    lua_pop(L, 1);
    
    if(luaResult <= 0){
        return LUA_DLL_ERROR;
    }
    
    return LUA_DLL_OK;
}
