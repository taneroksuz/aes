`timescale 1ns / 1ps

module aes_tb;

  localparam int CLK_PERIOD = 10;
  localparam int MAX_BLOCKS = 256;
  localparam int WATCHDOG = 512;

  int           key_bits_rt;

  logic         clk;
  logic         rst;
  logic         start;
  logic         encrypt;
  logic [255:0] key_in_wide;
  logic [127:0] data_in;
  logic [127:0] data_out_mux;
  logic         ready_mux;

  logic [127:0] key128;
  logic [191:0] key192;
  logic [255:0] key256;

  assign key128 = key_in_wide[127:0];
  assign key192 = key_in_wide[191:0];
  assign key256 = key_in_wide[255:0];

  logic [127:0] dout128, dout192, dout256;
  logic rdy128, rdy192, rdy256;

  aes #(
      .KEY_BITS(128)
  ) dut128 (
      .clk(clk),
      .rst(rst),
      .start(start),
      .encrypt(encrypt),
      .key_in(key128),
      .data_in(data_in),
      .data_out(dout128),
      .ready(rdy128)
  );

  aes #(
      .KEY_BITS(192)
  ) dut192 (
      .clk(clk),
      .rst(rst),
      .start(start),
      .encrypt(encrypt),
      .key_in(key192),
      .data_in(data_in),
      .data_out(dout192),
      .ready(rdy192)
  );

  aes #(
      .KEY_BITS(256)
  ) dut256 (
      .clk(clk),
      .rst(rst),
      .start(start),
      .encrypt(encrypt),
      .key_in(key256),
      .data_in(data_in),
      .data_out(dout256),
      .ready(rdy256)
  );

  always_comb begin
    case (key_bits_rt)
      192: begin
        data_out_mux = dout192;
        ready_mux = rdy192;
      end
      256: begin
        data_out_mux = dout256;
        ready_mux = rdy256;
      end
      default: begin
        data_out_mux = dout128;
        ready_mux = rdy128;
      end
    endcase
  end

  initial clk = 0;
  always #(CLK_PERIOD / 2) clk = ~clk;

  logic [255:0] key;
  logic [127:0] pt_blocks[MAX_BLOCKS];
  logic [127:0] ct_blocks[MAX_BLOCKS];
  int           num_pt;
  int           num_ct;

  function automatic logic [3:0] hex_to_nibble(input byte c);
    case (c)
      "0": return 4'h0;
      "1": return 4'h1;
      "2": return 4'h2;
      "3": return 4'h3;
      "4": return 4'h4;
      "5": return 4'h5;
      "6": return 4'h6;
      "7": return 4'h7;
      "8": return 4'h8;
      "9": return 4'h9;
      "a", "A": return 4'ha;
      "b", "B": return 4'hb;
      "c", "C": return 4'hc;
      "d", "D": return 4'hd;
      "e", "E": return 4'he;
      "f", "F": return 4'hf;
      default: return 4'h0;
    endcase
  endfunction

  task automatic read_key_file(input string filename);
    int            fd;
    string         line;
    int            n;
    byte           c;
    logic  [255:0] val;
    val = '0;
    n   = 0;
    fd  = $fopen(filename, "r");
    if (fd == 0) begin
      $display("FATAL: cannot open %s", filename);
      $finish;
    end
    while (!$feof(
        fd
    )) begin
      if ($fgets(line, fd) == 0) break;
      while (line.len() > 0 && (line.getc(
          line.len() - 1
      ) == "\n" || line.getc(
          line.len() - 1
      ) == "\r"))
      line = line.substr(0, line.len() - 2);
      if (line.len() == 0) continue;
      if (line.getc(0) == "#") continue;
      for (int i = 0; i < line.len(); i++) begin
        c = line.getc(i);
        if (c == " " || c == "\t") continue;
        val = (val << 4) | {252'b0, hex_to_nibble(c)};
        n++;
      end
      break;
    end
    $fclose(fd);
    if (n != key_bits_rt / 4)
      $display("WARNING: key file read %0d nibbles, expected %0d", n, key_bits_rt / 4);
    key = val;
  endtask

  task automatic read_block_file(input string filename, ref logic [127:0] blocks[MAX_BLOCKS],
                                 output int count);
    int    fd;
    string line;
    byte   c;
    logic [127:0] blk;
    int    nibbles;
    count = 0;
    nibbles = 0;
    blk = '0;
    fd = $fopen(filename, "r");
    if (fd == 0) begin
      $display("FATAL: cannot open %s", filename);
      $finish;
    end
    while (!$feof(
        fd
    )) begin
      if ($fgets(line, fd) == 0) break;
      while (line.len() > 0 && (line.getc(
          line.len() - 1
      ) == "\n" || line.getc(
          line.len() - 1
      ) == "\r"))
      line = line.substr(0, line.len() - 2);
      if (line.len() == 0) continue;
      if (line.getc(0) == "#") continue;
      for (int i = 0; i < line.len(); i++) begin
        c = line.getc(i);
        if (c == " " || c == "\t") continue;
        blk = (blk << 4) | {124'b0, hex_to_nibble(c)};
        nibbles++;
        if (nibbles == 32) begin
          if (count < MAX_BLOCKS) blocks[count] = blk;
          count++;
          blk = '0;
          nibbles = 0;
        end
      end
    end
    $fclose(fd);
    $display("INFO: loaded %0d block(s) from %s", count, filename);
  endtask

  task apply_reset();
    rst   = 0;
    start = 0;
    repeat (4) @(posedge clk);
    @(negedge clk);
    rst = 1;
    @(posedge clk);
  endtask

  task run_operation(input logic [255:0] k, input logic [127:0] din, input logic enc_mode,
                     output logic [127:0] result);
    int wd;
    @(negedge clk);
    key_in_wide = k;
    data_in     = din;
    encrypt     = enc_mode;
    start       = 1;
    @(negedge clk);
    start = 0;
    wd = 0;
    while (!ready_mux) begin
      @(posedge clk);
      wd++;
      if (wd > WATCHDOG) begin
        $display("FATAL: watchdog expired waiting for ready");
        $finish;
      end
    end
    result = data_out_mux;
    @(posedge clk);
  endtask

  logic [127:0] result;
  int pass_enc, fail_enc;
  int pass_dec, fail_dec;
  int num_blocks;

  initial begin
    rst = 0;
    start = 0;
    encrypt = 1;
    key_in_wide = '0;
    data_in = '0;
    key_bits_rt = 128;
    pass_enc = 0;
    fail_enc = 0;
    pass_dec = 0;
    fail_dec = 0;

    if (!$value$plusargs("KEY_BITS=%d", key_bits_rt))
      $display("INFO: +KEY_BITS not set, defaulting to 128");

    if (key_bits_rt != 128 && key_bits_rt != 192 && key_bits_rt != 256) begin
      $display("FATAL: invalid KEY_BITS=%0d", key_bits_rt);
      $finish;
    end

    $display("=============================================");
    $display("  AES-%0d Testbench", key_bits_rt);
    $display("=============================================");

    read_key_file("key.hex");
    read_block_file("plaintext.hex", pt_blocks, num_pt);
    read_block_file("ciphertext.hex", ct_blocks, num_ct);

    if (num_pt != num_ct) begin
      $display("FATAL: block count mismatch PT=%0d CT=%0d", num_pt, num_ct);
      $finish;
    end
    num_blocks = num_pt;

    case (key_bits_rt)
      192:     $display("KEY    : %048h", key[191:0]);
      256:     $display("KEY    : %064h", key[255:0]);
      default: $display("KEY    : %032h", key[127:0]);
    endcase
    $display("BLOCKS : %0d", num_blocks);
    $display("");

    apply_reset();

    $display("--- Encryption PT->CT ---");
    for (int b = 0; b < num_blocks; b++) begin
      run_operation(key, pt_blocks[b], 1'b1, result);
      if (result === ct_blocks[b]) begin
        $display("[PASS] ENC[%0d] %032h", b, result);
        pass_enc++;
      end else begin
        $display("[FAIL] ENC[%0d]", b);
        $display("       PT  : %032h", pt_blocks[b]);
        $display("       EXP : %032h", ct_blocks[b]);
        $display("       GOT : %032h", result);
        fail_enc++;
      end
      apply_reset();
    end

    $display("");
    $display("--- Decryption CT->PT ---");
    for (int b = 0; b < num_blocks; b++) begin
      run_operation(key, ct_blocks[b], 1'b0, result);
      if (result === pt_blocks[b]) begin
        $display("[PASS] DEC[%0d] %032h", b, result);
        pass_dec++;
      end else begin
        $display("[FAIL] DEC[%0d]", b);
        $display("       CT  : %032h", ct_blocks[b]);
        $display("       EXP : %032h", pt_blocks[b]);
        $display("       GOT : %032h", result);
        fail_dec++;
      end
      apply_reset();
    end

    $display("");
    $display("=============================================");
    $display("  ENC %0d/%0d passed", pass_enc, num_blocks);
    $display("  DEC %0d/%0d passed", pass_dec, num_blocks);
    if (fail_enc == 0 && fail_dec == 0) $display("  ALL PASSED");
    else $display("  *** FAILURES: ENC=%0d DEC=%0d ***", fail_enc, fail_dec);
    $display("=============================================");
    $finish;
  end

  initial begin
    $dumpfile("aes_tb.vcd");
    $dumpvars(0, aes_tb);
  end

endmodule
