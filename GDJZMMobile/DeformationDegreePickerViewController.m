//
//  DeformationDegreePickerViewController.m
//  GDJZMMobile
//
//  Created by tiank on 16/8/16.
//
//

//#import <Foundation/Foundation.h>
#import "DeformationDegreePickerViewController.h"
//#import "CaseInfo.h"

@interface DeformationDegreePickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation DeformationDegreePickerViewController


- (void)viewWillAppear:(BOOL)animated{
    self.data=[Systype typeValueForCodeName:@"路产损坏描述"];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[_data objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    //NSString *userID=[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"];
    // [_delegate setDegree:myCell.textLabel.text ];
    [_pickerPopover dismissPopoverAnimated:YES];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
//    if (_pickerType==0) {
//        [_delegate setWeather:myCell.textLabel.text];
//    } else if (_pickerType==1) {
//        [_delegate setAuotMobilePattern:myCell.textLabel.text];
//    } else if (_pickerType==2) {
//        [_delegate setBadDesc:myCell.textLabel.text];
//    }   else if (_pickerType==3) {
//        [_delegate setPeccancyType:myCell.textLabel.text];
//    }else if (_pickerType==4) {
//        [_delegate setCaseType:myCell.textLabel.text];
//    }
//    else if (_pickerType==5) {
//        [_delegate setCaseType:myCell.textLabel.text];
//    }
//    [_pickerPopover dismissPopoverAnimated:YES];
//}

@end
