//
//  AtonementNoticePrintViewController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-11-29.
//
//

#import "AtonementNoticePrintViewController.h"
#import "AtonementNotice.h"
#import "CaseDeformation.h"
#import "CaseProveInfo.h"
#import "Citizen.h"
#import "CaseInfo.h"
#import "RoadSegment.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "NSNumber+NumberConvert.h"
#import "Systype.h"
#import "MatchLaw.h"
#import "MatchLawDetails.h"
#import "LawItems.h"
#import "LawbreakingAction.h"
#import "Laws.h"
#import "FileCode.h"
#import "NSAttributedString+DrawMethod.h"
#import "DateSelectController.h"
#import "ListSelectViewController.h"

@interface AtonementNoticePrintViewController ()
@property (nonatomic,retain) AtonementNotice *notice;

//- (void)generateDefaultsForNotice:(AtonementNotice *)notice;
@end

@implementation AtonementNoticePrintViewController
@synthesize labelCaseCode     = _labelCaseCode;
@synthesize textParty         = _textParty;
@synthesize textPartyAddress  = _textPartyAddress;
@synthesize textCaseReason    = _textCaseReason;
@synthesize textOrg           = _textOrg;
@synthesize textViewCaseDesc  = _textViewCaseDesc;
@synthesize textWitness       = _textWitness;
@synthesize textViewPayReason = _textViewPayReason;
@synthesize textPayMode       = _textPayMode;
@synthesize textCheckOrg      = _textCheckOrg;
@synthesize labelDateSend     = _labelDateSend;
@synthesize textBankName      = _textBankName;
@synthesize caseID            = _caseID;
@synthesize notice            = _notice;

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:@"AtonementNoticeTable"];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 1330);
    /*modify by lxm 不能实时更新*/
    if (![self.caseID isEmpty]) {
        NSArray *noticeArray = [AtonementNotice AtonementNoticesForCase:self.caseID];
        if (noticeArray.count>0) {
            self.notice = [noticeArray objectAtIndex:0];
        } else {
            self.notice             = [AtonementNotice newDataObjectWithEntityName:@"AtonementNotice"];
            self.notice.caseinfo_id = self.caseID;
            [self generateDefaultsForNotice:self.notice];
            [[AppDelegate App] saveContext];
        }
//        [self generateDefaultsForNotice:self.notice];
        [self loadPageInfo];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabelCaseCode:nil];
    [self setTextParty:nil];
    [self setTextPartyAddress:nil];
    [self setTextCaseReason:nil];
    [self setTextOrg:nil];
    [self setTextViewCaseDesc:nil];
    [self setTextWitness:nil];
    [self setTextViewPayReason:nil];
    [self setTextPayMode:nil];
    [self setTextCheckOrg:nil];
    [self setLabelDateSend:nil];
    [self setNotice:nil];
    [self setTextBankName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)loadPageInfo{
    CaseInfo *caseInfo          = [CaseInfo caseInfoForID:self.caseID];
    self.labelCaseCode.text     = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第 %@ 号",caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.full_case_mark3];
    Citizen *citizen            = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" caseId:self.caseID];
    CaseProveInfo *proveInfo    = [CaseProveInfo proveInfoForCase:self.caseID];
    self.textParty.text         = citizen.party;
    self.textPartyAddress.text  = citizen.address;
    self.textCaseReason.text    = proveInfo.case_short_desc;
    self.textOrg.text           = self.notice.organization_id;
    self.textViewCaseDesc.text  = self.notice.case_desc;
    self.textWitness.text       = self.notice.witness;
    self.textViewPayReason.text = self.notice.pay_reason;
    
    NSArray *temp=[Citizen allCitizenNameForCase:self.caseID];
    NSArray *citizenList=[[temp valueForKey:@"automobile_number"] mutableCopy];
    
    double summary = 0.0;
    if (citizenList.count > 0) {
        NSArray *deformations = [CaseDeformation deformationsForCase:self.caseID forCitizen:[citizenList objectAtIndex:0]];
        summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    }
    NSNumber *sumNum      = @(summary);
    NSString *numString   = [sumNum numberConvertToChineseCapitalNumberString];
    self.textPayMode.text = [NSString stringWithFormat:@"路产损失费人民币%@（￥%.2f元）",numString,summary];
    
    self.textBankName.text         = [[Systype typeValueForCodeName:@"交款地点"] objectAtIndex:0];
    self.textCheckOrg.text         = self.notice.check_organization;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy     年      MM      月      dd      日"];
    self.labelDateSend.text = [dateFormatter stringFromDate:self.notice.date_send];
}

