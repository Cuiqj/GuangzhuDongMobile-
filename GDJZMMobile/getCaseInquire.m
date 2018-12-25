//
//  getCaseInquire.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseInquire.h"
@implementation getCaseInquire

-(void)downLoadCaseInquire{
    WebServiceInit;
    [service downloadDataSet:@" select  * from CaseInquire  where record_create_time >= dateadd(day,-365,GETDATE()) "];
}
//select  * from CaseInquire  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseInquire" andInXMLString:webString];
}

@end