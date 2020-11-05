//
//  ViewController.m
//  WCDB
//
//  Created by Jeff on 2020/11/4.
//

#import "ViewController.h"
#import "Message+WCTTableCoding.h"

@interface ViewController ()
/** strong属性注释 */
@property (nonatomic, strong) WCTDatabase *database;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *tableName = @"message";
    //获取沙盒根目录
   NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   
   // 文件路径
   NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
   NSLog(@"path = %@",filePath);
   
    self.database = [[WCTDatabase alloc]initWithPath:filePath];
   // 数据库加密
//   NSData *password = [@"123" dataUsingEncoding:NSASCIIStringEncoding];
//   [self.database setCipherKey:password];
   //测试数据库是否能够打开
   if ([self.database canOpen]) {
       
       // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
       // 先判断表是不是已经存在
       if ([self.database isOpened]) {
           
           if ([self.database isTableExists:tableName]) {
               
               NSLog(@"表已经存在,增加字段");
               [self.database createTableAndIndexesOfName:tableName withClass:Message.class];
               
               
           }else {
             [self.database createTableAndIndexesOfName:tableName withClass:Message.class];
           }
       }
   }
    
    //WCDB提供了了对错误和性能的全局监控，可⽤用于调试错误和性能。
   //Error Monitor
   [WCTStatistics SetGlobalErrorReport:^(WCTError *error) {
       NSLog(@"[WCDB]%@", error);
   }];
    
    
   //Performance Monitor
   [WCTStatistics SetGlobalPerformanceTrace:^(WCTTag tag, NSDictionary<NSString *, NSNumber *> *sqls, NSInteger cost) {
   NSLog(@"Database with tag:%d", tag);
   NSLog(@"Run :");
   [sqls enumerateKeysAndObjectsUsingBlock:^(NSString *sqls, NSNumber *count, BOOL *) {
   NSLog(@"SQL %@ %@ times", sqls, count);
   }];
   NSLog(@"Total cost %lld nanoseconds", cost); }];
    
    
    
   //SQL Execution Monitor
   [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) { NSLog(@"SQL: %@", sql);
   }];
    
    
    
//    开发者需要在数据库未损坏时，对数据库元信息定时进⾏行行备份
   NSData *backupPassword = [@"MyBackupPassword" dataUsingEncoding:NSASCIIStringEncoding]; [self.database backupWithCipher:backupPassword];
    
    
    
}

#pragma mark ———插⼊
- (IBAction)charu:(id)sender {
    Message *message = [[Message alloc] init];
    message.localID = 3;
    message.content = @"Hello, WCDB!";
//    message.contentxxx = @"修改!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    [self.database insertObject:message  into:@"message"];
    
}
#pragma mark ———插⼊ 事务(Transaction)
- (IBAction)charuTransaction:(id)sender {
    Message *message = [[Message alloc] init];
    message.localID = 6;
    message.content = @"Hello, 1顶顶顶顶!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    
    //这种⽅方式要求数据库操作在⼀一个BLOCK内完成，简单易易⽤用。
//   BOOL commited = [self.database runTransaction:^BOOL {
//   [self.database insertObject:message into:@"message"];
//       return YES; //return YES to commit transaction and return NO to rollback transaction.
//   }];
    
    
    //WCTTransaction 对象可以在类或函数间传递，因此这种⽅方式也更更具灵活性。
   WCTTransaction *transaction = [self.database getTransaction];
    BOOL result = [transaction begin];
   [transaction insertObject:message into:@"message"];
    result = [transaction commit];
   if (!result) {
   [transaction rollback]; NSLog(@"%@", [transaction error]); }
}

- (IBAction)AutoIncrement:(id)sender {
    Message *object = [[Message alloc] init];
    object.isAutoIncrement = YES;
   object.content = @"Insert auto increment";
   [self.database insertObject:object into:@"message"];
   long long lastInsertedRowID = object.lastInsertedRowID;
}

#pragma mark ———查询
- (IBAction)chaxun:(id)sender {
    //SELECT * FROM message ORDER BY localID
    NSArray<Message *> * message = [self.database getObjectsOfClass:Message.class fromTable:@"message" orderBy:Message.localID.order()];
    Message *messageOne = message[0];
    NSLog(@">>>> %@",messageOne);
    
    NSArray<Message *> * xxx = [self.database getObjectsOfClass:Message.class fromTable:@"message" limit:1];
    
//    limit y 分句表示: 读取 y 条数据
//    limit x, y 分句表示: 跳过 x 条数据，读取 y 条数据\
//    limit y offset x 分句表示: 跳过 x 条数据，读取 y 条数据
    
    
   WCTTable *table = [self.database getTableOfName:@"message" withClass:Message.class];
   //查询
//   SELECT * FROM message ORDER BY localID
    NSArray<Message *> *message2 = [table getObjectsOrderBy:Message.localID.order()];
    
}
#pragma mark ——— WCDB语⾔言集成查询

