//
//  SelfCenterController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/30.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "SelfCenterController.h"
#import "SelfCenterCell.h"
#import "LoginController.h"
#import "SelectedCell.h"
#import "Utility.h"
#import "UIImageView+WebCache.h"
#import "ChangePhoneController.h"

@interface SelfCenterController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate> {
    NSArray *data;
    NSString *identy;
    UIView *view;
    UITapGestureRecognizer *tap;
    UIView *selectView;
    UIImageView *imgView;
    UIView *garyView;
    
    
    UITableView *officeSelect;
    UITableView *proTitleSelect;
    UITableView *hospitalSelect;
    UITableView *citySelect;
    
    NSArray *officeArray;//科室
    NSArray *proTitleArray;//职称
    NSArray *cityArray;
    NSArray *hospitalArray;
    
    UIButton *leftButton;
    NSMutableArray *msgArray;//信息数据数组1
    NSMutableArray *msgArray1;//信息数据数组2
    NSArray *reArray;//备用数组1
    NSArray *reArray1;//备用数组2
    
    NSDictionary *dic;
    
    UIImage *iconIMG;
    
    NSDictionary *info1;
    
    NSString *cityID;
    NSString *hospitalID;
    NSString *proTitalID;
    NSString *officeID;
    
    NSInteger errorID;
}

@end

@implementation SelfCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    dic = [[NSUserDefaults standardUserDefaults] objectForKey:selfMSGKey];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePhone:) name:changePhoneNoticifition object:nil];
    
    [self _loadData];
    data = @[@[@"用  户  名:",@"性       别:",@"手  机  号:",@"身份证号:"],@[@"就职城市:",@"就职医院:",@"科       室:",@"职       称:",@"从业年限:"]];
    identy = @"selfCenter_cell";
    
    hospitalID = @"";
    officeID = @"";
    cityID = @"";
    proTitalID = @"";

    garyView = [[UIView alloc]initWithFrame:self.view.bounds];
    garyView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    garyView.hidden = YES;
    [self.view addSubview:garyView];
    
    preserveButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    exitButton.backgroundColor = [UIColor colorWithRed:0.298f green:0.514f blue:0.910f alpha:1.00f];
    
    UINib *nib = [UINib nibWithNibName:@"SelfCenterCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:identy];
    _tableView.allowsSelection = NO;
    preserveButton.hidden = YES;
    
    
    leftButton = [[UIButton alloc]init];
    [leftButton setTitle:@"编辑" forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton addTarget:self action:@selector(alterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"取消" forState:UIControlStateSelected];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.rightBarButtonItem = leftItem;
    
    selectView = [[UIView alloc]init];
    selectView.hidden = YES;
    selectView.backgroundColor = [UIColor grayColor];
    selectView.alpha = 0.95;
    selectView.frame = CGRectMake(0, self.view.height-150, self.view.width, 150);
    [self.view addSubview:selectView];
    

}

- (void)_loadData {
    msgArray = [[NSMutableArray alloc]initWithArray:@[@" ",@"男",@"13107311122",@" "]];
    msgArray1 = [[NSMutableArray alloc]initWithArray:@[@" ",@" ",@" ",@" ",@" "]];
    [DataService requestURL:[NSString stringWithFormat:@"%@getPromulgatorInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        info1 = result[@"info"];
        NSString *username = info1[@"username"];
        [msgArray replaceObjectAtIndex:0 withObject:username];
        NSString *gender;
        if ([info1[@"gender"] integerValue] == 0) {
            gender = @"男";
        }
        else {
            gender = @"女";
        }
        [msgArray replaceObjectAtIndex:1 withObject:gender];
        NSString *phone = info1[@"phone"];
        [msgArray replaceObjectAtIndex:2 withObject:phone];
        NSString *idcard = info1[@"idcard"];
        if (idcard == nil) {
            idcard = @" ";
        }
        [msgArray replaceObjectAtIndex:3 withObject:idcard];
        if (![info1[@"city_name"] isKindOfClass:[NSNull class]]) {
            NSString *city_name = info1[@"city_name"];
            [msgArray1 replaceObjectAtIndex:0 withObject:city_name];
        }
        
        if (![info1[@"hospital_name"] isKindOfClass:[NSNull class]])
        {
            NSString *hospital_name = info1[@"hospital_name"];
            [msgArray1 replaceObjectAtIndex:1 withObject:hospital_name];
        }
        if (![info1[@"department_name"] isKindOfClass:[NSNull class]]) {
            
            NSString *department_name = info1[@"department_name"];
            [msgArray1 replaceObjectAtIndex:2 withObject:department_name];
        }
        if (![info1[@"jobtitle_name"] isKindOfClass:[NSNull class]]) {
            
            
            NSString *jobtitle_name = info1[@"jobtitle_name"];
            [msgArray1 replaceObjectAtIndex:3 withObject:jobtitle_name];
        }
        NSString *expe = [NSString stringWithFormat:@"%@年",info1[@"experience"]];
        [msgArray1 replaceObjectAtIndex:4 withObject:expe];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,info1[@"avatar"]]]];
        [_tableView reloadData];


        reArray = [NSArray arrayWithArray:msgArray];
        reArray1 = [NSArray arrayWithArray:msgArray1];
        
    }];
}

