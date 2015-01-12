//
//  DataPickerView.m
//  FSDataPickerView https://github.com/Ericfengshi/FSDataPickerView
//
//  Created by fengs on 14-12-23.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "DataPickerView.h"

@implementation DataPickerView
@synthesize window;
@synthesize shadowView = _shadowView;
@synthesize pickView = _pickView;
@synthesize toolBar = _toolBar;
@synthesize pickViewList = _pickViewList;
@synthesize delegate = _delegate;
@synthesize defaultRowArray = _defaultRowArray;
@synthesize rowArray = _rowArray;
@synthesize numberOfComponents = _numberOfComponents;
@synthesize selectComponent = _selectComponent;

-(void)dealloc
{
    [window release];
    self.shadowView = nil;
    self.pickView = nil;
    self.toolBar = nil;
    self.pickViewList = nil;
    self.rowArray = nil;
    self.defaultRowArray = nil;
	[super dealloc];
}

-(id)initWithTitle:(NSString*)title delegate:(id<DataPickerViewDelegate>)delegate numberOfComponents:(NSInteger)numberOfComponents{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.numberOfComponents = numberOfComponents;
        self.rowArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<self.numberOfComponents; i++) {
            [self.rowArray addObject:[NSNumber numberWithInt:0]];
        }
        
        self.defaultRowArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<self.numberOfComponents; i++) {
            [self.defaultRowArray addObject:[NSNumber numberWithInt:0]];
        }
        
        self.delegate = delegate;
        
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(window)]){
            window = [appDelegate performSelector:@selector(window)];
        }else{
            window = [[UIApplication sharedApplication] keyWindow];
        }
        
        self.shadowView = [[[UIView alloc] init] autorelease];

        self.pickView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,216+44)] autorelease];
		self.pickView.backgroundColor = [UIColor underPageBackgroundColor];
        
		self.toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)] autorelease];
		self.toolBar.barStyle = UIBarStyleDefault;
		
		UIBarButtonItem *titleButton = [[[UIBarButtonItem alloc] initWithTitle:title style: UIBarButtonItemStylePlain target: nil action: nil] autorelease];
		UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone)] autorelease];
		UIBarButtonItem *leftButton  = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(actionCancel)] autorelease];
		UIBarButtonItem *fixedButton  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil] autorelease];
		NSArray *array = [[[NSArray alloc] initWithObjects: leftButton,fixedButton, titleButton,fixedButton,rightButton, nil] autorelease];
		[self.toolBar setItems: array];
		[self.pickView addSubview:self.toolBar];
        
        UIPickerView *pickList = [[[UIPickerView alloc] initWithFrame:CGRectMake(0, self.toolBar.frame.size.height,[UIScreen mainScreen].applicationFrame.size.width,216)] autorelease];
        pickList.showsSelectionIndicator = YES;
        pickList.delegate = self;
        pickList.dataSource = self;
        self.pickViewList = pickList;
        [self.pickView addSubview:pickList];

		[self addSubview:self.pickView];
        
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.pickView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.pickView.frame.size.height)];
    }
    return self;
}

-(void)viewLoad:(NSMutableArray*)rowArray{
    
    if (rowArray.count>0) {
        self.rowArray = rowArray;
        self.defaultRowArray = [[rowArray mutableCopy] autorelease];
    }

    for (int i=0; i<self.numberOfComponents; i++) {
        int selectRow = 0;
        if (self.rowArray && self.rowArray.count > i) {
            selectRow = [[self.rowArray objectAtIndex:i] integerValue];
        }
        [self.pickViewList selectRow:selectRow inComponent:i animated:YES];
    }
    [self.pickViewList reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
    [self.rowArray replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    for (int i=component; i<self.numberOfComponents-1; i++) {
        [self.pickViewList selectRow:0 inComponent:i+1 animated:YES];
        [self.pickViewList reloadComponent:i+1];
        [self.rowArray replaceObjectAtIndex:i+1 withObject:[NSNumber numberWithInt:0]];
    }
}

#pragma mark -
#pragma mark Picker Date Source Methods

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)reusingView {
    
    UILabel *pickerLabel = (UILabel *)reusingView;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 200, 70);
        pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
        pickerLabel.textColor = [UIColor blackColor];
    }

    if ([self.delegate respondsToSelector:@selector(textOfRow:inComponent:rowArray:)]) {
        pickerLabel.text = [self.delegate textOfRow:row inComponent:component rowArray:self.rowArray];
    }
    return pickerLabel;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return self.rowArray.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([self.delegate respondsToSelector:@selector(arrayOfRowArray:inComponent:)]) {
        return [self.delegate arrayOfRowArray:self.rowArray inComponent:component-1].count;
    }else{
        return 0;
    }
}

-(void)actionDone
{
    if ([self.delegate respondsToSelector:@selector(selectDataOfRowArray:actionDone:)]) {
        [self.delegate selectDataOfRowArray:[[self.rowArray mutableCopy] autorelease] actionDone:YES];
    }
    
    [self hidePickerView];
}

-(void)actionCancel
{
    if ([self.delegate respondsToSelector:@selector(selectDataOfRowArray:actionDone:)]) {
        [self.delegate selectDataOfRowArray:[[self.defaultRowArray mutableCopy] autorelease] actionDone:NO];
    }
    [self hidePickerView];
}

// UIPicker显示
- (void)showInView
{
    [self.shadowView setFrame:window.frame];
    [window addSubview:self.shadowView];
    
    [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.pickView.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.pickView.frame.size.height)];
    [self.shadowView addSubview:self];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
    } completion:^(BOOL isFinished){
        
    }];
}

// UIPicker隐藏
-(void)hidePickerView
{
    [self.shadowView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){
        self.shadowView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL isFinished){
        [self.shadowView removeFromSuperview];
    }];
}
@end