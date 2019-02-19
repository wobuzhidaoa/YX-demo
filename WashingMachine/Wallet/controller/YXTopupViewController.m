//
//  YXTopupViewController.m
//  WashingMachine
//
//  Created by 孙瑞中 on 2017/8/4.
//  Copyright © 2017年 孙瑞中. All rights reserved.
//

#import "YXTopupViewController.h"
#import "TopUpButtonView.h"
#import "TopupStyleChooseView.h"
#import "Order.h"
#import "RSADataSigner.h"
@interface YXTopupViewController ()<TopUpButtonViewDelegete>
{
    NSDictionary *userInfo;
    
    NSInteger payType;//支付方式
    NSDictionary *selectPriceInfo;//选择支付的金额信息
}
@property(nonatomic,strong)NSArray *numberArray;

//底部弹框 ---没用
@property(nonatomic,strong)UIView *backGrayView;
@property(nonatomic,strong)TopupStyleChooseView *topupChooseView;

//选中view
@property(nonatomic,strong)TopUpButtonView *selectView;

//支付类型label
@property(nonatomic,strong)UILabel *styleLabel;

//订单信息
@property(nonatomic,strong)NSDictionary *orderInfo;
@property(nonatomic,strong)NSDictionary *willPayorderInfo;
@property(nonatomic,strong)NSDictionary *wechatWillPayorderInfo;

@end

@implementation YXTopupViewController

//选中时右上角图片
static NSString * const selectImageStr = @"icon_label";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    userInfo = [UserDefaultsUtils valueWithKey:@"userInfo"];
    [self numberRequest];
}

