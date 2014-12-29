//
//  DataPickerView.h
//  FSDataPickerView https://github.com/Ericfengshi/FSDataPickerView
//
//  Created by fengs on 14-12-23.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataPickerViewDelegate <NSObject>
@optional
/**
 * 选择器选择完成
 * @param rowArray :
    选择器视图 每组选中的索引集合
 * @return
 */
-(void)selectDataOfRowArray:(NSMutableArray *)rowArray;
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
-(NSString *)textOfRow:(NSInteger)row inComponent:(NSInteger)component rowArray:(NSMutableArray *)rowArray;
/**
 * 本组此索引下下一组的数据集合
 * @param rowArray :
    选择器视图 每组索引的集合
 * @param component :
    选择器视图 哪一组
 * @return NSMutableArray
 */
-(NSMutableArray*)arrayOfRowArray:(NSMutableArray *)rowArray inComponent:(NSInteger)component;
@end

@interface DataPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,retain) UIToolbar *toolBar;
@property (nonatomic,retain) UIView *pickView;
@property (nonatomic,retain) UIPickerView *pickViewList;
@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) NSMutableArray *rowArray;
@property (nonatomic,assign) int numberOfComponents;
/**
 * 初始化
 * @param size :
    长宽
 * @param title :
    标题
 * @param delegate :
    委托
 * @param numberOfComponents :
    组件个数
 * @return id(UIView)
 */
-(id)initWithSize:(CGSize)size title:(NSString*)title delegate:(id<DataPickerViewDelegate>)delegate numberOfComponents:(NSInteger)numberOfComponents;
/**
 * 数据加载
 * @param rowArray :
    选择器视图 每组索引的集合
 * @return
 */
-(void)viewLoad:(NSMutableArray*)rowArray;
/**
 * DataPickerView展现
 * @param view :
    调用页面的self.view
 * @return
 */
-(void)showInView:(UIView *)view;
@end