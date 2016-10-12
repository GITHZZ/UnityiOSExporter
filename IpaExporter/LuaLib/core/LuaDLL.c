//
//  LuaDLL.c
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#include <math.h>
#include <stdlib.h>
#include "LuaDLL.h"
#include "lfs.h"

void check_version(lua_State* L)
{
    luaL_checkversion(L);
}

lua_State* open_lua()
{
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

int pop_lua_data(lua_State* L, int idx)
{
    int stackCount = lua_gettop(L);
    if (abs(idx) > stackCount)
        return LUA_DLL_MEMORY_ERROR;//序列号index错误 访问错误内存
    
    lua_pop(L, idx);
    return LUA_DLL_OK;
}

int call_lua_function()
{
    return 1;
}

int pcall_lua(lua_State *L, int nargs, int nresults, int errfunc)
{
    int s = lua_pcall(L, nargs, nresults, errfunc);
    if(s != LUA_OK)
        return LUA_DLL_ERROR;
    
    int ps = pop_lua_data(L, -1);
    if (ps != LUA_DLL_OK)
        return ps;
    
    return LUA_DLL_OK;
}

int get_lua_global_data(lua_State *L, const char *name)
{
    int s = lua_getglobal(L, name);
    if (s != LUA_OK)
        return LUA_DLL_ERROR;
    
    return LUA_DLL_OK;
}
