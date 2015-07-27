//
//  SearchView.m
//  Test1
//
//  Created by Pavel Deminov on 18/07/15.
//  Copyright (c) 2015 Company. All rights reserved.
//

#import "SearchView.h"


@interface SearchView () <UISearchBarDelegate> {
    
}

@end

@implementation SearchView



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SearchViewDelegate)]) {
        [self.delegate searchText:searchBar.text];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
