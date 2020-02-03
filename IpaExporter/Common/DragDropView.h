//
//  DragDropView.h
//  IpaExporter
//
//  Created by hezunzu on 2020/2/3.
//  Copyright © 2020 何遵祖. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DragDropViewDelegate <NSObject>
-(NSDragOperation)dragDropViewDraggingEntered:(NSArray*)fileUrlList withIdentifier:(NSString*) identifier;
-(BOOL)dragDropViewFileList:(NSArray*)fileUrlList withIdentifier:(NSString*)identifier;
@end

@interface DragDropView : NSView
@property (assign) IBOutlet id<DragDropViewDelegate> delegate;
@end



NS_ASSUME_NONNULL_END
