//
//  MapController.m
//  鸿康护理
//
//  Created by CaiNiao on 15/11/6.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "MapController.h"
#import <MAMapKit/MAMapKit.h>

@interface MapController ()<MAMapViewDelegate,AMapSearchDelegate> {
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    AMapGeoPoint *point;
}

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)isTrueAddress:(NSString *)address {
    _search = [[AMapSearchAPI alloc]init];
    [AMapSearchServices sharedServices].apiKey = @"17a6fcd60ff40936c2384286e4829a0a";
    _search.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    
    [_search AMapGeocodeSearch: geo];
}
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if(response.geocodes.count == 0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:addressIsNotTrue object:nil];
        return;
    }
    
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    for (AMapTip *p in response.geocodes) {
        point = p.location;
        NSDictionary *dic = @{@"point":point};
        [[NSNotificationCenter defaultCenter]postNotificationName:addressIsTrue object:nil userInfo:dic];
        
    }

}



@end