//我写的保存
- (void)pageSaveInfo{
    [self savePageInfo];
}
- (void)savePageInfo{
    self.notice.organization_id    = self.textOrg.text;
    self.notice.case_desc          = self.textViewCaseDesc.text;
    self.notice.pay_mode           = self.textPayMode.text;
    self.notice.pay_reason         = self.textViewPayReason.text;
    self.notice.check_organization = self.textCheckOrg.text;
    self.notice.witness            = self.textWitness.text;
    [[AppDelegate App] saveContext];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultsForNotice:self.notice];
    [self loadPageInfo];
}

//生成默认数据
- (void)generateDefaultsForNotice:(AtonementNotice *)notice{
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    if ([proveInfo.event_desc isEmpty] || proveInfo.event_desc == nil) {
        proveInfo.event_desc     = [CaseProveInfo generateEventDescForCase:self.caseID];
    }
    NSDateFormatter *codeFormatter = [[NSDateFormatter alloc] init];
    [codeFormatter setDateFormat:@"yyyyMM'0'dd"];
    [codeFormatter setLocale:[NSLocale currentLocale]];
    notice.code      = [codeFormatter stringFromDate:[NSDate date]];
    NSRange range    = [proveInfo.event_desc rangeOfString:@"于"];
    if (range.location != NSNotFound) {
        notice.case_desc = [proveInfo.event_desc substringFromIndex:range.location+1];
    }
    
    notice.witness            = @"现场照片、勘验检查笔录、询问笔录、现场勘验图";
    notice.check_organization = [[Systype typeValueForCodeName:@"复核单位"] objectAtIndex:0];
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    notice.organization_id    = [[OrgInfo orgInfoForOrgID:[UserInfo userInfoForUserID:currentUserID].organization_id] valueForKey:@"orgname"];
    
    Citizen *citizen        = [Citizen citizenForCitizenName:notice.citizen_name nexus:@"当事人" caseId:self.caseID];
    notice.citizen_name     = citizen.automobile_number;
    NSString *plistPath     = [[NSBundle mainBundle] pathForResource:@"MatchLaw" ofType:@"plist"];
    NSDictionary *matchLaws = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *payReason     = @"";
    if (matchLaws) {
        NSString *breakStr = @"";
        NSString *matchStr = @"";
        NSString *payStr   = @"";
        NSArray *lawids    = [proveInfo.case_desc_id componentsSeparatedByString:@"#"];
        NSString *lawid    = @"";
        if (lawids.count > 0){
            lawid = lawids[0];
        }
        NSDictionary *matchInfo = [[matchLaws objectForKey:@"case_desc_match_law"] objectForKey:lawid];
        if (matchInfo) {
            if ([matchInfo objectForKey:@"breakLaw"]) {
                breakStr = [(NSArray *)[matchInfo objectForKey:@"breakLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"matchLaw"]) {
                matchStr = [(NSArray *)[matchInfo objectForKey:@"matchLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"payLaw"]) {
                payStr = [(NSArray *)[matchInfo objectForKey:@"payLaw"] componentsJoinedByString:@"、"];
            }
        }
        
        payReason = [NSString stringWithFormat:@"%@%@，根据%@、并依照%@的规定，当事人应当承担民事责任，赔偿路产损失。", citizen.party, proveInfo.case_short_desc, matchStr, payStr];
        
    }
    notice.pay_reason = payReason;
   payReason = @"";
    if (matchLaws) {
        NSString *breakStr = @"";
        NSString *matchStr = @"";
        NSString *payStr = @"";
        NSArray *lawids    = [proveInfo.case_desc_id componentsSeparatedByString:@"#"];
        NSString *lawid    = @"";
        if (lawids.count > 0){
            lawid = lawids[0];
        }
        NSDictionary *matchInfo = [[matchLaws objectForKey:@"case_desc_match_law"] objectForKey:lawid];
        if (matchInfo) {
            if ([matchInfo objectForKey:@"breakLaw"]) {
                breakStr = [(NSArray *)[matchInfo objectForKey:@"breakLaw"] componentsJoinedByString:@"和"];
            }
            if ([matchInfo objectForKey:@"matchLaw"]) {
                matchStr = [(NSArray *)[matchInfo objectForKey:@"matchLaw"] componentsJoinedByString:@"、"];
            }
            if ([matchInfo objectForKey:@"payLaw"]) {
                payStr = [(NSArray *)[matchInfo objectForKey:@"payLaw"] componentsJoinedByString:@"、"];
            }
        }
        
        payReason = [NSString stringWithFormat:@"%@，根据%@，并依照%@", breakStr, matchStr, payStr];
        //payReason = [NSString stringWithFormat:@"%@，按照%@规定，并依照%@",  breakStr, matchStr, payStr];
        
    }
    notice.pay_reason = payReason;
    //    NSArray *deformations = [CaseDeformation deformationsForCase:self.caseID forCitizen:notice.citizen_name];
    //    double summary=[[deformations valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    //    NSNumber *sumNum = @(summary);
    //    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    //    notice.pay_mode = [NSString stringWithFormat:@"路产损失费人民币%@（￥%.2f元）",numString,summary];
    notice.date_send  = [NSDate date];
    [[AppDelegate App] saveContext];
}

/*test by lxm 无效*/
-(NSURL *)toFullPDFWithTable:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:@"AtonementNoticeTable"];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        
        //add by lxm 2013.05.08
        CaseInfo *caseInfo      = [CaseInfo caseInfoForID:self.caseID];
        self.labelCaseCode.text = [[NSString alloc] initWithFormat:@"(%@)年%@交赔字第0%@号",caseInfo.case_mark2, [[AppDelegate App].projectDictionary objectForKey:@"cityname"], caseInfo.full_case_mark3];
        Citizen *citizen        = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" caseId:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:citizen];
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:proveInfo];
        
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFullPDFWithPath_deprecated:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable1:@"AtonementNoticeTable"];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        
        //add by lxm 2013.05.08
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:caseInfo];
        
        Citizen *citizen = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" caseId:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:citizen];
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:proveInfo];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

