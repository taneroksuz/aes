#include "aes.h"



uint8_t S_Box[256] = {
0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16};

uint8_t Inv_S_Box[256] = {
0x52,0x09,0x6a,0xd5,0x30,0x36,0xa5,0x38,0xbf,0x40,0xa3,0x9e,0x81,0xf3,0xd7,0xfb,
0x7c,0xe3,0x39,0x82,0x9b,0x2f,0xff,0x87,0x34,0x8e,0x43,0x44,0xc4,0xde,0xe9,0xcb,
0x54,0x7b,0x94,0x32,0xa6,0xc2,0x23,0x3d,0xee,0x4c,0x95,0x0b,0x42,0xfa,0xc3,0x4e,
0x08,0x2e,0xa1,0x66,0x28,0xd9,0x24,0xb2,0x76,0x5b,0xa2,0x49,0x6d,0x8b,0xd1,0x25,
0x72,0xf8,0xf6,0x64,0x86,0x68,0x98,0x16,0xd4,0xa4,0x5c,0xcc,0x5d,0x65,0xb6,0x92,
0x6c,0x70,0x48,0x50,0xfd,0xed,0xb9,0xda,0x5e,0x15,0x46,0x57,0xa7,0x8d,0x9d,0x84,
0x90,0xd8,0xab,0x00,0x8c,0xbc,0xd3,0x0a,0xf7,0xe4,0x58,0x05,0xb8,0xb3,0x45,0x06,
0xd0,0x2c,0x1e,0x8f,0xca,0x3f,0x0f,0x02,0xc1,0xaf,0xbd,0x03,0x01,0x13,0x8a,0x6b,
0x3a,0x91,0x11,0x41,0x4f,0x67,0xdc,0xea,0x97,0xf2,0xcf,0xce,0xf0,0xb4,0xe6,0x73,
0x96,0xac,0x74,0x22,0xe7,0xad,0x35,0x85,0xe2,0xf9,0x37,0xe8,0x1c,0x75,0xdf,0x6e,
0x47,0xf1,0x1a,0x71,0x1d,0x29,0xc5,0x89,0x6f,0xb7,0x62,0x0e,0xaa,0x18,0xbe,0x1b,
0xfc,0x56,0x3e,0x4b,0xc6,0xd2,0x79,0x20,0x9a,0xdb,0xc0,0xfe,0x78,0xcd,0x5a,0xf4,
0x1f,0xdd,0xa8,0x33,0x88,0x07,0xc7,0x31,0xb1,0x12,0x10,0x59,0x27,0x80,0xec,0x5f,
0x60,0x51,0x7f,0xa9,0x19,0xb5,0x4a,0x0d,0x2d,0xe5,0x7a,0x9f,0x93,0xc9,0x9c,0xef,
0xa0,0xe0,0x3b,0x4d,0xae,0x2a,0xf5,0xb0,0xc8,0xeb,0xbb,0x3c,0x83,0x53,0x99,0x61,
0x17,0x2b,0x04,0x7e,0xba,0x77,0xd6,0x26,0xe1,0x69,0x14,0x63,0x55,0x21,0x0c,0x7d};

