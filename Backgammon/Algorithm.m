//
//  Algorithm.m
//  Backgammon
//
//  Created by Peter Wansch on 7/24/13.
//
//

#import "Algorithm.h"

BOOL fIsFinish(BOOL fWho, BOARD board)
{
    short i;
    
    if (fWho == PLAYER) {
        for (i = 8; i < 28; i++)
            if (board.fWho[i] == PLAYER && board.usNo[i] > 0)
                return NO;
    }
    else {
        for (i = 0; i < 20; i++)
            if (board.fWho[i] == COMPUTER && board.usNo[i] > 0)
                return NO;
    }
    return YES;
}

BOOL fIsPlayerMovePossibleHilf(BOARD hilfBoard, short asDiceHilf[4])
{
    BOOL fFinish;
    
    fFinish = YES;
    
    for (int i = 25; i > 1; i--)
        // Wir ueberpruefen nur die Positionen auf denen Steine vom Spieler liegen
        if (hilfBoard.fWho[i] == PLAYER && hilfBoard.usNo[i] > 0)
        {
            for (int j = 0; j < 4; j++)
                if (asDiceHilf[j] != -1)
                {
                    // Ueberpruefe, ob ein Zug moeglich ist
                    if ((i - asDiceHilf[j]) > 0)
                    {
                        if ((i - asDiceHilf[j]) == 1 && fFinish)
                            return YES;
                        if ((i - asDiceHilf[j]) != 1 && (hilfBoard.usNo[i - asDiceHilf[j]] < 2 || hilfBoard.fWho[i - asDiceHilf[j]] == PLAYER))
                            return YES;
                    }
                }
        }
    return NO;
}

BOOL fIsPlayerMovePossible(BOARD board, short asDice[4])
{
    BOOL fFinish;
    
    // Ueberpruefe, ob etwas am Balken liegt
    if (board.usNo[27] > 0)
    {
        // Es liegt etwas am Balken
        for (int i = 0; i < 4; i++)
            if (asDice[i] != -1)
                // ueberpruefe, ob ein Zug moeglich ist
                if (board.usNo[26 - asDice[i]] < 2 || board.fWho[26 - asDice[i]] == PLAYER)
                    return YES;
        return NO;
    }
    
    // Darf der Spieler schon Steine ins Ziel bringen?
    fFinish = fIsFinish (PLAYER, board);
    
    for (int i = 25; i > 1; i--)
        // Wir ueberpruefen nur die Positionen auf denen Steine vom Spieler liegen
        if (board.fWho[i] == PLAYER && board.usNo[i] > 0)
        {
            for (int j = 0; j < 4; j++)
                if (asDice[j] != -1)
                {
                    // ueberpruefe, ob ein Zug moeglich ist
                    if ((i - asDice[j]) > 0)
                    {
                        if ((i - asDice[j]) == 1 && fFinish)
                            return YES;
                        if ((i - asDice[j]) != 1 && (board.usNo[i - asDice[j]] < 2 || board.fWho[i - asDice[j]] == PLAYER))
                            return YES;
                    }
                }
        }
    return NO;
}

short sWhat(BOARD board, BOOL fWinner)
{
    if (fWinner == PLAYER)
    {
        for (int i = 0; i < 8; i++)
            if (board.fWho[i] == COMPUTER && board.usNo[i] > 0)
                return 3;
        if (board.usNo[26] == 0)
            return 2;
        return 1;
    }
    else
    {
        for (int i = 20; i < 28; i++)
            if (board.fWho[i] == PLAYER && board.usNo[i] > 0)
                return 3;
        if (board.usNo[1] == 0)
            return 2;
        return 1;
    }
}

BOOL fCanComputerThrowOne(BOARD board)
{
    for (int i = 20; i < 26; i++)
    {
        if (board.usNo[i] == 1 && board.fWho[i] == COMPUTER)
            return NO;
    }
    return YES;
}

short sGetComputerOnes(BOARD board)
{
    short sum, i;
    BOOL fDanger;
    
    sum = 0;
    
    fDanger = NO;
    
    for (i = 27; i > 8; i--)
    {
        if (!fDanger && board.usNo[i] > 0 && board.fWho[i] == PLAYER)
        {
            fDanger = YES;
            continue;
        }
        if (fDanger && board.usNo[i] == 1 && board.fWho[i] == COMPUTER)
        {
            if (i < 15)
                sum++;
            if (i > 14 && i < 21)
                sum += 2;
            if (i > 20)
                sum += 3;
        }
    }
    return sum;
}

BOOL fIsComputerAlmostFinish(BOARD board)
{
    short i;
    
    for (i = 0; i < 14; i++)
        if (board.fWho[i] == COMPUTER && board.usNo[i] > 0)
            return NO;
    return YES;
}



