import aes_const::*;

module aes_array(
  output logic [7:0] SBox [0:255],
  output logic [7:0] IBox [0:255],
  output logic [7:0] EXP3 [0:255],
  output logic [7:0] LN3 [0:255],
  output logic [7:0] RCon [0:15]
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] sbox [0:255];
  logic [7 : 0] ibox [0:255];
  logic [7 : 0] exp3 [0:255];
  logic [7 : 0] ln3 [0:255];
  logic [7 : 0] rcon [0:15];

  initial begin
    sbox[0]=8'h63; sbox[1]=8'h7c; sbox[2]=8'h77; sbox[3]=8'h7b; sbox[4]=8'hf2; sbox[5]=8'h6b; sbox[6]=8'h6f; sbox[7]=8'hc5; sbox[8]=8'h30; sbox[9]=8'h01; sbox[10]=8'h67; sbox[11]=8'h2b; sbox[12]=8'hfe; sbox[13]=8'hd7; sbox[14]=8'hab; sbox[15]=8'h76;
    sbox[16]=8'hca; sbox[17]=8'h82; sbox[18]=8'hc9; sbox[19]=8'h7d; sbox[20]=8'hfa; sbox[21]=8'h59; sbox[22]=8'h47; sbox[23]=8'hf0; sbox[24]=8'had; sbox[25]=8'hd4; sbox[26]=8'ha2; sbox[27]=8'haf; sbox[28]=8'h9c; sbox[29]=8'ha4; sbox[30]=8'h72; sbox[31]=8'hc0;
    sbox[32]=8'hb7; sbox[33]=8'hfd; sbox[34]=8'h93; sbox[35]=8'h26; sbox[36]=8'h36; sbox[37]=8'h3f; sbox[38]=8'hf7; sbox[39]=8'hcc; sbox[40]=8'h34; sbox[41]=8'ha5; sbox[42]=8'he5; sbox[43]=8'hf1; sbox[44]=8'h71; sbox[45]=8'hd8; sbox[46]=8'h31; sbox[47]=8'h15;
    sbox[48]=8'h04; sbox[49]=8'hc7; sbox[50]=8'h23; sbox[51]=8'hc3; sbox[52]=8'h18; sbox[53]=8'h96; sbox[54]=8'h05; sbox[55]=8'h9a; sbox[56]=8'h07; sbox[57]=8'h12; sbox[58]=8'h80; sbox[59]=8'he2; sbox[60]=8'heb; sbox[61]=8'h27; sbox[62]=8'hb2; sbox[63]=8'h75;
    sbox[64]=8'h09; sbox[65]=8'h83; sbox[66]=8'h2c; sbox[67]=8'h1a; sbox[68]=8'h1b; sbox[69]=8'h6e; sbox[70]=8'h5a; sbox[71]=8'ha0; sbox[72]=8'h52; sbox[73]=8'h3b; sbox[74]=8'hd6; sbox[75]=8'hb3; sbox[76]=8'h29; sbox[77]=8'he3; sbox[78]=8'h2f; sbox[79]=8'h84;
    sbox[80]=8'h53; sbox[81]=8'hd1; sbox[82]=8'h00; sbox[83]=8'hed; sbox[84]=8'h20; sbox[85]=8'hfc; sbox[86]=8'hb1; sbox[87]=8'h5b; sbox[88]=8'h6a; sbox[89]=8'hcb; sbox[90]=8'hbe; sbox[91]=8'h39; sbox[92]=8'h4a; sbox[93]=8'h4c; sbox[94]=8'h58; sbox[95]=8'hcf;
    sbox[96]=8'hd0; sbox[97]=8'hef; sbox[98]=8'haa; sbox[99]=8'hfb; sbox[100]=8'h43; sbox[101]=8'h4d; sbox[102]=8'h33; sbox[103]=8'h85; sbox[104]=8'h45; sbox[105]=8'hf9; sbox[106]=8'h02; sbox[107]=8'h7f; sbox[108]=8'h50; sbox[109]=8'h3c; sbox[110]=8'h9f; sbox[111]=8'ha8;
    sbox[112]=8'h51; sbox[113]=8'ha3; sbox[114]=8'h40; sbox[115]=8'h8f; sbox[116]=8'h92; sbox[117]=8'h9d; sbox[118]=8'h38; sbox[119]=8'hf5; sbox[120]=8'hbc; sbox[121]=8'hb6; sbox[122]=8'hda; sbox[123]=8'h21; sbox[124]=8'h10; sbox[125]=8'hff; sbox[126]=8'hf3; sbox[127]=8'hd2;
    sbox[128]=8'hcd; sbox[129]=8'h0c; sbox[130]=8'h13; sbox[131]=8'hec; sbox[132]=8'h5f; sbox[133]=8'h97; sbox[134]=8'h44; sbox[135]=8'h17; sbox[136]=8'hc4; sbox[137]=8'ha7; sbox[138]=8'h7e; sbox[139]=8'h3d; sbox[140]=8'h64; sbox[141]=8'h5d; sbox[142]=8'h19; sbox[143]=8'h73;
    sbox[144]=8'h60; sbox[145]=8'h81; sbox[146]=8'h4f; sbox[147]=8'hdc; sbox[148]=8'h22; sbox[149]=8'h2a; sbox[150]=8'h90; sbox[151]=8'h88; sbox[152]=8'h46; sbox[153]=8'hee; sbox[154]=8'hb8; sbox[155]=8'h14; sbox[156]=8'hde; sbox[157]=8'h5e; sbox[158]=8'h0b; sbox[159]=8'hdb;
    sbox[160]=8'he0; sbox[161]=8'h32; sbox[162]=8'h3a; sbox[163]=8'h0a; sbox[164]=8'h49; sbox[165]=8'h06; sbox[166]=8'h24; sbox[167]=8'h5c; sbox[168]=8'hc2; sbox[169]=8'hd3; sbox[170]=8'hac; sbox[171]=8'h62; sbox[172]=8'h91; sbox[173]=8'h95; sbox[174]=8'he4; sbox[175]=8'h79;
    sbox[176]=8'he7; sbox[177]=8'hc8; sbox[178]=8'h37; sbox[179]=8'h6d; sbox[180]=8'h8d; sbox[181]=8'hd5; sbox[182]=8'h4e; sbox[183]=8'ha9; sbox[184]=8'h6c; sbox[185]=8'h56; sbox[186]=8'hf4; sbox[187]=8'hea; sbox[188]=8'h65; sbox[189]=8'h7a; sbox[190]=8'hae; sbox[191]=8'h08;
    sbox[192]=8'hba; sbox[193]=8'h78; sbox[194]=8'h25; sbox[195]=8'h2e; sbox[196]=8'h1c; sbox[197]=8'ha6; sbox[198]=8'hb4; sbox[199]=8'hc6; sbox[200]=8'he8; sbox[201]=8'hdd; sbox[202]=8'h74; sbox[203]=8'h1f; sbox[204]=8'h4b; sbox[205]=8'hbd; sbox[206]=8'h8b; sbox[207]=8'h8a;
    sbox[208]=8'h70; sbox[209]=8'h3e; sbox[210]=8'hb5; sbox[211]=8'h66; sbox[212]=8'h48; sbox[213]=8'h03; sbox[214]=8'hf6; sbox[215]=8'h0e; sbox[216]=8'h61; sbox[217]=8'h35; sbox[218]=8'h57; sbox[219]=8'hb9; sbox[220]=8'h86; sbox[221]=8'hc1; sbox[222]=8'h1d; sbox[223]=8'h9e;
    sbox[224]=8'he1; sbox[225]=8'hf8; sbox[226]=8'h98; sbox[227]=8'h11; sbox[228]=8'h69; sbox[229]=8'hd9; sbox[230]=8'h8e; sbox[231]=8'h94; sbox[232]=8'h9b; sbox[233]=8'h1e; sbox[234]=8'h87; sbox[235]=8'he9; sbox[236]=8'hce; sbox[237]=8'h55; sbox[238]=8'h28; sbox[239]=8'hdf;
    sbox[240]=8'h8c; sbox[241]=8'ha1; sbox[242]=8'h89; sbox[243]=8'h0d; sbox[244]=8'hbf; sbox[245]=8'he6; sbox[246]=8'h42; sbox[247]=8'h68; sbox[248]=8'h41; sbox[249]=8'h99; sbox[250]=8'h2d; sbox[251]=8'h0f; sbox[252]=8'hb0; sbox[253]=8'h54; sbox[254]=8'hbb; sbox[255]=8'h16;

    ibox[0]=8'h52; ibox[1]=8'h09; ibox[2]=8'h6a; ibox[3]=8'hd5; ibox[4]=8'h30; ibox[5]=8'h36; ibox[6]=8'ha5; ibox[7]=8'h38; ibox[8]=8'hbf; ibox[9]=8'h40; ibox[10]=8'ha3; ibox[11]=8'h9e; ibox[12]=8'h81; ibox[13]=8'hf3; ibox[14]=8'hd7; ibox[15]=8'hfb;
    ibox[16]=8'h7c; ibox[17]=8'he3; ibox[18]=8'h39; ibox[19]=8'h82; ibox[20]=8'h9b; ibox[21]=8'h2f; ibox[22]=8'hff; ibox[23]=8'h87; ibox[24]=8'h34; ibox[25]=8'h8e; ibox[26]=8'h43; ibox[27]=8'h44; ibox[28]=8'hc4; ibox[29]=8'hde; ibox[30]=8'he9; ibox[31]=8'hcb;
    ibox[32]=8'h54; ibox[33]=8'h7b; ibox[34]=8'h94; ibox[35]=8'h32; ibox[36]=8'ha6; ibox[37]=8'hc2; ibox[38]=8'h23; ibox[39]=8'h3d; ibox[40]=8'hee; ibox[41]=8'h4c; ibox[42]=8'h95; ibox[43]=8'h0b; ibox[44]=8'h42; ibox[45]=8'hfa; ibox[46]=8'hc3; ibox[47]=8'h4e;
    ibox[48]=8'h08; ibox[49]=8'h2e; ibox[50]=8'ha1; ibox[51]=8'h66; ibox[52]=8'h28; ibox[53]=8'hd9; ibox[54]=8'h24; ibox[55]=8'hb2; ibox[56]=8'h76; ibox[57]=8'h5b; ibox[58]=8'ha2; ibox[59]=8'h49; ibox[60]=8'h6d; ibox[61]=8'h8b; ibox[62]=8'hd1; ibox[63]=8'h25;
    ibox[64]=8'h72; ibox[65]=8'hf8; ibox[66]=8'hf6; ibox[67]=8'h64; ibox[68]=8'h86; ibox[69]=8'h68; ibox[70]=8'h98; ibox[71]=8'h16; ibox[72]=8'hd4; ibox[73]=8'ha4; ibox[74]=8'h5c; ibox[75]=8'hcc; ibox[76]=8'h5d; ibox[77]=8'h65; ibox[78]=8'hb6; ibox[79]=8'h92;
    ibox[80]=8'h6c; ibox[81]=8'h70; ibox[82]=8'h48; ibox[83]=8'h50; ibox[84]=8'hfd; ibox[85]=8'hed; ibox[86]=8'hb9; ibox[87]=8'hda; ibox[88]=8'h5e; ibox[89]=8'h15; ibox[90]=8'h46; ibox[91]=8'h57; ibox[92]=8'ha7; ibox[93]=8'h8d; ibox[94]=8'h9d; ibox[95]=8'h84;
    ibox[96]=8'h90; ibox[97]=8'hd8; ibox[98]=8'hab; ibox[99]=8'h00; ibox[100]=8'h8c; ibox[101]=8'hbc; ibox[102]=8'hd3; ibox[103]=8'h0a; ibox[104]=8'hf7; ibox[105]=8'he4; ibox[106]=8'h58; ibox[107]=8'h05; ibox[108]=8'hb8; ibox[109]=8'hb3; ibox[110]=8'h45; ibox[111]=8'h06;
    ibox[112]=8'hd0; ibox[113]=8'h2c; ibox[114]=8'h1e; ibox[115]=8'h8f; ibox[116]=8'hca; ibox[117]=8'h3f; ibox[118]=8'h0f; ibox[119]=8'h02; ibox[120]=8'hc1; ibox[121]=8'haf; ibox[122]=8'hbd; ibox[123]=8'h03; ibox[124]=8'h01; ibox[125]=8'h13; ibox[126]=8'h8a; ibox[127]=8'h6b;
    ibox[128]=8'h3a; ibox[129]=8'h91; ibox[130]=8'h11; ibox[131]=8'h41; ibox[132]=8'h4f; ibox[133]=8'h67; ibox[134]=8'hdc; ibox[135]=8'hea; ibox[136]=8'h97; ibox[137]=8'hf2; ibox[138]=8'hcf; ibox[139]=8'hce; ibox[140]=8'hf0; ibox[141]=8'hb4; ibox[142]=8'he6; ibox[143]=8'h73;
    ibox[144]=8'h96; ibox[145]=8'hac; ibox[146]=8'h74; ibox[147]=8'h22; ibox[148]=8'he7; ibox[149]=8'had; ibox[150]=8'h35; ibox[151]=8'h85; ibox[152]=8'he2; ibox[153]=8'hf9; ibox[154]=8'h37; ibox[155]=8'he8; ibox[156]=8'h1c; ibox[157]=8'h75; ibox[158]=8'hdf; ibox[159]=8'h6e;
    ibox[160]=8'h47; ibox[161]=8'hf1; ibox[162]=8'h1a; ibox[163]=8'h71; ibox[164]=8'h1d; ibox[165]=8'h29; ibox[166]=8'hc5; ibox[167]=8'h89; ibox[168]=8'h6f; ibox[169]=8'hb7; ibox[170]=8'h62; ibox[171]=8'h0e; ibox[172]=8'haa; ibox[173]=8'h18; ibox[174]=8'hbe; ibox[175]=8'h1b;
    ibox[176]=8'hfc; ibox[177]=8'h56; ibox[178]=8'h3e; ibox[179]=8'h4b; ibox[180]=8'hc6; ibox[181]=8'hd2; ibox[182]=8'h79; ibox[183]=8'h20; ibox[184]=8'h9a; ibox[185]=8'hdb; ibox[186]=8'hc0; ibox[187]=8'hfe; ibox[188]=8'h78; ibox[189]=8'hcd; ibox[190]=8'h5a; ibox[191]=8'hf4;
    ibox[192]=8'h1f; ibox[193]=8'hdd; ibox[194]=8'ha8; ibox[195]=8'h33; ibox[196]=8'h88; ibox[197]=8'h07; ibox[198]=8'hc7; ibox[199]=8'h31; ibox[200]=8'hb1; ibox[201]=8'h12; ibox[202]=8'h10; ibox[203]=8'h59; ibox[204]=8'h27; ibox[205]=8'h80; ibox[206]=8'hec; ibox[207]=8'h5f;
    ibox[208]=8'h60; ibox[209]=8'h51; ibox[210]=8'h7f; ibox[211]=8'ha9; ibox[212]=8'h19; ibox[213]=8'hb5; ibox[214]=8'h4a; ibox[215]=8'h0d; ibox[216]=8'h2d; ibox[217]=8'he5; ibox[218]=8'h7a; ibox[219]=8'h9f; ibox[220]=8'h93; ibox[221]=8'hc9; ibox[222]=8'h9c; ibox[223]=8'hef;
    ibox[224]=8'ha0; ibox[225]=8'he0; ibox[226]=8'h3b; ibox[227]=8'h4d; ibox[228]=8'hae; ibox[229]=8'h2a; ibox[230]=8'hf5; ibox[231]=8'hb0; ibox[232]=8'hc8; ibox[233]=8'heb; ibox[234]=8'hbb; ibox[235]=8'h3c; ibox[236]=8'h83; ibox[237]=8'h53; ibox[238]=8'h99; ibox[239]=8'h61;
    ibox[240]=8'h17; ibox[241]=8'h2b; ibox[242]=8'h04; ibox[243]=8'h7e; ibox[244]=8'hba; ibox[245]=8'h77; ibox[246]=8'hd6; ibox[247]=8'h26; ibox[248]=8'he1; ibox[249]=8'h69; ibox[250]=8'h14; ibox[251]=8'h63; ibox[252]=8'h55; ibox[253]=8'h21; ibox[254]=8'h0c; ibox[255]=8'h7d;

    exp3[0]=8'h01; exp3[1]=8'h03; exp3[2]=8'h05; exp3[3]=8'h0f; exp3[4]=8'h11; exp3[5]=8'h33; exp3[6]=8'h55; exp3[7]=8'hff; exp3[8]=8'h1a; exp3[9]=8'h2e; exp3[10]=8'h72; exp3[11]=8'h96; exp3[12]=8'ha1; exp3[13]=8'hf8; exp3[14]=8'h13; exp3[15]=8'h35;
    exp3[16]=8'h5f; exp3[17]=8'he1; exp3[18]=8'h38; exp3[19]=8'h48; exp3[20]=8'hd8; exp3[21]=8'h73; exp3[22]=8'h95; exp3[23]=8'ha4; exp3[24]=8'hf7; exp3[25]=8'h02; exp3[26]=8'h06; exp3[27]=8'h0a; exp3[28]=8'h1e; exp3[29]=8'h22; exp3[30]=8'h66; exp3[31]=8'haa;
    exp3[32]=8'he5; exp3[33]=8'h34; exp3[34]=8'h5c; exp3[35]=8'he4; exp3[36]=8'h37; exp3[37]=8'h59; exp3[38]=8'heb; exp3[39]=8'h26; exp3[40]=8'h6a; exp3[41]=8'hbe; exp3[42]=8'hd9; exp3[43]=8'h70; exp3[44]=8'h90; exp3[45]=8'hab; exp3[46]=8'he6; exp3[47]=8'h31;
    exp3[48]=8'h53; exp3[49]=8'hf5; exp3[50]=8'h04; exp3[51]=8'h0c; exp3[52]=8'h14; exp3[53]=8'h3c; exp3[54]=8'h44; exp3[55]=8'hcc; exp3[56]=8'h4f; exp3[57]=8'hd1; exp3[58]=8'h68; exp3[59]=8'hb8; exp3[60]=8'hd3; exp3[61]=8'h6e; exp3[62]=8'hb2; exp3[63]=8'hcd;
    exp3[64]=8'h4c; exp3[65]=8'hd4; exp3[66]=8'h67; exp3[67]=8'ha9; exp3[68]=8'he0; exp3[69]=8'h3b; exp3[70]=8'h4d; exp3[71]=8'hd7; exp3[72]=8'h62; exp3[73]=8'ha6; exp3[74]=8'hf1; exp3[75]=8'h08; exp3[76]=8'h18; exp3[77]=8'h28; exp3[78]=8'h78; exp3[79]=8'h88;
    exp3[80]=8'h83; exp3[81]=8'h9e; exp3[82]=8'hb9; exp3[83]=8'hd0; exp3[84]=8'h6b; exp3[85]=8'hbd; exp3[86]=8'hdc; exp3[87]=8'h7f; exp3[88]=8'h81; exp3[89]=8'h98; exp3[90]=8'hb3; exp3[91]=8'hce; exp3[92]=8'h49; exp3[93]=8'hdb; exp3[94]=8'h76; exp3[95]=8'h9a;
    exp3[96]=8'hb5; exp3[97]=8'hc4; exp3[98]=8'h57; exp3[99]=8'hf9; exp3[100]=8'h10; exp3[101]=8'h30; exp3[102]=8'h50; exp3[103]=8'hf0; exp3[104]=8'h0b; exp3[105]=8'h1d; exp3[106]=8'h27; exp3[107]=8'h69; exp3[108]=8'hbb; exp3[109]=8'hd6; exp3[110]=8'h61; exp3[111]=8'ha3;
    exp3[112]=8'hfe; exp3[113]=8'h19; exp3[114]=8'h2b; exp3[115]=8'h7d; exp3[116]=8'h87; exp3[117]=8'h92; exp3[118]=8'had; exp3[119]=8'hec; exp3[120]=8'h2f; exp3[121]=8'h71; exp3[122]=8'h93; exp3[123]=8'hae; exp3[124]=8'he9; exp3[125]=8'h20; exp3[126]=8'h60; exp3[127]=8'ha0;
    exp3[128]=8'hfb; exp3[129]=8'h16; exp3[130]=8'h3a; exp3[131]=8'h4e; exp3[132]=8'hd2; exp3[133]=8'h6d; exp3[134]=8'hb7; exp3[135]=8'hc2; exp3[136]=8'h5d; exp3[137]=8'he7; exp3[138]=8'h32; exp3[139]=8'h56; exp3[140]=8'hfa; exp3[141]=8'h15; exp3[142]=8'h3f; exp3[143]=8'h41;
    exp3[144]=8'hc3; exp3[145]=8'h5e; exp3[146]=8'he2; exp3[147]=8'h3d; exp3[148]=8'h47; exp3[149]=8'hc9; exp3[150]=8'h40; exp3[151]=8'hc0; exp3[152]=8'h5b; exp3[153]=8'hed; exp3[154]=8'h2c; exp3[155]=8'h74; exp3[156]=8'h9c; exp3[157]=8'hbf; exp3[158]=8'hda; exp3[159]=8'h75;
    exp3[160]=8'h9f; exp3[161]=8'hba; exp3[162]=8'hd5; exp3[163]=8'h64; exp3[164]=8'hac; exp3[165]=8'hef; exp3[166]=8'h2a; exp3[167]=8'h7e; exp3[168]=8'h82; exp3[169]=8'h9d; exp3[170]=8'hbc; exp3[171]=8'hdf; exp3[172]=8'h7a; exp3[173]=8'h8e; exp3[174]=8'h89; exp3[175]=8'h80;
    exp3[176]=8'h9b; exp3[177]=8'hb6; exp3[178]=8'hc1; exp3[179]=8'h58; exp3[180]=8'he8; exp3[181]=8'h23; exp3[182]=8'h65; exp3[183]=8'haf; exp3[184]=8'hea; exp3[185]=8'h25; exp3[186]=8'h6f; exp3[187]=8'hb1; exp3[188]=8'hc8; exp3[189]=8'h43; exp3[190]=8'hc5; exp3[191]=8'h54;
    exp3[192]=8'hfc; exp3[193]=8'h1f; exp3[194]=8'h21; exp3[195]=8'h63; exp3[196]=8'ha5; exp3[197]=8'hf4; exp3[198]=8'h07; exp3[199]=8'h09; exp3[200]=8'h1b; exp3[201]=8'h2d; exp3[202]=8'h77; exp3[203]=8'h99; exp3[204]=8'hb0; exp3[205]=8'hcb; exp3[206]=8'h46; exp3[207]=8'hca;
    exp3[208]=8'h45; exp3[209]=8'hcf; exp3[210]=8'h4a; exp3[211]=8'hde; exp3[212]=8'h79; exp3[213]=8'h8b; exp3[214]=8'h86; exp3[215]=8'h91; exp3[216]=8'ha8; exp3[217]=8'he3; exp3[218]=8'h3e; exp3[219]=8'h42; exp3[220]=8'hc6; exp3[221]=8'h51; exp3[222]=8'hf3; exp3[223]=8'h0e;
    exp3[224]=8'h12; exp3[225]=8'h36; exp3[226]=8'h5a; exp3[227]=8'hee; exp3[228]=8'h29; exp3[229]=8'h7b; exp3[230]=8'h8d; exp3[231]=8'h8c; exp3[232]=8'h8f; exp3[233]=8'h8a; exp3[234]=8'h85; exp3[235]=8'h94; exp3[236]=8'ha7; exp3[237]=8'hf2; exp3[238]=8'h0d; exp3[239]=8'h17;
    exp3[240]=8'h39; exp3[241]=8'h4b; exp3[242]=8'hdd; exp3[243]=8'h7c; exp3[244]=8'h84; exp3[245]=8'h97; exp3[246]=8'ha2; exp3[247]=8'hfd; exp3[248]=8'h1c; exp3[249]=8'h24; exp3[250]=8'h6c; exp3[251]=8'hb4; exp3[252]=8'hc7; exp3[253]=8'h52; exp3[254]=8'hf6; exp3[255]=8'h01;

    ln3[0]=8'h00; ln3[1]=8'h00; ln3[2]=8'h19; ln3[3]=8'h01; ln3[4]=8'h32; ln3[5]=8'h02; ln3[6]=8'h1a; ln3[7]=8'hc6; ln3[8]=8'h4b; ln3[9]=8'hc7; ln3[10]=8'h1b; ln3[11]=8'h68; ln3[12]=8'h33; ln3[13]=8'hee; ln3[14]=8'hdf; ln3[15]=8'h03;
    ln3[16]=8'h64; ln3[17]=8'h04; ln3[18]=8'he0; ln3[19]=8'h0e; ln3[20]=8'h34; ln3[21]=8'h8d; ln3[22]=8'h81; ln3[23]=8'hef; ln3[24]=8'h4c; ln3[25]=8'h71; ln3[26]=8'h08; ln3[27]=8'hc8; ln3[28]=8'hf8; ln3[29]=8'h69; ln3[30]=8'h1c; ln3[31]=8'hc1;
    ln3[32]=8'h7d; ln3[33]=8'hc2; ln3[34]=8'h1d; ln3[35]=8'hb5; ln3[36]=8'hf9; ln3[37]=8'hb9; ln3[38]=8'h27; ln3[39]=8'h6a; ln3[40]=8'h4d; ln3[41]=8'he4; ln3[42]=8'ha6; ln3[43]=8'h72; ln3[44]=8'h9a; ln3[45]=8'hc9; ln3[46]=8'h09; ln3[47]=8'h78;
    ln3[48]=8'h65; ln3[49]=8'h2f; ln3[50]=8'h8a; ln3[51]=8'h05; ln3[52]=8'h21; ln3[53]=8'h0f; ln3[54]=8'he1; ln3[55]=8'h24; ln3[56]=8'h12; ln3[57]=8'hf0; ln3[58]=8'h82; ln3[59]=8'h45; ln3[60]=8'h35; ln3[61]=8'h93; ln3[62]=8'hda; ln3[63]=8'h8e;
    ln3[64]=8'h96; ln3[65]=8'h8f; ln3[66]=8'hdb; ln3[67]=8'hbd; ln3[68]=8'h36; ln3[69]=8'hd0; ln3[70]=8'hce; ln3[71]=8'h94; ln3[72]=8'h13; ln3[73]=8'h5c; ln3[74]=8'hd2; ln3[75]=8'hf1; ln3[76]=8'h40; ln3[77]=8'h46; ln3[78]=8'h83; ln3[79]=8'h38;
    ln3[80]=8'h66; ln3[81]=8'hdd; ln3[82]=8'hfd; ln3[83]=8'h30; ln3[84]=8'hbf; ln3[85]=8'h06; ln3[86]=8'h8b; ln3[87]=8'h62; ln3[88]=8'hb3; ln3[89]=8'h25; ln3[90]=8'he2; ln3[91]=8'h98; ln3[92]=8'h22; ln3[93]=8'h88; ln3[94]=8'h91; ln3[95]=8'h10;
    ln3[96]=8'h7e; ln3[97]=8'h6e; ln3[98]=8'h48; ln3[99]=8'hc3; ln3[100]=8'ha3; ln3[101]=8'hb6; ln3[102]=8'h1e; ln3[103]=8'h42; ln3[104]=8'h3a; ln3[105]=8'h6b; ln3[106]=8'h28; ln3[107]=8'h54; ln3[108]=8'hfa; ln3[109]=8'h85; ln3[110]=8'h3d; ln3[111]=8'hba;
    ln3[112]=8'h2b; ln3[113]=8'h79; ln3[114]=8'h0a; ln3[115]=8'h15; ln3[116]=8'h9b; ln3[117]=8'h9f; ln3[118]=8'h5e; ln3[119]=8'hca; ln3[120]=8'h4e; ln3[121]=8'hd4; ln3[122]=8'hac; ln3[123]=8'he5; ln3[124]=8'hf3; ln3[125]=8'h73; ln3[126]=8'ha7; ln3[127]=8'h57;
    ln3[128]=8'haf; ln3[129]=8'h58; ln3[130]=8'ha8; ln3[131]=8'h50; ln3[132]=8'hf4; ln3[133]=8'hea; ln3[134]=8'hd6; ln3[135]=8'h74; ln3[136]=8'h4f; ln3[137]=8'hae; ln3[138]=8'he9; ln3[139]=8'hd5; ln3[140]=8'he7; ln3[141]=8'he6; ln3[142]=8'had; ln3[143]=8'he8;
    ln3[144]=8'h2c; ln3[145]=8'hd7; ln3[146]=8'h75; ln3[147]=8'h7a; ln3[148]=8'heb; ln3[149]=8'h16; ln3[150]=8'h0b; ln3[151]=8'hf5; ln3[152]=8'h59; ln3[153]=8'hcb; ln3[154]=8'h5f; ln3[155]=8'hb0; ln3[156]=8'h9c; ln3[157]=8'ha9; ln3[158]=8'h51; ln3[159]=8'ha0;
    ln3[160]=8'h7f; ln3[161]=8'h0c; ln3[162]=8'hf6; ln3[163]=8'h6f; ln3[164]=8'h17; ln3[165]=8'hc4; ln3[166]=8'h49; ln3[167]=8'hec; ln3[168]=8'hd8; ln3[169]=8'h43; ln3[170]=8'h1f; ln3[171]=8'h2d; ln3[172]=8'ha4; ln3[173]=8'h76; ln3[174]=8'h7b; ln3[175]=8'hb7;
    ln3[176]=8'hcc; ln3[177]=8'hbb; ln3[178]=8'h3e; ln3[179]=8'h5a; ln3[180]=8'hfb; ln3[181]=8'h60; ln3[182]=8'hb1; ln3[183]=8'h86; ln3[184]=8'h3b; ln3[185]=8'h52; ln3[186]=8'ha1; ln3[187]=8'h6c; ln3[188]=8'haa; ln3[189]=8'h55; ln3[190]=8'h29; ln3[191]=8'h9d;
    ln3[192]=8'h97; ln3[193]=8'hb2; ln3[194]=8'h87; ln3[195]=8'h90; ln3[196]=8'h61; ln3[197]=8'hbe; ln3[198]=8'hdc; ln3[199]=8'hfc; ln3[200]=8'hbc; ln3[201]=8'h95; ln3[202]=8'hcf; ln3[203]=8'hcd; ln3[204]=8'h37; ln3[205]=8'h3f; ln3[206]=8'h5b; ln3[207]=8'hd1;
    ln3[208]=8'h53; ln3[209]=8'h39; ln3[210]=8'h84; ln3[211]=8'h3c; ln3[212]=8'h41; ln3[213]=8'ha2; ln3[214]=8'h6d; ln3[215]=8'h47; ln3[216]=8'h14; ln3[217]=8'h2a; ln3[218]=8'h9e; ln3[219]=8'h5d; ln3[220]=8'h56; ln3[221]=8'hf2; ln3[222]=8'hd3; ln3[223]=8'hab;
    ln3[224]=8'h44; ln3[225]=8'h11; ln3[226]=8'h92; ln3[227]=8'hd9; ln3[228]=8'h23; ln3[229]=8'h20; ln3[230]=8'h2e; ln3[231]=8'h89; ln3[232]=8'hb4; ln3[233]=8'h7c; ln3[234]=8'hb8; ln3[235]=8'h26; ln3[236]=8'h77; ln3[237]=8'h99; ln3[238]=8'he3; ln3[239]=8'ha5;
    ln3[240]=8'h67; ln3[241]=8'h4a; ln3[242]=8'hed; ln3[243]=8'hde; ln3[244]=8'hc5; ln3[245]=8'h31; ln3[246]=8'hfe; ln3[247]=8'h18; ln3[248]=8'h0d; ln3[249]=8'h63; ln3[250]=8'h8c; ln3[251]=8'h80; ln3[252]=8'hc0; ln3[253]=8'hf7; ln3[254]=8'h70; ln3[255]=8'h07;

    rcon[0]=8'h00; rcon[1]=8'h01; rcon[2]=8'h02; rcon[3]=8'h04; rcon[4]=8'h08; rcon[5]=8'h10; rcon[6]=8'h20; rcon[7]=8'h40; rcon[8]=8'h80; rcon[9]=8'h1b; rcon[10]=8'h36; rcon[11]=8'h6c; rcon[12]=8'hd8; rcon[13]=8'hab; rcon[14]=8'h4d; rcon[15]=8'h9a;
  end

  assign SBox = sbox;
  assign IBox = ibox;
  assign EXP3 = exp3;
  assign LN3 = ln3;
  assign RCon = rcon;

endmodule
