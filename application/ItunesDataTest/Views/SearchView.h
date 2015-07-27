//
//  SearchView.h
//  Test1
//
//  Created by Pavel Deminov on 18/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewDelegate <NSObject>

-(void)searchText:(NSString*)text;

@end

@interface SearchView : UIView

@property(nonatomic,weak) id <SearchViewDelegate> delegate;

@end
