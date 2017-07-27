//
//  IllegalParkAddFootView.h
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IllegalParkAddFootViewDelegate <NSObject>

-(void)handleCommitClicked;

@end


@interface IllegalParkAddFootView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (nonatomic, weak) id<IllegalParkAddFootViewDelegate> delegate;

@end
