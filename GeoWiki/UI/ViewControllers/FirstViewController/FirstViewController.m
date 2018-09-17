//
//  FirstViewController.m
//  GeoWiki
//
//  Created by Sergei Petrochenko on 17.09.2018.
//  Copyright © 2018 Sergei Petrochenko. All rights reserved.
//

#import "FirstViewController.h"
#import "MJExtension.h"
#import "Page.h"
#import "SecondViewController.h"

@interface FirstViewController (){
    NSMutableArray *images;
    
}
@end

@implementation FirstViewController
@synthesize mapMain, activityIndicator, locationManager, currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [mapMain setDelegate:self];
    mapMain.showsUserLocation = YES;
    mapMain.showsBuildings = YES;
    [mapMain setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    locationManager = [CLLocationManager new];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    [locationManager startUpdatingLocation];
    
    images = [[NSMutableArray alloc] init];
    
    [Page mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"pageId" : @"pageid",
                 @"title" : @"title",
                 @"index" : @"index",
                 @"lat" : @"coordinates[0].lat",
                 @"lon" : @"coordinates[0].lon",
                 @"thumbnailSource" : @"thumbnail.source",
                 @"originalSource" : @"original.source"
                 };
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    currentLocation = [locations lastObject];
}

- (IBAction)loadArticiclesButtonClick:(id)sender {
    [activityIndicator startAnimating];
    [mapMain removeAnnotations:mapMain.annotations];
    [images removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self JSONParseStart];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self JSONParseDone];
        });
    });
    
}
- (IBAction)setMapType:(id)sender{
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            mapMain.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapMain.mapType = MKMapTypeHybrid;
            break;
        case 2:
            mapMain.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

-(void)JSONParseStart{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger radius = [defaults integerForKey:@"radius"];
    NSInteger limit = [defaults integerForKey:@"limit"];
    
    NSError *error;
    NSString *url_string = [NSString stringWithFormat: @"https://en.wikipedia.org/w/api.php?action=query&format=json&responselanginfo=1&uselang=ru&prop=coordinates%%7Cpageimages%%7Cpageterms&generator=geosearch&colimit=50&piprop=original%%7Cthumbnail&pithumbsize=256&pilimit=50&pilicense=any&wbptterms=description&ggscoord=%f%%7C%f&ggsradius=%ld&ggslimit=%ld", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, radius, limit];

    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSArray *parsedData = [[[json objectForKey:@"query"] objectForKey:@"pages"] allValues];
 
    for (NSDictionary* pages in parsedData) {
        Page *pg = [Page mj_objectWithKeyValues:pages];
        if (pg.originalSource) {
            [images addObject:pg.thumbnailSource];
        }
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coordForPin = {.latitude = [pg.lat doubleValue], .longitude = [pg.lon doubleValue]};
        [annotation setCoordinate:coordForPin];
        [annotation setTitle:pg.title];
        [mapMain addAnnotation:annotation];
    }
}

-(void)JSONParseDone{
    CLLocationCoordinate2D center = mapMain.centerCoordinate;
    mapMain.centerCoordinate = center;
    
    [activityIndicator stopAnimating];
    [self performSegueWithIdentifier:@"Second" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Second"]){
        SecondViewController *sVC = (SecondViewController *)segue.destinationViewController;
        sVC.images = images;
    }
}


@end
