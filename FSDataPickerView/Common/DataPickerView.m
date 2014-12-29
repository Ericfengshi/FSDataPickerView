//
//  DataPickerView.m
//  FSDataPickerView https://github.com/Ericfengshi/FSDataPickerView
//
//  Created by fengs on 14-12-23.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "DataPickerView.h"

@implementation DataPickerView

@synthesize pickView = _pickView;
@synthesize toolBar = _toolBar;
@synthesize pickViewList = _pickViewList;
@synthesize delegate = _delegate;
@synthesize rowArray = _rowArray;
@synthesize numberOfComponents = _numberOfComponents;

-(void)dealloc
{
    self.pickView = nil;
    self.toolBar = nil;
    self.pickViewList = nil;
    self.rowArray = nil;
	[super dealloc];
}

-(id)initWithSize:(CGSize)size title:(NSString*)title delegate:(id<DataPickerViewDelegate>)delegate numberOfComponents:(NSInteger)numberOfComponents{
    self = [super init];
    if (self) {
        self.numberOfComponents = numberOfComponents;
        self.rowArray = [[[NSMutableArray alloc] init] autorelease];
        for (int i=0; i<self.numberOfComponents; i++) {
            [self.rowArray addObject:[NSNumber numberWithInt:0]];
        }

        self.delegate = delegate;

        self.pickView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width,size.height)] autorelease];
		self.pickView.backgroundColor = [UIColor underPageBackgroundColor];
        
		self.toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, size.width, 44)] autorelease];
		self.toolBar.barStyle = UIBarStyleDefault;
		
		UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:title style: UIBarButtonItemStylePlain target: nil action: nil];
		UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(actionDone)];
		UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStyleBordered target: self action: @selector(actionCancel)];
		UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
		NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton, titleButton,fixedButton,rightButton, nil];
		[self.toolBar setItems: array];
		
		[titleButton release];
		[leftButton  release];
		[rightButton release];
		[fixedButton release];
		[array       release];
		[self.pickView addSubview:self.toolBar];
        
        UIPickerView *pickList = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44,size.width,size.height-44)];
        pickList.showsSelectionIndicator = YES;//在当前选择上显示一个透明窗口
        pickList.delegate = self;
        pickList.dataSource = self;
        self.pickViewList = pickList;
        [self.pickView addSubview:pickList];
        [pickList release];
        [self setFrame:self.pickView.frame];
		[self addSubview:self.pickView];
    }
    return self;
}

-(void)viewLoad:(NSMutableArray*)rowArray{
    
    if (rowArray) {
        self.rowArray = rowArray;
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
    if ([self.delegate respondsToSelector:@selector(selectDataOfRowArray:)]) {
        [self.delegate selectDataOfRowArray:self.rowArray];
    }
    
    [self hidePickerView];
}

-(void)actionCancel
{
    [self hidePickerView];
}

- (void)showInView:(UIView *)view
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        // 添加阴影
        UIView *shadowView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        shadowView.userInteractionEnabled = NO;
        shadowView.tag = 1024;
        [view addSubview:shadowView];
        [view bringSubviewToFront:shadowView];
        // 添加UIPickerView
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.pickView.frame.size.height, [UIScreen mainScreen].bounds.size.width , self.pickView.frame.size.height)];
        [view addSubview:self];
        [view bringSubviewToFront:self];
        // navigationItem 禁用
        UIViewController *viewController = [self viewController];
        viewController.navigationItem.leftBarButtonItem.enabled = NO;
        viewController.navigationItem.rightBarButtonItem.enabled = NO;
        // 除了UIPickerView外 禁用
        for (UIView *subView in [view subviews]) {
            if (![self isEqual:subView]) {
                subView.userInteractionEnabled = NO;
            }
        }
    } completion:^(BOOL isFinished){
        
    }];
}

-(void)hidePickerView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        // 去掉阴影，去掉禁用
        for (UIView *subView in [[self superview] subviews]) {
            if (subView.tag == 1024) {
                [subView removeFromSuperview];
            }else{
                subView.userInteractionEnabled = YES;
            }
        }
        // UIPickerView隐藏
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //  navigationItem可用
        UIViewController *viewController = [self viewController];
        viewController.navigationItem.leftBarButtonItem.enabled = YES;
        viewController.navigationItem.rightBarButtonItem.enabled = YES;
        
    } completion:^(BOOL isFinished){
        
    }];
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

@end