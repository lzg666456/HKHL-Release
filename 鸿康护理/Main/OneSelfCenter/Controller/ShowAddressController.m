//
//  ShowAddressController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/10.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "ShowAddressController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface ShowAddressController ()<MAMapViewDelegate> {
    MAMapView *_mapView;
}

@end

@implementation ShowAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务地址";
    
    [MAMapServices sharedServices].apiKey = @"17a6fcd60ff40936c2384286e4829a0a";
    [AMapSearchServices sharedServices].apiKey = @"17a6fcd60ff40936c2384286e4829a0a";
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
//    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
//    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    _mapView.zoomLevel = _mapView.maxZoomLevel;
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(_latitude, _longitude)];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_latitude, _longitude);
//    pointAnnotation.title = @"1111";
//    pointAnnotation.subtitle = @"1111";
    
    [_mapView addAnnotation:pointAnnotation];
    [self.view addSubview:_mapView];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;         //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

@end
