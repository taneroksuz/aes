# AES
Hardware and software implementation of AES algorithm. This algorithm is implemented in Verilog and C++.

## Hardware Implementation
There are two version of this algorithm. These are in pipeline and finite state machine. These implementations includes key expansion, encryption and decryption.

### Pipelined Version

| Key Length | 128 | 192 | 256 |
|:-----------|:---:|:---:|:---:|
| LUT | 38766 | 47945 | 55001 |
| FF | 2763 | 3227 | 3691 |

### FSM Version

| Key Length | 128 | 192 | 256 |
|:-----------|:---:|:---:|:---:|
| LUT | 6794 | 8857 | 7866 |
| FF | 412 | 469 | 543 |