-(NSURL *)toFormedPDFWithPath_deprecated:(NSString *)filePath{
    [self savePageInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect           = CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:self.notice];
        
        //add by lxm 2013.05.08
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:caseInfo];
        
        Citizen *citizen = [Citizen citizenForCitizenName:self.notice.citizen_name nexus:@"当事人" caseId:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:citizen];
        
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        [self drawDateTable:@"AtonementNoticeTable" withDataModel:proveInfo];
        
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

#pragma CasePrintProtocol
- (NSString *)templateNameKey
{
    return DocNameKeyPei_PeiBuChangTongZhiShu;
}

//获取打印到pdf的数据 对象
/*
 - (id)dataForPDFTemplate
 {
 id data            = @{};
 CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
 if (caseInfo) {
 NSString *caseMark2       = caseInfo.case_mark2;
 NSString *caseMark3       = caseInfo.full_case_mark3;
 NSString *casePrefix      = [[AppDelegate App].projectDictionary objectForKey:@"cityname"];
 NSString *partyName       = @"";
 NSString *partyAddress    = @"";
 NSString *caseReason      = @"";
 NSString *agency          = @"";
 NSString *caseDescription = @"";
 NSString *caseEvidence    = @"";
 NSString *payReason       = @"";
 NSString *payDetail       = @"";
 NSString *paymentPlace    = @"";
 NSString *reviewOrgan     = @"";
 
 NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSString *strDate = [dateFormatter stringFromDate:caseInfo.happen_date];
 
 NSArray * tempArr = [[NSArray alloc]initWithArray:[[strDate substringToIndex:10] componentsSeparatedByString:@"-"]];
 
 NSString *year = [tempArr objectAtIndex:0];
 
 NSString *month = [tempArr objectAtIndex:1];
 
 NSString *day = [tempArr objectAtIndex:2];
 
 [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
 NSDate *temp=[dateFormatter dateFromString:self.labelDateSend.text];
 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
 NSString *dateString=[dateFormatter stringFromDate:temp];
 NSArray * tempArr1 = [[NSArray alloc]initWithArray:[[dateString substringToIndex:10] componentsSeparatedByString:@"-"]];
 NSString *year1    = [tempArr1 objectAtIndex:0];
 
 NSString *month1 = [tempArr1 objectAtIndex:1];
 
 NSString *day1 = [tempArr1 objectAtIndex:2];
 
 
 
 NSArray *notices = [AtonementNotice AtonementNoticesForCase:self.caseID];
 if (notices.count > 0) {
 AtonementNotice *notice = [notices objectAtIndex:0];
 agency                  = NSStringNilIsBad(notice.organization_info);
 caseDescription         = NSStringNilIsBad(notice.case_desc);
 caseEvidence            = NSStringNilIsBad(notice.witness);
 payReason               = NSStringNilIsBad(notice.pay_reason);
 NSArray *paymentPlaces  = [Systype typeValueForCodeName:@"交款地点"];
 if (paymentPlaces.count > 0) {
 paymentPlace = [paymentPlaces objectAtIndex:0];
 }
 reviewOrgan = NSStringNilIsBad(notice.check_organization);
 
 Citizen *citizen = [Citizen citizenForCitizenName:notice.citizen_name nexus:@"当事人" caseId:self.caseID];
 if (citizen) {
 partyName    = NSStringNilIsBad(citizen.party);
 partyAddress = NSStringNilIsBad(citizen.address);
 
 NSArray *payments       = [CaseDeformation deformationsForCase:self.caseID forCitizen:citizen.automobile_number];
 NSNumber *paymentAll    = [payments valueForKeyPath:@"@sum.total_price.doubleValue"];
 NSString *paymentString = [paymentAll numberConvertToChineseCapitalNumberString];
 payDetail               = [NSString stringWithFormat:@"路产损失费人民币%@（￥%.2f元）", paymentString, paymentAll.doubleValue];
 }
 
 }
 
 
 CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
 if (proveInfo) {
 caseReason = proveInfo.case_short_desc;
 }
 
 NSString * agency1 = [[self subString:agency] objectAtIndex:0];
 
 NSString * agency2 = [[self subString:agency] objectAtIndex:1];
 
 NSString * tempPlace1 = [[self subString:paymentPlace] objectAtIndex:0];
 
 NSString * tempPlace2 = [[self subString:paymentPlace] objectAtIndex:1];
 data                  = @{
 @"caseMark2": caseMark2,
 @"caseMark3": caseMark3,
 @"casePrefix": casePrefix,
 @"partyName": partyName,
 @"partyAddress": partyAddress,
 @"caseReason": caseReason,
 @"agencyCity": NSStringNilIsBad(agency1),
 @"notCityOrTown": @(YES),
 @"agency": NSStringNilIsBad(agency2),
 @"caseDescription": caseDescription,
 @"caseEvidence": caseEvidence,
 @"payReason": payReason,
 @"payDetail": payDetail,
 @"paymentPlace1": NSStringNilIsBad(tempPlace1),
 @"paymentPlace2": NSStringNilIsBad(tempPlace2),
 @"reviewOrgan": reviewOrgan,
 @"year": year,
 @"month": month,
 @"day":day,
 @"year1": year1,
 @"month1": month1,
 @"day1":day1
 };
 }
 
 return data;
 }
 */
