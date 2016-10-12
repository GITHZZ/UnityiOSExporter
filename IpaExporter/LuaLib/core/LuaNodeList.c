//
//  LuaNodeList.c
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#include "LuaNodeList.h"
#include <malloc/malloc.h>
#include <stdlib.h>

struct list_node* createNodeList()
{
    struct list_node* head;
    head = (struct list_node*)malloc(sizeof(*head));
    if(head != NULL)
    {
        head->data = NULL;
        head->next = NULL;
    }
    return NULL;
}

int destoryNodeList(struct list_node* list)
{
    if(list == NULL)
        return 0;
    
    if(list->next == NULL)
    {
        free(list->data->key);
        free(list->data->next);
        free(list->data);
        free(list);
        list = NULL;
        return 1;
    }
    
    struct list_node* p = list->next;
    while (p != NULL)
    {
        struct list_node* tmp = p;
        p = p->next;
        free(tmp->data->key);
        free(tmp->data->next);
        free(tmp->data);
        free(tmp);
    }
    
    free(list);
    list = NULL;
    
    return 1;
}

int addListNode(struct list_node* list, struct list_node* node)
{
    if(list == NULL)
        return 0;
    
    struct list_node* p = list->next;
    struct list_node* q = list;
    
    while (p != NULL)
    {
        q = p;
        p = p -> next;
    }
    
    q->next = node;
    node->next = NULL;
    
    return 1;
}

