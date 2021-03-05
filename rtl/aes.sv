import aes_wire::*;
import aes_func::*;

module aes
(
  input logic rst,
  input logic clk,
  input aes_in_type aes_in,
  output aes_out_type aes_out
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] S_Box [255:0];
  logic [7 : 0] I_Box [255:0];
  logic [7 : 0] EXP_3 [255:0];
  logic [7 : 0] LN_3 [255:0];
  logic [7 : 0] Rcon [15:0];

  localparam [1:0] idle = 2'h0;
  localparam [1:0] key_exp = 2'h1;
  localparam [1:0] cipher  = 2'h2;
  localparam [1:0] icipher = 2'h3;

  aes_reg_type r,rin;
  aes_reg_type v;

  initial begin
    S_Box[0]=8'h63; S_Box[1]=8'h7c; S_Box[2]=8'h77; S_Box[3]=8'h7b; S_Box[4]=8'hf2; S_Box[5]=8'h6b; S_Box[6]=8'h6f; S_Box[7]=8'hc5; S_Box[8]=8'h30; S_Box[9]=8'h01; S_Box[10]=8'h67; S_Box[11]=8'h2b; S_Box[12]=8'hfe; S_Box[13]=8'hd7; S_Box[14]=8'hab; S_Box[15]=8'h76;
    S_Box[16]=8'hca; S_Box[17]=8'h82; S_Box[18]=8'hc9; S_Box[19]=8'h7d; S_Box[20]=8'hfa; S_Box[21]=8'h59; S_Box[22]=8'h47; S_Box[23]=8'hf0; S_Box[24]=8'had; S_Box[25]=8'hd4; S_Box[26]=8'ha2; S_Box[27]=8'haf; S_Box[28]=8'h9c; S_Box[29]=8'ha4; S_Box[30]=8'h72; S_Box[31]=8'hc0;
    S_Box[32]=8'hb7; S_Box[33]=8'hfd; S_Box[34]=8'h93; S_Box[35]=8'h26; S_Box[36]=8'h36; S_Box[37]=8'h3f; S_Box[38]=8'hf7; S_Box[39]=8'hcc; S_Box[40]=8'h34; S_Box[41]=8'ha5; S_Box[42]=8'he5; S_Box[43]=8'hf1; S_Box[44]=8'h71; S_Box[45]=8'hd8; S_Box[46]=8'h31; S_Box[47]=8'h15;
    S_Box[48]=8'h04; S_Box[49]=8'hc7; S_Box[50]=8'h23; S_Box[51]=8'hc3; S_Box[52]=8'h18; S_Box[53]=8'h96; S_Box[54]=8'h05; S_Box[55]=8'h9a; S_Box[56]=8'h07; S_Box[57]=8'h12; S_Box[58]=8'h80; S_Box[59]=8'he2; S_Box[60]=8'heb; S_Box[61]=8'h27; S_Box[62]=8'hb2; S_Box[63]=8'h75;
    S_Box[64]=8'h09; S_Box[65]=8'h83; S_Box[66]=8'h2c; S_Box[67]=8'h1a; S_Box[68]=8'h1b; S_Box[69]=8'h6e; S_Box[70]=8'h5a; S_Box[71]=8'ha0; S_Box[72]=8'h52; S_Box[73]=8'h3b; S_Box[74]=8'hd6; S_Box[75]=8'hb3; S_Box[76]=8'h29; S_Box[77]=8'he3; S_Box[78]=8'h2f; S_Box[79]=8'h84;
    S_Box[80]=8'h53; S_Box[81]=8'hd1; S_Box[82]=8'h00; S_Box[83]=8'hed; S_Box[84]=8'h20; S_Box[85]=8'hfc; S_Box[86]=8'hb1; S_Box[87]=8'h5b; S_Box[88]=8'h6a; S_Box[89]=8'hcb; S_Box[90]=8'hbe; S_Box[91]=8'h39; S_Box[92]=8'h4a; S_Box[93]=8'h4c; S_Box[94]=8'h58; S_Box[95]=8'hcf;
    S_Box[96]=8'hd0; S_Box[97]=8'hef; S_Box[98]=8'haa; S_Box[99]=8'hfb; S_Box[100]=8'h43; S_Box[101]=8'h4d; S_Box[102]=8'h33; S_Box[103]=8'h85; S_Box[104]=8'h45; S_Box[105]=8'hf9; S_Box[106]=8'h02; S_Box[107]=8'h7f; S_Box[108]=8'h50; S_Box[109]=8'h3c; S_Box[110]=8'h9f; S_Box[111]=8'ha8;
    S_Box[112]=8'h51; S_Box[113]=8'ha3; S_Box[114]=8'h40; S_Box[115]=8'h8f; S_Box[116]=8'h92; S_Box[117]=8'h9d; S_Box[118]=8'h38; S_Box[119]=8'hf5; S_Box[120]=8'hbc; S_Box[121]=8'hb6; S_Box[122]=8'hda; S_Box[123]=8'h21; S_Box[124]=8'h10; S_Box[125]=8'hff; S_Box[126]=8'hf3; S_Box[127]=8'hd2;
    S_Box[128]=8'hcd; S_Box[129]=8'h0c; S_Box[130]=8'h13; S_Box[131]=8'hec; S_Box[132]=8'h5f; S_Box[133]=8'h97; S_Box[134]=8'h44; S_Box[135]=8'h17; S_Box[136]=8'hc4; S_Box[137]=8'ha7; S_Box[138]=8'h7e; S_Box[139]=8'h3d; S_Box[140]=8'h64; S_Box[141]=8'h5d; S_Box[142]=8'h19; S_Box[143]=8'h73;
    S_Box[144]=8'h60; S_Box[145]=8'h81; S_Box[146]=8'h4f; S_Box[147]=8'hdc; S_Box[148]=8'h22; S_Box[149]=8'h2a; S_Box[150]=8'h90; S_Box[151]=8'h88; S_Box[152]=8'h46; S_Box[153]=8'hee; S_Box[154]=8'hb8; S_Box[155]=8'h14; S_Box[156]=8'hde; S_Box[157]=8'h5e; S_Box[158]=8'h0b; S_Box[159]=8'hdb;
    S_Box[160]=8'he0; S_Box[161]=8'h32; S_Box[162]=8'h3a; S_Box[163]=8'h0a; S_Box[164]=8'h49; S_Box[165]=8'h06; S_Box[166]=8'h24; S_Box[167]=8'h5c; S_Box[168]=8'hc2; S_Box[169]=8'hd3; S_Box[170]=8'hac; S_Box[171]=8'h62; S_Box[172]=8'h91; S_Box[173]=8'h95; S_Box[174]=8'he4; S_Box[175]=8'h79;
    S_Box[176]=8'he7; S_Box[177]=8'hc8; S_Box[178]=8'h37; S_Box[179]=8'h6d; S_Box[180]=8'h8d; S_Box[181]=8'hd5; S_Box[182]=8'h4e; S_Box[183]=8'ha9; S_Box[184]=8'h6c; S_Box[185]=8'h56; S_Box[186]=8'hf4; S_Box[187]=8'hea; S_Box[188]=8'h65; S_Box[189]=8'h7a; S_Box[190]=8'hae; S_Box[191]=8'h08;
    S_Box[192]=8'hba; S_Box[193]=8'h78; S_Box[194]=8'h25; S_Box[195]=8'h2e; S_Box[196]=8'h1c; S_Box[197]=8'ha6; S_Box[198]=8'hb4; S_Box[199]=8'hc6; S_Box[200]=8'he8; S_Box[201]=8'hdd; S_Box[202]=8'h74; S_Box[203]=8'h1f; S_Box[204]=8'h4b; S_Box[205]=8'hbd; S_Box[206]=8'h8b; S_Box[207]=8'h8a;
    S_Box[208]=8'h70; S_Box[209]=8'h3e; S_Box[210]=8'hb5; S_Box[211]=8'h66; S_Box[212]=8'h48; S_Box[213]=8'h03; S_Box[214]=8'hf6; S_Box[215]=8'h0e; S_Box[216]=8'h61; S_Box[217]=8'h35; S_Box[218]=8'h57; S_Box[219]=8'hb9; S_Box[220]=8'h86; S_Box[221]=8'hc1; S_Box[222]=8'h1d; S_Box[223]=8'h9e;
    S_Box[224]=8'he1; S_Box[225]=8'hf8; S_Box[226]=8'h98; S_Box[227]=8'h11; S_Box[228]=8'h69; S_Box[229]=8'hd9; S_Box[230]=8'h8e; S_Box[231]=8'h94; S_Box[232]=8'h9b; S_Box[233]=8'h1e; S_Box[234]=8'h87; S_Box[235]=8'he9; S_Box[236]=8'hce; S_Box[237]=8'h55; S_Box[238]=8'h28; S_Box[239]=8'hdf;
    S_Box[240]=8'h8c; S_Box[241]=8'ha1; S_Box[242]=8'h89; S_Box[243]=8'h0d; S_Box[244]=8'hbf; S_Box[245]=8'he6; S_Box[246]=8'h42; S_Box[247]=8'h68; S_Box[248]=8'h41; S_Box[249]=8'h99; S_Box[250]=8'h2d; S_Box[251]=8'h0f; S_Box[252]=8'hb0; S_Box[253]=8'h54; S_Box[254]=8'hbb; S_Box[255]=8'h16;

    I_Box[0]=8'h52; I_Box[1]=8'h09; I_Box[2]=8'h6a; I_Box[3]=8'hd5; I_Box[4]=8'h30; I_Box[5]=8'h36; I_Box[6]=8'ha5; I_Box[7]=8'h38; I_Box[8]=8'hbf; I_Box[9]=8'h40; I_Box[10]=8'ha3; I_Box[11]=8'h9e; I_Box[12]=8'h81; I_Box[13]=8'hf3; I_Box[14]=8'hd7; I_Box[15]=8'hfb;
    I_Box[16]=8'h7c; I_Box[17]=8'he3; I_Box[18]=8'h39; I_Box[19]=8'h82; I_Box[20]=8'h9b; I_Box[21]=8'h2f; I_Box[22]=8'hff; I_Box[23]=8'h87; I_Box[24]=8'h34; I_Box[25]=8'h8e; I_Box[26]=8'h43; I_Box[27]=8'h44; I_Box[28]=8'hc4; I_Box[29]=8'hde; I_Box[30]=8'he9; I_Box[31]=8'hcb;
    I_Box[32]=8'h54; I_Box[33]=8'h7b; I_Box[34]=8'h94; I_Box[35]=8'h32; I_Box[36]=8'ha6; I_Box[37]=8'hc2; I_Box[38]=8'h23; I_Box[39]=8'h3d; I_Box[40]=8'hee; I_Box[41]=8'h4c; I_Box[42]=8'h95; I_Box[43]=8'h0b; I_Box[44]=8'h42; I_Box[45]=8'hfa; I_Box[46]=8'hc3; I_Box[47]=8'h4e;
    I_Box[48]=8'h08; I_Box[49]=8'h2e; I_Box[50]=8'ha1; I_Box[51]=8'h66; I_Box[52]=8'h28; I_Box[53]=8'hd9; I_Box[54]=8'h24; I_Box[55]=8'hb2; I_Box[56]=8'h76; I_Box[57]=8'h5b; I_Box[58]=8'ha2; I_Box[59]=8'h49; I_Box[60]=8'h6d; I_Box[61]=8'h8b; I_Box[62]=8'hd1; I_Box[63]=8'h25;
    I_Box[64]=8'h72; I_Box[65]=8'hf8; I_Box[66]=8'hf6; I_Box[67]=8'h64; I_Box[68]=8'h86; I_Box[69]=8'h68; I_Box[70]=8'h98; I_Box[71]=8'h16; I_Box[72]=8'hd4; I_Box[73]=8'ha4; I_Box[74]=8'h5c; I_Box[75]=8'hcc; I_Box[76]=8'h5d; I_Box[77]=8'h65; I_Box[78]=8'hb6; I_Box[79]=8'h92;
    I_Box[80]=8'h6c; I_Box[81]=8'h70; I_Box[82]=8'h48; I_Box[83]=8'h50; I_Box[84]=8'hfd; I_Box[85]=8'hed; I_Box[86]=8'hb9; I_Box[87]=8'hda; I_Box[88]=8'h5e; I_Box[89]=8'h15; I_Box[90]=8'h46; I_Box[91]=8'h57; I_Box[92]=8'ha7; I_Box[93]=8'h8d; I_Box[94]=8'h9d; I_Box[95]=8'h84;
    I_Box[96]=8'h90; I_Box[97]=8'hd8; I_Box[98]=8'hab; I_Box[99]=8'h00; I_Box[100]=8'h8c; I_Box[101]=8'hbc; I_Box[102]=8'hd3; I_Box[103]=8'h0a; I_Box[104]=8'hf7; I_Box[105]=8'he4; I_Box[106]=8'h58; I_Box[107]=8'h05; I_Box[108]=8'hb8; I_Box[109]=8'hb3; I_Box[110]=8'h45; I_Box[111]=8'h06;
    I_Box[112]=8'hd0; I_Box[113]=8'h2c; I_Box[114]=8'h1e; I_Box[115]=8'h8f; I_Box[116]=8'hca; I_Box[117]=8'h3f; I_Box[118]=8'h0f; I_Box[119]=8'h02; I_Box[120]=8'hc1; I_Box[121]=8'haf; I_Box[122]=8'hbd; I_Box[123]=8'h03; I_Box[124]=8'h01; I_Box[125]=8'h13; I_Box[126]=8'h8a; I_Box[127]=8'h6b;
    I_Box[128]=8'h3a; I_Box[129]=8'h91; I_Box[130]=8'h11; I_Box[131]=8'h41; I_Box[132]=8'h4f; I_Box[133]=8'h67; I_Box[134]=8'hdc; I_Box[135]=8'hea; I_Box[136]=8'h97; I_Box[137]=8'hf2; I_Box[138]=8'hcf; I_Box[139]=8'hce; I_Box[140]=8'hf0; I_Box[141]=8'hb4; I_Box[142]=8'he6; I_Box[143]=8'h73;
    I_Box[144]=8'h96; I_Box[145]=8'hac; I_Box[146]=8'h74; I_Box[147]=8'h22; I_Box[148]=8'he7; I_Box[149]=8'had; I_Box[150]=8'h35; I_Box[151]=8'h85; I_Box[152]=8'he2; I_Box[153]=8'hf9; I_Box[154]=8'h37; I_Box[155]=8'he8; I_Box[156]=8'h1c; I_Box[157]=8'h75; I_Box[158]=8'hdf; I_Box[159]=8'h6e;
    I_Box[160]=8'h47; I_Box[161]=8'hf1; I_Box[162]=8'h1a; I_Box[163]=8'h71; I_Box[164]=8'h1d; I_Box[165]=8'h29; I_Box[166]=8'hc5; I_Box[167]=8'h89; I_Box[168]=8'h6f; I_Box[169]=8'hb7; I_Box[170]=8'h62; I_Box[171]=8'h0e; I_Box[172]=8'haa; I_Box[173]=8'h18; I_Box[174]=8'hbe; I_Box[175]=8'h1b;
    I_Box[176]=8'hfc; I_Box[177]=8'h56; I_Box[178]=8'h3e; I_Box[179]=8'h4b; I_Box[180]=8'hc6; I_Box[181]=8'hd2; I_Box[182]=8'h79; I_Box[183]=8'h20; I_Box[184]=8'h9a; I_Box[185]=8'hdb; I_Box[186]=8'hc0; I_Box[187]=8'hfe; I_Box[188]=8'h78; I_Box[189]=8'hcd; I_Box[190]=8'h5a; I_Box[191]=8'hf4;
    I_Box[192]=8'h1f; I_Box[193]=8'hdd; I_Box[194]=8'ha8; I_Box[195]=8'h33; I_Box[196]=8'h88; I_Box[197]=8'h07; I_Box[198]=8'hc7; I_Box[199]=8'h31; I_Box[200]=8'hb1; I_Box[201]=8'h12; I_Box[202]=8'h10; I_Box[203]=8'h59; I_Box[204]=8'h27; I_Box[205]=8'h80; I_Box[206]=8'hec; I_Box[207]=8'h5f;
    I_Box[208]=8'h60; I_Box[209]=8'h51; I_Box[210]=8'h7f; I_Box[211]=8'ha9; I_Box[212]=8'h19; I_Box[213]=8'hb5; I_Box[214]=8'h4a; I_Box[215]=8'h0d; I_Box[216]=8'h2d; I_Box[217]=8'he5; I_Box[218]=8'h7a; I_Box[219]=8'h9f; I_Box[220]=8'h93; I_Box[221]=8'hc9; I_Box[222]=8'h9c; I_Box[223]=8'hef;
    I_Box[224]=8'ha0; I_Box[225]=8'he0; I_Box[226]=8'h3b; I_Box[227]=8'h4d; I_Box[228]=8'hae; I_Box[229]=8'h2a; I_Box[230]=8'hf5; I_Box[231]=8'hb0; I_Box[232]=8'hc8; I_Box[233]=8'heb; I_Box[234]=8'hbb; I_Box[235]=8'h3c; I_Box[236]=8'h83; I_Box[237]=8'h53; I_Box[238]=8'h99; I_Box[239]=8'h61;
    I_Box[240]=8'h17; I_Box[241]=8'h2b; I_Box[242]=8'h04; I_Box[243]=8'h7e; I_Box[244]=8'hba; I_Box[245]=8'h77; I_Box[246]=8'hd6; I_Box[247]=8'h26; I_Box[248]=8'he1; I_Box[249]=8'h69; I_Box[250]=8'h14; I_Box[251]=8'h63; I_Box[252]=8'h55; I_Box[253]=8'h21; I_Box[254]=8'h0c; I_Box[255]=8'h7d;

    EXP_3[0]=8'h01; EXP_3[1]=8'h03; EXP_3[2]=8'h05; EXP_3[3]=8'h0f; EXP_3[4]=8'h11; EXP_3[5]=8'h33; EXP_3[6]=8'h55; EXP_3[7]=8'hff; EXP_3[8]=8'h1a; EXP_3[9]=8'h2e; EXP_3[10]=8'h72; EXP_3[11]=8'h96; EXP_3[12]=8'ha1; EXP_3[13]=8'hf8; EXP_3[14]=8'h13; EXP_3[15]=8'h35;
    EXP_3[16]=8'h5f; EXP_3[17]=8'he1; EXP_3[18]=8'h38; EXP_3[19]=8'h48; EXP_3[20]=8'hd8; EXP_3[21]=8'h73; EXP_3[22]=8'h95; EXP_3[23]=8'ha4; EXP_3[24]=8'hf7; EXP_3[25]=8'h02; EXP_3[26]=8'h06; EXP_3[27]=8'h0a; EXP_3[28]=8'h1e; EXP_3[29]=8'h22; EXP_3[30]=8'h66; EXP_3[31]=8'haa;
    EXP_3[32]=8'he5; EXP_3[33]=8'h34; EXP_3[34]=8'h5c; EXP_3[35]=8'he4; EXP_3[36]=8'h37; EXP_3[37]=8'h59; EXP_3[38]=8'heb; EXP_3[39]=8'h26; EXP_3[40]=8'h6a; EXP_3[41]=8'hbe; EXP_3[42]=8'hd9; EXP_3[43]=8'h70; EXP_3[44]=8'h90; EXP_3[45]=8'hab; EXP_3[46]=8'he6; EXP_3[47]=8'h31;
    EXP_3[48]=8'h53; EXP_3[49]=8'hf5; EXP_3[50]=8'h04; EXP_3[51]=8'h0c; EXP_3[52]=8'h14; EXP_3[53]=8'h3c; EXP_3[54]=8'h44; EXP_3[55]=8'hcc; EXP_3[56]=8'h4f; EXP_3[57]=8'hd1; EXP_3[58]=8'h68; EXP_3[59]=8'hb8; EXP_3[60]=8'hd3; EXP_3[61]=8'h6e; EXP_3[62]=8'hb2; EXP_3[63]=8'hcd;
    EXP_3[64]=8'h4c; EXP_3[65]=8'hd4; EXP_3[66]=8'h67; EXP_3[67]=8'ha9; EXP_3[68]=8'he0; EXP_3[69]=8'h3b; EXP_3[70]=8'h4d; EXP_3[71]=8'hd7; EXP_3[72]=8'h62; EXP_3[73]=8'ha6; EXP_3[74]=8'hf1; EXP_3[75]=8'h08; EXP_3[76]=8'h18; EXP_3[77]=8'h28; EXP_3[78]=8'h78; EXP_3[79]=8'h88;
    EXP_3[80]=8'h83; EXP_3[81]=8'h9e; EXP_3[82]=8'hb9; EXP_3[83]=8'hd0; EXP_3[84]=8'h6b; EXP_3[85]=8'hbd; EXP_3[86]=8'hdc; EXP_3[87]=8'h7f; EXP_3[88]=8'h81; EXP_3[89]=8'h98; EXP_3[90]=8'hb3; EXP_3[91]=8'hce; EXP_3[92]=8'h49; EXP_3[93]=8'hdb; EXP_3[94]=8'h76; EXP_3[95]=8'h9a;
    EXP_3[96]=8'hb5; EXP_3[97]=8'hc4; EXP_3[98]=8'h57; EXP_3[99]=8'hf9; EXP_3[100]=8'h10; EXP_3[101]=8'h30; EXP_3[102]=8'h50; EXP_3[103]=8'hf0; EXP_3[104]=8'h0b; EXP_3[105]=8'h1d; EXP_3[106]=8'h27; EXP_3[107]=8'h69; EXP_3[108]=8'hbb; EXP_3[109]=8'hd6; EXP_3[110]=8'h61; EXP_3[111]=8'ha3;
    EXP_3[112]=8'hfe; EXP_3[113]=8'h19; EXP_3[114]=8'h2b; EXP_3[115]=8'h7d; EXP_3[116]=8'h87; EXP_3[117]=8'h92; EXP_3[118]=8'had; EXP_3[119]=8'hec; EXP_3[120]=8'h2f; EXP_3[121]=8'h71; EXP_3[122]=8'h93; EXP_3[123]=8'hae; EXP_3[124]=8'he9; EXP_3[125]=8'h20; EXP_3[126]=8'h60; EXP_3[127]=8'ha0;
    EXP_3[128]=8'hfb; EXP_3[129]=8'h16; EXP_3[130]=8'h3a; EXP_3[131]=8'h4e; EXP_3[132]=8'hd2; EXP_3[133]=8'h6d; EXP_3[134]=8'hb7; EXP_3[135]=8'hc2; EXP_3[136]=8'h5d; EXP_3[137]=8'he7; EXP_3[138]=8'h32; EXP_3[139]=8'h56; EXP_3[140]=8'hfa; EXP_3[141]=8'h15; EXP_3[142]=8'h3f; EXP_3[143]=8'h41;
    EXP_3[144]=8'hc3; EXP_3[145]=8'h5e; EXP_3[146]=8'he2; EXP_3[147]=8'h3d; EXP_3[148]=8'h47; EXP_3[149]=8'hc9; EXP_3[150]=8'h40; EXP_3[151]=8'hc0; EXP_3[152]=8'h5b; EXP_3[153]=8'hed; EXP_3[154]=8'h2c; EXP_3[155]=8'h74; EXP_3[156]=8'h9c; EXP_3[157]=8'hbf; EXP_3[158]=8'hda; EXP_3[159]=8'h75;
    EXP_3[160]=8'h9f; EXP_3[161]=8'hba; EXP_3[162]=8'hd5; EXP_3[163]=8'h64; EXP_3[164]=8'hac; EXP_3[165]=8'hef; EXP_3[166]=8'h2a; EXP_3[167]=8'h7e; EXP_3[168]=8'h82; EXP_3[169]=8'h9d; EXP_3[170]=8'hbc; EXP_3[171]=8'hdf; EXP_3[172]=8'h7a; EXP_3[173]=8'h8e; EXP_3[174]=8'h89; EXP_3[175]=8'h80;
    EXP_3[176]=8'h9b; EXP_3[177]=8'hb6; EXP_3[178]=8'hc1; EXP_3[179]=8'h58; EXP_3[180]=8'he8; EXP_3[181]=8'h23; EXP_3[182]=8'h65; EXP_3[183]=8'haf; EXP_3[184]=8'hea; EXP_3[185]=8'h25; EXP_3[186]=8'h6f; EXP_3[187]=8'hb1; EXP_3[188]=8'hc8; EXP_3[189]=8'h43; EXP_3[190]=8'hc5; EXP_3[191]=8'h54;
    EXP_3[192]=8'hfc; EXP_3[193]=8'h1f; EXP_3[194]=8'h21; EXP_3[195]=8'h63; EXP_3[196]=8'ha5; EXP_3[197]=8'hf4; EXP_3[198]=8'h07; EXP_3[199]=8'h09; EXP_3[200]=8'h1b; EXP_3[201]=8'h2d; EXP_3[202]=8'h77; EXP_3[203]=8'h99; EXP_3[204]=8'hb0; EXP_3[205]=8'hcb; EXP_3[206]=8'h46; EXP_3[207]=8'hca;
    EXP_3[208]=8'h45; EXP_3[209]=8'hcf; EXP_3[210]=8'h4a; EXP_3[211]=8'hde; EXP_3[212]=8'h79; EXP_3[213]=8'h8b; EXP_3[214]=8'h86; EXP_3[215]=8'h91; EXP_3[216]=8'ha8; EXP_3[217]=8'he3; EXP_3[218]=8'h3e; EXP_3[219]=8'h42; EXP_3[220]=8'hc6; EXP_3[221]=8'h51; EXP_3[222]=8'hf3; EXP_3[223]=8'h0e;
    EXP_3[224]=8'h12; EXP_3[225]=8'h36; EXP_3[226]=8'h5a; EXP_3[227]=8'hee; EXP_3[228]=8'h29; EXP_3[229]=8'h7b; EXP_3[230]=8'h8d; EXP_3[231]=8'h8c; EXP_3[232]=8'h8f; EXP_3[233]=8'h8a; EXP_3[234]=8'h85; EXP_3[235]=8'h94; EXP_3[236]=8'ha7; EXP_3[237]=8'hf2; EXP_3[238]=8'h0d; EXP_3[239]=8'h17;
    EXP_3[240]=8'h39; EXP_3[241]=8'h4b; EXP_3[242]=8'hdd; EXP_3[243]=8'h7c; EXP_3[244]=8'h84; EXP_3[245]=8'h97; EXP_3[246]=8'ha2; EXP_3[247]=8'hfd; EXP_3[248]=8'h1c; EXP_3[249]=8'h24; EXP_3[250]=8'h6c; EXP_3[251]=8'hb4; EXP_3[252]=8'hc7; EXP_3[253]=8'h52; EXP_3[254]=8'hf6; EXP_3[255]=8'h01;

    LN_3[0]=8'h00; LN_3[1]=8'h00; LN_3[2]=8'h19; LN_3[3]=8'h01; LN_3[4]=8'h32; LN_3[5]=8'h02; LN_3[6]=8'h1a; LN_3[7]=8'hc6; LN_3[8]=8'h4b; LN_3[9]=8'hc7; LN_3[10]=8'h1b; LN_3[11]=8'h68; LN_3[12]=8'h33; LN_3[13]=8'hee; LN_3[14]=8'hdf; LN_3[15]=8'h03;
    LN_3[16]=8'h64; LN_3[17]=8'h04; LN_3[18]=8'he0; LN_3[19]=8'h0e; LN_3[20]=8'h34; LN_3[21]=8'h8d; LN_3[22]=8'h81; LN_3[23]=8'hef; LN_3[24]=8'h4c; LN_3[25]=8'h71; LN_3[26]=8'h08; LN_3[27]=8'hc8; LN_3[28]=8'hf8; LN_3[29]=8'h69; LN_3[30]=8'h1c; LN_3[31]=8'hc1;
    LN_3[32]=8'h7d; LN_3[33]=8'hc2; LN_3[34]=8'h1d; LN_3[35]=8'hb5; LN_3[36]=8'hf9; LN_3[37]=8'hb9; LN_3[38]=8'h27; LN_3[39]=8'h6a; LN_3[40]=8'h4d; LN_3[41]=8'he4; LN_3[42]=8'ha6; LN_3[43]=8'h72; LN_3[44]=8'h9a; LN_3[45]=8'hc9; LN_3[46]=8'h09; LN_3[47]=8'h78;
    LN_3[48]=8'h65; LN_3[49]=8'h2f; LN_3[50]=8'h8a; LN_3[51]=8'h05; LN_3[52]=8'h21; LN_3[53]=8'h0f; LN_3[54]=8'he1; LN_3[55]=8'h24; LN_3[56]=8'h12; LN_3[57]=8'hf0; LN_3[58]=8'h82; LN_3[59]=8'h45; LN_3[60]=8'h35; LN_3[61]=8'h93; LN_3[62]=8'hda; LN_3[63]=8'h8e;
    LN_3[64]=8'h96; LN_3[65]=8'h8f; LN_3[66]=8'hdb; LN_3[67]=8'hbd; LN_3[68]=8'h36; LN_3[69]=8'hd0; LN_3[70]=8'hce; LN_3[71]=8'h94; LN_3[72]=8'h13; LN_3[73]=8'h5c; LN_3[74]=8'hd2; LN_3[75]=8'hf1; LN_3[76]=8'h40; LN_3[77]=8'h46; LN_3[78]=8'h83; LN_3[79]=8'h38;
    LN_3[80]=8'h66; LN_3[81]=8'hdd; LN_3[82]=8'hfd; LN_3[83]=8'h30; LN_3[84]=8'hbf; LN_3[85]=8'h06; LN_3[86]=8'h8b; LN_3[87]=8'h62; LN_3[88]=8'hb3; LN_3[89]=8'h25; LN_3[90]=8'he2; LN_3[91]=8'h98; LN_3[92]=8'h22; LN_3[93]=8'h88; LN_3[94]=8'h91; LN_3[95]=8'h10;
    LN_3[96]=8'h7e; LN_3[97]=8'h6e; LN_3[98]=8'h48; LN_3[99]=8'hc3; LN_3[100]=8'ha3; LN_3[101]=8'hb6; LN_3[102]=8'h1e; LN_3[103]=8'h42; LN_3[104]=8'h3a; LN_3[105]=8'h6b; LN_3[106]=8'h28; LN_3[107]=8'h54; LN_3[108]=8'hfa; LN_3[109]=8'h85; LN_3[110]=8'h3d; LN_3[111]=8'hba;
    LN_3[112]=8'h2b; LN_3[113]=8'h79; LN_3[114]=8'h0a; LN_3[115]=8'h15; LN_3[116]=8'h9b; LN_3[117]=8'h9f; LN_3[118]=8'h5e; LN_3[119]=8'hca; LN_3[120]=8'h4e; LN_3[121]=8'hd4; LN_3[122]=8'hac; LN_3[123]=8'he5; LN_3[124]=8'hf3; LN_3[125]=8'h73; LN_3[126]=8'ha7; LN_3[127]=8'h57;
    LN_3[128]=8'haf; LN_3[129]=8'h58; LN_3[130]=8'ha8; LN_3[131]=8'h50; LN_3[132]=8'hf4; LN_3[133]=8'hea; LN_3[134]=8'hd6; LN_3[135]=8'h74; LN_3[136]=8'h4f; LN_3[137]=8'hae; LN_3[138]=8'he9; LN_3[139]=8'hd5; LN_3[140]=8'he7; LN_3[141]=8'he6; LN_3[142]=8'had; LN_3[143]=8'he8;
    LN_3[144]=8'h2c; LN_3[145]=8'hd7; LN_3[146]=8'h75; LN_3[147]=8'h7a; LN_3[148]=8'heb; LN_3[149]=8'h16; LN_3[150]=8'h0b; LN_3[151]=8'hf5; LN_3[152]=8'h59; LN_3[153]=8'hcb; LN_3[154]=8'h5f; LN_3[155]=8'hb0; LN_3[156]=8'h9c; LN_3[157]=8'ha9; LN_3[158]=8'h51; LN_3[159]=8'ha0;
    LN_3[160]=8'h7f; LN_3[161]=8'h0c; LN_3[162]=8'hf6; LN_3[163]=8'h6f; LN_3[164]=8'h17; LN_3[165]=8'hc4; LN_3[166]=8'h49; LN_3[167]=8'hec; LN_3[168]=8'hd8; LN_3[169]=8'h43; LN_3[170]=8'h1f; LN_3[171]=8'h2d; LN_3[172]=8'ha4; LN_3[173]=8'h76; LN_3[174]=8'h7b; LN_3[175]=8'hb7;
    LN_3[176]=8'hcc; LN_3[177]=8'hbb; LN_3[178]=8'h3e; LN_3[179]=8'h5a; LN_3[180]=8'hfb; LN_3[181]=8'h60; LN_3[182]=8'hb1; LN_3[183]=8'h86; LN_3[184]=8'h3b; LN_3[185]=8'h52; LN_3[186]=8'ha1; LN_3[187]=8'h6c; LN_3[188]=8'haa; LN_3[189]=8'h55; LN_3[190]=8'h29; LN_3[191]=8'h9d;
    LN_3[192]=8'h97; LN_3[193]=8'hb2; LN_3[194]=8'h87; LN_3[195]=8'h90; LN_3[196]=8'h61; LN_3[197]=8'hbe; LN_3[198]=8'hdc; LN_3[199]=8'hfc; LN_3[200]=8'hbc; LN_3[201]=8'h95; LN_3[202]=8'hcf; LN_3[203]=8'hcd; LN_3[204]=8'h37; LN_3[205]=8'h3f; LN_3[206]=8'h5b; LN_3[207]=8'hd1;
    LN_3[208]=8'h53; LN_3[209]=8'h39; LN_3[210]=8'h84; LN_3[211]=8'h3c; LN_3[212]=8'h41; LN_3[213]=8'ha2; LN_3[214]=8'h6d; LN_3[215]=8'h47; LN_3[216]=8'h14; LN_3[217]=8'h2a; LN_3[218]=8'h9e; LN_3[219]=8'h5d; LN_3[220]=8'h56; LN_3[221]=8'hf2; LN_3[222]=8'hd3; LN_3[223]=8'hab;
    LN_3[224]=8'h44; LN_3[225]=8'h11; LN_3[226]=8'h92; LN_3[227]=8'hd9; LN_3[228]=8'h23; LN_3[229]=8'h20; LN_3[230]=8'h2e; LN_3[231]=8'h89; LN_3[232]=8'hb4; LN_3[233]=8'h7c; LN_3[234]=8'hb8; LN_3[235]=8'h26; LN_3[236]=8'h77; LN_3[237]=8'h99; LN_3[238]=8'he3; LN_3[239]=8'ha5;
    LN_3[240]=8'h67; LN_3[241]=8'h4a; LN_3[242]=8'hed; LN_3[243]=8'hde; LN_3[244]=8'hc5; LN_3[245]=8'h31; LN_3[246]=8'hfe; LN_3[247]=8'h18; LN_3[248]=8'h0d; LN_3[249]=8'h63; LN_3[250]=8'h8c; LN_3[251]=8'h80; LN_3[252]=8'hc0; LN_3[253]=8'hf7; LN_3[254]=8'h70; LN_3[255]=8'h07;

    Rcon[0]=8'h00; Rcon[1]=8'h01; Rcon[2]=8'h02; Rcon[3]=8'h04; Rcon[4]=8'h08; Rcon[5]=8'h10; Rcon[6]=8'h20; Rcon[7]=8'h40; Rcon[8]=8'h80; Rcon[9]=8'h1b; Rcon[10]=8'h36,; Rcon[11]=8'h6c,; Rcon[12]=8'hd8,; Rcon[13]=8'hab,; Rcon[14]=8'h4d,; Rcon[15]=8'h9a
  end

  always_comb begin

    v = r;

    if (r.state == idle) begin
      if (aes_in.enable == 1) begin
        if (aes_in.func == 0) begin
          v.Nb = aes_in.data[3:0];
          v.Nk = aes_in.data[11:8];
          v.Nr = aes_in.data[19:16];
          v.state = idle;
        end else if (aes_in.func == 1) begin
          v.key = aes_in.data;
          v.state = key_exp;
        end else if (aes_in.func == 2) begin
          v.data = aes_in.data;
          v.state = cipher;
        end else if (aes_in.func == 3) begin
          v.data = aes_in.data;
          v.state = icipher;
        end
      end
    end else if (r.state == key_exp) begin
      v.state = idle;
    end else if (r.state == cipher) begin
      v.state = idle;
    end else if (r.state == icipher) begin
      v.state = idle;
    end

    rin = v;

  end

  always_ff @(posedge clk) begin
    if (rst == 0) begin
      r <= init_aes_reg;
    end else begin
      r <= rin;
    end
  end

endmodule
