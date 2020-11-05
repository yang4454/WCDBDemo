//
//  Message.m
//  WCDB
//
//  Created by Jeff on 2020/11/3.
//

#import "Message.h"
#import "Message+WCTTableCoding.h"

//字段宏以 WCDB_SYNTHESIZE 开头，定义了了类属性与字段之间的联系。⽀支持⾃自定义字段名和默认值。
//  WCDB_SYNTHESIZE(className, propertyName) 是最简单的⽤用法，它直接使⽤用 propertyName作为数据库字段名。
//  WCDB_SYNTHESIZE_COLUMN(className, propertyName, columnName) ⽀支持⾃自定义字段名。
//  WCDB_SYNTHESIZE_DEFAULT(className, propertyName, defaultValue) ⽀支持⾃自定义字段的默认值。默认值可以是任意的C类型或 NSString 、 NSData 、 NSNumber 、 NSNull 。
//  WCDB_SYNTHESIZE_COLUMN_DEFAULT(className, propertyName, columnName,defaultValue) 为以上两者的组合。
             
 
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
