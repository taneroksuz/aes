#!/usr/bin/env python3

import os
import argparse

import secrets
import codecs
import hashlib
import base64

from Crypto import Random
from Crypto.Cipher import AES

parser = argparse.ArgumentParser()
parser.add_argument("-k","--key_length", help="length of key in bits", type=int)
parser.add_argument("-w","--word_number", help="number of words in bits", type=int)

args = parser.parse_args()

if (args.key_length != 128) and (args.key_length != 192) and (args.key_length != 256):
    print("Key length: ",args.key_length," is invalid!")
    exit(1)
if (args.word_number is None) or (args.word_number<1):
    print("Word number: ",args.word_number," is invalid!")
    exit(1)

key = Random.new().read(int(args.key_length/8))
f = open("key.txt", "w")
f.writelines(key.hex()+"\n")
f.close()


d = open("data.txt", "w")
e = open("encrypt.txt", "w")
cipher = AES.new(key,AES.MODE_ECB)
for i in range(args.word_number):
    data = Random.new().read(AES.block_size)
    encrypt = cipher.encrypt(data)
    d.writelines(data.hex()+"\n")
    e.writelines(encrypt.hex()+"\n")
d.close()
e.close()