- (id)dataForPDFTemplate
{
    id data            = @{};
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo) {
        NSString *caseMark2       = caseInfo.case_mark2;
        NSString *caseMark3       = [NSString stringWithFormat:@"%@",caseInfo.case_mark3];
        NSString *casePrefix      = [FileCode fileCodeWithPredicateFormat :@"赔补偿案件编号"].organization_code;
        NSString *partyName       = @"";
        NSString *partyAddress    = @"";
        NSString *caseReason      = @"";
        NSString *agency          = @"";
        NSString *caseDescription = @"";
        NSString *caseEvidence    = @"";
        NSString *payReason       = @"";
        NSString *payDetail       = @"";
        NSString *paymentPlace    = @"";
        NSString *reviewOrgan     = @"";
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:caseInfo.happen_date];
        
        NSArray * tempArr = [[NSArray alloc]initWithArray:[[strDate substringToIndex:10] componentsSeparatedByString:@"-"]];
        
        NSString *year = [tempArr objectAtIndex:0];
        
        NSString *month = [tempArr objectAtIndex:1];
        
        NSString *day = [tempArr objectAtIndex:2];
        
        /*
         [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
         NSDate *temp=[dateFormatter dateFromString:self.labelDateSend.text];
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         NSString *dateString=[dateFormatter stringFromDate:temp];
         NSArray * tempArr1 = [[NSArray alloc]initWithArray:[[dateString substringToIndex:10] componentsSeparatedByString:@"-"]];
         NSString *year1    = [tempArr1 objectAtIndex:0];
         
         NSString *month1 = [tempArr1 objectAtIndex:1];
         
         NSString *day1 = [tempArr1 objectAtIndex:2];
         
         */
        NSString *year1    = year;
        
        NSString *month1 = month;
        
        NSString *day1 = day;
        NSArray *payReasonArray;
        NSArray *notices = [AtonementNotice AtonementNoticesForCase:self.caseID];
        if (notices.count > 0) {
            AtonementNotice *notice = [notices objectAtIndex:0];
            agency                  = NSStringNilIsBad(notice.organization_info);
            NSArray * temp=[notice.case_desc componentsSeparatedByString:@"分"];
            caseDescription=[temp objectAtIndex:1];
            //caseDescription = NSStringNilIsBad(notice.case_desc);
            
            caseEvidence   = NSStringNilIsBad(notice.witness);
            payReason      = NSStringNilIsBad(notice.pay_reason);
            //            NSArray * arr=[notice.pay_reason componentsSeparatedByString:@"根据"];
            //            NSString *strtem=[arr objectAtIndex:1];
            //            NSArray *arr2=[strtem componentsSeparatedByString:@"的规定"];
            //            payReason=[arr2 objectAtIndex:0];
            //            payReasonArray = [self pagesWithFont:payReason];
            //            NSArray *paymentPlaces = [Systype typeValueForCodeName:@"交款地点"];
            //            if (paymentPlaces.count > 0) {
            //                paymentPlace = [paymentPlaces objectAtIndex:0];
            //            }
            paymentPlace = self.textBankName.text;
            reviewOrgan  = NSStringNilIsBad(notice.check_organization);
            
            Citizen *citizen = [Citizen citizenForCitizenName:notice.citizen_name nexus:@"当事人" case:self.caseID];
            if (citizen) {
                partyName    = NSStringNilIsBad(citizen.party);
                partyAddress = NSStringNilIsBad(citizen.address);
                
                NSArray *payments       = [CaseDeformation deformationsForCase:self.caseID forCitizen:citizen.automobile_number];
                NSNumber *paymentAll    = [payments valueForKeyPath:@"@sum.total_price.doubleValue"];
                NSString *paymentString = [paymentAll numberConvertToChineseCapitalNumberString];
                payDetail               = [NSString stringWithFormat:@"路产损失费人民币%@（￥%.2f）", paymentString, paymentAll.doubleValue];
            }
            
        }
        //NSArray * temp=[self.textCaseReason.text componentsSeparatedByString:@"分"];
        //caseReason=[temp objectAtIndex:1];
        caseReason = NSStringNilIsBad(self.textCaseReason.text);
        
        data = @{
                 @"caseMark2": caseMark2,
                 @"caseMark3": caseMark3,
                 @"casePrefix": casePrefix,
                 @"partyName": partyName,
                 @"partyAddress": partyAddress,
                 @"caseReason": caseReason,
                 @"agencyCity": [[self subString2:agency] objectAtIndex:0],
                 @"agency":  agency ,
                 @"notCityOrTown": @(YES),
                 @"agency": [[self subString2:agency] objectAtIndex:1],
                 @"caseDescription": caseDescription,
                 @"caseEvidence": caseEvidence,
                 @"payReason": payReason,
                 @"payDetail": payDetail,
                 @"paymentPlace": paymentPlace,
                 @"reviewOrgan": reviewOrgan,
                 @"year": year,
                 @"month": month,
                 @"day":day,
                 @"year1": year1,
                 @"month1": month1,
                 @"day1":day1
                 //@"payReason1":payReason,
                 // @"payReason2":payReason
                 };
    }
    
    return data;
}

