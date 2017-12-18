//
//  ViewController.m
//  04掌握-登录案例
//
//  Created by 朝阳 on 2017/12/2.
//  Copyright © 2017年 sunny. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (IBAction)login:(id)sender {
    
    //添加灰色的背景遮罩
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //0 拿到用户输入
    NSString *userNameStr = self.userName.text;
    NSString *pwdStr = self.password.text;
    if (userNameStr.length ==  0) {
        [SVProgressHUD showErrorWithStatus:self.userName.placeholder];
        return;
    }
    if (pwdStr.length ==  0) {
        [SVProgressHUD showErrorWithStatus:self.password.placeholder];
        return;
    }
    //1. 确定请求地址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:8080/MJServer/login?username=%@&pwd=%@&method=get&type=JSON",userNameStr,pwdStr]];
    //2. 创建请求(GET)
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    
    [SVProgressHUD showWithStatus:@"正在登录.."];
    
    //3. 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        // 容错处理
        if (connectionError) {
            NSLog(@"请求失败!");
            return ;
        }
        
        // 解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![dict objectForKey:@"success"]) {
                
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"error"]];
            }else{
                [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"success"]];
            }
        });
        
    }];
}

@end