#pragma mark 请求
//充值金额列表
- (void)numberRequest{
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:nil requestUrl:@"getAccountPriceList.do" present:self success:^(id obj) {
//        "price":"30.00",
//        "giftMoney":"3.00",
//        "priceId":"005"
        self.numberArray = obj[@"data"][@"priceList"];
        
        [self initView];
    } failed:^(id obj) {
        
    }];
}
//创建订单
- (void)creatOrder{
//    1	userId	用户名	是	[string]
//    2	priceId	所选金额的ID	是	[string]
//    3	price	充值的金额	是	[string]
//    4	giftprice	赠送的金额	是	[string]
    if (selectPriceInfo == nil) {
        [YXShortcut alertWithTitle:nil message:@"请选择支付金额" controller:self buttonNumber:NO];
    }
    
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setValue:userInfo[@"userId"] forKey:@"userId"];
    [mdic setValue:selectPriceInfo[@"priceId"] forKey:@"priceId"];
    [mdic setValue:selectPriceInfo[@"price"] forKey:@"price"];
    [mdic setValue:selectPriceInfo[@"giftMoney"] forKey:@"giftprice"];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:mdic requestUrl:@"creatOrder" present:self success:^(id obj) {
//        1	create_order_time	订单创建日期
//        2	order_index	订单唯一标识
//        3	order_id	订单号
//        4	order_good_price	订单实际支付金额
        self.orderInfo = obj[@"data"][@"orderInfo"];
        [self willPay];
    } failed:^(id obj) {
        
    }];
}
//预支付
- (void)willPay{
//    1	userId	用户ID	是	[string]
//    2	pay_type	支付方式 0标识支付宝 1标识微信	是	[string]
//    3	payment_fee	支付金额（此金额一定要与创建订单时候返回的那个金额一致后端做判断，否则可能会存在安全问题）	是	[string]
//    4	consumer_openid	微信唯一id app情况传0	是	[string]
//    5	order_id	订单号此订单号为创建订单返回的订单号	是	[string]
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setValue:userInfo[@"userId"] forKey:@"userId"];
    [mdic setValue:[NSString stringWithFormat:@"%ld",payType] forKey:@"pay_type"];
    [mdic setValue:self.orderInfo[@"order_goods_price"] forKey:@"payment_fee"];
    [mdic setValue:@"0" forKey:@"consumer_openid"];
    [mdic setValue:self.orderInfo[@"order_id"] forKey:@"order_id"];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:mdic requestUrl:@"rechargeorder" present:self success:^(id obj) {
//        1	payment_index	//支付订单编号	是	[string]
//        2	payment_apply_time	支付发起时间	是	[string]
//        3	payment_fee	充值金额	是	[string]
        self.willPayorderInfo = obj[@"data"];
        if (payType == 0) {
            [self zhbThirdPay];
        }else{
            
        }
        
    } failed:^(id obj) {
        
    }];
}
//微信专业接口
- (void)forWechatPay{
//    1	userId	用户id	是	[string]
//    2	fee	预支付订单返回的金额	是	[string]
//    3	payment_index	预支付订单返回支付订单编号	是	[string]
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setValue:userInfo[@"userId"] forKey:@"userId"];
    [mdic setValue:self.willPayorderInfo[@"payment_fee"] forKey:@"fee"];
    [mdic setValue:self.willPayorderInfo[@"payment_index"] forKey:@"payment_index"];
    BaseHandler *handler = [[BaseHandler alloc]init];
    [handler requestData:nil requestUrl:nil present:self success:^(id obj) {
//        1	appid	微信开放者平台上的微信appid 此时必须服务器返回 写死客户端可能会有安全问题	是	[string]
//        2	noncestr	剩下的接口都是微信需要用的 可以参考微信支付官方文档	是	[string]
//        3	package		是	[string]
//        4	partnerid		是	[string]
//        5	prepayid		是	[string]
//        6	timestamp		是	[string]	
//        7	sign
        self.wechatWillPayorderInfo = obj[@"data"];
        [self jumpToBizPay];
    } failed:^(id obj) {
        
    }];
}
//支付结果
- (void)payResult{
//    1	userId	用户id	是	[string]
//    2	order_id	充值的订单号码	是	[string]
//    3	type	充值方式0支付宝 1微信	是	[string]
    NSMutableDictionary *mdic = [NSMutableDictionary new];
    [mdic setValue:userInfo[@"userId"] forKey:@"userId"];
    [mdic setValue:@"" forKey:@"order_id"];
    [mdic setValue:[NSString stringWithFormat:@"%ld",payType] forKey:@"type"];
    BaseHandler *handle = [[BaseHandler alloc]init];
    [handle requestData:nil requestUrl:nil present:self success:^(id obj) {
        
    } failed:^(id obj) {
        
    }];
}
#pragma mark 界面
- (void)initView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SIDESSPACING, navHight, SCREEN_WIDTH, 48)];
    titleLabel.text = @"请选择充值金额";
    titleLabel.textColor = [YXColor blackColor];
    titleLabel.font = ORDINARYFONT;
    [self.view addSubview:titleLabel];
    
    //宽高
    CGFloat Y = CGRectGetMaxY(titleLabel.frame);
    CGFloat tHeight = 60;
    CGFloat tWidth = (SCREEN_WIDTH-SIDESSPACING*4)/3.0;
    for (int i = 0; i<self.numberArray.count; i++) {
        NSDictionary *dic = self.numberArray[i];
        TopUpButtonView *tview = [[TopUpButtonView alloc]initWithFrame:CGRectMake(SIDESSPACING+(SIDESSPACING+tWidth)*(i%3), Y+i/3*(tHeight+10), tWidth, tHeight)];
        tview.numberLabel.text = [NSString stringWithFormat:@"%@元",dic[@"price"]];
        tview.givingLabel.text = [NSString stringWithFormat:@"(送%@元)",dic[@"giftMoney"]];
        [self.view addSubview:tview];
        tview.delegate = self;
        tview.tag = 1000+i;
    }
    
    
    //支付类型选择
    NSInteger number = (self.numberArray.count%3 == 0) ? self.numberArray.count/3 : self.numberArray.count/3+1;
    UIButton *styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    styleButton.frame = CGRectMake(0, Y+number*tHeight+(number-1)*10 +48, SCREEN_WIDTH, 48);
    [styleButton addTarget:self action:@selector(styleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:styleButton];
    [styleButton setBackgroundColor:[YXColor whiteColor]];
    UILabel *styleTitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SIDESSPACING, 0, 120, styleButton.height)];
    styleTitLabel.text = @"支付方式";
    styleTitLabel.textColor = [YXColor blackColor];
    styleTitLabel.font = ORDINARYFONT;
    [styleButton addSubview:styleTitLabel];
    self.styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, 0, 120, styleButton.height)];
    self.styleLabel.text = @"支付宝";
    self.styleLabel.font = ORDINARYFONT;
    self.styleLabel.textColor = [YXColor colorWithHexString:@"#2196f3"];
    self.styleLabel.textAlignment = NSTextAlignmentRight;
    [styleButton addSubview:self.styleLabel];
    
    
    //确认充值
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake((SCREEN_WIDTH-100)/2.0, CGRectGetMaxY(styleButton.frame)+24, 100, 40);
    [sureButton setTitle:@"确认充值" forState:UIControlStateNormal];
    [sureButton setBackgroundColor:[YXColor blueFirColor]];
    [sureButton setTitleColor:[YXColor whiteColor] forState:UIControlStateNormal];
    [sureButton.titleLabel setFont:ORDINARYFONT];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    sureButton.layer.masksToBounds = YES;
    sureButton.layer.cornerRadius = sureButton.height/2.0;
}
#pragma mark 确认支付
- (void)sureButtonClick:(UIButton *)sender{
//    [YXShortcut alertWithTitle:self.styleLabel.text message:nil controller:self buttonNumber:NO];
    [self creatOrder];
}
//支付宝
- (void)zhbThirdPay{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = safPayId;
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = safPayKey;
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少appId或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = @"RSA2";//(rsa2PrivateKey.length > 1) ? rsa2PrivateKey : rsaPrivateKey;
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"智享洗衣";
    order.biz_content.subject = @"智享洗衣";
    order.biz_content.out_trade_no = self.willPayorderInfo[@"payment_index"]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = self.willPayorderInfo[@"payment_fee"]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"zhixiangxiyi";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSInteger code = [resultDic[@"code"] integerValue];
            if (code == 10000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"walletNumber" object:nil];
            }
        }];
//        [[AlipaySDK defaultService] payOrder:self.willPayorderInfo[@"payment_index"] fromScheme:@"zhixiangxiyi" callback:^(NSDictionary *resultDic) {
//            [YXShortcut alertWithTitle:nil message:resultDic[@"memo"] controller:self buttonNumber:NO];
//        }];
    }
    
}
//微信
- (NSString *)jumpToBizPay {
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}
#pragma mark 支付完通知首页更改钱包余额
- (void)notWallet{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"walletNumber" object:nil];
}
#pragma mark 选择支付类型
- (void)styleButtonClick{
    [self initUIAlertSheet];
}
//弹框
- (void)initUIAlertSheet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.styleLabel.text = action.title;
        payType = 0;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.styleLabel.text = action.title;
        payType = 1;
    }]];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark topupView delegate
- (void)changeView:(TopUpButtonView *)view{
    if (self.selectView != view) {
        self.selectView.selectImageView.image = [UIImage imageNamed:@""];
        self.selectView = view;
        self.selectView.selectImageView.image = [UIImage imageNamed:selectImageStr];
        
        selectPriceInfo = self.numberArray[view.tag - 1000];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
