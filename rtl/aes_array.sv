import aes_const::*;

module aes_array(
  output logic [7:0] S_Box [0:255],
  output logic [7:0] I_Box [0:255],
  output logic [7:0] EXP_3 [0:255],
  output logic [7:0] LN_3 [0:255],
  output logic [7:0] R_Con [0:15]
);
  timeunit 1ns;
  timeprecision 1ps;

  logic [7 : 0] SBox [0:255];
  logic [7 : 0] IBox [0:255];
  logic [7 : 0] EXP3 [0:255];
  logic [7 : 0] LN3 [0:255];
  logic [7 : 0] RCon [0:15];

  initial begin
    SBox[0]=8'h63; SBox[1]=8'h7c; SBox[2]=8'h77; SBox[3]=8'h7b; SBox[4]=8'hf2; SBox[5]=8'h6b; SBox[6]=8'h6f; SBox[7]=8'hc5; SBox[8]=8'h30; SBox[9]=8'h01; SBox[10]=8'h67; SBox[11]=8'h2b; SBox[12]=8'hfe; SBox[13]=8'hd7; SBox[14]=8'hab; SBox[15]=8'h76;
    SBox[16]=8'hca; SBox[17]=8'h82; SBox[18]=8'hc9; SBox[19]=8'h7d; SBox[20]=8'hfa; SBox[21]=8'h59; SBox[22]=8'h47; SBox[23]=8'hf0; SBox[24]=8'had; SBox[25]=8'hd4; SBox[26]=8'ha2; SBox[27]=8'haf; SBox[28]=8'h9c; SBox[29]=8'ha4; SBox[30]=8'h72; SBox[31]=8'hc0;
    SBox[32]=8'hb7; SBox[33]=8'hfd; SBox[34]=8'h93; SBox[35]=8'h26; SBox[36]=8'h36; SBox[37]=8'h3f; SBox[38]=8'hf7; SBox[39]=8'hcc; SBox[40]=8'h34; SBox[41]=8'ha5; SBox[42]=8'he5; SBox[43]=8'hf1; SBox[44]=8'h71; SBox[45]=8'hd8; SBox[46]=8'h31; SBox[47]=8'h15;
    SBox[48]=8'h04; SBox[49]=8'hc7; SBox[50]=8'h23; SBox[51]=8'hc3; SBox[52]=8'h18; SBox[53]=8'h96; SBox[54]=8'h05; SBox[55]=8'h9a; SBox[56]=8'h07; SBox[57]=8'h12; SBox[58]=8'h80; SBox[59]=8'he2; SBox[60]=8'heb; SBox[61]=8'h27; SBox[62]=8'hb2; SBox[63]=8'h75;
    SBox[64]=8'h09; SBox[65]=8'h83; SBox[66]=8'h2c; SBox[67]=8'h1a; SBox[68]=8'h1b; SBox[69]=8'h6e; SBox[70]=8'h5a; SBox[71]=8'ha0; SBox[72]=8'h52; SBox[73]=8'h3b; SBox[74]=8'hd6; SBox[75]=8'hb3; SBox[76]=8'h29; SBox[77]=8'he3; SBox[78]=8'h2f; SBox[79]=8'h84;
    SBox[80]=8'h53; SBox[81]=8'hd1; SBox[82]=8'h00; SBox[83]=8'hed; SBox[84]=8'h20; SBox[85]=8'hfc; SBox[86]=8'hb1; SBox[87]=8'h5b; SBox[88]=8'h6a; SBox[89]=8'hcb; SBox[90]=8'hbe; SBox[91]=8'h39; SBox[92]=8'h4a; SBox[93]=8'h4c; SBox[94]=8'h58; SBox[95]=8'hcf;
    SBox[96]=8'hd0; SBox[97]=8'hef; SBox[98]=8'haa; SBox[99]=8'hfb; SBox[100]=8'h43; SBox[101]=8'h4d; SBox[102]=8'h33; SBox[103]=8'h85; SBox[104]=8'h45; SBox[105]=8'hf9; SBox[106]=8'h02; SBox[107]=8'h7f; SBox[108]=8'h50; SBox[109]=8'h3c; SBox[110]=8'h9f; SBox[111]=8'ha8;
    SBox[112]=8'h51; SBox[113]=8'ha3; SBox[114]=8'h40; SBox[115]=8'h8f; SBox[116]=8'h92; SBox[117]=8'h9d; SBox[118]=8'h38; SBox[119]=8'hf5; SBox[120]=8'hbc; SBox[121]=8'hb6; SBox[122]=8'hda; SBox[123]=8'h21; SBox[124]=8'h10; SBox[125]=8'hff; SBox[126]=8'hf3; SBox[127]=8'hd2;
    SBox[128]=8'hcd; SBox[129]=8'h0c; SBox[130]=8'h13; SBox[131]=8'hec; SBox[132]=8'h5f; SBox[133]=8'h97; SBox[134]=8'h44; SBox[135]=8'h17; SBox[136]=8'hc4; SBox[137]=8'ha7; SBox[138]=8'h7e; SBox[139]=8'h3d; SBox[140]=8'h64; SBox[141]=8'h5d; SBox[142]=8'h19; SBox[143]=8'h73;
    SBox[144]=8'h60; SBox[145]=8'h81; SBox[146]=8'h4f; SBox[147]=8'hdc; SBox[148]=8'h22; SBox[149]=8'h2a; SBox[150]=8'h90; SBox[151]=8'h88; SBox[152]=8'h46; SBox[153]=8'hee; SBox[154]=8'hb8; SBox[155]=8'h14; SBox[156]=8'hde; SBox[157]=8'h5e; SBox[158]=8'h0b; SBox[159]=8'hdb;
    SBox[160]=8'he0; SBox[161]=8'h32; SBox[162]=8'h3a; SBox[163]=8'h0a; SBox[164]=8'h49; SBox[165]=8'h06; SBox[166]=8'h24; SBox[167]=8'h5c; SBox[168]=8'hc2; SBox[169]=8'hd3; SBox[170]=8'hac; SBox[171]=8'h62; SBox[172]=8'h91; SBox[173]=8'h95; SBox[174]=8'he4; SBox[175]=8'h79;
    SBox[176]=8'he7; SBox[177]=8'hc8; SBox[178]=8'h37; SBox[179]=8'h6d; SBox[180]=8'h8d; SBox[181]=8'hd5; SBox[182]=8'h4e; SBox[183]=8'ha9; SBox[184]=8'h6c; SBox[185]=8'h56; SBox[186]=8'hf4; SBox[187]=8'hea; SBox[188]=8'h65; SBox[189]=8'h7a; SBox[190]=8'hae; SBox[191]=8'h08;
    SBox[192]=8'hba; SBox[193]=8'h78; SBox[194]=8'h25; SBox[195]=8'h2e; SBox[196]=8'h1c; SBox[197]=8'ha6; SBox[198]=8'hb4; SBox[199]=8'hc6; SBox[200]=8'he8; SBox[201]=8'hdd; SBox[202]=8'h74; SBox[203]=8'h1f; SBox[204]=8'h4b; SBox[205]=8'hbd; SBox[206]=8'h8b; SBox[207]=8'h8a;
    SBox[208]=8'h70; SBox[209]=8'h3e; SBox[210]=8'hb5; SBox[211]=8'h66; SBox[212]=8'h48; SBox[213]=8'h03; SBox[214]=8'hf6; SBox[215]=8'h0e; SBox[216]=8'h61; SBox[217]=8'h35; SBox[218]=8'h57; SBox[219]=8'hb9; SBox[220]=8'h86; SBox[221]=8'hc1; SBox[222]=8'h1d; SBox[223]=8'h9e;
    SBox[224]=8'he1; SBox[225]=8'hf8; SBox[226]=8'h98; SBox[227]=8'h11; SBox[228]=8'h69; SBox[229]=8'hd9; SBox[230]=8'h8e; SBox[231]=8'h94; SBox[232]=8'h9b; SBox[233]=8'h1e; SBox[234]=8'h87; SBox[235]=8'he9; SBox[236]=8'hce; SBox[237]=8'h55; SBox[238]=8'h28; SBox[239]=8'hdf;
    SBox[240]=8'h8c; SBox[241]=8'ha1; SBox[242]=8'h89; SBox[243]=8'h0d; SBox[244]=8'hbf; SBox[245]=8'he6; SBox[246]=8'h42; SBox[247]=8'h68; SBox[248]=8'h41; SBox[249]=8'h99; SBox[250]=8'h2d; SBox[251]=8'h0f; SBox[252]=8'hb0; SBox[253]=8'h54; SBox[254]=8'hbb; SBox[255]=8'h16;

    IBox[0]=8'h52; IBox[1]=8'h09; IBox[2]=8'h6a; IBox[3]=8'hd5; IBox[4]=8'h30; IBox[5]=8'h36; IBox[6]=8'ha5; IBox[7]=8'h38; IBox[8]=8'hbf; IBox[9]=8'h40; IBox[10]=8'ha3; IBox[11]=8'h9e; IBox[12]=8'h81; IBox[13]=8'hf3; IBox[14]=8'hd7; IBox[15]=8'hfb;
    IBox[16]=8'h7c; IBox[17]=8'he3; IBox[18]=8'h39; IBox[19]=8'h82; IBox[20]=8'h9b; IBox[21]=8'h2f; IBox[22]=8'hff; IBox[23]=8'h87; IBox[24]=8'h34; IBox[25]=8'h8e; IBox[26]=8'h43; IBox[27]=8'h44; IBox[28]=8'hc4; IBox[29]=8'hde; IBox[30]=8'he9; IBox[31]=8'hcb;
    IBox[32]=8'h54; IBox[33]=8'h7b; IBox[34]=8'h94; IBox[35]=8'h32; IBox[36]=8'ha6; IBox[37]=8'hc2; IBox[38]=8'h23; IBox[39]=8'h3d; IBox[40]=8'hee; IBox[41]=8'h4c; IBox[42]=8'h95; IBox[43]=8'h0b; IBox[44]=8'h42; IBox[45]=8'hfa; IBox[46]=8'hc3; IBox[47]=8'h4e;
    IBox[48]=8'h08; IBox[49]=8'h2e; IBox[50]=8'ha1; IBox[51]=8'h66; IBox[52]=8'h28; IBox[53]=8'hd9; IBox[54]=8'h24; IBox[55]=8'hb2; IBox[56]=8'h76; IBox[57]=8'h5b; IBox[58]=8'ha2; IBox[59]=8'h49; IBox[60]=8'h6d; IBox[61]=8'h8b; IBox[62]=8'hd1; IBox[63]=8'h25;
    IBox[64]=8'h72; IBox[65]=8'hf8; IBox[66]=8'hf6; IBox[67]=8'h64; IBox[68]=8'h86; IBox[69]=8'h68; IBox[70]=8'h98; IBox[71]=8'h16; IBox[72]=8'hd4; IBox[73]=8'ha4; IBox[74]=8'h5c; IBox[75]=8'hcc; IBox[76]=8'h5d; IBox[77]=8'h65; IBox[78]=8'hb6; IBox[79]=8'h92;
    IBox[80]=8'h6c; IBox[81]=8'h70; IBox[82]=8'h48; IBox[83]=8'h50; IBox[84]=8'hfd; IBox[85]=8'hed; IBox[86]=8'hb9; IBox[87]=8'hda; IBox[88]=8'h5e; IBox[89]=8'h15; IBox[90]=8'h46; IBox[91]=8'h57; IBox[92]=8'ha7; IBox[93]=8'h8d; IBox[94]=8'h9d; IBox[95]=8'h84;
    IBox[96]=8'h90; IBox[97]=8'hd8; IBox[98]=8'hab; IBox[99]=8'h00; IBox[100]=8'h8c; IBox[101]=8'hbc; IBox[102]=8'hd3; IBox[103]=8'h0a; IBox[104]=8'hf7; IBox[105]=8'he4; IBox[106]=8'h58; IBox[107]=8'h05; IBox[108]=8'hb8; IBox[109]=8'hb3; IBox[110]=8'h45; IBox[111]=8'h06;
    IBox[112]=8'hd0; IBox[113]=8'h2c; IBox[114]=8'h1e; IBox[115]=8'h8f; IBox[116]=8'hca; IBox[117]=8'h3f; IBox[118]=8'h0f; IBox[119]=8'h02; IBox[120]=8'hc1; IBox[121]=8'haf; IBox[122]=8'hbd; IBox[123]=8'h03; IBox[124]=8'h01; IBox[125]=8'h13; IBox[126]=8'h8a; IBox[127]=8'h6b;
    IBox[128]=8'h3a; IBox[129]=8'h91; IBox[130]=8'h11; IBox[131]=8'h41; IBox[132]=8'h4f; IBox[133]=8'h67; IBox[134]=8'hdc; IBox[135]=8'hea; IBox[136]=8'h97; IBox[137]=8'hf2; IBox[138]=8'hcf; IBox[139]=8'hce; IBox[140]=8'hf0; IBox[141]=8'hb4; IBox[142]=8'he6; IBox[143]=8'h73;
    IBox[144]=8'h96; IBox[145]=8'hac; IBox[146]=8'h74; IBox[147]=8'h22; IBox[148]=8'he7; IBox[149]=8'had; IBox[150]=8'h35; IBox[151]=8'h85; IBox[152]=8'he2; IBox[153]=8'hf9; IBox[154]=8'h37; IBox[155]=8'he8; IBox[156]=8'h1c; IBox[157]=8'h75; IBox[158]=8'hdf; IBox[159]=8'h6e;
    IBox[160]=8'h47; IBox[161]=8'hf1; IBox[162]=8'h1a; IBox[163]=8'h71; IBox[164]=8'h1d; IBox[165]=8'h29; IBox[166]=8'hc5; IBox[167]=8'h89; IBox[168]=8'h6f; IBox[169]=8'hb7; IBox[170]=8'h62; IBox[171]=8'h0e; IBox[172]=8'haa; IBox[173]=8'h18; IBox[174]=8'hbe; IBox[175]=8'h1b;
    IBox[176]=8'hfc; IBox[177]=8'h56; IBox[178]=8'h3e; IBox[179]=8'h4b; IBox[180]=8'hc6; IBox[181]=8'hd2; IBox[182]=8'h79; IBox[183]=8'h20; IBox[184]=8'h9a; IBox[185]=8'hdb; IBox[186]=8'hc0; IBox[187]=8'hfe; IBox[188]=8'h78; IBox[189]=8'hcd; IBox[190]=8'h5a; IBox[191]=8'hf4;
    IBox[192]=8'h1f; IBox[193]=8'hdd; IBox[194]=8'ha8; IBox[195]=8'h33; IBox[196]=8'h88; IBox[197]=8'h07; IBox[198]=8'hc7; IBox[199]=8'h31; IBox[200]=8'hb1; IBox[201]=8'h12; IBox[202]=8'h10; IBox[203]=8'h59; IBox[204]=8'h27; IBox[205]=8'h80; IBox[206]=8'hec; IBox[207]=8'h5f;
    IBox[208]=8'h60; IBox[209]=8'h51; IBox[210]=8'h7f; IBox[211]=8'ha9; IBox[212]=8'h19; IBox[213]=8'hb5; IBox[214]=8'h4a; IBox[215]=8'h0d; IBox[216]=8'h2d; IBox[217]=8'he5; IBox[218]=8'h7a; IBox[219]=8'h9f; IBox[220]=8'h93; IBox[221]=8'hc9; IBox[222]=8'h9c; IBox[223]=8'hef;
    IBox[224]=8'ha0; IBox[225]=8'he0; IBox[226]=8'h3b; IBox[227]=8'h4d; IBox[228]=8'hae; IBox[229]=8'h2a; IBox[230]=8'hf5; IBox[231]=8'hb0; IBox[232]=8'hc8; IBox[233]=8'heb; IBox[234]=8'hbb; IBox[235]=8'h3c; IBox[236]=8'h83; IBox[237]=8'h53; IBox[238]=8'h99; IBox[239]=8'h61;
    IBox[240]=8'h17; IBox[241]=8'h2b; IBox[242]=8'h04; IBox[243]=8'h7e; IBox[244]=8'hba; IBox[245]=8'h77; IBox[246]=8'hd6; IBox[247]=8'h26; IBox[248]=8'he1; IBox[249]=8'h69; IBox[250]=8'h14; IBox[251]=8'h63; IBox[252]=8'h55; IBox[253]=8'h21; IBox[254]=8'h0c; IBox[255]=8'h7d;

    EXP3[0]=8'h01; EXP3[1]=8'h03; EXP3[2]=8'h05; EXP3[3]=8'h0f; EXP3[4]=8'h11; EXP3[5]=8'h33; EXP3[6]=8'h55; EXP3[7]=8'hff; EXP3[8]=8'h1a; EXP3[9]=8'h2e; EXP3[10]=8'h72; EXP3[11]=8'h96; EXP3[12]=8'ha1; EXP3[13]=8'hf8; EXP3[14]=8'h13; EXP3[15]=8'h35;
    EXP3[16]=8'h5f; EXP3[17]=8'he1; EXP3[18]=8'h38; EXP3[19]=8'h48; EXP3[20]=8'hd8; EXP3[21]=8'h73; EXP3[22]=8'h95; EXP3[23]=8'ha4; EXP3[24]=8'hf7; EXP3[25]=8'h02; EXP3[26]=8'h06; EXP3[27]=8'h0a; EXP3[28]=8'h1e; EXP3[29]=8'h22; EXP3[30]=8'h66; EXP3[31]=8'haa;
    EXP3[32]=8'he5; EXP3[33]=8'h34; EXP3[34]=8'h5c; EXP3[35]=8'he4; EXP3[36]=8'h37; EXP3[37]=8'h59; EXP3[38]=8'heb; EXP3[39]=8'h26; EXP3[40]=8'h6a; EXP3[41]=8'hbe; EXP3[42]=8'hd9; EXP3[43]=8'h70; EXP3[44]=8'h90; EXP3[45]=8'hab; EXP3[46]=8'he6; EXP3[47]=8'h31;
    EXP3[48]=8'h53; EXP3[49]=8'hf5; EXP3[50]=8'h04; EXP3[51]=8'h0c; EXP3[52]=8'h14; EXP3[53]=8'h3c; EXP3[54]=8'h44; EXP3[55]=8'hcc; EXP3[56]=8'h4f; EXP3[57]=8'hd1; EXP3[58]=8'h68; EXP3[59]=8'hb8; EXP3[60]=8'hd3; EXP3[61]=8'h6e; EXP3[62]=8'hb2; EXP3[63]=8'hcd;
    EXP3[64]=8'h4c; EXP3[65]=8'hd4; EXP3[66]=8'h67; EXP3[67]=8'ha9; EXP3[68]=8'he0; EXP3[69]=8'h3b; EXP3[70]=8'h4d; EXP3[71]=8'hd7; EXP3[72]=8'h62; EXP3[73]=8'ha6; EXP3[74]=8'hf1; EXP3[75]=8'h08; EXP3[76]=8'h18; EXP3[77]=8'h28; EXP3[78]=8'h78; EXP3[79]=8'h88;
    EXP3[80]=8'h83; EXP3[81]=8'h9e; EXP3[82]=8'hb9; EXP3[83]=8'hd0; EXP3[84]=8'h6b; EXP3[85]=8'hbd; EXP3[86]=8'hdc; EXP3[87]=8'h7f; EXP3[88]=8'h81; EXP3[89]=8'h98; EXP3[90]=8'hb3; EXP3[91]=8'hce; EXP3[92]=8'h49; EXP3[93]=8'hdb; EXP3[94]=8'h76; EXP3[95]=8'h9a;
    EXP3[96]=8'hb5; EXP3[97]=8'hc4; EXP3[98]=8'h57; EXP3[99]=8'hf9; EXP3[100]=8'h10; EXP3[101]=8'h30; EXP3[102]=8'h50; EXP3[103]=8'hf0; EXP3[104]=8'h0b; EXP3[105]=8'h1d; EXP3[106]=8'h27; EXP3[107]=8'h69; EXP3[108]=8'hbb; EXP3[109]=8'hd6; EXP3[110]=8'h61; EXP3[111]=8'ha3;
    EXP3[112]=8'hfe; EXP3[113]=8'h19; EXP3[114]=8'h2b; EXP3[115]=8'h7d; EXP3[116]=8'h87; EXP3[117]=8'h92; EXP3[118]=8'had; EXP3[119]=8'hec; EXP3[120]=8'h2f; EXP3[121]=8'h71; EXP3[122]=8'h93; EXP3[123]=8'hae; EXP3[124]=8'he9; EXP3[125]=8'h20; EXP3[126]=8'h60; EXP3[127]=8'ha0;
    EXP3[128]=8'hfb; EXP3[129]=8'h16; EXP3[130]=8'h3a; EXP3[131]=8'h4e; EXP3[132]=8'hd2; EXP3[133]=8'h6d; EXP3[134]=8'hb7; EXP3[135]=8'hc2; EXP3[136]=8'h5d; EXP3[137]=8'he7; EXP3[138]=8'h32; EXP3[139]=8'h56; EXP3[140]=8'hfa; EXP3[141]=8'h15; EXP3[142]=8'h3f; EXP3[143]=8'h41;
    EXP3[144]=8'hc3; EXP3[145]=8'h5e; EXP3[146]=8'he2; EXP3[147]=8'h3d; EXP3[148]=8'h47; EXP3[149]=8'hc9; EXP3[150]=8'h40; EXP3[151]=8'hc0; EXP3[152]=8'h5b; EXP3[153]=8'hed; EXP3[154]=8'h2c; EXP3[155]=8'h74; EXP3[156]=8'h9c; EXP3[157]=8'hbf; EXP3[158]=8'hda; EXP3[159]=8'h75;
    EXP3[160]=8'h9f; EXP3[161]=8'hba; EXP3[162]=8'hd5; EXP3[163]=8'h64; EXP3[164]=8'hac; EXP3[165]=8'hef; EXP3[166]=8'h2a; EXP3[167]=8'h7e; EXP3[168]=8'h82; EXP3[169]=8'h9d; EXP3[170]=8'hbc; EXP3[171]=8'hdf; EXP3[172]=8'h7a; EXP3[173]=8'h8e; EXP3[174]=8'h89; EXP3[175]=8'h80;
    EXP3[176]=8'h9b; EXP3[177]=8'hb6; EXP3[178]=8'hc1; EXP3[179]=8'h58; EXP3[180]=8'he8; EXP3[181]=8'h23; EXP3[182]=8'h65; EXP3[183]=8'haf; EXP3[184]=8'hea; EXP3[185]=8'h25; EXP3[186]=8'h6f; EXP3[187]=8'hb1; EXP3[188]=8'hc8; EXP3[189]=8'h43; EXP3[190]=8'hc5; EXP3[191]=8'h54;
    EXP3[192]=8'hfc; EXP3[193]=8'h1f; EXP3[194]=8'h21; EXP3[195]=8'h63; EXP3[196]=8'ha5; EXP3[197]=8'hf4; EXP3[198]=8'h07; EXP3[199]=8'h09; EXP3[200]=8'h1b; EXP3[201]=8'h2d; EXP3[202]=8'h77; EXP3[203]=8'h99; EXP3[204]=8'hb0; EXP3[205]=8'hcb; EXP3[206]=8'h46; EXP3[207]=8'hca;
    EXP3[208]=8'h45; EXP3[209]=8'hcf; EXP3[210]=8'h4a; EXP3[211]=8'hde; EXP3[212]=8'h79; EXP3[213]=8'h8b; EXP3[214]=8'h86; EXP3[215]=8'h91; EXP3[216]=8'ha8; EXP3[217]=8'he3; EXP3[218]=8'h3e; EXP3[219]=8'h42; EXP3[220]=8'hc6; EXP3[221]=8'h51; EXP3[222]=8'hf3; EXP3[223]=8'h0e;
    EXP3[224]=8'h12; EXP3[225]=8'h36; EXP3[226]=8'h5a; EXP3[227]=8'hee; EXP3[228]=8'h29; EXP3[229]=8'h7b; EXP3[230]=8'h8d; EXP3[231]=8'h8c; EXP3[232]=8'h8f; EXP3[233]=8'h8a; EXP3[234]=8'h85; EXP3[235]=8'h94; EXP3[236]=8'ha7; EXP3[237]=8'hf2; EXP3[238]=8'h0d; EXP3[239]=8'h17;
    EXP3[240]=8'h39; EXP3[241]=8'h4b; EXP3[242]=8'hdd; EXP3[243]=8'h7c; EXP3[244]=8'h84; EXP3[245]=8'h97; EXP3[246]=8'ha2; EXP3[247]=8'hfd; EXP3[248]=8'h1c; EXP3[249]=8'h24; EXP3[250]=8'h6c; EXP3[251]=8'hb4; EXP3[252]=8'hc7; EXP3[253]=8'h52; EXP3[254]=8'hf6; EXP3[255]=8'h01;

    LN3[0]=8'h00; LN3[1]=8'h00; LN3[2]=8'h19; LN3[3]=8'h01; LN3[4]=8'h32; LN3[5]=8'h02; LN3[6]=8'h1a; LN3[7]=8'hc6; LN3[8]=8'h4b; LN3[9]=8'hc7; LN3[10]=8'h1b; LN3[11]=8'h68; LN3[12]=8'h33; LN3[13]=8'hee; LN3[14]=8'hdf; LN3[15]=8'h03;
    LN3[16]=8'h64; LN3[17]=8'h04; LN3[18]=8'he0; LN3[19]=8'h0e; LN3[20]=8'h34; LN3[21]=8'h8d; LN3[22]=8'h81; LN3[23]=8'hef; LN3[24]=8'h4c; LN3[25]=8'h71; LN3[26]=8'h08; LN3[27]=8'hc8; LN3[28]=8'hf8; LN3[29]=8'h69; LN3[30]=8'h1c; LN3[31]=8'hc1;
    LN3[32]=8'h7d; LN3[33]=8'hc2; LN3[34]=8'h1d; LN3[35]=8'hb5; LN3[36]=8'hf9; LN3[37]=8'hb9; LN3[38]=8'h27; LN3[39]=8'h6a; LN3[40]=8'h4d; LN3[41]=8'he4; LN3[42]=8'ha6; LN3[43]=8'h72; LN3[44]=8'h9a; LN3[45]=8'hc9; LN3[46]=8'h09; LN3[47]=8'h78;
    LN3[48]=8'h65; LN3[49]=8'h2f; LN3[50]=8'h8a; LN3[51]=8'h05; LN3[52]=8'h21; LN3[53]=8'h0f; LN3[54]=8'he1; LN3[55]=8'h24; LN3[56]=8'h12; LN3[57]=8'hf0; LN3[58]=8'h82; LN3[59]=8'h45; LN3[60]=8'h35; LN3[61]=8'h93; LN3[62]=8'hda; LN3[63]=8'h8e;
    LN3[64]=8'h96; LN3[65]=8'h8f; LN3[66]=8'hdb; LN3[67]=8'hbd; LN3[68]=8'h36; LN3[69]=8'hd0; LN3[70]=8'hce; LN3[71]=8'h94; LN3[72]=8'h13; LN3[73]=8'h5c; LN3[74]=8'hd2; LN3[75]=8'hf1; LN3[76]=8'h40; LN3[77]=8'h46; LN3[78]=8'h83; LN3[79]=8'h38;
    LN3[80]=8'h66; LN3[81]=8'hdd; LN3[82]=8'hfd; LN3[83]=8'h30; LN3[84]=8'hbf; LN3[85]=8'h06; LN3[86]=8'h8b; LN3[87]=8'h62; LN3[88]=8'hb3; LN3[89]=8'h25; LN3[90]=8'he2; LN3[91]=8'h98; LN3[92]=8'h22; LN3[93]=8'h88; LN3[94]=8'h91; LN3[95]=8'h10;
    LN3[96]=8'h7e; LN3[97]=8'h6e; LN3[98]=8'h48; LN3[99]=8'hc3; LN3[100]=8'ha3; LN3[101]=8'hb6; LN3[102]=8'h1e; LN3[103]=8'h42; LN3[104]=8'h3a; LN3[105]=8'h6b; LN3[106]=8'h28; LN3[107]=8'h54; LN3[108]=8'hfa; LN3[109]=8'h85; LN3[110]=8'h3d; LN3[111]=8'hba;
    LN3[112]=8'h2b; LN3[113]=8'h79; LN3[114]=8'h0a; LN3[115]=8'h15; LN3[116]=8'h9b; LN3[117]=8'h9f; LN3[118]=8'h5e; LN3[119]=8'hca; LN3[120]=8'h4e; LN3[121]=8'hd4; LN3[122]=8'hac; LN3[123]=8'he5; LN3[124]=8'hf3; LN3[125]=8'h73; LN3[126]=8'ha7; LN3[127]=8'h57;
    LN3[128]=8'haf; LN3[129]=8'h58; LN3[130]=8'ha8; LN3[131]=8'h50; LN3[132]=8'hf4; LN3[133]=8'hea; LN3[134]=8'hd6; LN3[135]=8'h74; LN3[136]=8'h4f; LN3[137]=8'hae; LN3[138]=8'he9; LN3[139]=8'hd5; LN3[140]=8'he7; LN3[141]=8'he6; LN3[142]=8'had; LN3[143]=8'he8;
    LN3[144]=8'h2c; LN3[145]=8'hd7; LN3[146]=8'h75; LN3[147]=8'h7a; LN3[148]=8'heb; LN3[149]=8'h16; LN3[150]=8'h0b; LN3[151]=8'hf5; LN3[152]=8'h59; LN3[153]=8'hcb; LN3[154]=8'h5f; LN3[155]=8'hb0; LN3[156]=8'h9c; LN3[157]=8'ha9; LN3[158]=8'h51; LN3[159]=8'ha0;
    LN3[160]=8'h7f; LN3[161]=8'h0c; LN3[162]=8'hf6; LN3[163]=8'h6f; LN3[164]=8'h17; LN3[165]=8'hc4; LN3[166]=8'h49; LN3[167]=8'hec; LN3[168]=8'hd8; LN3[169]=8'h43; LN3[170]=8'h1f; LN3[171]=8'h2d; LN3[172]=8'ha4; LN3[173]=8'h76; LN3[174]=8'h7b; LN3[175]=8'hb7;
    LN3[176]=8'hcc; LN3[177]=8'hbb; LN3[178]=8'h3e; LN3[179]=8'h5a; LN3[180]=8'hfb; LN3[181]=8'h60; LN3[182]=8'hb1; LN3[183]=8'h86; LN3[184]=8'h3b; LN3[185]=8'h52; LN3[186]=8'ha1; LN3[187]=8'h6c; LN3[188]=8'haa; LN3[189]=8'h55; LN3[190]=8'h29; LN3[191]=8'h9d;
    LN3[192]=8'h97; LN3[193]=8'hb2; LN3[194]=8'h87; LN3[195]=8'h90; LN3[196]=8'h61; LN3[197]=8'hbe; LN3[198]=8'hdc; LN3[199]=8'hfc; LN3[200]=8'hbc; LN3[201]=8'h95; LN3[202]=8'hcf; LN3[203]=8'hcd; LN3[204]=8'h37; LN3[205]=8'h3f; LN3[206]=8'h5b; LN3[207]=8'hd1;
    LN3[208]=8'h53; LN3[209]=8'h39; LN3[210]=8'h84; LN3[211]=8'h3c; LN3[212]=8'h41; LN3[213]=8'ha2; LN3[214]=8'h6d; LN3[215]=8'h47; LN3[216]=8'h14; LN3[217]=8'h2a; LN3[218]=8'h9e; LN3[219]=8'h5d; LN3[220]=8'h56; LN3[221]=8'hf2; LN3[222]=8'hd3; LN3[223]=8'hab;
    LN3[224]=8'h44; LN3[225]=8'h11; LN3[226]=8'h92; LN3[227]=8'hd9; LN3[228]=8'h23; LN3[229]=8'h20; LN3[230]=8'h2e; LN3[231]=8'h89; LN3[232]=8'hb4; LN3[233]=8'h7c; LN3[234]=8'hb8; LN3[235]=8'h26; LN3[236]=8'h77; LN3[237]=8'h99; LN3[238]=8'he3; LN3[239]=8'ha5;
    LN3[240]=8'h67; LN3[241]=8'h4a; LN3[242]=8'hed; LN3[243]=8'hde; LN3[244]=8'hc5; LN3[245]=8'h31; LN3[246]=8'hfe; LN3[247]=8'h18; LN3[248]=8'h0d; LN3[249]=8'h63; LN3[250]=8'h8c; LN3[251]=8'h80; LN3[252]=8'hc0; LN3[253]=8'hf7; LN3[254]=8'h70; LN3[255]=8'h07;

    RCon[0]=8'h00; RCon[1]=8'h01; RCon[2]=8'h02; RCon[3]=8'h04; RCon[4]=8'h08; RCon[5]=8'h10; RCon[6]=8'h20; RCon[7]=8'h40; RCon[8]=8'h80; RCon[9]=8'h1b; RCon[10]=8'h36; RCon[11]=8'h6c; RCon[12]=8'hd8; RCon[13]=8'hab; RCon[14]=8'h4d; RCon[15]=8'h9a;
  end

  assign S_Box = SBox;
  assign I_Box = IBox;
  assign EXP_3 = EXP3;
  assign LN_3 = LN3;
  assign R_Con = RCon;

endmodule
