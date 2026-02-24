`timescale 1ns / 1ps

module aes_tb;

  localparam int CLK_PERIOD = 10;

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
  logic [127:0] plaintext;
  logic [127:0] ciphertext;

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
      default: begin
        $display("WARNING: unexpected char '%c' - skipped", c);
        return 4'h0;
      end
    endcase
  endfunction

  task automatic read_hex_file(input string filename, output logic [255:0] val,
                               input int expected_nibbles);
    int    fd;
    string line;
    int    n;
    byte   c;

    val = '0;
    n   = 0;

    fd  = $fopen(filename, "r");
    if (fd == 0) begin
      $display("FATAL: cannot open '%s'", filename);
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

    if (n != expected_nibbles)
      $display("WARNING: '%s' - read %0d nibbles, expected %0d", filename, n, expected_nibbles);
  endtask

  task apply_reset();
    rst   = 1;
    start = 0;
    repeat (4) @(posedge clk);
    @(negedge clk);
    rst = 0;
    @(posedge clk);
  endtask

  task run_operation(input logic [255:0] k, input logic [127:0] din, input logic enc_mode,
                     output logic [127:0] result);
    @(negedge clk);
    key_in_wide = k;
    data_in     = din;
    encrypt     = enc_mode;
    start       = 1;
    #1;
    result = data_out_mux;
    @(negedge clk);
    start = 0;
  endtask

  task print_result(input string label, input logic [127:0] got, input logic [127:0] expected);
    if (got === expected) begin
      $display("[PASS] %s", label);
      $display("       Result   : %032h", got);
    end else begin
      $display("[FAIL] %s", label);
      $display("       Expected : %032h", expected);
      $display("       Got      : %032h", got);
    end
  endtask

  logic [255:0] raw;
  logic [127:0] result;

  initial begin
    rst         = 1;
    start       = 0;
    encrypt     = 1;
    key_in_wide = '0;
    data_in     = '0;
    key_bits_rt = 128;

    if (!$value$plusargs("KEY_BITS=%d", key_bits_rt))
      $display("INFO: +KEY_BITS not provided, defaulting to 128");

    if (key_bits_rt != 128 && key_bits_rt != 192 && key_bits_rt != 256) begin
      $display("FATAL: invalid +KEY_BITS=%0d. Use 128, 192 or 256.", key_bits_rt);
      $finish;
    end

    $display("=============================================");
    $display("  AES-%0d Testbench", key_bits_rt);
    $display("=============================================");

    read_hex_file("key.hex", raw, key_bits_rt / 4);
    key = raw;

    read_hex_file("plaintext.hex", raw, 32);
    plaintext = raw[127:0];

    read_hex_file("ciphertext.hex", raw, 32);
    ciphertext = raw[127:0];

    case (key_bits_rt)
      192:     $display("KEY        : %048h", key[191:0]);
      256:     $display("KEY        : %064h", key[255:0]);
      default: $display("KEY        : %032h", key[127:0]);
    endcase
    $display("PLAINTEXT  : %032h", plaintext);
    $display("CIPHERTEXT : %032h", ciphertext);
    $display("");

    apply_reset();

    $display("--- Encryption (PT -> CT) ---");
    run_operation(key, plaintext, 1'b1, result);
    print_result("Encryption", result, ciphertext);
    $display("");

    $display("--- Decryption (CT -> PT) ---");
    run_operation(key, ciphertext, 1'b0, result);
    print_result("Decryption", result, plaintext);
    $display("");

    $display("=============================================");
    $display("  Done.");
    $display("=============================================");
    $finish;
  end

  initial begin
    $dumpfile("aes_tb.vcd");
    $dumpvars(0, aes_tb);
  end

endmodule
