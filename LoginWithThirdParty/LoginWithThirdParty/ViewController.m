//
//  ViewController.m
//  LoginWithThirdParty
//
//  Created by bruce on 15/8/24.
//  Copyright (c) 2015年 bruce. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "WXApi.h"

@interface ViewController ()<WXApiDelegate>

@property (strong, nonatomic)FBSDKLoginButton *loginButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //=====================================
    //facebook
    //self
//    self.loginButton = [[FBSDKLoginButton alloc] init];
//    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//    self.loginButton.center = self.view.center;
//    [self.view addSubview:self.loginButton];
    
    
    // Add a custom login button to your app
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor darkGrayColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    CGPoint point = self.view.center;
    point.y = point.y-100;
    myLoginButton.center = point;
    [myLoginButton setTitle: @"Facebook" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [myLoginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
    
    
    //=====================================
    //Wechat
    // Add a custom login button to your app
    UIButton *weChatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    weChatBtn.backgroundColor=[UIColor darkGrayColor];
    weChatBtn.frame=CGRectMake(0,0,180,40);
    point = self.view.center;
    point.y = point.y+100;
    weChatBtn.center = point;
    [weChatBtn setTitle: @"Wechat" forState: UIControlStateNormal];
    [weChatBtn addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weChatBtn];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked {
     //[FBSDKAccessToken currentAccessToken] 用来判断是否已经登录了facebook
    if([FBSDKAccessToken currentAccessToken]) {//
        [self loginedFacebook];
    }else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        //表示登陆成功
//                                        NSLog(@"%@",result.token);
//                                        FBSDKAccessToken *token = result.token;
//                                        
//                                        NSLog(@"%@",token.appID);
//                                        NSLog(@"%@",token.tokenString);
//                                        NSLog(@"%@",token.userID);
//                                        
//                                        NSLog(@"Logged in");
                                        [self loginedFacebook];
                                        
                                        
                                    }
                                }];
    }
    
}

- (void)loginedFacebook {
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    NSDictionary *parameters = @{@"fields": @"id,name,picture,email"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:parameters
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {

        NSDictionary *dic = (NSDictionary *)result;
        NSMutableDictionary *resutlDic = [NSMutableDictionary dictionary];
        [resutlDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
        [resutlDic setObject:[dic objectForKey:@"email"] forKey:@"email"];
        [resutlDic setObject:[dic objectForKey:@"name"] forKey:@"name"];
        
        NSString *picUrl = [[[dic objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        
        
        [resutlDic setObject:picUrl forKey:@"picture_url"];
        
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"result" message:[resutlDic description] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        NSLog(@"result = \n%@",result);
        // Handle the result
    }];
}

-(void)sendAuthRequest
{
    
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未安装Wechat" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo"; // @"post_timeline,sns"
    req.state = @"xxx";
    req.openID = @"colorfun0c806938e2413ce73eef92cc3";
//    req.openID = @"0c806938e2413ce73eef92cc3";
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
}



@end
