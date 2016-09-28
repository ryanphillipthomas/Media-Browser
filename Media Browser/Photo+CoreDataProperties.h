//
//  Photo+CoreDataProperties.h
//  Media Browser
//
//  Created by Ryan Thomas on 9/28/16.
//  Copyright © 2016 Ryan Thomas. All rights reserved.
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *mediaURL;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *photoID;
@property (nullable, nonatomic, retain) NSManagedObject *routine;

@end

NS_ASSUME_NONNULL_END
