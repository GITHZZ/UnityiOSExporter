//
//  DragDropView.m
//  IpaExporter
//
//  Created by hezunzu on 2020/2/3.
//  Copyright © 2020 何遵祖. All rights reserved.
//

#import "DragDropView.h"
#import <objc/runtime.h>

@implementation DragDropView

- (void)dealloc{
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForDraggedTypes:@[NSPasteboardTypeFileURL, NSPasteboardTypePDF, NSPasteboardTypeString]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    if(_delegate == nil)
        return NSDragOperationNone;

    NSArray *array = [self getUrlArrayFromDragInfo:sender];
    return [_delegate dragDropViewDraggingEntered:array withIdentifier:[self identifier]];
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    if(_delegate == nil)
        return NO;
    
    NSArray *array = [self getUrlArrayFromDragInfo:sender];
    return [_delegate dragDropViewFileList:array withIdentifier:[self identifier]];
}

- (NSArray*)getUrlArrayFromDragInfo:(id<NSDraggingInfo>)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:10];
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    //判断是否为单个文件
    if (pboard.pasteboardItems.count <= 1) {
        NSURL *url = [NSURL URLFromPasteboard:pboard];
        if (url) {
            [array addObject:url];
        }
    }else{
        for(NSPasteboardItem *item in pboard.pasteboardItems){
            NSString *urlStr = [item propertyListForType:NSPasteboardTypeFileURL];
            [array addObject:[NSURL URLWithString:urlStr]];
        }
    }
    return array;
}

@end