#pragma mark 修改按钮
- (void)alterButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected == NO) {
        preserveButton.hidden = YES;
        _tableView.allowsSelection = NO;
        [view removeGestureRecognizer:tap];
        NSRange range = {0,3};
        [msgArray replaceObjectsInRange:range withObjectsFromArray:reArray];
        [msgArray1 replaceObjectsInRange:range withObjectsFromArray:reArray1];
        [_tableView reloadData];
        garyView.hidden = YES;
    }
    else {
        preserveButton.hidden = NO;
         _tableView.allowsSelection = YES;
         tap = [[UITapGestureRecognizer alloc]initWithTarget:self action: @selector(headViewClick)];
         tap.numberOfTapsRequired = 1;
         [view addGestureRecognizer:tap];
    }
}

//修改头像
- (void)headViewClick {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从相册选取", nil];
    [sheet showInView:self.view];
}


#pragma mark actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 200) {
        if (buttonIndex == 0) {//男
            [msgArray replaceObjectAtIndex:1 withObject:@"男"];
            [_tableView reloadData];
        }
        else if (buttonIndex == 1) {//女
            [msgArray replaceObjectAtIndex:1 withObject:@"女"];
            [_tableView reloadData];
        }
    }
    else {
        if (buttonIndex == 0) {
             BOOL isCamer = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        
             if (!isCamer) {
            
                 [SVProgressHUD showErrorWithStatus:@"设备不支持相机"];
              return;
             }
        
        UIImagePickerController *pckerController = [[UIImagePickerController alloc] init];
        //指定sourceType 为拍照
        pckerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        pckerController.delegate = self;
        
        [self presentViewController:pckerController animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
              UIImagePickerController *pckerController = [[UIImagePickerController alloc] init];
        
             //指定资源(照片、视频)的来源
             /*
             UIImagePickerControllerSourceTypePhotoLibrary : 系统相册中所有的文件夹
             UIImagePickerControllerSourceTypeSavedPhotosAlbum : 使用系统的文件夹
             */
             pckerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
             pckerController.delegate = self;
        
        
        [self presentViewController:pckerController animated:YES completion:nil];
    
        }
    }
}
#pragma mark - UIImagePickerController delegate
//选择照片、拍照 完成之后调用的协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //    NSLog(@"%@",info);
    picker.allowsEditing = YES;
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {  //照片资源
        //取得选取的照片
        UIImage *img = info[@"UIImagePickerControllerEditedImage"];
        if (img == nil) {
            img = info[@"UIImagePickerControllerOriginalImage"];
        }
        
//        self.imgView.image = img;
        imgView.image = img;
        iconIMG = img;
        //判断照片是否来自摄像头
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            //保存到相册，@selector(image:didFinishSavingWithError:contextInfo:)  保存成功之后调用的方法
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            iconIMG = img;
        }
    }
    else if([mediaType isEqualToString:@"public.movie"]) {
        
        //处理视频
        //        NSLog(@"%@",info);
        
        //读取视频数据
        //        NSString *url = info[UIImagePickerControllerMediaURL];
        //        NSData *data = [NSData dataWithContentsOfFile:url];
        //
        //        NSLog(@"%@",data);
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存照片到相册成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSLog(@"保存成功");
    
}

