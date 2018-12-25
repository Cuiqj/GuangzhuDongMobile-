//
//  getCaseEnd.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseEnd.h"
@implementation getCaseEnd

-(void)downLoadCaseEnd{
    WebServiceInit;
    [service downloadDataSet:@" select  * from CaseEnd  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from CaseEnd  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseEnd" andInXMLString:webString];
}

@end