# AES
Hardware and software implementation of AES algorithm. This algorithm is implemented in Verilog and C++.

## Hardware Implementation
There are two version of this algorithm. These are in pipeline and finite state machine. These implementations includes key expansion, encryption and decryption. 

### Pipelined Version

| Key Length | 128 | 192 | 256 |
|:-----------|:---:|:---:|:---:|
| LUT | 38766 | 47546 | 54642 |
| FF | 2763 | 3098 | 3562 |

### FSM Version

| Key Length | 128 | 192 | 256 |
|:-----------|:---:|:---:|:---:|
| LUT | 6547 | 8795 | 7515 |
| FF | 418 | 475 | 541 |
