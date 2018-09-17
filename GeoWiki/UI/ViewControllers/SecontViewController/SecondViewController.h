//
//  SecondViewController.h
//  GeoWiki
//
//  Created by Sergei Petrochenko on 17.09.2018.
//  Copyright © 2018 Sergei Petrochenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) IBOutlet UILabel *errorTitle;
@property (strong, nonatomic) IBOutlet UILabel *errorSubTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *imageSortedArray;
@property (strong, nonatomic) NSMutableDictionary* imagesSortedList;


-(void)setImages:(NSMutableArray *)imagesArray;

@end

