//
//  getProject.m
//  GDJZMMobile
//
//  Created by xiaoxiaojia on 16/8/4.
//
//
#import "getProject.h"
@implementation getProject

-(void)downLoadProject{
    WebServiceInit;
    [service downloadDataSet:@"select  * from Project  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from Project  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"Project" andInXMLString:webString];
}

@end