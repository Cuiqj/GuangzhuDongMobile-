//
//  getCaseMap.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseMap.h"
@implementation getCaseMap

-(void)downLoadCaseMap{
    WebServiceInit;
    [service downloadDataSet:@" select  * from CaseMap  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from CaseMap  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseMap" andInXMLString:webString];
}

@end