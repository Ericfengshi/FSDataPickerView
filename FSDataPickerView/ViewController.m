//
//  ViewController.m
//  FSDataPickerView
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,retain) NSMutableArray *oneComponentRowArray;
@property (nonatomic,retain) NSMutableArray *twoComponentRowArray;
@property (nonatomic,retain) NSMutableArray *threeComponentRowArray;
@property (nonatomic,assign) int textFieldTag;

@end

@implementation ViewController
@synthesize oneComponentTextField = _oneComponentTextField;
@synthesize oneComponentDataPicker = _oneComponentDataPicker;
@synthesize twoComponentTextField = _twoComponentTextField;
@synthesize twoComponentDataPicker = _twoComponentDataPicker;
@synthesize threeComponentTextField = _threeComponentTextField;
@synthesize threeComponentDataPicker = _threeComponentDataPicker;
@synthesize oneComponentRowArray = _oneComponentRowArray;
@synthesize twoComponentRowArray = _twoComponentRowArray;
@synthesize threeComponentRowArray = _threeComponentRowArray;
@synthesize textFieldTag = _textFieldTag;

-(void)dealloc{
    [_oneComponentTextField release];
    [_oneComponentDataPicker release];
    [_twoComponentTextField release];
    [_twoComponentDataPicker release];
    [_threeComponentTextField release];
    [_threeComponentDataPicker release];
    [_oneComponentRowArray release];
    [_twoComponentRowArray release];
    [_threeComponentRowArray release];
    [super dealloc];
}

- (void)viewDidUnload
{
    self.oneComponentTextField = nil;
    self.oneComponentTextField = nil;
    self.twoComponentTextField = nil;
    self.twoComponentDataPicker = nil;
    self.threeComponentTextField = nil;
    self.threeComponentDataPicker = nil;
    self.oneComponentRowArray = nil;
    self.twoComponentRowArray = nil;
    self.threeComponentRowArray = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"FSDataPickerView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.oneComponentRowArray = [[[NSMutableArray alloc] init] autorelease];
    self.twoComponentRowArray = [[[NSMutableArray alloc] init] autorelease];
    self.threeComponentRowArray = [[[NSMutableArray alloc] init] autorelease];
    
    self.oneComponentTextField = [[[UITextField alloc] initWithFrame:CGRectMake(30, 10, [UIScreen mainScreen].bounds.size.width-60, 30)] autorelease];
    self.oneComponentTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.oneComponentTextField.placeholder = @"省份";
    self.oneComponentTextField.delegate = self;
    self.oneComponentTextField.tag = 1;
    [self.view addSubview:self.oneComponentTextField];
    
    DataPickerView *oneComponentDataPicker = [[[DataPickerView alloc] initWithSize:CGSizeMake(320,280) title:@"省份" delegate:self numberOfComponents:1] autorelease];
    self.oneComponentDataPicker = oneComponentDataPicker;
    self.oneComponentRowArray = self.oneComponentDataPicker.rowArray;
    
    self.twoComponentTextField = [[[UITextField alloc] initWithFrame:CGRectMake(30, 50, [UIScreen mainScreen].bounds.size.width-60, 30)] autorelease];
    self.twoComponentTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.twoComponentTextField.placeholder = @"省份-城市";
    self.twoComponentTextField.delegate = self;
    self.twoComponentTextField.tag = 2;
    [self.view addSubview:self.twoComponentTextField];
    
    DataPickerView *twoComponentDataPicker = [[[DataPickerView alloc] initWithSize:CGSizeMake(320,280) title:@"省份-城市" delegate:self numberOfComponents:2] autorelease];
    self.twoComponentDataPicker = twoComponentDataPicker;
    self.twoComponentRowArray = self.twoComponentDataPicker.rowArray;
    
    self.threeComponentTextField = [[[UITextField alloc] initWithFrame:CGRectMake( 30, 90, [UIScreen mainScreen].bounds.size.width-60, 30)] autorelease];
    self.threeComponentTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.threeComponentTextField.placeholder = @"省份-城市-区县";
    self.threeComponentTextField.delegate = self;
    self.threeComponentTextField.tag = 3;
    [self.view addSubview:self.threeComponentTextField];
    
    DataPickerView *threeComponentDataPicker = [[[DataPickerView alloc] initWithSize:CGSizeMake(320,280) title:@"省份-城市-区县" delegate:self numberOfComponents:3] autorelease];
    self.threeComponentDataPicker = threeComponentDataPicker;
    self.threeComponentRowArray = self.threeComponentDataPicker.rowArray;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - DataPickerView Delegate
/**
 * 选择器选择完成
 * @param rowArray :
    选择器视图 每组选中的索引集合
 * @return
 */
-(void)selectDataOfRowArray:(NSMutableArray *)rowArray{
    NSMutableArray *provinceArray = [[Logic sharedInstance] getProvinceList];
    if (self.textFieldTag == 1) {
        int provinceRow = [[rowArray objectAtIndex:0] integerValue];
        NSString *province = [provinceArray objectAtIndex:provinceRow];
        
        self.oneComponentTextField.text = province;
        self.oneComponentRowArray = rowArray;
    }else if(self.textFieldTag == 2){
        
        int provinceRow = [[rowArray objectAtIndex:0] integerValue];
        NSString *province = [provinceArray objectAtIndex:provinceRow];
        NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
        int cityRow = [[rowArray objectAtIndex:1] integerValue];
        NSString *city = [cityArray objectAtIndex:cityRow];
        
        self.twoComponentTextField.text = [NSString stringWithFormat:@"%@-%@",province,city];
        self.twoComponentRowArray = rowArray;
    }else if(self.textFieldTag == 3){
        int provinceRow = [[rowArray objectAtIndex:0] integerValue];
        NSString *province = [provinceArray objectAtIndex:provinceRow];
        NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
        int cityRow = [[rowArray objectAtIndex:1] integerValue];
        NSString *city = [cityArray objectAtIndex:cityRow];
        NSMutableArray *townArray = [[Logic sharedInstance] getTownListByCity:city];
        int townRow = [[rowArray objectAtIndex:2] integerValue];
        NSString *town = [townArray objectAtIndex:townRow];
        
        self.threeComponentTextField.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,town];
        self.threeComponentRowArray = rowArray;
    }
}