- (IBAction)WINQ:(id)sender {
    /*
    SELECT MAX(createTime), MIN(createTime)
    FROM message
    WHERE localID>0 AND content IS NOT NULL
    */
     NSArray<Message *> * message1 = [self.database getObjectsOnResults:{Message.createTime.max(), Message.createTime.min()}
    fromTable:@"message"
    where:Message.localID > 0 && Message.content.isNotNull()];
     
     
     
    /*
    SELECT DISTINCT localID
    FROM message
    ORDER BY modifiedTime ASC
    LIMIT 10
    */
     NSArray<Message *> * message2 = [self.database getObjectsOnResults:Message.localID.distinct() fromTable:@"message" orderBy:Message.modifiedTime.order(WCTOrderedAscending) limit:10];
     
     
    /*
    DELETE FROM message
    WHERE localID BETWEEN 10 AND 20 OR content LIKE 'Hello%' */
//     BOOL isDelete = [self.database deleteObjectsFromTable:@"message" where: Message.localID.between(10, 20)
//      || Message.content.like("Hello%")];
    
    
   /*
   SELECT localID, content
   FROM message
   */
    NSArray<Message *> * message3 = [self.database getAllObjectsOnResults:{Message.localID, Message.content} fromTable:@"message"];
    
    
   /*
   SELECT *
   FROM message
   ORDER BY createTime ASC, localID DESC
   */
    NSArray<Message *> * message4 = [self.database getObjectsOfClass:Message.class fromTable:@"message" orderBy:{Message.createTime.order(WCTOrderedAscending),
   Message.localID.order(WCTOrderedDescending)}];
    
    
    
   /*
   SELECT localID, content, createTime, modifiedTime
   FROM message
   */
    NSArray<Message *> * message5 = [self.database getAllObjectsOnResults:Message.AllProperties fromTable:@"message"];
    
    
    
   /*
   SELECT count(*)
   FROM message
   */
    NSNumber *nunber = [self.database getOneValueOnResult:Message.AnyProperty.count() fromTable:@"message"];
}

#pragma mark ———修改
- (IBAction)genxin:(id)sender {
    //UPDATE message SET content="Hello, Wechat!";
    Message *message = [[Message alloc] init];
    message.content = @"Hello, Wechat!";
        
    //下面这句在17号的时候和微信团队的人在学习群里面沟通过，这个方法确实是不存在的，使用教程应该会更新，要是没更新注意这个方法
    //BOOL result = [database updateTable:@"message" onProperties:Message.content withObject:message];
    [self.database updateAllRowsInTable:@"message" onProperty:Message.content withObject:message];
    
    
}
#pragma mark ———删除
- (IBAction)shanchu:(id)sender {
    [self.database deleteObjectsFromTable:@"message" where:Message.localID > 0];
}
//插⼊入
//   insertObject:into: 和 insertObjects:into: ，插⼊入单个或多个对象
//insertOrReplaceObject:into 和 insertOrReplaceObjects:into ，插⼊入单个或多个对象。 当对象的主键在数据库内已经存在时，更更新数据;否则插⼊入对象。
//insertObject:onProperties:into: 和 insertObjects:onProperties:into: ，插⼊入单个或 多个对象的部分属性
//insertOrReplaceObject:onProperties:into 和
//insertOrReplaceObjects:onProperties:into ，插⼊入单个或多个对象的部分属性。当对象的 主键在数据库内已经存在时，更更新数据;否则插⼊入对象。
//        删除
//更更新
//deleteAllObjectsFromTable: 删除表内的所有数据
//deleteObjectsFromTable: 后可组合接 where 、 orderBy 、 limit 、 offset 以删除部分数据
//      updateAllRowsInTable:onProperties:withObject: ，通过object更更新数据库中所有指定列列 的数据
//updateRowsInTable:onProperties:withObject: 后可组合接
//where 、 orderBy 、 limit 、 offset 以通过object更更新指定列列的部分数据 updateAllRowsInTable:onProperty:withObject: ，通过object更更新数据库某⼀一列列的数据 updateRowsInTable:onProperty:withObject: 后可组合接
//where 、 orderBy 、 limit 、 offset 以通过object更更新某⼀一列列的部分数据 updateAllRowsInTable:onProperties:withRow: ，通过数组更更新数据库中的所有指定列列的数
//据
//updateRowsInTable:onProperties:withRow: 后可组合接
//where 、 orderBy 、 limit 、 offset 以通过数组更更新指定列列的部分数据 updateAllRowsInTable:onProperty:withRow: ，通过数组更更新数据库某⼀一列列的数据
//
//updateRowsInTable:onProperty:withRow: 后可组合接
//where 、 orderBy 、 limit 、 offset 以通过数组更更新某⼀一列列的部分数
//查找
//     getOneObjectOfClass:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库 中取出⼀一⾏行行数据并组合成object
//getOneObjectOnResults:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据 库中取出⼀一⾏行行数据的部分列列并组合成object
//getOneRowOnResults:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库 中取出⼀一⾏行行数据的部分列列并组合成数组
//getOneColumnOnResult:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据 库中取出⼀一列列数据并组合成数组
//getOneDistinctColumnOnResult:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库中取出⼀一列列数据，并取distinct后组合成数组。
//getOneValueOnResult:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库 中取出⼀一⾏行行数据的某⼀一列列
//getAllObjectsOfClass:fromTable: ，取出所有数据，并组合成object
//getObjectsOfClass:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库中 取出⼀一部分数据，并组合成object
//getAllObjectsOnResults:fromTable: ，取出所有数据的指定列列，并组合成object
//getObjectsOnResults:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库 中取出⼀一部分数据的指定列列，并组合成object
//getAllRowsOnResults:fromTable: ，取出所有数据的指定列列，并组合成数组
//getRowsOnResults:fromTable: 后可接 where 、 orderBy 、 limit 、 offset 以从数据库中取 出⼀一部分数据的指定列列，并组合成数组
@end
