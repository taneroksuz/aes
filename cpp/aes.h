#ifndef AES_H
#define AES_H

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <cerrno>

class AES
{
    private:

        int NK; // 4,6,8
        int NR; // 10,12,14

        uint8_t *Key;
        uint32_t *Word;
        // uint32_t *Rcon;

        int NumRounds(int NK);

        uint32_t RoundConstant(int i);

        uint8_t RC(int i);

        uint8_t GaloisMul(uint8_t a,uint8_t b);

        void AddRoundkey(uint8_t *state,int round);

        void MixColumns(uint8_t *state);
        void ShiftRows(uint8_t *state);
        void SubBytes(uint8_t *state);

        void InvMixColumns(uint8_t *state);
        void InvShiftRows(uint8_t *state);
        void InvSubBytes(uint8_t *state);

        uint32_t RotWord(uint32_t word);
        uint32_t SubWord(uint32_t word);

        void print_state(uint8_t *state);

        void copy_in(uint8_t *state,uint8_t *in);

        void copy_out(uint8_t *state,uint8_t *out);

        void KeyExpansion();


    public:

        AES(int NK,uint8_t *key);

        void Cipher(uint8_t *in,uint8_t *out);

        void InvCipher(uint8_t *in,uint8_t *out);
};


#endif
