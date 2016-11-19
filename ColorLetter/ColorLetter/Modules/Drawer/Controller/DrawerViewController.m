//
//  DrawerViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "DrawerViewController.h"
#import "DrawerTableViewCell.h"                           
#import "FZY_SettingViewController.h"
#import "FZY_LoginOrRegisterViewController.h"
#import "FZY_BmobObject.h"
#import "FZY_LoginAndRegisterViewController.h"
#import "FZY_HelpViewController.h"
#import "FZY_CreateGroupViewController.h"

static NSString *const cellIdentifier = @"drawerCell";

@interface DrawerViewController ()

<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *objectArray;

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) FZY_User *user;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DrawerViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
    self.objectArray = [[FZY_DataHandle shareDatahandle] select:nil];
    for (FZY_User *user in _objectArray) {
        if (user.name == [[EMClient sharedClient] currentUsername]) {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:user.imageUrl]];
            _flag = YES;
            self.user = user;
        }
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flag = NO;
    self.objectArray = [NSMutableArray array];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_myImage];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 7 * 5, 0, WIDTH / 7 * 2, HEIGHT)];
    bgView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.view addSubview:bgView];
    // 轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    // 视图添加一个手势
    [bgView addGestureRecognizer:tap];
    
    // 轻扫手势
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    // 设置轻扫方向
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [bgView addGestureRecognizer:swipe];
    
    [self createArray];
    [self createTableView];
}

- (void)reduction {
    //    [UIView animateWithDuration:0.001 animations:^{
    //        self.view.transform = CGAffineTransformMakeTranslation(-500, 0);
    //    }];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;
//    animation.type = @"suckEffect";
    animation.type = kCATransitionFromRight;
     [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    [self reduction];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self reduction];
}

- (void)createArray {
    self.imageArray = @[@"groups", @"help", @"log Out"];
    self.nameArray = @[@"Create Group", @"Help", @"Log Out"];
}

- (void)createTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 7 * 5, HEIGHT)];
    [self.view addSubview:view];
    // 设置模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 创建模糊效果的视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    // 添加到有模糊效果的控件上
    effectView.frame = view.bounds;
    [view addSubview:effectView];
    
    
    //头像
   self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH / 7 * 2 - 100) * 0.5, (HEIGHT - HEIGHT / 3 * 2 - 100) * 0.5, 100, 100)];
   _imageView.image = [UIImage imageNamed:@"mood-confused"];

    [effectView addSubview:_imageView];
    
    //把头像设置成圆形
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
    
    //隐藏裁剪掉的部分
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
     
    //给头像加一个圆形边框
    _imageView.layer.borderWidth = 1.5f;
    //允许用户交互
    _imageView.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertImageView:)];
   //给imageView添加手势
    [_imageView addGestureRecognizer:singleTap];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT / 3, WIDTH / 7 * 5, HEIGHT / 3 * 2) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    [_tableView registerClass:[DrawerTableViewCell class] forCellReuseIdentifier:cellIdentifier];

}
-(void)alertImageView:(UITapGestureRecognizer *)gesture{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
         //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
         //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
        
    }]];   
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
       //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //定义一个newPhoto，用来存放我们选择的图片
    UIImage *newPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSLog(@"%@", newPhoto);
    //把newPhono设置成头像
    _imageView.image = newPhoto;
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.activityIndicatorView.center=self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicatorView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *imageData = UIImageJPEGRepresentation(newPhoto, 0.5);
         AVFile *file = [AVFile fileWithData:imageData];
        if (_flag == YES) {
            // 第一个参数是 className，第二个参数是 objectId
            AVObject *userPhoto =[AVObject objectWithClassName:@"userAvatar" objectId:[NSString stringWithFormat:@"%@", _user.userId]];
            // 修改属性
            [userPhoto setObject:file forKey:@"image"];
            // 保存到云端
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [[FZY_DataHandle shareDatahandle] update:_user.imageUrl new:file.url];
                    [_imageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
                    [TSMessage showNotificationWithTitle:@"Success" subtitle:@"更新成功" type:TSMessageNotificationTypeSuccess];
                    [self.activityIndicatorView stopAnimating];
                    self.view.userInteractionEnabled = YES;

                }else {
                    [TSMessage showNotificationWithTitle:@"Error" subtitle:@"更新失败" type:TSMessageNotificationTypeError];
                    [self.activityIndicatorView stopAnimating];
                    self.view.userInteractionEnabled = YES;
                }
            }];
        }else {
            AVObject *userPhoto = [AVObject objectWithClassName:@"userAvatar"];
            [userPhoto setObject:file forKey:@"image"];
            [userPhoto setObject:[[EMClient sharedClient] currentUsername] forKey:@"userName"];
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // 存储成功
                    NSLog(@"上传成功");
                    [[FZY_DataHandle shareDatahandle] inset:[[EMClient sharedClient] currentUsername] imageUrl:file.url userId:userPhoto.objectId];
                    [TSMessage showNotificationWithTitle:@"Success" subtitle:@"上传成功" type:TSMessageNotificationTypeSuccess];
                    [self.activityIndicatorView stopAnimating];
                    self.view.userInteractionEnabled = YES;
                    
                } else {
                    // 失败的话，请检查网络环境以及 SDK 配置是否正确
                    [TSMessage showNotificationWithTitle:@"Error" subtitle:@"上传失败" type:TSMessageNotificationTypeError];
                    [self.activityIndicatorView stopAnimating];
                    self.view.userInteractionEnabled = YES;
                }
            }];

        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.cellName = _nameArray[indexPath.row];
    cell.cellImage = _imageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            FZY_CreateGroupViewController *createVC = [[FZY_CreateGroupViewController alloc] init];
            [self presentViewController:createVC animated:YES completion:nil];
        }
        case 1:{

            FZY_HelpViewController *helpViewControllView = [[FZY_HelpViewController alloc]init];

            [self presentViewController:helpViewControllView animated:YES completion:nil];
            
            NSLog(@"你点击了help");
            break;
        }
        case 2:{
            EMError *error = [[EMClient sharedClient]logout:YES];
            if (!error) {
                FZY_LoginAndRegisterViewController *larVC = [[FZY_LoginAndRegisterViewController                                                 alloc] init];
                self.view.window.rootViewController = larVC;
                
                }
            }
            break;
        default:
            break;
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
