//
//  Message.h
//  WCDB
//
//  Created by Jeff on 2020/11/3.
//
//https://www.bookstack.cn/read/tencent-wcdb/66f893c12ef91f78.md
//https://github.com/Tencent/wcdb/wiki/ORM%e4%bd%bf%e7%94%a8%e6%95%99%e7%a8%8b

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject

@property int localID;
@property(retain) NSString *content;
@property(retain) NSDate *createTime;
@property(retain) NSDate *modifiedTime;
@property(assign) int unused; //You can only define the properties you need'

@end

NS_ASSUME_NONNULL_END
