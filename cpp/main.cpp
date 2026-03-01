#include "aes.h"
#include <fstream>
#include <iostream>

using namespace std;

#define CLR_RESET  "\x1B[0m"
#define CLR_BLUE   "\x1B[1;34m"
#define CLR_GREEN  "\x1B[1;32m"
#define CLR_RED    "\x1B[1;31m"
#define CLR_YELLOW "\x1B[1;33m"

uint8_t hex(char c)
{
    uint8_t res = (uint8_t) c;
    if (c <= '9' && c >= '0')
        res = res - 48;
    else if (c <= 'f' && c >= 'a')
        res = res - 87;
    else if (c <= 'F' && c >= 'A')
        res = res - 55;
    return res;
}

void get(string in, uint8_t *out, int num)
{
    for (int i = 0; i < num; i++)
    {
        out[i]  = hex(in[2*i]) << 4;
        out[i] += hex(in[2*i+1]);
    }
}

void print_block(const char *label, uint8_t *data)
{
    printf("%s%-8s" CLR_RESET " ", CLR_BLUE, label);
    for (int i = 0; i < 16; i++)
        printf("%02x", data[i]);
    printf("\n");
}

int compare_blocks(uint8_t *got, uint8_t *expected, int num_bytes, const char *op_name)
{
    int num_blocks = num_bytes / 16;
    int pass = 0, fail = 0;

    printf(CLR_BLUE "=== %s ===\n" CLR_RESET, op_name);

    for (int b = 0; b < num_blocks; b++)
    {
        uint8_t *g = got      + b * 16;
        uint8_t *e = expected + b * 16;

        bool ok = true;
        for (int i = 0; i < 16; i++)
            if (g[i] != e[i]) { ok = false; break; }

        if (ok)
        {
            printf(CLR_GREEN "[PASS]" CLR_RESET " block %3d  ", b);
            for (int i = 0; i < 16; i++) printf("%02x", g[i]);
            printf("\n");
            pass++;
        }
        else
        {
            printf(CLR_RED "[FAIL]" CLR_RESET " block %3d\n", b);
            print_block("  GOT:",      g);
            print_block("  EXPECTED:", e);
            fail++;
        }
    }

    printf("\n");
    printf(CLR_BLUE "%-10s" CLR_RESET, op_name);
    if (fail == 0)
        printf(CLR_GREEN "%d/%d PASSED" CLR_RESET "\n", pass, num_blocks);
    else
        printf(CLR_RED "%d/%d FAILED" CLR_RESET "  (%d passed)\n", fail, num_blocks, pass);
    printf("\n");

    return fail;
}

int main(int argc, char *argv[])
{
    ifstream key_file("./out/key.hex", fstream::in);
    ifstream data_file("./out/plaintext.hex", fstream::in);
    ifstream encrypt_file("./out/ciphertext.hex", fstream::in);

    int NK;
    if (atoi(argv[1]) == 128)
        NK = 4;
    else if (atoi(argv[1]) == 192)
        NK = 6;
    else
        NK = 8;

    int NW = atoi(argv[2]);

    uint8_t *key = (uint8_t *) malloc(4 * NK * sizeof(uint8_t));
    uint8_t *dat = (uint8_t *) malloc(NW * sizeof(uint8_t));
    uint8_t *enc = (uint8_t *) malloc(NW * sizeof(uint8_t));
    uint8_t *out = (uint8_t *) malloc(NW * sizeof(uint8_t));
    uint8_t *res = (uint8_t *) malloc(NW * sizeof(uint8_t));

    string key_str, data_str, encrypt_str;
    getline(key_file, key_str);
    getline(data_file, data_str);
    getline(encrypt_file, encrypt_str);

    get(key_str,     key, 4 * NK);
    get(data_str,    dat, NW);
    get(encrypt_str, enc, NW);

    AES *aes = new AES(NK, key);

    for (int i = 0; i < NW; i += 16) aes->Cipher(dat+i, out+i);
    for (int i = 0; i < NW; i += 16) aes->InvCipher(out+i, res+i);

    printf(CLR_YELLOW "AES-%d  blocks=%d\n\n" CLR_RESET, atoi(argv[1]), NW / 16);

    int enc_fail = compare_blocks(out, enc, NW, "ENCRYPT");
    int dec_fail = compare_blocks(res, dat, NW, "DECRYPT");

    printf(CLR_BLUE "=== SUMMARY ===" CLR_RESET "\n");
    if (enc_fail == 0 && dec_fail == 0)
        printf(CLR_GREEN "ALL TESTS PASSED\n" CLR_RESET);
    else
        printf(CLR_RED "FAILURES: ENC=%d  DEC=%d\n" CLR_RESET, enc_fail, dec_fail);

    free(key); free(dat); free(enc); free(out); free(res);
    return (enc_fail || dec_fail) ? 1 : 0;
}