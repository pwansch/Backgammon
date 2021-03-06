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

typedef BOARD *PBOARD;

// Function prototypes
BOOL fIsFinish(BOOL fWho, BOARD board);
BOOL fIsPlayerMovePossibleHilf(BOARD hilfBoard, short asDiceHilf[4]);
BOOL fIsPlayerMovePossible(BOARD board, short asDice[4]);
short sWhat(BOARD board, BOOL fWinner);
BOOL fCanComputerThrowOne(BOARD board);
short sGetComputerOnes(BOARD board);
BOOL fIsComputerAlmostFinish(BOARD board);