uint8_t EXP_3[256] = {
0x01,0x03,0x05,0x0f,0x11,0x33,0x55,0xff,0x1a,0x2e,0x72,0x96,0xa1,0xf8,0x13,0x35,
0x5f,0xe1,0x38,0x48,0xd8,0x73,0x95,0xa4,0xf7,0x02,0x06,0x0a,0x1e,0x22,0x66,0xaa,
0xe5,0x34,0x5c,0xe4,0x37,0x59,0xeb,0x26,0x6a,0xbe,0xd9,0x70,0x90,0xab,0xe6,0x31,
0x53,0xf5,0x04,0x0c,0x14,0x3c,0x44,0xcc,0x4f,0xd1,0x68,0xb8,0xd3,0x6e,0xb2,0xcd,
0x4c,0xd4,0x67,0xa9,0xe0,0x3b,0x4d,0xd7,0x62,0xa6,0xf1,0x08,0x18,0x28,0x78,0x88,
0x83,0x9e,0xb9,0xd0,0x6b,0xbd,0xdc,0x7f,0x81,0x98,0xb3,0xce,0x49,0xdb,0x76,0x9a,
0xb5,0xc4,0x57,0xf9,0x10,0x30,0x50,0xf0,0x0b,0x1d,0x27,0x69,0xbb,0xd6,0x61,0xa3,
0xfe,0x19,0x2b,0x7d,0x87,0x92,0xad,0xec,0x2f,0x71,0x93,0xae,0xe9,0x20,0x60,0xa0,
0xfb,0x16,0x3a,0x4e,0xd2,0x6d,0xb7,0xc2,0x5d,0xe7,0x32,0x56,0xfa,0x15,0x3f,0x41,
0xc3,0x5e,0xe2,0x3d,0x47,0xc9,0x40,0xc0,0x5b,0xed,0x2c,0x74,0x9c,0xbf,0xda,0x75,
0x9f,0xba,0xd5,0x64,0xac,0xef,0x2a,0x7e,0x82,0x9d,0xbc,0xdf,0x7a,0x8e,0x89,0x80,
0x9b,0xb6,0xc1,0x58,0xe8,0x23,0x65,0xaf,0xea,0x25,0x6f,0xb1,0xc8,0x43,0xc5,0x54,
0xfc,0x1f,0x21,0x63,0xa5,0xf4,0x07,0x09,0x1b,0x2d,0x77,0x99,0xb0,0xcb,0x46,0xca,
0x45,0xcf,0x4a,0xde,0x79,0x8b,0x86,0x91,0xa8,0xe3,0x3e,0x42,0xc6,0x51,0xf3,0x0e,
0x12,0x36,0x5a,0xee,0x29,0x7b,0x8d,0x8c,0x8f,0x8a,0x85,0x94,0xa7,0xf2,0x0d,0x17,
0x39,0x4b,0xdd,0x7c,0x84,0x97,0xa2,0xfd,0x1c,0x24,0x6c,0xb4,0xc7,0x52,0xf6,0x01};

uint8_t LN_3[256] = {
0x00,0x00,0x19,0x01,0x32,0x02,0x1a,0xc6,0x4b,0xc7,0x1b,0x68,0x33,0xee,0xdf,0x03,
0x64,0x04,0xe0,0x0e,0x34,0x8d,0x81,0xef,0x4c,0x71,0x08,0xc8,0xf8,0x69,0x1c,0xc1,
0x7d,0xc2,0x1d,0xb5,0xf9,0xb9,0x27,0x6a,0x4d,0xe4,0xa6,0x72,0x9a,0xc9,0x09,0x78,
0x65,0x2f,0x8a,0x05,0x21,0x0f,0xe1,0x24,0x12,0xf0,0x82,0x45,0x35,0x93,0xda,0x8e,
0x96,0x8f,0xdb,0xbd,0x36,0xd0,0xce,0x94,0x13,0x5c,0xd2,0xf1,0x40,0x46,0x83,0x38,
0x66,0xdd,0xfd,0x30,0xbf,0x06,0x8b,0x62,0xb3,0x25,0xe2,0x98,0x22,0x88,0x91,0x10,
0x7e,0x6e,0x48,0xc3,0xa3,0xb6,0x1e,0x42,0x3a,0x6b,0x28,0x54,0xfa,0x85,0x3d,0xba,
0x2b,0x79,0x0a,0x15,0x9b,0x9f,0x5e,0xca,0x4e,0xd4,0xac,0xe5,0xf3,0x73,0xa7,0x57,
0xaf,0x58,0xa8,0x50,0xf4,0xea,0xd6,0x74,0x4f,0xae,0xe9,0xd5,0xe7,0xe6,0xad,0xe8,
0x2c,0xd7,0x75,0x7a,0xeb,0x16,0x0b,0xf5,0x59,0xcb,0x5f,0xb0,0x9c,0xa9,0x51,0xa0,
0x7f,0x0c,0xf6,0x6f,0x17,0xc4,0x49,0xec,0xd8,0x43,0x1f,0x2d,0xa4,0x76,0x7b,0xb7,
0xcc,0xbb,0x3e,0x5a,0xfb,0x60,0xb1,0x86,0x3b,0x52,0xa1,0x6c,0xaa,0x55,0x29,0x9d,
0x97,0xb2,0x87,0x90,0x61,0xbe,0xdc,0xfc,0xbc,0x95,0xcf,0xcd,0x37,0x3f,0x5b,0xd1,
0x53,0x39,0x84,0x3c,0x41,0xa2,0x6d,0x47,0x14,0x2a,0x9e,0x5d,0x56,0xf2,0xd3,0xab,
0x44,0x11,0x92,0xd9,0x23,0x20,0x2e,0x89,0xb4,0x7c,0xb8,0x26,0x77,0x99,0xe3,0xa5,
0x67,0x4a,0xed,0xde,0xc5,0x31,0xfe,0x18,0x0d,0x63,0x8c,0x80,0xc0,0xf7,0x70,0x07};

