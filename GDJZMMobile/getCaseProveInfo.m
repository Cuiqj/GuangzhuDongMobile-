//
//  getCaseProveInfo.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseProveInfo.h"
@implementation getCaseProveInfo

-(void)downLoadCaseProveInfo{
    WebServiceInit;
    [service downloadDataSet:@"select  * from CaseProveInfo  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from CaseProveInfo  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseProveInfo" andInXMLString:webString];
}

@end