/*
 * Copyright 2016 Eliocity
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "XeeRegisterButton.h"

@interface XeeRegisterButton () {
    UILabel *label;
    UIImageView *iv;
}

@end

@implementation XeeRegisterButton

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 180.0, 44.0)];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    [self setTitle:@"" forState:UIControlStateNormal];
    
    label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 20.0, 0.0)];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    label.text = NSLocalizedStringFromTableInBundle(@"creer_compte", @"local", bundle, @"");
    label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16.0];
    [self addSubview:label];
    
    UIImage *image = [UIImage imageNamed:@"btn-xee" inBundle:bundle compatibleWithTraitCollection:nil];
    iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - self.bounds.size.height, 0.0, self.bounds.size.height, self.bounds.size.height)];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = image;
    [self addSubview:iv];
    iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.style = XeeRegisterButtonStyleGreen;
    self.size = XeeLoginButtonSizeNormal;
    [self addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setStyle:(XeeRegisterButtonStyle)style {
    if(style == XeeRegisterButtonStyleGreen) {
        label.textColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:153/255.0 green:204/255.0 blue:0/255.0 alpha:1.0];
    } else if (style == XeeRegisterButtonStyleDark) {
        label.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:71/255.0 green:71/255.0 blue:71/255.0 alpha:1.0];
    }
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 0.0;
    self.layer.shadowOpacity = 0.3;
}

-(void)setSize:(XeeRegisterButtonSize)size {
    if(size == XeeRegisterButtonSizeNormal) {
        label.hidden = false;
        CGRect frame = self.frame;
        frame.size.width = 180.0;
        self.frame = frame;
    } else if(size == XeeRegisterButtonSizeIcon) {
        label.hidden = true;
        CGRect frame = self.frame;
        frame.size.width = 44.0;
        self.frame = frame;
    }
}

-(void)press {
    [[Xee connectManager] createAccount];
}

-(void)setDelegate:(id<XeeConnectManagerDelegate>)delegate {
    [Xee connectManager].delegate = delegate;
}

@end
