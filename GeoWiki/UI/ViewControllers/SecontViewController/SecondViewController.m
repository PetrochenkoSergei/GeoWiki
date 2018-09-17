//
//  SecondViewController.m
//  GeoWiki
//
//  Created by Sergei Petrochenko on 17.09.2018.
//  Copyright © 2018 Sergei Petrochenko. All rights reserved.
//

#import "SecondViewController.h"
#import "DBImageView.h"

@interface SecondViewController (){
    NSMutableArray *imageUrlSplitWord;
}
@end

@implementation SecondViewController
@synthesize images, errorTitle, errorSubTitle, collectionView, imageSortedArray, imagesSortedList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (images) {
        
        imageUrlSplitWord = [[NSMutableArray alloc] init];
        imagesSortedList = [[NSMutableDictionary alloc] init];
        
        if (images.count > 0) {
            [errorTitle setHidden:YES];
            [errorSubTitle setHidden:YES];
        }
        
        /*==================
        Регулярное выражение удаляет все, кроме названия файла.
        https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Moskovskie_Vorota_SPB.jpg/256px-Moskovskie_Vorota_SPB.jpg --> 256px-Moskovskie_Vorota_SPB
        Группировка всех полученных изображений идет по полному совпадению названия файла.
        ==================*/
        
        for(NSString* image in images){
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([^\\/]+)(?=\\.\\w+$)" options:0 error:&error];
            NSArray *matches = [regex matchesInString:image options:0 range:NSMakeRange(0, [image length])];
            NSUInteger matchCount = [matches count];
            if (matchCount) {
                for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
                    NSTextCheckingResult *match = [matches objectAtIndex:matchIdx];
                    NSRange matchRange = [match range];
                    NSString *result = [image substringWithRange:matchRange];
                    [imageUrlSplitWord addObject:result];
                    [imagesSortedList setObject:image forKey:result];
                }
            }
        }
        NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:imageUrlSplitWord];
        NSMutableArray *countedArray = [NSMutableArray array];
        [countedSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            [countedArray addObject:@{@"object": obj,
                                      @"count": @([countedSet countForObject:obj])}];
        }];
        imageSortedArray = [[NSMutableArray alloc] initWithArray:[countedArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]]];
        [self.collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setImages:(NSMutableArray *)imagesArray{
    [images removeAllObjects];
    [imageUrlSplitWord removeAllObjects];
    [imagesSortedList removeAllObjects];
    [imageSortedArray removeAllObjects];
    [errorTitle setHidden:NO];
    [errorSubTitle setHidden:NO];
    images = [[NSMutableArray alloc] initWithArray:imagesArray];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imagesSortedList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:100];
    UILabel *cellTitle = (UILabel *)[cell viewWithTag:101];
    UILabel *cellCounter = (UILabel *)[cell viewWithTag:102];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.imagesSortedList objectForKey:[[self.imageSortedArray objectAtIndex:indexPath.row] objectForKey:@"object"]]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cellImage.image = [UIImage imageWithData: data];
        });
    });
    
    cellTitle.text = [[imageSortedArray objectAtIndex:indexPath.row] objectForKey:@"object"];
    cellCounter.text = [[[imageSortedArray objectAtIndex:indexPath.row] objectForKey:@"count"] stringValue];
    return cell;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


@end
