//
//  LuaDictionary.c
//  IpaExporter
//
//  Created by 何遵祖 on 2016/9/9.
//  Copyright © 2016年 何遵祖. All rights reserved.
//

#include "LuaDictionary.h"
#include "LuaNodeList.h"
#include <string.h>
#include <malloc/malloc.h>
#include <stdlib.h>

#define HASH_SIZE 101
static struct list_node* head;
static struct dict_node* hashtab[HASH_SIZE];

unsigned hash(char* s)
{
    unsigned hashval;
    for(hashval = 0; *s != '\0'; s++)
        hashval = *s + 31 * hashval;
    
    return hashval % HASH_SIZE;
}

struct dict_node *lookup(char *s)
{
    struct dict_node *np;
    for(np = hashtab[hash(s)]; np != NULL; np = np->next)
        if(strcmp(s, np->key) == 0)
            return np; //found
    return np;//not found
}

char* strdupStr(char* s)
{
    char* p;
    p = (char *)malloc(strlen(s) + 1);
    if(p != NULL)
        strcpy(p, s);
    return p;
}

struct dict_node *install(char* name, union LuaVal value)
{
    struct dict_node* np;
    unsigned hashval;
    if((np = lookup(name)) == NULL)/*not found*/
    {
        np = (struct dict_node*)malloc(sizeof(*np));
        if(np == NULL || (np ->key = strdupStr(name)) == NULL)
            return NULL;
        hashval = hash(name);
        np->next = hashtab[hashval];
        hashtab[hashval] = np;
    }
    
    np->val = value;
    return np;
}

void lua_dic_put_data(char *key, union LuaVal value)
{
    if(head == NULL)
        head = createNodeList();
    
    struct dict_node* node = install(key, value);
    struct list_node* lNode = (struct list_node*)malloc(sizeof(struct list_node));
    lNode->data = node;
    addListNode(head, lNode);
}

union LuaVal lua_dic_get_data(char* key)
{
    union LuaVal ret;
    struct dict_node* np = lookup(key);
    if(np != NULL)
        ret = np->val;
        
    return ret;
}

void cleanDict()
{
    destoryNodeList(head);
}