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
        printf("%02x",out[i]);
    }
    printf("\n");
}

void compare(uint8_t *in,uint8_t *out, int num)
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
    if (res)
      printf("Success\n");
    else
      printf("Error\n");
}

int main(int argc, char *argv[])
{
    /*
    uint8_t *key128 = (uint8_t *) malloc(16*sizeof(uint8_t));
    key128[0] = 0x2b;
    key128[1] = 0x7e;
    key128[2] = 0x15;
    key128[3] = 0x16;
    key128[4] = 0x28;
    key128[5] = 0xae;
    key128[6] = 0xd2;
    key128[7] = 0xa6;
    key128[8] = 0xab;
    key128[9] = 0xf7;
    key128[10] = 0x15;
    key128[11] = 0x88;
    key128[12] = 0x09;
    key128[13] = 0xcf;
    key128[14] = 0x4f;
    key128[15] = 0x3c;
    AES *aes128 = new AES(4,4,key128);

    uint8_t *key192 = (uint8_t *) malloc(24*sizeof(uint8_t));
    key192[0] = 0x8e;
    key192[1] = 0x73;
    key192[2] = 0xb0;
    key192[3] = 0xf7;
    key192[4] = 0xda;
    key192[5] = 0x0e;
    key192[6] = 0x64;
    key192[7] = 0x52;
    key192[8] = 0xc8;
    key192[9] = 0x10;
    key192[10] = 0xf3;
    key192[11] = 0x2b;
    key192[12] = 0x80;
    key192[13] = 0x90;
    key192[14] = 0x79;
    key192[15] = 0xe5;
    key192[16] = 0x62;
    key192[17] = 0xf8;
    key192[18] = 0xea;
    key192[19] = 0xd2;
    key192[20] = 0x52;
    key192[21] = 0x2c;
    key192[22] = 0x6b;
    key192[23] = 0x7b;
    AES *aes192 = new AES(4,6,key192);

    uint8_t *key256 = (uint8_t *) malloc(32*sizeof(uint8_t));
    key256[0] = 0x60;
    key256[1] = 0x3d;
    key256[2] = 0xeb;
    key256[3] = 0x10;
    key256[4] = 0x15;
    key256[5] = 0xca;
    key256[6] = 0x71;
    key256[7] = 0xbe;
    key256[8] = 0x2b;
    key256[9] = 0x73;
    key256[10] = 0xae;
    key256[11] = 0xf0;
    key256[12] = 0x85;
    key256[13] = 0x7d;
    key256[14] = 0x77;
    key256[15] = 0x81;
    key256[16] = 0x1f;
    key256[17] = 0x35;
    key256[18] = 0x2c;
    key256[19] = 0x07;
    key256[20] = 0x3b;
    key256[21] = 0x61;
    key256[22] = 0x08;
    key256[23] = 0xd7;
    key256[24] = 0x2d;
    key256[25] = 0x98;
    key256[26] = 0x10;
    key256[27] = 0xa3;
    key256[28] = 0x09;
    key256[29] = 0x14;
    key256[30] = 0xdf;
    key256[31] = 0xf4;
    AES *aes256 = new AES(4,8,key256);

    uint8_t *key128_test0 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *in128_test0 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *out128_test0 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *orig128_test0 = (uint8_t *) malloc(16*sizeof(uint8_t));
    key128_test0[0] = 0x2b;
    key128_test0[1] = 0x7e;
    key128_test0[2] = 0x15;
    key128_test0[3] = 0x16;
    key128_test0[4] = 0x28;
    key128_test0[5] = 0xae;
    key128_test0[6] = 0xd2;
    key128_test0[7] = 0xa6;
    key128_test0[8] = 0xab;
    key128_test0[9] = 0xf7;
    key128_test0[10] = 0x15;
    key128_test0[11] = 0x88;
    key128_test0[12] = 0x09;
    key128_test0[13] = 0xcf;
    key128_test0[14] = 0x4f;
    key128_test0[15] = 0x3c;
    in128_test0[0] = 0x32;
    in128_test0[1] = 0x43;
    in128_test0[2] = 0xf6;
    in128_test0[3] = 0xa8;
    in128_test0[4] = 0x88;
    in128_test0[5] = 0x5a;
    in128_test0[6] = 0x30;
    in128_test0[7] = 0x8d;
    in128_test0[8] = 0x31;
    in128_test0[9] = 0x31;
    in128_test0[10] = 0x98;
    in128_test0[11] = 0xa2;
    in128_test0[12] = 0xe0;
    in128_test0[13] = 0x37;
    in128_test0[14] = 0x07;
    in128_test0[15] = 0x34;
    AES *aes128_test0 = new AES(4,4,key128_test0);
    aes128_test0->Cipher(in128_test0,out128_test0);
    aes128_test0->InvCipher(out128_test0,orig128_test0);

    uint8_t *key128_test1 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *in128_test1 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *out128_test1 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *orig128_test1 = (uint8_t *) malloc(16*sizeof(uint8_t));
    key128_test1[0] = 0x00;
    key128_test1[1] = 0x01;
    key128_test1[2] = 0x02;
    key128_test1[3] = 0x03;
    key128_test1[4] = 0x04;
    key128_test1[5] = 0x05;
    key128_test1[6] = 0x06;
    key128_test1[7] = 0x07;
    key128_test1[8] = 0x08;
    key128_test1[9] = 0x09;
    key128_test1[10] = 0x0a;
    key128_test1[11] = 0x0b;
    key128_test1[12] = 0x0c;
    key128_test1[13] = 0x0d;
    key128_test1[14] = 0x0e;
    key128_test1[15] = 0x0f;
    in128_test1[0] = 0x00;
    in128_test1[1] = 0x11;
    in128_test1[2] = 0x22;
    in128_test1[3] = 0x33;
    in128_test1[4] = 0x44;
    in128_test1[5] = 0x55;
    in128_test1[6] = 0x66;
    in128_test1[7] = 0x77;
    in128_test1[8] = 0x88;
    in128_test1[9] = 0x99;
    in128_test1[10] = 0xaa;
    in128_test1[11] = 0xbb;
    in128_test1[12] = 0xcc;
    in128_test1[13] = 0xdd;
    in128_test1[14] = 0xee;
    in128_test1[15] = 0xff;
    AES *aes128_test1 = new AES(4,4,key128_test1);
    aes128_test1->Cipher(in128_test1,out128_test1);
    aes128_test1->InvCipher(out128_test1,orig128_test1);

    uint8_t *key128_test2 = (uint8_t *) malloc(24*sizeof(uint8_t));
    uint8_t *in128_test2 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *out128_test2 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *orig128_test2 = (uint8_t *) malloc(16*sizeof(uint8_t));
    key128_test2[0] = 0x00;
    key128_test2[1] = 0x01;
    key128_test2[2] = 0x02;
    key128_test2[3] = 0x03;
    key128_test2[4] = 0x04;
    key128_test2[5] = 0x05;
    key128_test2[6] = 0x06;
    key128_test2[7] = 0x07;
    key128_test2[8] = 0x08;
    key128_test2[9] = 0x09;
    key128_test2[10] = 0x0a;
    key128_test2[11] = 0x0b;
    key128_test2[12] = 0x0c;
    key128_test2[13] = 0x0d;
    key128_test2[14] = 0x0e;
    key128_test2[15] = 0x0f;
    key128_test2[16] = 0x10;
    key128_test2[17] = 0x11;
    key128_test2[18] = 0x12;
    key128_test2[19] = 0x13;
    key128_test2[20] = 0x14;
    key128_test2[21] = 0x15;
    key128_test2[22] = 0x16;
    key128_test2[23] = 0x17;
    in128_test2[0] = 0x00;
    in128_test2[1] = 0x11;
    in128_test2[2] = 0x22;
    in128_test2[3] = 0x33;
    in128_test2[4] = 0x44;
    in128_test2[5] = 0x55;
    in128_test2[6] = 0x66;
    in128_test2[7] = 0x77;
    in128_test2[8] = 0x88;
    in128_test2[9] = 0x99;
    in128_test2[10] = 0xaa;
    in128_test2[11] = 0xbb;
    in128_test2[12] = 0xcc;
    in128_test2[13] = 0xdd;
    in128_test2[14] = 0xee;
    in128_test2[15] = 0xff;
    AES *aes128_test2 = new AES(4,6,key128_test2);
    aes128_test2->Cipher(in128_test2,out128_test2);
    aes128_test2->InvCipher(out128_test2,orig128_test2);

    uint8_t *key128_test3 = (uint8_t *) malloc(32*sizeof(uint8_t));
    uint8_t *in128_test3 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *out128_test3 = (uint8_t *) malloc(16*sizeof(uint8_t));
    uint8_t *orig128_test3 = (uint8_t *) malloc(16*sizeof(uint8_t));
    key128_test3[0] = 0x00;
    key128_test3[1] = 0x01;
    key128_test3[2] = 0x02;
    key128_test3[3] = 0x03;
    key128_test3[4] = 0x04;
    key128_test3[5] = 0x05;
    key128_test3[6] = 0x06;
    key128_test3[7] = 0x07;
    key128_test3[8] = 0x08;
    key128_test3[9] = 0x09;
    key128_test3[10] = 0x0a;
    key128_test3[11] = 0x0b;
    key128_test3[12] = 0x0c;
    key128_test3[13] = 0x0d;
    key128_test3[14] = 0x0e;
    key128_test3[15] = 0x0f;
    key128_test3[16] = 0x10;
    key128_test3[17] = 0x11;
    key128_test3[18] = 0x12;
    key128_test3[19] = 0x13;
    key128_test3[20] = 0x14;
    key128_test3[21] = 0x15;
    key128_test3[22] = 0x16;
    key128_test3[23] = 0x17;
    key128_test3[24] = 0x18;
    key128_test3[25] = 0x19;
    key128_test3[26] = 0x1a;
    key128_test3[27] = 0x1b;
    key128_test3[28] = 0x1c;
    key128_test3[29] = 0x1d;
    key128_test3[30] = 0x1e;
    key128_test3[31] = 0x1f;
    in128_test3[0] = 0x00;
    in128_test3[1] = 0x11;
    in128_test3[2] = 0x22;
    in128_test3[3] = 0x33;
    in128_test3[4] = 0x44;
    in128_test3[5] = 0x55;
    in128_test3[6] = 0x66;
    in128_test3[7] = 0x77;
    in128_test3[8] = 0x88;
    in128_test3[9] = 0x99;
    in128_test3[10] = 0xaa;
    in128_test3[11] = 0xbb;
    in128_test3[12] = 0xcc;
    in128_test3[13] = 0xdd;
    in128_test3[14] = 0xee;
    in128_test3[15] = 0xff;
    AES *aes128_test3 = new AES(4,8,key128_test3);
    aes128_test3->Cipher(in128_test3,out128_test3);
    aes128_test3->InvCipher(out128_test3,orig128_test3);
    */

    ifstream key_file("key.txt", fstream::in);
    ifstream data_file("data.txt", fstream::in);
    ifstream encrypt_file("encrypt.txt", fstream::in);

    int Nb = 4;
    int Nk = atoi(argv[1])/32;
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
        compare(out,enc,16);
        compare(res,dat,16);
    }



    return 0;

}
