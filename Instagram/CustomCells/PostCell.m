//
//  PostCell.m
//  Instagram
//
//  Created by Adam Issah on 6/27/22.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setPost {
    [self.post.author fetchIfNeeded];

    self.caption.text = self.post.caption;
    NSString *postImageURL = self.post.image.url;
    
    self.likeCount.text = [NSString stringWithFormat:@"%@",self.post.likeCount];
    NSLog(@"%@", self.post.likeCount);
    
    self.commentCount.text = [NSString stringWithFormat:@"%@",self.post.commentCount];
    NSLog(@"%@", self.post.commentCount);
    
    NSDate *date = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert Date to String
    self.timeStamp.text = [date shortTimeAgoSinceNow];
    
    
    if (![self.post.likers containsObject: PFUser.currentUser.objectId]) {
    UIImage *heartIcon = [UIImage systemImageNamed: @"heart"];
    [self.likedButton setImage:heartIcon forState:UIControlStateNormal];
    } else {
    UIImage *heartIcon = [UIImage systemImageNamed: @"heart"];
    [self.likedButton setImage:heartIcon forState:UIControlStateNormal];
    }
    

    [self.image setImageWithURL:[ NSURL URLWithString:postImageURL ] placeholderImage:nil];
    
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
    
