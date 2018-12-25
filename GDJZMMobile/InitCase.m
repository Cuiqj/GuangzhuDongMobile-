//
//  InitCase.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//

#import "InitCase.h"
@implementation InitCase

-(void)downLoadCase{
    WebServiceInit;
    [service downloadDataSet:@"select  * from CaseInfo  where record_create_time >= dateadd(day,-365,GETDATE()) order by record_create_time desc "];
    // select  * from CaseInfo  where DATEDIFF(DD,record_create_time,GETDATE())<=365
    
    //select  * from CaseInfo  where record_create_time >= dateadd(day,-365,GETDATE())
}

- (void)xmlParser:(NSString *)webString{
    //NSLog(webString.capitalizedString);
    [self autoParserForOldDataModel:@"CaseInfo" andInXMLString:webString];
}

@end
