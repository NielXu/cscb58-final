module dodge(CLK_50, KEY, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);
	 input CLK_50;
    input [1:0]KEY;
	 
	 output			VGA_CLK;   				//	VGA Clock
	 output			VGA_HS;					//	VGA H_SYNC
	 output			VGA_VS;					//	VGA V_SYNC
	 output			VGA_BLANK_N;				//	VGA BLANK
	 output			VGA_SYNC_N;				//	VGA SYNC
	 output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	 output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	 output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

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
	 reg finished_initialize = 1'b0;
	 
	 wire colour;
	 wire [7:0] x;
	 wire [6:0] y;
	 wire writeEn;
	 
	 // initial wires
	 wire initializeColor;
	 wire [7:0] ix;
	 wire [6:0] iy;
	 wire iwriteEn;
	 
	 // drawShape wires
	 wire shapeColor;
	 wire [7:0] shapeX;
	 wire [6:0] shapeY;
	 wire shapeWriteEn;
	 
	 initalizeBoarder createBoard(
		.clk(CLOCK_50),
		.color(initializeColor),
		.x(ix),
		.y(iy),
		.plot(iwriteEn),
		.finished(finished_initialize));
	 
	 
	 always @(posedge clk)
		begin 
			if (finished_initialize == 0) begin
				writeEn = iwriteEn;
				colour = initializeColor;
				x = ix;
				y = iy;
				end
			else begin
				writeEn = shapeWriteEn;
				colour = shapeColor;
				x = shapeX;
				y = shapeY;
				end
		end
	 
	 // Create an Instance of a VGA controller - there can be only one!
	 // Define the number of colours as well as the initial background
	 // image file (.MIF) for the controller.
	 vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
	
	 drawBoard dboard(
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
	 .clk(CLOCK_50),
	 .color(shapeColor),
	 .x(shapeX),
	 .y(shapeY),
	 .plot(shapeWriteEn));
	 
	 
	 genblock gen(
		.r0(r1),
		.r1(r2),
		.r2(r3),
		.r3(r4),
		.f0(r1),
		.f1(r2),
		.f2(r3),
		.f3(r4)
	);

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
		  .f1(r1),
        .f2(r2),
        .f3(r3),
        .f4(r4),
        .f5(r5),
        .f6(r6),
        .f7(r7),
        .f8(r8),
        .f9(r9),
        .f10(r10),
        .f11(r11),
        .f12(r12),
        .f13(r13),
        .f14(r14),
        .f15(r15),
        .f16(r16),
        .f17(r17),
        .f18(r18),
        .f19(r19),
        .f20(r20),
        .player_x(player_x),
		  .CLK_5(CLOCK_5),
        .end_game(end_game)
    );
endmodule

