//
//  PrimaryBlock.h
//  allforyou
//
//  Created by Rakefet Tsabari on 5/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PrimaryBlock : NSManagedObject

@property (nonatomic, retain) NSString * datelabel;
@property (nonatomic, retain) NSString * titlelabel;

@end
