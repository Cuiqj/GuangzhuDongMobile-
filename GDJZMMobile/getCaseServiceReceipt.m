//
//  getCaseServiceReceipt.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseServiceReceipt.h"
@implementation getCaseServiceReceipt

-(void)downLoadCaseServiceReceipt{
    WebServiceInit;
    [service downloadDataSet:@"select  * from CaseServiceReceipt  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from CaseServiceReceipt  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseServiceReceipt" andInXMLString:webString];
}

@end