//取消按钮的点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        NSArray *arr = data[section];
        return arr.count;
    }
    else if (tableView == officeSelect) {
        return officeArray.count;
    }
    else if (tableView == hospitalSelect) {
        return hospitalArray.count;
    }
    else if (tableView == citySelect) {
        return cityArray.count;
    }
    return proTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        SelfCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
        cell.keyLableText = data[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.msgString = msgArray[indexPath.row];
        }
        else if (indexPath.section == 1) {
            cell.msgString = msgArray1[indexPath.row];
        }
        return cell;
    }
    else if (tableView == officeSelect) {
        SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"officeSelect_cell"];
        cell.lableText = [officeArray[indexPath.row] objectForKey:@"name"];
        return cell;
    }
    else if (tableView == proTitleSelect) {
        SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proTitle_cell"];
        cell.lableText = [proTitleArray[indexPath.row] objectForKey:@"name"];
        return cell;
    }
    else if (tableView == hospitalSelect) {
        SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hospitalSelect_cell"];
        cell.lableText = [hospitalArray[indexPath.row] objectForKey:@"name"];
        return cell;
    }
    else if (tableView == citySelect) {
        SelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citySelect_cell"];
        cell.lableText = [cityArray[indexPath.row] objectForKey:@"class_name"];
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return data.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return 60;
        }
        return 5;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section != 0) {
            return nil;
        }
        view = [[UIView alloc]initWithFrame:CGRectZero];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 30)];
        lable.text = @"头像:";
        [view addSubview:lable];
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-100, 5,50 , 50)];
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 25;
        imgView.backgroundColor = [UIColor yellowColor];
        [view addSubview:imgView];
        view.backgroundColor = [UIColor whiteColor];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,info1[@"avatar"]]]];
