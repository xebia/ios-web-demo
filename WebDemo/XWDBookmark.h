//
//  XWDBookmark.h
//  WebDemo
//
//  Created by Lammert Westerhoff on 15/01/14.
//  Copyright (c) 2014 Xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XWDBookmark : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageUrl;

@end