module initalizeBoarder(clk, color, x, y, plot, finished);
	input clk;
	output reg [2:0] color;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg plot;
	output reg finished;
	
	reg [3:0] total_counter;
	reg [2:0] current_state, next_state;
	reg [7:0] plot_counter;
	
	localparam 	PLOTROW		= 3'd0,
				DETERMINE1	= 3'd1,
				PLOTCOLUMN	= 3'd2,
				DETERMINE2  = 3'd3,
				RESTING	 	= 3'd4;

	
	always @(posedge clk)
	begin: state
		case (current_state)
			PLOTROW: next_state = (plot_counter == 6'd39) ? DETERMINE1 : PLOTROW;
			DETERMINE1: next_state = (total_counter == 4'd3) ? PLOTCOLUMN : PLOTROW;
			PLOTCOLUMN: next_state = (plot_counter == 8'd79) ? DETERMINE2 : PLOTCOLUMN;
			DETERMINE2: next_state = (total_counter == 4'd7) ? RESTING : PLOTCOLUMN;
			default: next_state = RESTING;
		endcase
	end
	
	assign plot = (current_state == PLOTROW || current_state == PLOTCOLUMN);
	
	always @(*)
	begin: make_output
		case (current_state)
			PLOTROW: begin
				if (total_counter == 1'd0) begin
					y <= 6'd18;
					x <= 6'd60 + plot_counter;
				end
				else if (total_counter == 1'd1) begin
					y <= 6'd19;
					x <= 6'd60 + plot_counter;
				end
				else if (total_counter == 4'd2) begin
					y <= 7'd100;
					x <= 6'd60 + plot_counter;
				end
				else if (total_counter == 4'd3) begin
					y <= 7'd101;
					x <= 6'd60 + plot_counter;
				end
				plot_counter <= plot_counter+1;
			end
			DETERMINE1: begin
				plot_counter <= 1'd0;
				total_counter <= total_counter+1;
			end
			PLOTCOLUMN: begin
				if (total_counter == 4'd4) begin
					x <= 6'd58;
					y <= 6'd18 + plot_counter;
				end
				else if (total_counter == 4'd5) begin
					x <= 6'd59;
					y <= 6'd18 + plot_counter;
				end
				else if (total_counter == 4'd6) begin
					x <= 7'd100;
					y <= 6'd18 + plot_counter;
				end
				else begin
					x <= 7'd101;
					y <= 6'd18 + plot_counter;
				end
				plot_counter <= plot_counter+1;
			end
			DETERMINE2: begin
				plot_counter <= 1'd0;
				total_counter <= total_counter+1;
			end
			RESTING: begin
				finished <= 1'd1;
			end
			default: begin
				color <= 3'd0;
			end
		endcase
	end
	
	assign color = 3'd7;
	
	
	always@(posedge clk) begin
		current_state <= next_state;
		end
endmodule


module drawBoard(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, clk, color, x, y, plot);
	input [9:0] r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20;
	input clk;
	output reg [2:0] color;
	output reg [7:0] x;
	output reg [6:0] y;
	output reg plot;
	
	reg [9:0] rowList [19:0];

	reg [4:0] column;
	reg [4:0] row;
	reg [2:0] current_state, next_state;
	reg [3:0] plotCounter;
	reg [9:0] rowData;
	assign rowData = r1;

	localparam 	ROWCHECK	= 3'd0,
				PLOTROW		= 3'd1,
				DETERMINE1	= 3'd2,
				NEXTROW     = 3'd3,
				PLOTNEXTROW = 3'd4,
				DETERMINE2  = 3'd5,
				RESTING 	= 3'd6;
	
	always @(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20) 
		begin
			next_state = ROWCHECK;
			rowList = {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20};
		end
	
	always @(posedge clk)
	begin: state
		case (current_state)
			ROWCHECK: next_state = PLOTROW;
			PLOTROW: next_state = (plotCounter == 4'd15) ? DETERMINE1 : PLOTROW;
			DETERMINE1: next_state = (column == 4'd9) ? NEXTROW : ROWCHECK;
			NEXTROW: next_state = PLOTNEXTROW;
			PLOTNEXTROW: next_state = (plotCounter == 4'd15) ? DETERMINE2 : PLOTNEXTROW;
			DETERMINE2: next_state = (row == 5'd19) ? RESTING : ROWCHECK;
			default: next_state = RESTING;
		endcase
	end
	
	// plot
	assign plot = (current_state == PLOTROW || current_state == PLOTNEXTROW);
	assign baseX = 6'd60;
	assign baseY = 6'd20;
	
	always @(*)
	begin: make_outputcolumn
		case (current_state)
			ROWCHECK: begin
				column <= column+1;
				if (rowList[row][column-1] == 1'd1)
					color = 3'd4;
				else
					color = 3'd0;
			end
			PLOTROW: begin
				x <= baseX + ((column-1)*4) + (plotCounter % 4);
				y <= baseY + (row*4) + (plotCounter / 4);
				plotCounter <= plotCount+1;
			end
			DETERMINE1: begin
				plotCounter <= 1'd0;
			end
			NEXTROW: begin
				column <= 1'd0;
				row <= row+1;
				if (rowList[row][column-1] == 1'd1)
					color = 3'd4;
				else
					color = 3'd0;
			end
			PLOTNEXTROW: begin
				x <= baseX + ((column-1)*4) + (plotCounter % 4);
				y <= baseY + (row*4) + (plotCounter / 4);
				plotCounter <= plotCount+1;
			end
			DETERMINE2: begin
				plotCounter <= 1'd0;
			end
			RESTING: begin
				row <= 1'd0;
				column <= 1'd0;
			end
			default: begin
				color = 3'd0;
			end
		endcase
	end
	
	always@(posedge clk)
		current_state <= next_state;

endmodule


module drop(
    r1, r2, r3, r4, r5,
    r6, r7, r8, r9, r10,
    r11, r12, r13, r14, r15,
    r16, r17, r18, r19, r20,
	 
	 f1, f2, f3, f4, f5,
    f6, f7, f8, f9, f10,
    f11, f12, f13, f14, f15,
    f16, f17, f18, f19, f20,
    player_x,CLK_4,
    end_game
);

    input player_x;
    input r1, r2, r3, r4, r5,
    r6, r7, r8, r9, r10,
    r11, r12, r13, r14, r15,
    r16, r17, r18, r19, r20,CLK_4;
	 
	 output f1, f2, f3, f4, f5,
    f6, f7, f8, f9, f10,
    f11, f12, f13, f14, f15,
    f16, f17, f18, f19, f20;
    output end_game;
    assign end_game = 1'b0;

    always @(CLK_4)
	 begin
	 f1 = 10'b0000000000;
	 f2 = r1;
	 f3 = r2;
	 f4 = r3;
	 f5 = r4;
	 f6 = r5;
	 f7 = r6;
	 f8 = r7;
	 f9 = r8;
	 f10 = r9;
	 f11 = r10;
	 f12 = r11;
	 f13 = r12;
	 f14 = r13;
	 f15 = r14;
	 f16 = r15;
	 f17 = r16;
	 f18 = r17;
	 f19 = r18;
	 f20 = r19;
    end
endmodule

module genblock(r0,r1,r2,r3,f0,f1,f2,f3);
	// set the preparing place, this is a 10*4 big matrix.
	input r0,r1,r2,r3;
	output f0,f1,f2,f3;
	// poi is show the horizontal position of the block, initial it to be 6(middle)
	reg [5:0] poi;
	// s is for showing the shape of the block.
	reg [0:5] s;
	//	reg [9:0]p0=10'b0000000000;
	//	reg [9:0]p1=10'b0000000000;
	//	reg [9:0]p2=10'b0000000000;
	//	reg [9:0]p3=10'b0000000000;
	// x for recording the horizontal in the whole screen.
	
	assign poi = $random % 10;
	assign s = $random % 19;
	always @(*)
	begin
	if((poi == 0 && s != 1 && s != 3 && s != 9 && s != 12 && s != 16 && s != 18) || (poi == 1 && s == 2))
		assign poi = 1;
	if((poi == 9 && s!=0 && s!=1 && s!=5 && s!=7 && s!=14))
		assign poi = 8;
	// now generate the blocks.
	p1[poi] = 1;
	// Square
	if (s == 0)
	begin
		f2[poi] <= 1;
		f2[poi - 1] <= 1;
		f1[poi - 1] <= 1;
	end
	// shape I
	else if (s == 1)
	begin
		f0[poi] <= 1;
		f2[poi] <= 1;
		f3[poi] <= 1;
	end
	else if (s == 2)
	begin
		f1[poi + 1] = 1;
		f1[poi - 1] = 1;
		f1[poi - 2] = 1;
	end
	// shape L
	else if (s == 3)
	begin
		f0[poi] = 1;
		f2[poi] = 1;
		f2[poi + 1] = 1;
	end	
	else if (s == 4)
	begin
		f1[poi - 1] = 1;
		f2[poi - 1] = 1;
		f1[poi + 1] = 1;
	end
	else if (s == 5)
	begin
		f0[poi] = 1;
		f0[poi - 1] = 1;
		f2[poi] = 1;
	end
	else if (s == 6)
	begin
		f1[poi - 1] = 1;
		f1[poi + 1] = 1;
		f0[poi + 1] = 1;
	end
	// for shape J
	else if (s == 7)
	begin
		f0[poi] = 1;
		f2[poi] = 1;
		f2[poi - 1] = 1;
	end
	else if (s == 8)
	begin
		f1[poi - 1] = 1;
		f1[poi + 1] = 1;
		f0[poi - 1] = 1;
	end
	else if (s == 9)
	begin
		f0[poi] = 1;
		f0[poi + 1] = 1;
		f2[poi] = 1;
	end
	else if (s == 10)
	begin
		f1[poi - 1] = 1;
		f1[poi + 1] = 1;
		f2[poi + 1] = 1;
	end
	 // for shape T
	else if (s == 11)
	begin
		f0[poi] = 1;
		f1[poi + 1] = 1;
		f1[poi - 1] = 1;
	end
	else if (s == 12)
	begin
		f0[poi] = 1;
		f2[poi] = 1;
		f1[poi + 1] = 1;
	end
	else if (s == 13)
	begin
		f1[poi - 1] = 1;
		f1[poi + 1] = 1;
		f2[poi] = 1;
	end
	else if (s == 14)
	begin
		f0[poi] = 1;
		f2[poi] = 1;
		f1[poi - 1] = 1;
	end
	// for shape Z
	else if (s == 15)
	begin
		f0[poi - 1] = 1;
		f0[poi] = 1;
		f1[poi + 1] = 1;
	end
	else if (s == 16)
	begin
		f0[poi + 1] = 1;
		f1[poi + 1] = 1;
		f2[poi] = 1;
	end
	// for shape S
	else if (s == 17)
	begin
		f0[poi] = 1;
		f0[poi + 1] = 1;
		f1[poi - 1] = 1;
	end
	else if (s == 18)
	begin
		f0[poi] = 1;
		f1[poi + 1] = 1;
		f2[poi + 1] = 1;
	end
end
endmodule
		