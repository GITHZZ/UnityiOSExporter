//
//  CustomLog.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/2/17.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

void showLog(const char* content, ...);
void showError(const char* content, ...);

//Lua log输出到屏幕上
void lua_show_log(const char* s);
void lua_show_error(const char *s);