//        if (imgView.image == nil) {
//            imgView.image = [UIImage imageNamed:@"图像_xhdpi"];
//        }
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        if (indexPath.row == 0 && indexPath.section == 0) {//修改用户名
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改用户名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            alert.tag = 100;
            [alert show];
        }
        else if (indexPath.section == 0 && indexPath.row == 1) {//修改性别
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
            actionSheet.tag = 200;
            [actionSheet showInView:self.view];
        }
        else if (indexPath.section == 0 && indexPath.row ==2) {//修改手机号
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//            UITextField *text = [alert textFieldAtIndex:0];
//            text.keyboardType = UIKeyboardTypeNumberPad;
//            text.delegate = self;
//            text.tag = 200;
//            alert.tag = 200;
//            [alert show];
//            [SVProgressHUD showErrorWithStatus:@"手机号码请到个人中心修改"];
            ChangePhoneController *cpVC = [[ChangePhoneController alloc]init];
            [self.navigationController pushViewController:cpVC animated:YES];
        }
        else if (indexPath.section == 0 && indexPath.row == 3) {//修改身份证号
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改身份证号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *text = [alert textFieldAtIndex:0];
            text.delegate = self;
            text.tag = 300;
            alert.tag = 300;
            [alert show];
        }
        else if (indexPath.section == 1 && indexPath.row == 1) {//修改就职单位
            [self removeGarySubView];
            if (hospitalSelect == nil) {
                hospitalSelect = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, garyView.width-80, garyView.height-200) style:UITableViewStylePlain];
                hospitalSelect.dataSource = self;
                hospitalSelect.delegate = self;
                hospitalSelect.layer.cornerRadius = 7;
                UIView *foot = [[UIView alloc]init];
                foot.backgroundColor = [UIColor clearColor];
                hospitalSelect.tableFooterView = foot;
                [hospitalSelect registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"hospitalSelect_cell"];
            }
            if (cityID == nil) {
                [SVProgressHUD showErrorWithStatus:@"请先选择城市"];
            }
            else {
            [DataService requestURL:[NSString stringWithFormat:@"%@getHospital",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"city_id":cityID} responseSerializer:nil completion:^(id result, NSError *error) {
                if (error == nil) {
                    if ([result[@"err"] integerValue] == 0) {
                        hospitalArray = result[@"hospital_list"];
                        [hospitalSelect reloadData];
                        garyView.hidden = NO;
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
            }];
            [garyView addSubview:hospitalSelect];
            }
        }
        else if (indexPath.section == 1 && indexPath.row == 2) {//修改专业
            [self removeGarySubView];
            if (officeSelect == nil) {
                officeSelect = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, garyView.width-80, garyView.height-200) style:UITableViewStylePlain];
                officeSelect.backgroundColor = [UIColor whiteColor];
                officeSelect.dataSource = self;
                officeSelect.delegate = self;
                officeSelect.layer.cornerRadius = 7;
                UIView *foot = [[UIView alloc]init];
                foot.backgroundColor = [UIColor clearColor];
                officeSelect.tableFooterView = foot;
                [officeSelect registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"officeSelect_cell"];
            }
            [DataService requestURL:[NSString stringWithFormat:@"%@getDepartment",BaseUrl] httpMethod:@"GET" timeout:30 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
                if (error == nil) {
                    if ([result[@"err"] integerValue] == 0) {
                        officeArray = result[@"department_list"];
                        [officeSelect reloadData];
                        garyView.hidden = NO;
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
            }];
            [garyView addSubview:officeSelect];
        }
        else if (indexPath.section == 1 && indexPath.row == 3) {//修改职称
            [self removeGarySubView];
            if (proTitleSelect == nil) {
                proTitleSelect = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, garyView.width-80, garyView.height-200) style:UITableViewStylePlain];
                proTitleSelect.delegate = self;
                proTitleSelect.dataSource = self;
                proTitleSelect.layer.cornerRadius = 7;
                proTitleSelect.backgroundColor = [UIColor whiteColor];
                UIView *foot = [[UIView alloc]init];
                foot.backgroundColor = [UIColor clearColor];
                proTitleSelect.tableFooterView = foot;
                [proTitleSelect registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"proTitle_cell"];
            }
            [DataService requestURL:[NSString stringWithFormat:@"%@getJobtitle",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"type":@"1"} responseSerializer:nil completion:^(id result, NSError *error) {
                if (error == nil) {
                    if ([result[@"err"] integerValue] == 0) {
                        proTitleArray = result[@"jobtitle_list"];
                        [proTitleSelect reloadData];
                        garyView.hidden = NO;
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
            }];
            [garyView addSubview:proTitleSelect];
            
        }
        else if (indexPath.section == 1 && indexPath.row == 4){//从业年限
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改从业年限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *text = [alert textFieldAtIndex:0];
            text.keyboardType = UIKeyboardTypeNumberPad;
            text.delegate = self;
            text.tag = 500;
            alert.tag = 500;
            [alert show];
        }
        else if (indexPath.section == 1 && indexPath.row == 0) {//就职城市
            [self removeGarySubView];
            if (citySelect == nil) {
                citySelect = [[UITableView alloc]initWithFrame:CGRectMake(40, 100, garyView.width-80, garyView.height-200) style:UITableViewStylePlain];
                citySelect.dataSource = self;
                citySelect.delegate = self;
                citySelect.layer.cornerRadius = 7;
                UIView *foot = [[UIView alloc]init];
                foot.backgroundColor = [UIColor clearColor];
                citySelect.tableFooterView = foot;
                [citySelect registerNib:[UINib nibWithNibName:@"SelectedCell" bundle:nil] forCellReuseIdentifier:@"citySelect_cell"];
            }
            [DataService requestURL:[NSString stringWithFormat:@"%@getCity",BaseUrl] httpMethod:@"GET" timeout:30 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
                if (error == nil) {
                    if ([result[@"err"] integerValue] == 0) {
                        cityArray = result[@"city_list"];
                        [citySelect reloadData];
                        garyView.hidden = NO;
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                }
            }];
            [garyView addSubview:citySelect];
        }
    }
    else if (tableView == officeSelect) {
        garyView.hidden = YES;
        [msgArray1 replaceObjectAtIndex:2 withObject:[officeArray[indexPath.row] objectForKey:@"name"]];
        officeID = [officeArray[indexPath.row] objectForKey:@"id"];
        [_tableView reloadData];
    }
    else if (tableView == proTitleSelect) {
        garyView.hidden = YES;
        [msgArray1 replaceObjectAtIndex:3 withObject:[proTitleArray[indexPath.row] objectForKey:@"name"]];
        proTitalID = [proTitleArray[indexPath.row] objectForKey:@"id"];
        [_tableView reloadData];
    }
    else if (tableView == hospitalSelect) {
        garyView.hidden = YES;
        [msgArray1 replaceObjectAtIndex:1 withObject:[hospitalArray[indexPath.row] objectForKey:@"name"]];
        hospitalID = [hospitalArray[indexPath.row] objectForKey:@"id"];
        [_tableView reloadData];
    }
    else if (tableView == citySelect) {
        garyView.hidden = YES;
        [msgArray1 replaceObjectAtIndex:0 withObject:[cityArray[indexPath.row] objectForKey:@"class_name"]];
        if (![cityID isEqualToString:[cityArray[indexPath.row] objectForKey:@"class_id"]]) {
            cityID = [cityArray[indexPath.row] objectForKey:@"class_id"];
            [msgArray1 replaceObjectAtIndex:1 withObject:@""];
        }
        [_tableView reloadData];
    }
    
}
//data = @[@[@"用户名:",@"性别:",@"手机号:",@"身份证号:"],@[@"就职单位:",@"专业:",@"职称:",@"从业年限:"]];

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 200) {
        if (![Utility isValidateMobile:textField.text]) {
            [SVProgressHUD showErrorWithStatus:@"手机号输入错误"];
        }
    }
    else if (textField.tag == 300) {
        if (![Utility isValidateIDCard:textField.text]) {
            [SVProgressHUD showErrorWithStatus:@"身份证号码输入错误"];
            errorID = 1;
        }
    }
}
#pragma mark 提交按钮
- (IBAction)preserveMessage:(id)sender {
    preserveButton.hidden = YES;
     _tableView.allowsSelection = NO;
    [view removeGestureRecognizer:tap];
    leftButton.selected = NO;
    NSString *sex;
    if ([msgArray[1] isEqualToString:@"男"]) {
        sex = @"0";
    }else {
        sex = @"1";
    }
    NSString *expe = msgArray1[4];
    NSString *ex = [NSString stringWithFormat:@"%c",[expe characterAtIndex:0]];
    [DataService requestURL:[NSString stringWithFormat:@"%@modPromulgatorInfo",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"],@"username":msgArray[0],@"gender":sex,@"hospital_id":hospitalID,@"idcard":msgArray[3],@"experience":ex,@"jobtitle_id":proTitalID,@"department_id":officeID,@"city_id":cityID} responseSerializer:nil completion:^(id result, NSError *error) {
        if (error == nil){
            if ([result[@"err"] integerValue] == 0) {
            [SVProgressHUD showSuccessWithStatus:result[@"msg"]];
                reArray = msgArray;
                reArray1 = msgArray1;
        }
            else {
            [SVProgressHUD showErrorWithStatus:result[@"msg"]];
        }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"网络不稳定"];
        }
    }];
    
    if (iconIMG != nil) {
        NSData *imgData = UIImageJPEGRepresentation(iconIMG, 1);
        [DataService requestURL:[NSString stringWithFormat:@"%@modPromulgatorAvatar",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"]} fileData:imgData responseSerializer:nil completion:^(id result, NSError *error) {
            if ([result[@"err"] integerValue] == 1) {
                [SVProgressHUD showErrorWithStatus:@"更新头像失败"];
            }
            else {
                NSDictionary *dict = @{@"icon":iconIMG};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:changeIconIMG object:nil userInfo:dict];
                [[NSUserDefaults standardUserDefaults] setObject:result[@"msg"] forKey:@"avatar"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
        }];
    }
}