uint8_t Rcon[11] = {
0x00,0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80,0x1b,0x36
};

AES::AES(int Nb,int Nk, uint8_t *key)
{
    this->Nb = Nb;
    this->Nk = Nk;
    this->Nr = NumRounds(Nb,Nk);

    this->Key = (uint8_t *) malloc(4*this->Nk*sizeof(uint8_t));

    for (int i=0; i<4*this->Nk; i++)
    {
      this->Key[i] = key[i];
    }

    this->Word = (uint32_t *) malloc(this->Nb*(this->Nr+1)*sizeof(uint32_t));

    this->KeyExpansion();
}

int AES::NumRounds(int Nb,int Nk)
{
    if (Nb == 4 && Nk == 4)
    {
        return 10;
    }
    else if (Nb == 4 && Nk == 6)
    {
        return 12;
    }
    else if (Nb == 4 && Nk == 8)
    {
        return 14;
    }
    else if (Nb == 6 && Nk == 4)
    {
        return 12;
    }
    else if (Nb == 6 && Nk == 6)
    {
        return 12;
    }
    else if (Nb == 6 && Nk == 8)
    {
        return 14;
    }
    else if (Nb == 8 && Nk == 4)
    {
        return 14;
    }
    else if (Nb == 8 && Nk == 6)
    {
        return 14;
    }
    else if (Nb == 8 && Nk == 8)
    {
        return 14;
    }
    else
    {
        fprintf(stderr, "Division by zero! Exiting...\n");
        exit(-1);
    }
}

uint8_t AES::RC(int i)
{
    if (i == 1)
    {
        return 1;
    }
    else if (i > 1)
    {
        if (RC(i-1) < 0x80)
        {
            return 2*RC(i-1);
        }
        else
        {
            return (2*RC(i-1) ^ 0x11B);
        }
    }
    else
    {
        return 0;
    }
}

uint8_t AES::GaloisMul(uint8_t a,uint8_t b)
{
    if(a && b)
    {
        return EXP_3[(LN_3[a] + LN_3[b]) % 0xFF];
    }
    else
    {
        return 0;
    }
}

uint32_t AES::RoundConstant(int i)
{
    uint8_t rc = RC(i);
    uint32_t temp = (rc << 24);
    return temp;
}

void AES::AddRoundkey(uint8_t *state,int round)
{
    uint32_t temp;
    for (int j=0; j<this->Nb; j++)
    {
        temp = this->Word[round*this->Nb+j];
        for (int i=0; i<4; i++)
        {
            uint8_t index = state[4*i+j];
            uint8_t key = (temp >> ((3-i)*8)) & 0xFF;
            state[4*i+j] = key ^ index;
        }
    }
}

void AES::MixColumns(uint8_t *state)
{
    uint8_t *column = (uint8_t *) malloc(4*sizeof(uint8_t));
    uint8_t *last = (uint8_t *) malloc(4*sizeof(uint8_t));
    for (int j=0; j<this->Nb; j++)
    {
        for (int i=0; i<4; i++)
        {
            column[i] = state[4*i+j];
        }
        last[0] = GaloisMul(0x02,column[0]) ^ GaloisMul(0x03,column[1]) ^ GaloisMul(0x01,column[2]) ^ GaloisMul(0x01,column[3]);
        last[1] = GaloisMul(0x01,column[0]) ^ GaloisMul(0x02,column[1]) ^ GaloisMul(0x03,column[2]) ^ GaloisMul(0x01,column[3]);
        last[2] = GaloisMul(0x01,column[0]) ^ GaloisMul(0x01,column[1]) ^ GaloisMul(0x02,column[2]) ^ GaloisMul(0x03,column[3]);
        last[3] = GaloisMul(0x03,column[0]) ^ GaloisMul(0x01,column[1]) ^ GaloisMul(0x01,column[2]) ^ GaloisMul(0x02,column[3]);
        for (int i=0; i<4; i++)
        {
            state[4*i+j] = last[i];
        }
    }
}

