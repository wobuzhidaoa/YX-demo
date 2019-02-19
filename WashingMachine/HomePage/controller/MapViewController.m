//
//  MapViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/9/14.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "MapViewController.h"
#import "CommonUtility.h"
@interface MapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAPointAnnotation* pointAnnotation;
    MAPinAnnotationView* newAnnotation;
    float latitude;
    float longitude;
    //当前客户所在城市
    NSString *cityName;
    
    int num;
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,strong)NSMutableArray *ponits;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近洗衣点";
    
    
    [self initMapView];
    
    [self initSearch];
    
    self.mapView.showsUserLocation = YES;
    [self addPointAnnotation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)dealloc
{
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    
    [self returnAction];
}

#pragma mark - Handle Action

- (void)returnAction
{
    [self clearMapView];
    
    [self clearSearch];
}
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}
#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, navHight, self.view.width, self.view.height - navHight)];
    self.mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    [self.mapView setMapType:MAMapTypeStandard];
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.rotateCameraEnabled = NO;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 17;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc]init];
}

#pragma mark - 添加标注
- (void)addPointAnnotation
{
    _ponits = [NSMutableArray new];
    for (int i = 0; i<self.listArray.count; i++) {
        NSDictionary *dic = [self.listArray objectAtIndex:i];
        pointAnnotation = [[MAPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[dic objectForKey:@"latitude"] floatValue];
        coor.longitude = [[dic objectForKey:@"longitude"] floatValue];
        
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = dic[@"school"];
        pointAnnotation.subtitle = dic[@"address"];
        [_ponits addObject:pointAnnotation];
        [self.mapView addAnnotation:pointAnnotation];
    }
    [self mapViewFitPolyLine:_ponits];
}

- (void)mapViewFitPolyLine:(NSMutableArray *)pontis {
    if (pontis.count == 1) {
        self.mapView.zoomLevel = 19;
        MAPointAnnotation *pt1 = pontis[0];
        [self.mapView setCenterCoordinate:pt1.coordinate];
    }else{
        MAMapRect rect = [CommonUtility minMapRectForAnnotations:pontis];;
        [self.mapView setVisibleMapRect:rect
                            edgePadding:UIEdgeInsetsMake(300, 200, 300, 200)
                               animated:YES];
    }
}

#pragma mark implement BMKMapViewDelegate
// 根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        newAnnotation = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (newAnnotation == nil)
        {
            newAnnotation = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        newAnnotation.image = [UIImage imageNamed:@"pin_red_1"];
//        设置颜色
//        for (int i = 0; i<self.listArray.count; i++) {
//            NSDictionary *dic = self.listArray[i];
//            NSString *name = dic[@"locationName"];
//            NSString *time = dic[@"createTime"];
//            if ([annotation.title rangeOfString:name].location != NSNotFound  && [annotation.subtitle rangeOfString:time].location != NSNotFound) {
//                for (id view in newAnnotation.subviews) {
//                    if ([view isKindOfClass:[UILabel class]]) {
//                        [view removeFromSuperview];
//                    }
//                }
//
//                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//                numLabel.textColor = [UIColor whiteColor];
//                numLabel.font = [UIFont systemFontOfSize:14.0f];
//                numLabel.text = [NSString stringWithFormat:@"%lu",self.listArray.count-i];
//                numLabel.textAlignment = NSTextAlignmentCenter;
//                [newAnnotation addSubview:numLabel];
//
//            }
//        }
        
        //设置从天上掉下来的效果（annotation）
        newAnnotation.animatesDrop = YES;
        // 设置可拖拽
        ((MAPinAnnotationView*)newAnnotation).draggable = NO;
        newAnnotation.centerOffset = CGPointMake(0, -18);
        newAnnotation.canShowCallout = YES;
        
        return newAnnotation;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
