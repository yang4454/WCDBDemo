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

WCDB_SYNTHESIZE(Message, XXSXS)// Add a new column增加字段


//WCDB_SYNTHESIZE(WCTSampleAddColumn, deletedColumn)// delete a column
//由于SQLite不不⽀支持删除字段，因此，删除定义后，WCDB只是将该字段忽略略，其旧数据依然存在在数据 库内，但新增加的数据基本不不会因为该字段产⽣生额外的性能和空间损耗。


//修改字段
//由于SQLite不不⽀支持修改字段名称，因此WCDB使⽤用 WCDB_SYNTHESIZE_COLUMN(className, propertyName, columnName) 重新映射宏。
//对于已经定义的字段 WCDB_SYNTHESIZE(MyClass, myValue) 可以修改 为 WCDB_SYNTHESIZE_COLUMN(MyClass, newMyValue, "myValue") 。
//对于已经定义的字段类型，可以任意修改为其他类型。但旧数据会使⽤用新类型的解析⽅方式进⾏行行反序列列 化，因此需要确保其兼容性。
//WCDB_SYNTHESIZE_COLUMN(Message, contentxxx, "content")
@end
