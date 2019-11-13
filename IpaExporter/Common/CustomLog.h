//
//  CustomLog.h
//  IpaExporter
//
//  Created by 何遵祖 on 2017/2/17.
//  Copyright © 2017年 何遵祖. All rights reserved.
//

/// 显示普通Log到屏幕上
/// @param content 需要打印内容
void showLog(const char* content, ...);


/// 显示错误信息Log到屏幕（颜色为红色）
/// @param content 需要打印内容
void showError(const char* content, ...);


/// 显示成功Log信息（颜色为绿色）
/// @param content 需要打印内容
void showSuccess(const char* content, ...);
        

/// 显示警告Log信息（颜色为黄色）
/// @param content 需要打印内容
void showWarning(const char* content, ...);

//Lua log输出到屏幕上
void lua_show_log(const char* s);
void lua_show_error(const char *s);
