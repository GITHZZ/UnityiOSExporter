//
//  main.m
//  ttt
//
//  Created by 何遵祖 on 2016/9/1.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>

//FILE *stream;

int main(int argc, const char * argv[])
{
    FILE* stream = freopen("/Users/apple/Desktop/test.txt", "w", stdout ); // 重定向
    if(stream == NULL)
        printf("重定向出错");
    
//    stream = freopen( "/Users/apple/Desktop/test.txt", "w", stdout ); // 重定向
//    
//    if( stream == NULL )
//    fprintf( stdout, "error on freopen\n" );
//    else
//    {
//        //system( "type freopen.out" );
//        system( "ls -l" );
//        fprintf( stream, "This will go to the file 'freopen.out'\n" );
//        fprintf( stdout, "successfully reassigned\n" );
//        fclose( stream );
//    }
//    fprintf( stdout, "this is not print out\n" );//这里没有输出
    
    return NSApplicationMain(argc, argv);
}
