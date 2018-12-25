//
//  getCaseInvestigate.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "getCaseInvestigate.h"
@implementation getCaseInvestigate

-(void)downLoadCaseInvestigate{
    WebServiceInit;
    [service downloadDataSet:@"select  * from CaseInvestigate  where record_create_time >= dateadd(day,-365,GETDATE())"];
}
//select  * from CaseInvestigate  where record_create_time >= dateadd(day,-365,GETDATE())
- (void)xmlParser:(NSString *)webString{
    [self autoParserForOldDataModel:@"CaseInvestigate" andInXMLString:webString];
}

@end