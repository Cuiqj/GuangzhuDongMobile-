//
//  getTask.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getTask.h"
@implementation getTask

-(void)downLoadTask{
    WebServiceInit;
    [service downloadDataSet:@"select  * from Task  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from Task  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"Task" andInXMLString:webString];
}

@end