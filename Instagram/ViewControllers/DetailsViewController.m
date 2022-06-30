//
//  DetailsViewController.m
//  Instagram
//
//  Created by Adam Issah on 6/28/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PostCell.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIButton *likedButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *timePassed;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.post.author fetchIfNeeded];
    [self.post fetchIfNeeded];
    self.caption.text = self.post.caption;
    NSString *postImageURL = self.post.image.url;
    
    self.likeCount.text = [NSString stringWithFormat:@"%@",self.post.likeCount];
    NSLog(@"%@", self.post.likeCount);
    
    self.commentCount.text = [NSString stringWithFormat:@"%@",self.post.commentCount];
    NSLog(@"%@", self.post.commentCount);
    
    NSDate *date = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    self.timePassed.text = [date shortTimeAgoSinceNow];
    
    
    if (![self.post.likers containsObject: PFUser.currentUser.objectId]) {
    UIImage *heartIcon = [UIImage systemImageNamed: @"heart"];
    [self.likedButton setImage:heartIcon forState:UIControlStateNormal];
    } else {
    UIImage *heartIcon = [UIImage systemImageNamed: @"heart"];
    [self.likedButton setImage:heartIcon forState:UIControlStateNormal];
    }
    

    [self.photo setImageWithURL:[ NSURL URLWithString:postImageURL ] placeholderImage:nil];
}

- (IBAction)didTapLike:(id)sender {
    
    if (![self.post.likers containsObject: PFUser.currentUser.objectId]) {
    UIImage *heartIconFilled = [UIImage systemImageNamed: @"heart.fill"];
    [self.likedButton setImage:heartIconFilled forState:UIControlStateNormal];
    [self.post incrementKey:@"likeCount"];
    [self.post addObject:PFUser.currentUser.objectId forKey:@"likers"];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Liked post");
            self.likeCount.text = [NSString stringWithFormat:@"%@",self.post.likeCount];
            NSLog(@"%@", self.post.likeCount);
            
            NSLog(@"..");
        } else {
            NSLog(@"Failed to Like");
        }
    }];
    
   
    } else {
        UIImage *heartIcon = [UIImage systemImageNamed: @"heart"];
        [self.likedButton setImage:heartIcon forState:UIControlStateNormal];
        [self.post incrementKey:@"likeCount" byAmount: @(-1)];
        [self.post removeObject:PFUser.currentUser.objectId forKey:@"likers"];
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Unliked post");
                self.likeCount.text = [NSString stringWithFormat:@"%@",self.post.likeCount];
                NSLog(@"%@", self.post.likeCount);
                    
                NSLog(@"..");
            } else {
                NSLog(@"Failed to Unlike");
            }
        }];
        
       
    }

}
@end
