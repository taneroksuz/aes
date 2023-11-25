#include "aes.h"
#include <fstream>
#include <iostream>

using namespace std;

uint8_t hex(char c)
{
    uint8_t res = (uint8_t) c;
    if (c <= '9' && c >= '0')
    {
        res = res - 48;
    }
    else if (c <= 'f' && c >= 'a')
    {
        res = res - 87;
    }
    else if (c <= 'F' && c >= 'A')
    {
        res = res - 55;
    }
    return res;
}

void get(string in,uint8_t *out, int num)
{
    for (int i=0; i<num; i=i+1)
    {
        out[i] = hex(in[2*i]);
        out[i] <<= 0x4;
        out[i] += hex(in[2*i+1]);
    }
}

void compare(uint8_t *in,uint8_t *out, int num, int type)
{
    bool res = true;
    for (int i=0; i<num; i=i+1)
    {
        if (in[i] != out[i])
        {
            res = false;
            break;
        }
    }
    if (type)
        printf("\x1B[1;34mENCRYPT:\x1B[0m ");
    else
        printf("\x1B[1;34mDECRYPT:\x1B[0m ");
    for (int i=0; i<num; i=i+1)
    {
        printf("%02x",in[i]);
    }
    printf("\n");
    printf("\x1B[1;34mCORRECT:\x1B[0m ");
    for (int i=0; i<num; i=i+1)
    {
        printf("%02x",out[i]);
    }
    printf("\n");
    if (res)
        printf("\x1B[1;32mTEST SUCCEEDED\x1B[0m\n");
    else
        printf("\x1B[1;31mTEST FAILED\x1B[0m\n");
}

int main(int argc, char *argv[])
{

    ifstream key_file("key.txt", fstream::in);
    ifstream data_file("data.txt", fstream::in);
    ifstream encrypt_file("encrypt.txt", fstream::in);

    int Nb = 4;
    int Nk;
    if (atoi(argv[1]) == 0)
    {
        Nk = 4;
    }
    else if (atoi(argv[1]) == 1)
    {
        Nk = 6;
    }
    else if (atoi(argv[1]) == 2)
    {
        Nk = 8;
    }
    int Nw = atoi(argv[2]);

    uint8_t *key = (uint8_t *) malloc(4*Nk*sizeof(uint8_t));
    uint8_t *dat = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *enc = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *out = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *res = (uint8_t *) malloc(16*sizeof(uint8_t));

    string key_str;
    string data_str;
    string encrypt_str;

    getline(key_file,key_str);
    get(key_str,key,4*Nk);

    AES *aes = new AES(4,Nk,key);

    for (int i=0; i<Nw; i++)
    {
        getline(data_file,data_str);
        getline(encrypt_file,encrypt_str);
        get(data_str,dat,16);
        aes->Cipher(dat,out);
        aes->InvCipher(out,res);
        get(encrypt_str,enc,16);
        compare(out,enc,16,1);
        compare(res,dat,16,0);
    }

    return 0;

}
