//
//  Message+WCTTableCoding.h
//  WCDB
//
//  Created by Jeff on 2020/11/4.
//

#import "Message.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message (WCTTableCoding) <WCTTableCoding>
// 需要绑定到表中的字段在这里声明，在.mm中去绑定
WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)

WCDB_PROPERTY(XXSXS)//增加字段
//WCDB_PROPERTY(contentxxx)//修改字段

@end

NS_ASSUME_NONNULL_END
