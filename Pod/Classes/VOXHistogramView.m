//
// Created by Nickolay Sheika on 10/8/14.
// Copyright (c) 2014 Coppertino Inc. All rights reserved. (http://coppertino.com/)
//
// VOX, VOX Player, LOOP for VOX are registered trademarks of Coppertino Inc in US.
// Coppertino Inc. 910 Foulk Road, Suite 201, Wilmington, County of New Castle, DE, 19803, USA.
// Contact phone: +1 (888) 765-7069
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "VOXHistogramView.h"
#import "FrameAccessor.h"


@interface VOXHistogramView ()


@property(nonatomic, assign) CGFloat playbackProgress;
@property(nonatomic, assign) CGFloat downloadProgress;

@property(nonatomic, weak) UIImageView *completeImageView;
@property(nonatomic, weak) UIImageView *notCompleteImageView;
@property(nonatomic, weak) UIImageView *downloadedImageView;


@property(nonatomic, weak) UIImageView *completeImageView1;
@property(nonatomic, weak) UIImageView *notCompleteImageView1;
@property(nonatomic, weak) UIImageView *downloadedImageView1;
@end



@implementation VOXHistogramView


#pragma mark - Accessors

- (void)setCompleteColor:(UIColor *)completeColor
{
    _completeColor = completeColor;
    self.completeImageView.tintColor = completeColor;
  //  self.progressPlayView.tintColor = completeColor;
    self.completeImageView1.tintColor = completeColor ;
}

- (void)setNotCompleteColor:(UIColor *)notCompleteColor
{
    _notCompleteColor = notCompleteColor;
    self.notCompleteImageView.tintColor = notCompleteColor;
    self.notCompleteImageView1.tintColor = notCompleteColor ;
}

- (void)setDownloadedColor:(UIColor *)downloadedColor
{
    _downloadedColor = downloadedColor;
    self.downloadedImageView.tintColor = downloadedColor;
   // self.notCompletedProgressPlayView.tintColor = downloadedColor;
    self.downloadedImageView1.tintColor = downloadedColor;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect newFrame = self.bounds;
    newFrame.origin.y += self.bounds.size.height / 2 ;
    
    CGRect newFrame1 = self.bounds;
    newFrame1.origin.y += self.bounds.size.height / 2 + 2 ;
   
    self.notCompleteImageView.frame = self.bounds;
    self.notCompleteImageView.height = self.bounds.size.height / 2 ;
    self.notCompleteImageView1.frame = newFrame1;
    self.notCompleteImageView1.height = self.bounds.size.height / 2 - 2.0;
    
    self.downloadedImageView.frame = self.bounds;
    self.downloadedImageView.height = self.bounds.size.height / 2 ;
    self.downloadedImageView1.frame = newFrame1;
     self.downloadedImageView1.height = self.bounds.size.height / 2 - 2.0;
  
    
    self.completeImageView.frame = self.bounds;
    self.completeImageView.height = self.bounds.size.height / 2;
    self.completeImageView1.frame = newFrame1;
    self.completeImageView1.height = self.bounds.size.height / 2 - 2.0;
    
//    self.progressPlayView.frame =  newFrame;
//    self.progressPlayView.height = 4.0;
//
//    self.notCompletedProgressPlayView.frame = newFrame;
//    self.notCompletedProgressPlayView.height = 4.0;
//

    CGFloat currentWidth = CGRectGetWidth(self.bounds);
    self.completeImageView.width = currentWidth * self.playbackProgress;
    self.completeImageView1.width = currentWidth * self.playbackProgress;
    
    self.downloadedImageView.width = currentWidth * self.downloadProgress;
    self.downloadedImageView1.width = currentWidth * self.downloadProgress;
    
//    self.progressPlayView.width = currentWidth * self.playbackProgress;
//    self.notCompletedProgressPlayView.width = currentWidth * self.downloadProgress;
    
    
}

#pragma mark - Setup

- (void)setup
{
    self.notCompleteImageView1 = [self _buildImageView];
    self.downloadedImageView1 = [self _buildImageView];
    self.completeImageView1 = [self _buildImageView];
    
    self.notCompleteImageView = [self _buildImageView];
    self.downloadedImageView = [self _buildImageView];
    self.completeImageView = [self _buildImageView];
    
 
    
}

- (UIImageView *)_buildImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeLeft;
    [self addSubview:imageView];
    return imageView;
}

#pragma mark - Accessors


- (void)setImage:(UIImage *)image
{
    if ([_image isEqual:image])
        return;
    
    _image = image;
    
    self.completeImageView.image = _image;
    self.notCompleteImageView.image = _image;
    self.downloadedImageView.image = _image;
//    
    UIImage *image2 = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation: UIImageOrientationDownMirrored];
    
    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//
    self.completeImageView1.image = image2;
    self.notCompleteImageView1.image = image2;
    self.downloadedImageView1.image = image2;
    
   
    [self setNeedsLayout];
}
#pragma mark - Public

- (void)updatePlaybackProgress:(CGFloat)playbackProgress
{
    self.playbackProgress = [self _normalizedValue:playbackProgress];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateDownloadProgress:(CGFloat)downloadProgress
{
    self.downloadProgress = [self _normalizedDownloadProgressValue:downloadProgress];
    [self setNeedsLayout];
     [self layoutIfNeeded];
}

#pragma mark - Helpers

- (CGFloat)_normalizedValue:(CGFloat)value
{
    return MAX(MIN(value, 1), 0);
}

- (CGFloat)_normalizedDownloadProgressValue:(CGFloat)downloadProgressValue
{
    return MAX(MIN(downloadProgressValue, 1), self.playbackProgress);
}

@end