-(NSArray *) subString:(NSString *)str {
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    if (str != nil&& str.length>3){
        
        //从开始截取到指定索引字符   但不包含此字符  。
        NSString * tempStr1 = [str substringToIndex:str.length/2+1];
        
        //从指定字符串截取到末尾
        NSString * tempStr2 = [str substringFromIndex:str.length/2+1];
        
        [array addObject:tempStr1];
        
        [array addObject:tempStr2];
    }
    
    return array;
}
-(NSArray *) subString2:(NSString *)str {
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    if (str != nil){
        
        //从开始截取到指定索引字符   但不包含此字符  。
        NSString * tempStr1 = [str substringToIndex:str.length/2+1];
        
        //从指定字符串截取到末尾
        NSString * tempStr2 = [str substringFromIndex:str.length/2+1];
        
        [array addObject:tempStr1];
        
        [array addObject:tempStr2];
    }
    
    return array;
}

//将文本分页，可定义第一页和后续页大小，及整体行高
- (NSArray *)pagesWithFont:(NSString*)content{
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *test1       = @"测试";
    
    
    UIFont *font = [UIFont fontWithName:FONT_FangSong size:10];
    
    
    CGFloat x        = 27;
    CGFloat y        = 147;
    CGFloat width    = 525                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ;
    CGFloat height   = 42;
    CGRect page1Rect = CGRectMake(x, y, width, height);
    
    
    
    
    
    
    //设置行高
    CGFloat lineSpace = 0;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec      = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    lineSpaceStyle.value     = &lineSpace;
    
    //设置对齐方式
    CTTextAlignment coreTextAlignment = kCTTextAlignmentLeft;
    
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec      = kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.value     = &coreTextAlignment;
    alignmentStyle.valueSize = sizeof(CTTextAlignment);
    
    CTParagraphStyleSetting settings[2] = {lineSpaceStyle, alignmentStyle};
    CTParagraphStyleRef style           = CTParagraphStyleCreate(settings, sizeof(settings));
    
    
    CTFontRef fontRef      = CTFontCreateWithName((__bridge CFStringRef)(font.fontName), font.pointSize, nil);
    NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style, (__bridge id)kCTFontAttributeName : (__bridge id)fontRef };
    
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:content attributes:attriDic];
    CFRange currentRange                = CFRangeMake(0, 0);
    
    currentRange         = [attributeString rangeInRect:page1Rect withTextRange:currentRange];
    NSString *subcontent = [content substringWithRange:NSMakeRange(currentRange.location, currentRange.length)];
    [pages addObject:subcontent];
    [pages addObject:[content substringFromIndex:subcontent.length ]];
    return pages;
}

@end