/**
 * 本组此索引对应的内容
 * @param row :
    选择器视图 此组下的内容索引
 * @param component :
    选择器视图 哪一组
 * @param rowArray :
    选择器视图 每组索引的集合
 * @return NSString
 */
-(NSString *)textOfRow:(NSInteger)row inComponent:(NSInteger)component rowArray:(NSMutableArray *)rowArray{
    NSMutableArray *provinceArray = [[Logic sharedInstance] getProvinceList];
    if (self.textFieldTag == 1) {
        return [provinceArray objectAtIndex:row];
    }else if(self.textFieldTag == 2){
        if (component == 0) {
            return [provinceArray objectAtIndex:row];
        }else{// if(component == 1){
            int provinceRow = [[rowArray objectAtIndex:0] integerValue];
            NSString *province = [provinceArray objectAtIndex:provinceRow];
            NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
            NSString *city = [cityArray objectAtIndex:row];
            return city;
        }
    }else{// if(self.textFieldTag == 3){
        if (component == 0) {
            return [provinceArray objectAtIndex:row];
        }else if(component == 1){
            int provinceRow = [[rowArray objectAtIndex:0] integerValue];
            NSString *province = [provinceArray objectAtIndex:provinceRow];
            NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
            NSString *city = [cityArray objectAtIndex:row];
            return city;
        }else{
            int provinceRow = [[rowArray objectAtIndex:0] integerValue];
            NSString *province = [provinceArray objectAtIndex:provinceRow];
            NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
            int cityRow = [[rowArray objectAtIndex:1] integerValue];
            NSString *city = [cityArray objectAtIndex:cityRow];
            NSMutableArray *townArray = [[Logic sharedInstance] getTownListByCity:city];
            NSString *town = [townArray objectAtIndex:row];
            return town;
        }

    }
}

/**
 * 本组此索引下下一组的数据集合
 * @param rowArray :
    选择器视图 每组索引的集合
 * @param component :
    选择器视图 哪一组
 * @return NSMutableArray
 */
-(NSMutableArray*)arrayOfRowArray:(NSMutableArray *)rowArray inComponent:(NSInteger)component {
    NSMutableArray *provinceArray = [[Logic sharedInstance] getProvinceList];
    if (self.textFieldTag == 1) {
        return provinceArray;
    }else if(self.textFieldTag == 2){
        if (component == -1) {
            return provinceArray;
        }else{//component == 0
            int provinceRow = [[rowArray objectAtIndex:component] integerValue];
            NSString *province = [provinceArray objectAtIndex:provinceRow];
            NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
            return cityArray;
        }
        
    }else{// if(self.textFieldTag == 3){
        if (component == -1) {
            return provinceArray;
        }else if(component == 0){
            int provinceRow = [[rowArray objectAtIndex:component] integerValue];
            NSString *province = [provinceArray objectAtIndex:provinceRow];
            NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
            return cityArray;
        }else{//component == 1
            int provinceRow = [[rowArray objectAtIndex:0] integerValue];
            NSString *province = [provinceArray objectAtIndex:provinceRow];
            NSMutableArray *cityArray = [[Logic sharedInstance] getCityListByProvince:province];
            int cityRow = [[rowArray objectAtIndex:1] integerValue];
            NSString *city = [cityArray objectAtIndex:cityRow];
            NSMutableArray *townArray = [[Logic sharedInstance] getTownListByCity:city];
            return townArray;
        }
    }
}

#pragma mark -
#pragma mark -textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.textFieldTag = textField.tag;
    if (textField.tag == 1) {

        [self.oneComponentDataPicker viewLoad:self.oneComponentRowArray];
        [self.oneComponentDataPicker showInView:self.view];

    }else if(textField.tag == 2){
        
        [self.twoComponentDataPicker viewLoad:self.twoComponentRowArray];
        [self.twoComponentDataPicker showInView:self.view];
    }else if(textField.tag == 3){
        
        [self.threeComponentDataPicker viewLoad:self.threeComponentRowArray];
        [self.threeComponentDataPicker showInView:self.view];
    }
    return NO;
}
@end
