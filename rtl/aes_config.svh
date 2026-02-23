// =============================================================================
// aes_config.svh
// AES Accelerator — Minimal Configuration Header
// Edit AES_KEY_BITS only — all other parameters are derived automatically
// =============================================================================

`ifndef AES_CONFIG_SVH
`define AES_CONFIG_SVH

// =============================================================================
// USER SETTING — change this one line to switch key length
// =============================================================================
`define AES_KEY_BITS 128      // 128 / 192 / 256

// =============================================================================
// DERIVED ALGORITHM PARAMETERS (FIPS-197)
// =============================================================================

// Nk — 32-bit words in the key
`define AES_NK  ((`AES_KEY_BITS == 256) ? 8  : \
                 (`AES_KEY_BITS == 192) ? 6  : 4)

// Nr — cipher rounds
`define AES_NR  ((`AES_KEY_BITS == 256) ? 14 : \
                 (`AES_KEY_BITS == 192) ? 12 : 10)

`endif // AES_CONFIG_SVH