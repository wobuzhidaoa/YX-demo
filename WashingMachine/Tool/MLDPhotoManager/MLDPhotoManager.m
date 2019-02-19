//
//  MLDPhotoManager.m
//  Photo
//
//  Created by Moliy on 2017/3/23.
//  Copyright © 2017年 Moliy. All rights reserved.
//

#import "MLDPhotoManager.h"

@interface MLDPhotoManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate>
{
    
}

@property (nonatomic, assign) LGShowImageType showType;
@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserPhotoArray;
@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserURLArray;
@property (nonatomic,copy)void(^CameraImage)(UIImage *cameraImage);
@property (nonatomic,copy)void(^AlbumArray)(NSArray *albumArray);
@property (nonatomic,assign) NSInteger maxCount;
@end

@implementation MLDPhotoManager

- (void)showPhotoManager:(UIView *)carryView
       withMaxImageCount:(NSInteger)maxCount
                withType:(NSInteger)type
         withCameraImage:(void(^)(UIImage *cameraImage))cameraImage
          withAlbumArray:(void(^)(NSArray *albumArray))albumArray
{
    self.AlbumArray = albumArray;
    self.CameraImage = cameraImage;
    self.maxCount = maxCount;
    [self showAlert:carryView withType:type];
}


#pragma mark - 懒加载

- (NSMutableArray *)LGPhotoPickerBrowserPhotoArray
{
    if (!_LGPhotoPickerBrowserPhotoArray)
    {
        _LGPhotoPickerBrowserPhotoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _LGPhotoPickerBrowserPhotoArray;
}

- (NSMutableArray *)LGPhotoPickerBrowserURLArray
{
    if (!_LGPhotoPickerBrowserURLArray)
    {
        _LGPhotoPickerBrowserURLArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _LGPhotoPickerBrowserURLArray;
}

#pragma mark - setupUI

- (void)showAlert:(UIView *)view withType:(NSInteger)type
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    if (type == 1 || type == 2) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"相机"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [self presentCameraSingle];
                                    }]];
    }
    if (type == 1 || type == 3) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"相册"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
                                    }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                }]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = view;
            popover.sourceRect = view.bounds;
            popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
        }
        [[self getCurrentVC] presentViewController:alertController
                                          animated:YES
                                        completion:nil];
    }
    else
    {
        [[self getCurrentVC] presentViewController:alertController
                                          animated:YES
                                        completion:nil];
    }
}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style
{
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = self.maxCount;   // 最多能选9张图片
    pickerVc.callBack = ^(NSArray *assets)
    {
        NSMutableArray *thumbImageArray = [NSMutableArray array];
        NSMutableArray *originImageArray = [NSMutableArray array];
        NSMutableArray *compressionImageArray = [NSMutableArray array];
        NSMutableArray *fullResolutionImageArray = [NSMutableArray array];
        for (LGPhotoAssets *photo in assets)
        {
            //缩略图
            [thumbImageArray addObject:photo.thumbImage];
            //原图
            [originImageArray addObject:photo.originImage];
            //全屏图
            [fullResolutionImageArray addObject:photo.fullResolutionImage];
            //压缩图片
            [compressionImageArray addObject:photo.compressionImage];
        }
        self.AlbumArray(originImageArray);
    };
    self.showType = style;
    [pickerVc showPickerVc:[self getCurrentVC]];
}

/**
 *  相机
 */
- (void)presentCameraSingle
{
    if (!self.pickVC) {
        self.pickVC = [[UIImagePickerController alloc]init];
    }
    self.pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.pickVC.allowsEditing = YES;
    self.pickVC.delegate = self;
    [[self getCurrentVC] presentViewController:self.pickVC animated:YES completion:^{
        self.pickVC.delegate = self;
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       //关闭界面
                       [picker dismissViewControllerAnimated:YES completion:nil];
                       NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
                       //当选择的类型是图片
                       if([type isEqualToString:@"public.image"]){
                           //先把图片转成NSData
                           UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
                           self.CameraImage(image);
                       }
                   });
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/**
 获取父视图控制器
 */
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    result = window.rootViewController;
    return result;
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser
   numberOfItemsInSection:(NSUInteger)section
{
    if (self.showType == LGShowImageTypeImageBroswer)
    {
        return self.LGPhotoPickerBrowserPhotoArray.count;
    }
    else if (self.showType == LGShowImageTypeImageURL)
    {
        return self.LGPhotoPickerBrowserURLArray.count;
    }
    else
    {
        NSLog(@"非法数据源");
        return 0;
    }
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser
                             photoAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showType == LGShowImageTypeImageBroswer)
    {
        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
    }
    else if (self.showType == LGShowImageTypeImageURL)
    {
        return [self.LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
    }
    else
    {
        NSLog(@"非法数据源");
        return nil;
    }
}


@end
