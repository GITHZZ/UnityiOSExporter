//
//  LuaNodeList.h
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#ifndef LuaNodeList_h
#define LuaNodeList_h

#include <stdio.h>
#include "LuaDefine.h"

struct list_node* createNodeList();
int destoryNodeList(struct list_node* list);
int addListNode(struct list_node* list, struct list_node* node);

#endif /* LuaNodeList_h */