- (IBAction)endLogin:(id)sender {
    [DataService requestURL:[NSString stringWithFormat:@"%@promulgatorLogout",BaseUrl] httpMethod:@"POST" timeout:30 params:@{@"promulgator_id":dic[@"promulgator_id"]} responseSerializer:nil completion:^(id result, NSError *error) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:selfMSGKey];
        LoginController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
        [self.navigationController pushViewController:loginController animated:YES];
    }];
}

- (void)removeSubView {
    NSArray *arr = [selectView subviews];
    for (UIView *subview in arr) {
        [subview removeFromSuperview];
    }
}

- (void)removeGarySubView {
    NSArray *arr = [garyView subviews];
    for (UIView *subView in arr) {
        [subView removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    garyView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100 && buttonIndex == 1) {
        UITextField *text = [alertView textFieldAtIndex:0];
        if ([text.text isEqualToString:@""])
        {
            return;
        }
        [msgArray replaceObjectAtIndex:0 withObject:text.text];
        [_tableView reloadData];
    }
    else if (alertView.tag == 200 && buttonIndex == 1) {
        UITextField *text = [alertView textFieldAtIndex:0];
        [msgArray replaceObjectAtIndex:2 withObject:text.text];
        [_tableView reloadData];
    }
    else if (alertView.tag == 300 && buttonIndex == 1) {
        UITextField *text = [alertView textFieldAtIndex:0];
        if (errorID != 1) {
            [msgArray replaceObjectAtIndex:3 withObject:text.text];
            [_tableView reloadData];
        }
    }

    else if (alertView.tag == 500 && buttonIndex == 1) {
        UITextField *text = [alertView textFieldAtIndex:0];
        if ([text.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"输入为空"];
            return;
        }
        [msgArray1 replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@年",text.text]];
        [_tableView reloadData];
    }
}

- (void)changePhone:(NSNotification *)aNotification {
    NSString *newPhone = [aNotification.userInfo objectForKey:@"newPhone"];
    [msgArray replaceObjectAtIndex:2 withObject:newPhone];
    [_tableView reloadData];
}

@end
