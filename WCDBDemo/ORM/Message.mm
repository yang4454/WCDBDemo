//
//  Message.m
//  WCDB
//
//  Created by Jeff on 2020/11/3.
//

#import "Message.h"
#import "Message+WCTTableCoding.h"

@implementation Message
WCDB_IMPLEMENTATION(Message)//宏在类⽂文件定义绑定到数据库表的类。
WCDB_SYNTHESIZE(Message, localID)//宏在类⽂文件定义需要绑定到数据库表的字段。
WCDB_SYNTHESIZE(Message, content)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)
WCDB_PRIMARY(Message, localID)//⽤用于定义主键
WCDB_INDEX(Message, "_index", createTime)//⽤用于定义索引
//WCDB_UNIQUE ⽤用于定义唯⼀一约束
//WCDB_NOT_NULL ⽤用于定义⾮非空约束
@end
