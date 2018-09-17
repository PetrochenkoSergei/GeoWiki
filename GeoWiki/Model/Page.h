//
//  Page.h
//  GeoWiki
//
//  Created by Sergei Petrochenko on 17.09.2018.
//  Copyright © 2018 Sergei Petrochenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (copy, nonatomic) NSNumber *pageId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSNumber *index;
@property (copy, nonatomic) NSNumber *lat;
@property (copy, nonatomic) NSNumber *lon;
@property (copy, nonatomic) NSString *thumbnailSource;
@property (copy, nonatomic) NSString *originalSource;


@end