void AES::ShiftRows(uint8_t *state)
{
    int C[3] = {0,0,0};
    if (this->Nb == 4)
    {
        C[0] = 1;
        C[1] = 2;
        C[2] = 3;
    }
    else if (this->Nb == 6)
    {
        C[0] = 2;
        C[1] = 2;
        C[2] = 3;
    }
    else if (this->Nb == 8)
    {
        C[0] = 3;
        C[1] = 3;
        C[2] = 4;
    }
    uint8_t *row = (uint8_t *) malloc(Nb*sizeof(uint8_t));
    for (int i=1; i<4; i++)
    {
        for (int j=0; j<this->Nb; j++)
        {
            row[j] = state[i*this->Nb+((j+C[i-1])%this->Nb)];
        }
        for (int j=0; j<this->Nb; j++)
        {
            state[i*this->Nb+j] = row[j];
        }
    }
}

void AES::SubBytes(uint8_t *state)
{
    for (int i=0; i<4; i++)
    {
        for (int j=0; j<this->Nb; j++)
        {
            state[i*this->Nb+j] = S_Box[state[i*this->Nb+j]];
        }
    }
}

void AES::InvMixColumns(uint8_t *state)
{
    uint8_t *column = (uint8_t *) malloc(4*sizeof(uint8_t));
    uint8_t *last = (uint8_t *) malloc(4*sizeof(uint8_t));
    for (int j=0; j<this->Nb; j++)
    {
        for (int i=0; i<4; i++)
        {
            column[i] = state[4*i+j];
        }
        last[0] = GaloisMul(0x0e,column[0]) ^ GaloisMul(0x0b,column[1]) ^ GaloisMul(0x0d,column[2]) ^ GaloisMul(0x09,column[3]);
        last[1] = GaloisMul(0x09,column[0]) ^ GaloisMul(0x0e,column[1]) ^ GaloisMul(0x0b,column[2]) ^ GaloisMul(0x0d,column[3]);
        last[2] = GaloisMul(0x0d,column[0]) ^ GaloisMul(0x09,column[1]) ^ GaloisMul(0x0e,column[2]) ^ GaloisMul(0x0b,column[3]);
        last[3] = GaloisMul(0x0b,column[0]) ^ GaloisMul(0x0d,column[1]) ^ GaloisMul(0x09,column[2]) ^ GaloisMul(0x0e,column[3]);
        for (int i=0; i<4; i++)
        {
            state[4*i+j] = last[i];
        }
    }
}
void AES::InvShiftRows(uint8_t *state)
{
    int C[3] = {0,0,0};
    if (this->Nb == 4)
    {
        C[0] = 1;
        C[1] = 2;
        C[2] = 3;
    }
    else if (this->Nb == 6)
    {
        C[0] = 2;
        C[1] = 2;
        C[2] = 3;
    }
    else if (this->Nb == 8)
    {
        C[0] = 3;
        C[1] = 3;
        C[2] = 4;
    }
    uint8_t *row = (uint8_t *) malloc(Nb*sizeof(uint8_t));
    for (int i=1; i<4; i++)
    {
        for (int j=0; j<this->Nb; j++)
        {
            row[j] = state[i*this->Nb+((j+this->Nb-C[i-1])%this->Nb)];
        }
        for (int j=0; j<this->Nb; j++)
        {
            state[i*this->Nb+j] = row[j];
        }
    }
}

void AES::InvSubBytes(uint8_t *state)
{
    for (int i=0; i<4; i++)
    {
        for (int j=0; j<this->Nb; j++)
        {
            state[i*this->Nb+j] = Inv_S_Box[state[i*this->Nb+j]];
        }
    }
}

uint32_t AES::RotWord(uint32_t word)
{
    uint32_t temp = (word & 0xFFFFFF) << 8;
    temp |= (word >> 24) & 0xFF;
    return temp;
}

