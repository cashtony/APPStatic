//
//  ViewController.m
//  APPStatic
//
//  Created by LiuXuan on 2017/2/13.
//  Copyright © 2017年 Xuan. All rights reserved.
//



#import "ViewController.h"
#import "AppInfo.h"
#import "AppModel.h"

@interface ViewController (){
    NSMutableArray *appArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
//    [self appInfoOnIPhone];
    
    Class c=NSClassFromString(@"LSApplicationWorkspace");
    id    s=[(id)c performSelector:NSSelectorFromString(@"defaultWorkspace")];
    appArray=[s performSelector:NSSelectorFromString(@"allInstalledApplications")];
//    for (id item in appArray) {
//        NSLog(@"name:%@,Id:%@,version:%@ %@",[item performSelector:NSSelectorFromString(@"localizedName")],[item performSelector:NSSelectorFromString(@"applicationIdentifier")],[item performSelector:NSSelectorFromString(@"bundleVersion")],[item performSelector:NSSelectorFromString(@"shortVersionString")]);
//    }
}


-(void)initView{
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.appTableView];
}

-(void)initData{
    self.navigationItem.title=NSLocalizedString(@"本地应用", nil);
    appArray=[NSMutableArray array];
}

-(void)openOtherApp{
    [AppInfo openAppByBundleId:@"com.xiangchao.StarZone"];
}

-(void)appInfoOnIPhone{
    //初始化设置
    [[AppInfo shareAppInfo] setAppInfoInitState];
    
    appArray= [NSMutableArray arrayWithArray:[AppInfo getAllActiveAppBundleIDs]];
    
//    [AppInfo setAirplaneMode:YES];
    
}

-(UITableView *)appTableView{
    if (!_appTableView) {
        _appTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT) style:UITableViewStylePlain];
        _appTableView.delegate  =self;
        _appTableView.dataSource=self;
    }
    return _appTableView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifiler=@"cellIdentifiler";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifiler];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifiler];
        cell.imageView.layer.cornerRadius=5.0f;
        cell.imageView.layer.masksToBounds=YES;
    }
    AppModel *model= [[AppModel alloc]initWithModel:appArray[indexPath.row]];
    cell.textLabel.text=model.appName;
    cell.detailTextLabel.text=model.appBundelID;
    cell.imageView.image=model.iconImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class cls=NSClassFromString(@"LSApplicationWorkspace");
    id s=[(id)cls performSelector:NSSelectorFromString(@"defaultWorkspace")];
    AppModel *model= [[AppModel alloc]initWithModel:appArray[indexPath.row]];
    [s performSelector:NSSelectorFromString(@"openApplicationWithBundleID:") withObject:model.appBundelID];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
