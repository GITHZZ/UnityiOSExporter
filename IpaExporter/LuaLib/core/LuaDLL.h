//
//  LuaDLL.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef LuaDLL_h
#define LuaDLL_h

#include "LuaException.h"
#include <stdarg.h>

//检测内核版本是否一致
void check_version(lua_State* L);
//初始化Lua堆栈
lua_State* open_lua();
int open_lua_libs(lua_State* L);
//释放Lua主线程堆栈
void close_lua(lua_State* L);

//预加载Lua文件
int load_lua_file(lua_State* L, const char* filePath);
//读取并且运行Lua文件
int do_lua_file(lua_State* L, const char* filePath);
//预加载字符串
int load_lua_string(lua_State* L, const char* content);
//读取Lua字符串
int do_lua_string(lua_State* L, const char* content);

#pragma mark - Lua&c元素交互相关

//出栈
int pop_lua_data(lua_State* L, int idx);

//获取Lua表全局数据(_G)
int get_call_lua_func(lua_State *L, const char *name);
void push_lua_args_string(lua_State *L, int count, const char* args1, ...);
void push_lua_args_boolean(lua_State *L, int count, int args1, ...);
int start_call_lua_func(lua_State *L, int nargs, int nresults, int errfunc);

#endif /* LuaDLL_h */
