//
//  ViewController.m
//  treasureSeekers
//
//  Created by Isaac Zhang on 9/24/16.
//  Copyright © 2016 Isaac Zhang. All rights reserved.
//

#import "ViewController.h"
#import "GameManager.h"
#import "Map.h"
#import "Seeker.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) GameManager * gm;
@property (weak, nonatomic) IBOutlet UILabel *playerOneScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerTwoScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameProgressButton;
@property (weak, nonatomic) IBOutlet UICollectionView *gameBoardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;

@end

@implementation ViewController
CGFloat static itemPadding = 6;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gm = [[GameManager alloc] init];
    self.gameStatusLabel.hidden = YES;
    [self.gm prepareNewGame];
    
    [self setupUI];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.gameBoardCollectionView reloadData];
}


-(void) setupUI
{
    [self updateScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClicked:(id)sender
{
    if(self.gm.status == ended)
        [self prepareNewGame];
    
    self.gameProgressButton.hidden = YES;
    self.gameStatusLabel.text = @"Round 1";
    self.gameStatusLabel.hidden = NO;
    
    [self startGame];
}

-(void) startGame
{
    
    [self advanceGame:^(gameStatus status) {
        if(status == advancing)
            [self performSelector:@selector(startGame) withObject:NULL afterDelay:1];
    }];
}


-(void) advanceGame:(executeBlock) block
{
    [self.gm advanceRoundWithCompleteBlock:^{
        //update UI
        self.gameStatusLabel.text = [NSString stringWithFormat:@"Round %d", self.gm.round];
        
        [self.gm checkCurrentRoundResultWithCompleteBlock:^(gameStatus status, Seeker * winner) {
            [self.gameBoardCollectionView reloadData];

            if(status == ended)
            {
                [self updateScores];
                self.gameProgressButton.hidden = NO;
                self.gameStatusLabel.text = [NSString stringWithFormat:@"Game ended at round %d, %@ won", self.gm.round, winner.colorName];
            }
            
            if(block)
                block(status);
        }];
    }];
}



-(void) prepareNewGame
{
    [self.gm prepareNewGame];
    self.gameProgressButton.userInteractionEnabled = YES;
    [self.gameProgressButton setTitle:@"Start" forState:UIControlStateNormal];
}



-(void) updateScores
{
    self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%ld", ((Seeker *)self.gm.playerList[0]).score];
    self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%ld", ((Seeker *)self.gm.playerList[1]).score];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gm.map.height * self.gm.map.width;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize ret = CGSizeZero;
    
    CGFloat width = (self.view.frame.size.width - itemPadding * (self.gm.map.width + 2) * 2) / self.gm.map.width;
    ret = CGSizeMake(width, width);
    
    return ret;
}


-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return itemPadding;
}


-(CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return itemPadding;
}


-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.gm.map.width * self.gm.map.height? UIEdgeInsetsMake(itemPadding, itemPadding, itemPadding, itemPadding) : UIEdgeInsetsZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return self.gm.map.width * self.gm.map.height == 0? CGSizeZero : CGSizeMake(CGRectGetWidth(collectionView.frame), 32);
}



-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    Location * aLocation = [[Location alloc] initWithX:indexPath.row % self.gm.map.width y: floor(indexPath.row / self.gm.map.height)];
    
    NSString * colorName = [self.gm colorOfLocation: aLocation];
    
    UIImageView * image = [[UIImageView alloc] initWithImage: [UIImage imageNamed: colorName]];
    image.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    [cell.contentView addSubview: image];

    return cell;
}

@end