uint32_t AES::SubWord(uint32_t word)
{
    uint32_t temp = 0;
    uint8_t byte;
    int i = 3;
    while(i>=0)
    {
        byte = (word >> (0x08 * i)) & 0xFF;
        byte = S_Box[byte];
        temp = (temp << 8) | byte;
        i--;
    }
    return temp;
}

#ifdef DEBUG
void AES::print_state(uint8_t *state)
{
#ifdef LINE
    for (int j=0; j<this->Nb; j++)
    {
        for (int i=0; i<4; i++)
        {
            printf("%02x",state[i*this->Nb+j]);
        }
    }
    printf("\n");
#else
    for (int i=0; i<4; i++)
    {
        for (int j=0; j<this->Nb; j++)
        {
            printf("%02X |",state[i*this->Nb+j]);
        }
        printf("\n");
    }
    printf("\n");
#endif
}
#else
void AES::print_state(uint8_t *state)
{}
#endif

void AES::copy_in(uint8_t *state,uint8_t *in)
{
    for (int j=0; j<this->Nb; j++)
    {
        for (int i=0; i<4; i++)
        {
            state[4*i+j] = in[j*this->Nb+i];
        }
    }
}

void AES::copy_out(uint8_t *state,uint8_t *out)
{
    for (int j=0; j<this->Nb; j++)
    {
        for (int i=0; i<4; i++)
        {
            out[j*this->Nb+i] = state[4*i+j];
        }
    }
}

void AES::KeyExpansion()
{
    uint32_t temp;

    for(int i=0; i<this->Nk; i++)
    {
        this->Word[i] = (this->Key[4*i] << 24) |
                  (this->Key[4*i+1] << 16) |
                  (this->Key[4*i+2] << 8) |
                  (this->Key[4*i+3]);
#ifdef DEBUG
        printf("%08X\n",this->Word[i]);
#endif
    }

    for(int i=this->Nk; i<(this->Nb*(this->Nr+1)); i++)
    {
        temp = this->Word[i-1];
#ifdef DEBUG
        printf("%08X\t",temp);
#endif
        if ((i % this->Nk) == 0)
        {
          temp = SubWord(RotWord(temp)) ^ (Rcon[i/this->Nk] << 24);
#ifdef DEBUG
          printf("%08X\t",(Rcon[i/this->Nk] << 24));
#endif
        }
        else if (this->Nk>6 && (i%this->Nk) == 4)
        {
          temp = SubWord(temp);
        }
        this->Word[i] = this->Word[i-this->Nk] ^ temp;
#ifdef DEBUG
        printf("%08X\t",this->Word[i-this->Nk]);
        printf("%08X\n",this->Word[i]);
#endif
    }
#ifdef DEBUG
    printf("\n\n");
#endif
}

void AES::Cipher(uint8_t *in,uint8_t *out)
{
    uint8_t *state = (uint8_t *) malloc(4*this->Nb*sizeof(uint8_t));

    copy_in(state,in);

    print_state(state);
    AddRoundkey(state,0);

    for(int round=1; round<this->Nr; round++)
    {
        print_state(state);
        SubBytes(state);
        print_state(state);
        ShiftRows(state);
        print_state(state);
        MixColumns(state);
        print_state(state);
        AddRoundkey(state,round);
    }

    print_state(state);
    SubBytes(state);
    print_state(state);
    ShiftRows(state);
    print_state(state);
    AddRoundkey(state,this->Nr);

    print_state(state);
    copy_out(state,out);
#ifdef DEBUG
  printf("\n\n");
#endif
}

void AES::InvCipher(uint8_t *in,uint8_t *out)
{
    uint8_t *state = (uint8_t *) malloc(4*this->Nb*sizeof(uint8_t));

    copy_in(state,in);

    print_state(state);
    AddRoundkey(state,this->Nr);

    for(int round=this->Nr-1; round>0; round--)
    {
        print_state(state);
        InvShiftRows(state);
        print_state(state);
        InvSubBytes(state);
        print_state(state);
        AddRoundkey(state,round);
        print_state(state);
        InvMixColumns(state);
    }

    print_state(state);
    InvShiftRows(state);
    print_state(state);
    InvSubBytes(state);
    print_state(state);
    AddRoundkey(state,0);

    print_state(state);
    copy_out(state,out);
#ifdef DEBUG
  printf("\n\n");
#endif
}
