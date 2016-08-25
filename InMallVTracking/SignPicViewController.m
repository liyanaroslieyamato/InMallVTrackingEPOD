//
//  SignPicViewController.m
//  InMallVTracking
//
//  Created by Liyana Roslie on 25/8/16.
//  Copyright © 2016 YamatoAsia. All rights reserved.
//

#import "SignPicViewController.h"
#import "SignViewController.h"
#import "Image.h"
#import "ImageCollectionViewCell.h"
#import "GGFullScreenImageViewController.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

@interface SignPicViewController ()

@property (nonatomic, strong) NSArray *images;

@end

@implementation SignPicViewController

- (NSArray *)images
{
    if (!_images)
    {
        _images = [[NSArray alloc] init];
    }
    return _images;
}


NSString *entity_id;
NSString *entity_type;
BOOL img_from_camera = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)download_images {
    
    // setup object mappings
    
    
    
    RKObjectMapping *UserMapping = [RKObjectMapping mappingForClass:[Image class]];
    
    [UserMapping addAttributeMappingsFromDictionary:@{@"type" : @"type",
                                                      @"url": @"url",
                                                      @"thumb":@"thumb"}];
    
    
    
    // register mappings with the provider using a response descriptor
    
    RKResponseDescriptor *responseDescriptor =
    
    [RKResponseDescriptor responseDescriptorWithMapping:UserMapping
     
                                                 method:RKRequestMethodGET
     
                                            pathPattern:@"/hpapi/get_images.json"
     
                                                keyPath:nil
     
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    
    
    NSDictionary *queryParams = @{@"entity_id" : entity_id, @"entity_type":entity_type};
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/hpapi/get_images.json"
     
                                           parameters:queryParams
     
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  self.images = mappingResult.array;
                                                  
                                                  self.imageCollection.dataSource = self;
                                                  [self.imageCollection reloadData];
                                                  //[self reloadData];
                                                  
                                              }
     
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                                  
                                              }];
    
    
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    GGFullscreenImageViewController *vc = [[GGFullscreenImageViewController alloc] init];
    Image *image    = self.images[indexPath.row];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.url]];
    vc.liftedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 400)];
    [vc.liftedImageView setImage:[UIImage imageWithData:data]];
    [self presentViewController:vc animated:YES completion:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *collectionCellID = @"myCollectionCell";
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];

    Image *image    = self.images[indexPath.row];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.thumb]];
    //UIImage *uiImage       = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image.url]]];
    //[cell.imageView setImageWithURL:[NSURL URLWithString:image.url]];
    //cell.imageView.image = uiImage;
    [cell.imageView setImage:[UIImage imageWithData:data]];
    return cell;
};

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_remarksTextView resignFirstResponder];
    }
}

- (void)processCompleted:(UIImage*)signImage remark:(NSString *)remark
{
    img_from_camera = YES;
    [self uploadImage:signImage type:[entity_type stringByAppendingString:@"_sign"] remark:remark];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sign:(id)sender {
     [self performSegueWithIdentifier:@"signSegue" sender:self];
}

- (IBAction)takePic:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;

    self.imageCollection.delegate = self;
    // Do any additional setup after loading the view.
    entity_id = [self.detailDataDict objectForKey:@"entity_id"];
    entity_type = [self.detailDataDict objectForKey:@"entity_type"];
    [self download_images];
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        img_from_camera = YES;
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = YES;
        controller.delegate = self;
        [self presentViewController: controller animated: YES completion: NULL];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        img_from_camera = NO;
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = YES;
        controller.delegate = self;
        [self presentViewController: controller animated: YES completion: NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];

}

-(void)uploadImage:(UIImage *)captureImage type:(NSString *)type remark:(NSString *) remark
{
    if(img_from_camera) {
        UIImageWriteToSavedPhotosAlbum(captureImage, nil, nil, nil);
    }
    NSData *imageData = UIImageJPEGRepresentation(captureImage, 1.0);

    NSString *encodedString = [@"data:image/jpeg;base64," stringByAppendingString: [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    NSDictionary *queryParams = @{@"entity_id" : entity_id,
                                  @"entity_type" : type,
                                  @"image" : encodedString,
                                  @"remark" : remark,
                                  };
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];


    NSMutableURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodPOST path:@"/hpapi/upload_image.json" parameters:queryParams];

    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {

        [self download_images];
        [spinner stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"The picture saved to server."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        //[self.navigationController dismissViewControllerAnimated:YES completion:NULL];


    } failure:^(RKObjectRequestOperation *operation, NSError *error){
        [spinner stopAnimating];
        NSError *jsonError;
        NSData *objectData = [[error localizedRecoverySuggestion] dataUsingEncoding:NSUTF8StringEncoding];
        NSString* message =  @"The internet connection appears to be offline.";
        if(objectData){
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            if(json) {
                message = json[@"errors"];
            }
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }];

    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *captureImage = info[UIImagePickerControllerEditedImage];
    [self uploadImage:captureImage type:entity_type remark:@""];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"signSegue"])
    {
        // Get reference to the destination view controller

        UINavigationController *navigationController =
        segue.destinationViewController;
        SignViewController
        *ViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
        ViewController.delegate = self;
    }
}

@end
