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
   NSData *password = [@"MyPassword" dataUsingEncoding:NSASCIIStringEncoding];
   [self.database setCipherKey:password];
   //测试数据库是否能够打开
   if ([self.database canOpen]) {
       
       // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
       // 先判断表是不是已经存在
       if ([self.database isOpened]) {
           
           if ([self.database isTableExists:tableName]) {
               
               NSLog(@"表已经存在");
               
           }else {
             [self.database createTableAndIndexesOfName:tableName withClass:Message.class];
           }
       }
   }
}


- (IBAction)charu:(id)sender {
    Message *message = [[Message alloc] init];
    message.localID = 2;
    message.content = @"Hello, WCDB!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    [self.database insertObject:message  into:@"message"];
    
}
- (IBAction)chaxun:(id)sender {
    //SELECT * FROM message ORDER BY localID
    NSArray<Message *> * message = [self.database getObjectsOfClass:Message.class fromTable:@"message" orderBy:Message.localID.order()];
    Message *messageOne = message[0];
    NSLog(@">>>> %@",messageOne);
    
    NSArray<Message *> * xxx = [self.database getObjectsOfClass:Message.class fromTable:@"message" limit:1];
    
//    limit y 分句表示: 读取 y 条数据
//    limit x, y 分句表示: 跳过 x 条数据，读取 y 条数据\
//    limit y offset x 分句表示: 跳过 x 条数据，读取 y 条数据
    
}
- (IBAction)genxin:(id)sender {
    //UPDATE message SET content="Hello, Wechat!";
    Message *message = [[Message alloc] init];
    message.content = @"Hello, Wechat!";
        
    //下面这句在17号的时候和微信团队的人在学习群里面沟通过，这个方法确实是不存在的，使用教程应该会更新，要是没更新注意这个方法
    //BOOL result = [database updateTable:@"message" onProperties:Message.content withObject:message];
    [self.database updateAllRowsInTable:@"message" onProperty:Message.content withObject:message];
    
    
}
- (IBAction)shanchu:(id)sender {
    [self.database deleteObjectsFromTable:@"message" where:Message.localID > 0];
}

@end
