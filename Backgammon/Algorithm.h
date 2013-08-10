//
//  Algorithm.h
//  Backgammon
//
//  Created by Peter Wansch on 7/24/13.
//
//

// Algorithm defines
#define DIVISIONSX  14
#define DIVISIONSY  12
#define PLAYER      NO
#define COMPUTER    YES
#define NOINDEXES   28

typedef struct _BOARD
{
    BOOL fWho[NOINDEXES];
    unsigned short usNo[NOINDEXES];
} BOARD;

// Function prototypes
BOOL fIsComputerAlmostFinish(BOARD board);
short sGetComputerOnes(BOARD board);
BOOL fCanComputerThrowOne(BOARD board);
void Draw(unsigned short usFromIndex, unsigned short usToIndex, BOOL fUpdateBar);
void CalcMoves();
void RollDice();
short sWhat(BOOL fWinner);
void SortasDice();
BOOL fIsPlayerMovePossibleHilf();
BOOL fIsPlayerMovePossible();
BOOL fIsFinish(BOOL fWho, BOARD board);
BOOL fQueryDice(unsigned short sDist);
