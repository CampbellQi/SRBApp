//
//  MapViewController.m
//  CoolCar
//
//  Created by zz on 14-10-20.
//  Copyright (c) 2014年 winter. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
@interface MapViewController ()<MKMapViewDelegate>
{
    BOOL isBack;
}
@property (nonatomic, assign) BOOL map;

@end

@implementation MapViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"卫星/地图" style:UIBarButtonItemStyleBordered target:self action:@selector(moon_map:)];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.customTab.hidden = NO;
    }
}

- (void)backBtn:(UIBarButtonItem *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    self.map = YES;
    isBack = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    MKMapView * mapView = [[MKMapView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    mapView.delegate = self;
    self.mapView = mapView;
    mapView.showsUserLocation = YES;
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = self.lat;
    centerCoordinate.longitude = self.lon;
    
    //定义显示的范围
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    //定义一个区域(用定义的经纬度和范围来定义)
    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;
    
    //在地图上显示
    [mapView setRegion:region animated:YES];
    
        //添加大头针
        MKPointAnnotation * ann = [[MKPointAnnotation alloc]init];
        ann.coordinate = centerCoordinate;
        [ann setTitle:self.name];
        [ann setSubtitle:self.address];
        [mapView addAnnotation:ann];
        [mapView selectAnnotation:ann animated:YES];

    //设置地图模式
    [mapView setMapType:MKMapTypeStandard];  //mkmapTypehybrid混合,mkmaptypestandard街道和道路,mkmaptypesatellite卫星
    [self.view addSubview:mapView];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- customMothed --
//切换卫星或地图的方法
- (void)moon_map:(UIBarButtonItem *)item
{
    if (_map == YES) {
        self.mapView.mapType = MKMapTypeSatellite;
        _map = NO;
        
    }else if (_map == NO){
        self.mapView.mapType = MKMapTypeStandard;
        _map = YES;
    }
}


@end
