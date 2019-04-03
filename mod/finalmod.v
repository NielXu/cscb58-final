/*
	Modification of the game: There are 12 rows in total and 
	every second or so there will be a random row that get
	picked, and player has to dodge this row by using KEY
 */
module dodge
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	wire [3:0] color;
	wire [7:0] x;
	wire [6:0] y;
	wire plot;
	wire resetn;
	assign resetn = KEY[0];

	// Wire the output of game to draw
	wire r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14;
	// Wire the player location
	wire playerx, playery;

	control c(
		.up(KEY[0]),
		.down(KEY[1]),
		.left(KEY[2]),
		.right(KEY[3]),
		.playerx(playerx),
		.playery(playery)
	);

	game g(
		.clk(CLK_50),
		.playerx(playerx),
		.playery(playery),
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
	)

	draw d(
		.clk(CLK_50),
		.color(color),
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
		.x(x),
		.y(y),
		.plot(plot)
	);

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(x),
			.y(y),
			.plot(plot),
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
endmodule

/*
	This module responsible for player movement
 */
module control(
	clk,
	up,
	down,
	left,
	right,
	playerx,
	playery
);
	input clk, up, down, left, right;
	output reg [7:0] playerx = 8'd0;
	output reg [6:0] playery = 7'd0;

	always @(posedge clk)
	begin
		if(up) begin
			if(playery == 7'd0)
				playery = 7'd0;
			else
				playery = playery - 1;
		end
		else if(down) begin
			if(playery == 7'd11)
				playery = 7'd11;
			else
				playery = playery + 1;
		end
		else if(left) begin
			if(playerx == 8'd1)
				playerx = 8'd1;
			else
				playerx = playerx - 1;
		end
		else if(right) begin
			if(playerx == 8'd8)
				playerx = 8'd8;
			else
				playerx = playerx + 1;
		end
	end

endmodule

/*
	This module responsible for most of the game logic
 */
module game
(
	clk,
	playerx,
	playery,
	r1,
	r2,
	r3,
	r4,
	r5,
	r6,
	r7,
	r8,
	r9,
	r10,
	r11,
	r12,
	r13,
	r14
);
	input clk, playerx, playery;
	output reg [9:0] r1 = 10'b1111111111;
	output reg [9:0] r2 = 10'b1000000001;
	output reg [9:0] r3 = 10'b1000000001;
	output reg [9:0] r4 = 10'b1000000001;
	output reg [9:0] r5 = 10'b1000000001;
	output reg [9:0] r6 = 10'b1000000001;
	output reg [9:0] r7 = 10'b1000000001;
	output reg [9:0] r8 = 10'b1000000001;
	output reg [9:0] r9 = 10'b1000000001;
	output reg [9:0] r10 = 10'b1000000001;
	output reg [9:0] r11 = 10'b1000000001;
	output reg [9:0] r12 = 10'b1000000001;
	output reg [9:0] r13 = 10'b1000000001;
	output reg [9:0] r14 = 10'b1111111111;

	// Set player location
	always @(*) begin
		case(playery) begin
			4'd0: r2[playerx] = 1;
			4'd1: r3[playerx] = 1;
			4'd2: r4[playerx] = 1;
			4'd3: r5[playerx] = 1;
			4'd4: r6[playerx] = 1;
			4'd5: r7[playerx] = 1;
			4'd6: r8[playerx] = 1;
			4'd7: r9[playerx] = 1;
			4'd8: r10[playerx] = 1;
			4'd9: r11[playerx] = 1;
			4'd10: r12[playerx] = 1;
			4'd11: r13[playerx] = 1;
		endcase
	end

endmodule


/*
	This module is responsible for drawing by given r1-r14, represents row1
	to row 14. Row 1 and row 14 are the bound. Each row has 10 bits therefore
	the actual game size is 12 * 8 (2 bits count for bound).
	For each row 0 represents drawing black and 1 represents drawing white.
	r1 = 10'b1111111111
	r2 = 10'b1000000001
	r3 = 10'b1000000001
	...
	r14 = 10b'1111111111
 */
module draw
	(
		clk,
		color,
		r1,
		r2,
		r3,
		r4,
		r5,
		r6,
		r7,
		r8,
		r9,
		r10,
		r11,
		r12,
		r13,
		r14,
		x,
		y,
		plot
	);
	input clk;
	input r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
	output reg[7:0] x;
	output reg[6:0] y;
	output color;
	output plot;

	reg [2:0] current_state, next_state;
	
	reg [3:0] sq_counter; // 4 bit counter to draw 2*2 square
	reg [9:0] r1_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r2_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r3_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r4_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r5_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r6_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r7_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r8_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r9_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r10_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r11_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r12_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r13_counter; // This counter count whether we have drawn 10 bits already
	reg [9:0] r14_counter; // This counter count whether we have drawn 10 bits already

	localparam	draw_r1 = 5'd0,
				draw_r2 = 5'd1,
				draw_r3 = 5'd2,
				draw_r4 = 5'd3,
				draw_r5 = 5'd4,
				draw_r6 = 5'd5,
				draw_r7 = 5'd6,
				draw_r8 = 5'd7,
				draw_r9 = 5'd8,
				draw_r10 = 5'd9,
				draw_r11 = 5'd10,
				draw_r12 = 5'd11,
				draw_r13 = 5'd12,
				draw_r14 = 5'd13,
				RESET = 5'd14;
	
	always @(posedge clk)
	begin: state
		case(current_state)
			draw_r1: next_state = (r1_counter == 4'd9)? draw_r2 : draw_r1;
			draw_r2: next_state = (r2_counter == 4'd9)? draw_r3 : draw_r1;
			draw_r3: next_state = (r3_counter == 4'd9)? draw_r4 : draw_r1;
			draw_r4: next_state = (r4_counter == 4'd9)? draw_r5 : draw_r1;
			draw_r5: next_state = (r5_counter == 4'd9)? draw_r6 : draw_r1;
			draw_r6: next_state = (r6_counter == 4'd9)? draw_r7 : draw_r1;
			draw_r7: next_state = (r7_counter == 4'd9)? draw_r8 : draw_r1;
			draw_r8: next_state = (r8_counter == 4'd9)? draw_r9 : draw_r1;
			draw_r9: next_state = (r9_counter == 4'd9)? draw_r10 : draw_r1;
			draw_r10: next_state = (r10_counter == 4'd9)? draw_r11 : draw_r1;
			draw_r11: next_state = (r11_counter == 4'd9)? draw_r12 : draw_r1;
			draw_r12: next_state = (r12_counter == 4'd9)? draw_r13 : draw_r1;
			draw_r13: next_state = (r13_counter == 4'd9)? draw_r14 : draw_r1;
			draw_r14: next_state = (r14_counter == 4'd9)? RESET : draw_r14;
			RESET: next_state = draw_r1;

			// After drawing all 14 rows, the state will go to RESET state, which
			// will reset all the counters and then go back to draw_r1, in this
			// way we will keep drawing and never goes to RESTING state
		default: next_state = RESET;
		endcase
	end

	// We simply assigning a true for plot since we keep drawing
	assign plot = 1'b1 == 1'b1;

	// The origin of the image that being drawn
	// since we are not drawing start from (0,0) but (60, 18)
	wire x_origin, y_origin;
	assign x_origin = 6'd60;
	assign y_origin = 6'd18;

	// Draw every row
	always @(posedge clk)
	begin: make_output
		case (current_state)
			draw_r1: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd0;
					x <= x_origin + 6'd0 + r1_counter + r1_counter;
					// If at this index it is 1, draw white, otherwise draw black
					assign color = (r1[r1_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd0;
					x <= x_origin + 6'd1 + r1_counter + r1_counter;
					// If at this index it is 1, draw white, otherwise draw black
					assign color = (r1[r1_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd1;
					x <= x_origin + 6'd0 + r1_counter + r1_counter;
					// If at this index it is 1, draw white, otherwise draw black
					assign color = (r1[r1_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd1;
					x <= x_origin + 6'd1 + r1_counter + r1_counter;
					// We have drawn a full square, set sq_counter back to 0
					// and increment row_counter by 1 indicates that we have
					// drawn 1 bit
					sq_counter = 4'd0;
					r1_counter <= r1_counter + 1;
					// If at this index it is 1, draw white, otherwise draw black
					assign color = (r1[r1_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r2: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd2;
					x <= x_origin + 6'd0 + r2_counter + r2_counter;
					assign color = (r2[r2_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd2;
					x <= x_origin + 6'd1 + r2_counter + r2_counter;
					assign color = (r2[r2_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd3;
					x <= x_origin + 6'd0 + r2_counter + r2_counter;
					assign color = (r2[r2_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd3;
					x <= x_origin + 6'd1 + r2_counter + r2_counter;
					sq_counter = 4'd0;
					r2_counter <= r2_counter + 1;
					assign color = (r2[r2_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r3: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd4;
					x <= x_origin + 6'd0 + r3_counter + r3_counter;
					assign color = (r3[r3_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd4;
					x <= x_origin + 6'd1 + r3_counter + r3_counter;
					assign color = (r3[r3_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd5;
					x <= x_origin + 6'd0 + r3_counter + r3_counter;
					assign color = (r3[r3_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd5;
					x <= x_origin + 6'd1 + r3_counter + r3_counter;
					sq_counter = 4'd0;
					r3_counter <= r3_counter + 1;
					assign color = (r3[r3_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r4: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd6;
					x <= x_origin + 6'd0 + r4_counter + r4_counter;
					assign color = (r4[r4_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd6;
					x <= x_origin + 6'd1 + r4_counter + r4_counter;
					assign color = (r4[r4_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd7;
					x <= x_origin + 6'd0 + r4_counter + r4_counter;
					assign color = (r4[r4_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd7;
					x <= x_origin + 6'd1 + r4_counter + r4_counter;
					sq_counter = 4'd0;
					r4_counter <= r4_counter + 1;
					assign color = (r4[r4_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r5: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd8;
					x <= x_origin + 6'd0 + r5_counter + r5_counter;
					assign color = (r5[r5_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd8;
					x <= x_origin + 6'd1 + r5_counter + r5_counter;
					assign color = (r5[r5_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd9;
					x <= x_origin + 6'd0 + r5_counter + r5_counter;
					assign color = (r5[r5_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd9;
					x <= x_origin + 6'd1 + r5_counter + r5_counter;
					sq_counter = 4'd0;
					r5_counter <= r5_counter + 1;
					assign color = (r5[r5_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r6: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd10;
					x <= x_origin + 6'd0 + r6_counter + r6_counter;
					assign color = (r6[r6_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd10;
					x <= x_origin + 6'd1 + r6_counter + r6_counter;
					assign color = (r6[r6_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd11;
					x <= x_origin + 6'd0 + r6_counter + r6_counter;
					assign color = (r6[r6_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd11;
					x <= x_origin + 6'd1 + r6_counter + r6_counter;
					sq_counter = 4'd0;
					r6_counter <= r6_counter + 1;
					assign color = (r6[r6_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r7: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd12;
					x <= x_origin + 6'd0 + r7_counter + r7_counter;
					assign color = (r7[r7_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd12;
					x <= x_origin + 6'd1 + r7_counter + r7_counter;
					assign color = (r7[r7_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd13;
					x <= x_origin + 6'd0 + r7_counter + r7_counter;
					assign color = (r7[r7_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd13;
					x <= x_origin + 6'd1 + r7_counter + r7_counter;
					sq_counter = 4'd0;
					r7_counter <= r7_counter + 1;
					assign color = (r7[r7_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r8: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd14;
					x <= x_origin + 6'd0 + r8_counter + r8_counter;
					assign color = (r8[r8_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd14;
					x <= x_origin + 6'd1 + r8_counter + r8_counter;
					assign color = (r8[r8_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd15;
					x <= x_origin + 6'd0 + r8_counter + r8_counter;
					assign color = (r8[r8_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd15;
					x <= x_origin + 6'd1 + r8_counter + r8_counter;
					sq_counter = 4'd0;
					r8_counter <= r8_counter + 1;
					assign color = (r8[r8_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r9: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd16;
					x <= x_origin + 6'd0 + r9_counter + r9_counter;
					assign color = (r9[r9_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd16;
					x <= x_origin + 6'd1 + r9_counter + r9_counter;
					assign color = (r9[r9_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd17;
					x <= x_origin + 6'd0 + r9_counter + r9_counter;
					assign color = (r9[r9_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd17;
					x <= x_origin + 6'd1 + r9_counter + r9_counter;
					sq_counter = 4'd0;
					r9_counter <= r9_counter + 1;
					assign color = (r9[r9_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r10: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd18;
					x <= x_origin + 6'd0 + r10_counter + r10_counter;
					assign color = (r10[r10_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd18;
					x <= x_origin + 6'd1 + r10_counter + r10_counter;
					assign color = (r10[r10_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd19;
					x <= x_origin + 6'd0 + r10_counter + r10_counter;
					assign color = (r10[r10_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd19;
					x <= x_origin + 6'd1 + r10_counter + r10_counter;
					sq_counter = 4'd0;
					r10_counter <= r10_counter + 1;
					assign color = (r10[r10_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r11: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd20;
					x <= x_origin + 6'd0 + r11_counter + r11_counter;
					assign color = (r11[r11_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd20;
					x <= x_origin + 6'd1 + r11_counter + r11_counter;
					assign color = (r11[r11_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd21;
					x <= x_origin + 6'd0 + r11_counter + r11_counter;
					assign color = (r11[r11_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd21;
					x <= x_origin + 6'd1 + r11_counter + r11_counter;
					sq_counter = 4'd0;
					r11_counter <= r11_counter + 1;
					assign color = (r11[r11_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r12: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd22;
					x <= x_origin + 6'd0 + r12_counter + r12_counter;
					assign color = (r12[r12_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd22;
					x <= x_origin + 6'd1 + r12_counter + r12_counter;
					assign color = (r12[r12_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd23;
					x <= x_origin + 6'd0 + r12_counter + r12_counter;
					assign color = (r12[r12_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd23;
					x <= x_origin + 6'd1 + r12_counter + r12_counter;
					sq_counter = 4'd0;
					r12_counter <= r12_counter + 1;
					assign color = (r12[r12_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r13: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd24;
					x <= x_origin + 6'd0 + r13_counter + r13_counter;
					assign color = (r13[r13_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd24;
					x <= x_origin + 6'd1 + r13_counter + r13_counter;
					assign color = (r13[r13_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd25;
					x <= x_origin + 6'd0 + r13_counter + r13_counter;
					assign color = (r13[r13_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd25;
					x <= x_origin + 6'd1 + r13_counter + r13_counter;
					sq_counter = 4'd0;
					r13_counter <= r13_counter + 1;
					assign color = (r13[r13_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			draw_r14: begin
				if(sq_counter == 4'd0) begin
					y <= y_origin + 6'd26;
					x <= x_origin + 6'd0 + r14_counter + r14_counter;
					assign color = (r14[r14_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd1) begin
					y <= y_origin + 6'd26;
					x <= x_origin + 6'd1 + r14_counter + r14_counter;
					assign color = (r14[r14_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd2) begin
					y <= y_origin + 6'd27;
					x <= x_origin + 6'd0 + r14_counter + r14_counter;
					assign color = (r14[r14_counter] == 1'b1)? 3'b111 : 3'b000;
				end
				else if(sq_counter == 4'd3) begin
					y <= x_origin + 6'd27;
					x <= x_origin + 6'd1 + r14_counter + r14_counter;
					sq_counter = 4'd0;
					r14_counter <= r14_counter + 1;
					assign color = (r14[r14_counter] == 1'b1)? 3'b111 : 3'b000;
				end
			end

			RESET: begin
			// RESET all counter back to zero in this state
				r1_counter = 10'b0000000000;
				r2_counter = 10'b0000000000;
				r3_counter = 10'b0000000000;
				r4_counter = 10'b0000000000;
				r5_counter = 10'b0000000000;
				r6_counter = 10'b0000000000;
				r7_counter = 10'b0000000000;
				r8_counter = 10'b0000000000;
				r9_counter = 10'b0000000000;
				r10_counter = 10'b0000000000;
				r11_counter = 10'b0000000000;
				r12_counter = 10'b0000000000;
				r13_counter = 10'b0000000000;
				r14_counter = 10'b0000000000;
			end

		endcase
	end

endmodule
	