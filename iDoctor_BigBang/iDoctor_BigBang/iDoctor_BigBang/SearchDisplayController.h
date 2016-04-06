//
//  TWKSearchDisplayController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/11/2.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol TWKSearchProtocol <UISearchBarDelegate,UISearchDisplayDelegate>
//
//@end

@interface SearchDisplayController : UISearchDisplayController <UISearchBarDelegate,UISearchDisplayDelegate>

-(instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController*)contentsController withDataArr:(NSArray *)dataArr;

@end
