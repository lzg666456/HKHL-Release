//
//  NotcificationController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/24.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "NotcificationController.h"
#import "NoticificationCell.h"
#import "MJRefresh.h"

@interface NotcificationController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSString *identy;
    NSDictionary *infoDic;
    NSInteger page;
    NSInteger topMJ;
}

@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,assign)NSInteger selectedRow;
@end

@implementation NotcificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的通知";
    
    self.selectedRow = -100;
    page = 1;
    topMJ = 2;
    _data = @[].mutableCopy;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-69) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    UIView *foot = [[UIView alloc]init];
    foot.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = foot;
    identy = @"notcification_cell";
    [_tableView registerNib:[UINib nibWithNibName:@"NoticificationCell" bundle:nil] forCellReuseIdentifier:identy];
    [self.view addSubview:_tableView];
    infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    [self _loadData];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        topMJ = 0;
        [weakSelf _loadData];
    }];
    [_tableView addLegendFooterWithRefreshingBlock:^{
        page = page + 1;
        topMJ = 1;
        [weakSelf _loadData];
    }];
}

- (void)_loadData {
    [DataService requestURL:[NSString stringWithFormat:@"%@getMassage",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"role_id":@"1",@"user_id":infoDic[@"promulgator_id"],@"p":@(page)} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil) {
            if ([result[@"err"] integerValue] == 0) {
                if (topMJ == 0) {
                    _data = [NSMutableArray array];
                }
                for (NSDictionary *diccc in result[@"message_list"]) {
                    [_data addObject:diccc];
                }
                [_tableView reloadData];
                
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
        [_tableView.legendFooter endRefreshing];
        [_tableView.legendHeader endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    cell.infoDic = _data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.selectedRow) {
        
        NSString *content = [_data[indexPath.row] objectForKey:@"content"];
        CGFloat labelWidth = self.view.width;
        
        NSDictionary *attrubutes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:17]
                                     };
        
        //计算文本的高度
        CGRect bounds = [content boundingRectWithSize:CGSizeMake(labelWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrubutes context:nil];
        
        return bounds.size.height+80;
    }
    
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedRow = indexPath.row;
    
    [tableView reloadData];
}


@end
