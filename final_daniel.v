module top(CLK_50, KEY);

    input CLK_50;
    input KEY[0:1]

    // the 20 rows
    reg [9:0] r1;
    reg [9:0] r2;
    reg [9:0] r3;
    reg [9:0] r4;
    reg [9:0] r5;
    reg [9:0] r6;
    reg [9:0] r7;
    reg [9:0] r8;
    reg [9:0] r9;
    reg [9:0] r10;
    reg [9:0] r11;
    reg [9:0] r12;
    reg [9:0] r13;
    reg [9:0] r14;
    reg [9:0] r15;
    reg [9:0] r16;
    reg [9:0] r17;
    reg [9:0] r18;
    reg [9:0] r19;
    reg [9:0] r20;

    reg player_x = 5'd5;
    reg end_game = 1'b0;

    drop d(
        .r1(r1),
        .r2(r2),
        .r3(r3),
        .r4(r4),
        .r5(r5),
        .r6(r6),
        .r7(r7),
        .r8(r8),
        .r9(r9),
        .r10(r10),
        .r11(r11),
        .r12(r12),
        .r13(r13),
        .r14(r14),
        .r15(r15),
        .r16(r16),
        .r17(r17),
        .r18(r18),
        .r19(r19),
        .r20(r20),
        .player_x(player_x)
        .end_game(end_game)
    );

endmodule

module drop(
    r1, r2, r3, r4, r5,
    r6, r7, r8, r9, r10,
    r11, r12, r13, r14, r15,
    r16, r17, r18, r19, r20,
    player_x,
    end_game
);

    input player_x;
    input r1, r2, r3, r4, r5,
    r6, r7, r8, r9, r10,
    r11, r12, r13, r14, r15,
    r16, r17, r18, r19, r20,
    player_x,
    output end_game;

    end_game = 1'b0;

    for(i=0;i<10;i=i+1)
    begin
      
      if(r1[i] == 1)
      begin
        r2[i] = 1;
        r1[i] = 0;
      end

      if(r2[i] == 1)
      begin
        r3[i] = 1;
        r2[i] = 0;
      end

      if(r3[i] == 1)
      begin
        r4[i] = 1;
        r3[i] = 0;
      end

      if(r4[i] == 1)
      begin
        r5[i] = 1;
        r4[i] = 0;
      end

      if(r5[i] == 1)
      begin
        r6[i] = 1;
        r5[i] = 0;
      end

      if(r6[i] == 1)
      begin
        r7[i] = 1;
        r6[i] = 0;
      end

      if(r7[i] == 1)
      begin
        r8[i] = 1;
        r7[i] = 0;
      end

      if(r8[i] == 1)
      begin
        r9[i] = 1;
        r8[i] = 0;
      end

      if(r9[i] == 1)
      begin
        r10[i] = 1;
        r9[i] = 0;
      end

      if(r10[i] == 1)
      begin
        r11[i] = 1;
        r10[i] = 0;
      end

      if(r11[i] == 1)
      begin
        r12[i] = 1;
        r11[i] = 0;
      end

      if(r12[i] == 1)
      begin
        r13[i] = 1;
        r12[i] = 0;
      end

      if(r13[i] == 1)
      begin
        r14[i] = 1;
        r13[i] = 0;
      end

      if(r14[i] == 1)
      begin
        r15[i] = 1;
        r14[i] = 0;
      end

      if(r15[i] == 1)
      begin
        r16[i] = 1;
        r15[i] = 0;
      end

      if(r16[i] == 1)
      begin
        r17[i] = 1;
        r16[i] = 0;
      end

      if(r17[i] == 1)
      begin
        r18[i] = 1;
        r17[i] = 0;
      end

      if(r18[i] == 1)
      begin
        r19[i] = 1;
        r18[i] = 0;
      end

      if(r19[i] == 1)
      begin
        r20[i] = 1;
        r20[i] = 0;
        if(i == player_x)
            end_game = 1'b1;
      end

    end
endmodule