//
//  LSPageControl.m
//  liveShop
//
//  Created by mac on 2023/7/10.
//

#import "LSPageControl.h"

@implementation LSPageControl

//重写setCurrentPage方法，可设置圆点大小
- (void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView *subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;

        if (subviewIndex == page){

            if ((self.currentPageSize.width == 0)&&(self.currentPageSize.height == 0)) {
                size.height = 7;
                size.width = 7;
            }else{
                size = self.currentPageSize;
            }
            
        }else{
            if ((self.pageSize.width == 0)&&(self.pageSize.height == 0)) {
                size.height = 7;
                size.width = 7;
            }else{
                size = self.pageSize;
            }
        }
        
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,size.width,size.height)];

    }

}


@end
