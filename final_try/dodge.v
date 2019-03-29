`timescale 1ns / 1ps

module dodge( KEY, CLK, RST, DIN, DOUT,VGA_HSYNC, VGA_VSYNC,y2);


input CLK; // System clock= 50MHz
input RST; // high active
input [1:0] DIN;
input [2:0] KEY;
output [2:0] DOUT;// RGB
output VGA_HSYNC;
output VGA_VSYNC;
output [10:1]y2;
reg over;
reg [9:0]y1=10'b0000000000;
reg [9:0]y2=10'b0000000000;
reg [9:0]y3=10'b0000000000;
reg [9:0]y4=10'b0000000000;
reg [9:0]y5=10'b0000000000;
reg [9:0]y6=10'b0000000000;
reg [9:0]y7=10'b0000000000;
reg [9:0]y8=10'b0000000000;
reg [9:0]y9=10'b0000000000;
reg [9:0]y10=10'b0000000000;
reg [9:0]y11=10'b0000000000;
reg [9:0]y12=10'b0000000000;
reg [9:0]y13=10'b0000000000;
reg [9:0]y14=10'b0000000000;
reg [9:0]y15=10'b0000000000;
reg [9:0]y16=10'b0000000000;
reg [9:0]y17=10'b0000000000;
reg [9:0]y18=10'b0000000000;
reg [1:0]n;

reg qa = 0, qb = 0;
reg qa_dly = 0;
reg rot_event = 0; 
reg rot_left = 0;


reg [2:0] RGB;
reg [9:0] h_cnt;//horizontal counter
reg [9:0] v_cnt; // vertical counter
reg vga_ck; // VGA clock = 25MHz
reg [32:1]temp=6;
wire clk_4;
reg [32:1]x=390;
reg [32:1]y=80;
wire [1:0] state;
wire data_valid;

assign DOUT = data_valid ? RGB:3'd0;
assign state = DIN;
assign VGA_HSYNC = ((h_cnt >10'd111 ) && (h_cnt  < 10'd799))? 1'b1 : 1'b0;
assign VGA_VSYNC = ((v_cnt > 10'd11) && (v_cnt < 10'd499 ))? 1'b1 : 1'b0;

assign data_valid = ((h_cnt >10'd111 ) && (h_cnt  < 10'd759) && (v_cnt > 10'd11) && (v_cnt < 10'd499 ));

/////// Generate VGA CLOCK = 25MHz /////////////
always @ (posedge CLK or posedge RST)begin
	if(RST) vga_ck <= 1'b0;
	else vga_ck <= ~vga_ck;
end
// horizontal counter /////
always @(posedge vga_ck or posedge RST)begin
	if(RST) h_cnt <= 10'd0;
	else if (h_cnt == 10'd799) h_cnt <= 10'd0;		
	else  h_cnt <= h_cnt + 1'b1;
end

/// vertical counter /////////
always @(posedge vga_ck or posedge RST)begin
	if(RST) v_cnt <= 10'd0;
	else if (v_cnt == 10'd520) v_cnt <= 10'd0;
	else if(h_cnt == 10'd799) v_cnt <= v_cnt + 1'b1;
	else v_cnt <= v_cnt;
end

fd_4 fd_4(
	.clk_50m(CLK),
	.clk_4(clk_4)

);



always @(posedge clk_4)
begin	
	if(KEY[2])
	begin
		y1<=10'b0000000000;
		y2<=10'b0000000000;
		y3<=10'b0000000000;
		y4<=10'b0000000000;
		y5<=10'b0000000000;
		y6<=10'b0000000000;
		y7<=10'b0000000000;
		y8<=10'b0000000000;
		y9<=10'b0000000000;
		y10<=10'b0000000000;
		y11<=10'b0000000000;
		y12<=10'b0000000000;
		y13<=10'b0000000000;
		y14<=10'b0000000000;
		y15<=10'b0000000000;
		y16<=10'b0000000000;
		y17<=10'b0000000000;
		y18<=10'b0000000000;
	end
	if(y18==0)
	begin
	over<=0;
	y<=y+20;
	if(y1==10'b1111111111)
	begin
		y1<=y2;
		y2<=y3;
		y3<=y4;
		y4<=y5;
		y5<=y6;
		y6<=y7;
		y7<=y8;
		y8<=y9;
		y9<=y10;
		y10<=y11;
		y11<=y12;
		y12<=y13;
		y13<=y14;
		y14<=y15;
		y15<=y16;
		y16<=y17;
		y17<=y18;
		y18<=10'b0000000000;
	end

	if(KEY[0])
			begin	
				if(x>443&&n==2)
				begin
				end
				else if(x<462)
					begin
					x<=x+18;
					temp<=temp+1;
					end
				
			end
	else if(KEY[1])
			begin	
			if(x>300)
				begin
					x<=x-18;
					temp<=temp-1;
				end
			end

	if((y<80)&&(y>=60)&&(y17[temp]==1))
	begin
		y18[temp]<=1;
				y<=60;
					
				n<=n+1;
	end	
		
	else if((y<100)&&(y>=80)&&(y16[temp]==1))
	begin
		y17[temp]<=1;
		if(n==1)
			begin
				y18[temp]<=1;
			end
		if(n==2)
			begin
				y17[temp+1]<=1;
			end
		y<=60;
		n<=n+1;
	end
		
	else if((y<400)&&(y>=100)&&(y15[temp]==1))
	begin
		y16[temp]<=1;
		if(n==1)
			begin
				y17[temp]<=1;
			end
		if(n==2)
			begin
				y16[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end		
			
			
	else if((y<400)&&(y>=120)&&(y14[temp]==1))
	begin
		y15[temp]<=1;
		if(n==1)
			begin
				y16[temp]<=1;
			end
		if(n==2)
			begin
				y15[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	else if((y<400)&&(y>=140)&&(y13[temp]==1))
	begin
		y14[temp]<=1;
		if(n==1)
			begin
				y15[temp]<=1;
			end
		if(n==2)
			begin
				y14[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	else if((y<400)&&(y>=160)&&(y12[temp]==1))
	begin
		y13[temp]<=1;
		if(n==1)
			begin
				y14[temp]<=1;
			end
		if(n==2)
			begin
				y13[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	else if((y<400)&&(y>=180)&&(y11[temp]==1))
	begin
		y12[temp]<=1;
		if(n==1)
			begin
				y13[temp]<=1;
			end
		if(n==2)
			begin
				y12[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	else if((y<220)&&(y>=200)&&(y10[temp]==1))
	begin
		y11[temp]<=1;
		if(n==1)
			begin
				y12[temp]<=1;
			end
		if(n==2)
			begin
				y11[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	else if((y<240)&&(y>=220)&&(y9[temp]==1))
	begin
		y10[temp]<=1;
		if(n==1)
			begin
				y11[temp]<=1;
			end
		if(n==2)
			begin
				y10[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	else if((y<260)&&(y>=240)&&(y8[temp]==1))
	begin
		y9[temp]<=1;
		if(n==1)
			begin
				y10[temp]<=1;
			end
		if(n==2)
			begin
				y9[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	
			
	else if((y<280)&&(y>=260)&&(y7[temp]==1))
	begin
		y8[temp]<=1;
		if(n==1)
			begin
				y9[temp]<=1;
			end
		if(n==2)
			begin
				y8[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end	
	
	else if((y<300)&&(y>=280)&&(y6[temp]==1))
	begin
		y7[temp]<=1;
		if(n==1)
			begin
				y8[temp]<=1;
			end
		if(n==2)
			begin
				y7[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end	
		
	else if((y<320)&&(y>=300)&&(y5[temp]==1))
	begin
		y6[temp]<=1;
		if(n==1)
			begin
				y7[temp]<=1;
			end
		if(n==2)
			begin
				y6[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end	
		
	else if((y<340)&&(y>=320)&&(y4[temp]==1))
	begin
		y5[temp]<=1;
		if(n==1)
			begin
				y6[temp]<=1;
			end
		if(n==2)
			begin
				y5[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
		
	else if((y<360)&&(y>=340)&&(y3[temp]==1))
	begin
		y4[temp]<=1;
		if(n==1)
			begin
				y5[temp]<=1;
			end
		if(n==2)
			begin
				y4[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end	
			
	else if((y<380)&&(y>=360)&&(y2[temp]==1))
	begin
		y3[temp]<=1;
		if(n==1)
			begin
				y4[temp]<=1;
			end
		if(n==2)
			begin
				y3[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end		
			
	else if((y<400)&&(y>=380)&&(y1[temp]==1))
	begin
		y2[temp]<=1;
		if(n==1)
			begin
				y3[temp]<=1;
			end
		if(n==2)
			begin
				y2[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	
	else if(y>=400)
	begin
		y1[temp]<=1;
		if(n==1)
			begin
				y2[temp]<=1;
			end
		if(n==2)
			begin
				y1[temp+1]<=1;
			end
				y<=60;
				n<=n+1;
	end
	end
	else
		over<=1;
end


always @ (posedge CLK) begin
	
	begin		

				if(v_cnt>50 && v_cnt<60 && h_cnt>290 && h_cnt< 490) RGB <= 3'd000;	
				else if(v_cnt>420 && v_cnt<430 && h_cnt>290 && h_cnt< 490) RGB <= 3'd000;
				else if(v_cnt>60 && v_cnt<420 && h_cnt>290 && h_cnt< 300) RGB <= 3'd000;	
				else if(v_cnt>60 && v_cnt<420 && h_cnt>480 && h_cnt<490) RGB <= 3'd000;	
				
				else if(v_cnt>400&&v_cnt<420&&y1[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>400&&v_cnt<420&&y1[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>380&&v_cnt<400&&y2[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<400&&y2[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				else if(v_cnt>360&&v_cnt<380&&y3[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>360&&v_cnt<380&&y3[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				else if(v_cnt>340&&v_cnt<360&&y4[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<3600&&y4[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>340&&v_cnt<360&&y4[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				else if(v_cnt>320&&v_cnt<340&&y5[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>320&&v_cnt<340&&y5[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>300&&v_cnt<320&&y6[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>300&&v_cnt<320&&y6[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>280&&v_cnt<300&&y7[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>280&&v_cnt<300&&y7[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>260&&v_cnt<280&&y8[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>260&&v_cnt<280&&y8[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>240&&v_cnt<260&&y9[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>240&&v_cnt<260&&y9[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>220&&v_cnt<240&&y10[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<240&&y10[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>200&&v_cnt<220&&y11[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<220&&y11[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>180&&v_cnt<200&&y12[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>180&&v_cnt<200&&y12[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>160&&v_cnt<180&&y13[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>160&&v_cnt<180&&y13[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>140&&v_cnt<160&&y14[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>140&&v_cnt<160&&y14[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>120&&v_cnt<140&&y15[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>120&&v_cnt<140&&y15[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				
				else if(v_cnt>100&&v_cnt<120&&y16[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>100&&v_cnt<120&&y16[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				else if(v_cnt>80&&v_cnt<100&&y17[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>80&&v_cnt<100&&y17[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				else if(v_cnt>60&&v_cnt<80&&y18[0]&&h_cnt>300 && h_cnt<318) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[1]&&h_cnt>318 && h_cnt<336) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[2]&&h_cnt>336 && h_cnt<354) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[3]&&h_cnt>354 && h_cnt<372) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[4]&&h_cnt>372 && h_cnt<390) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[5]&&h_cnt>390 && h_cnt<408) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[6]&&h_cnt>408 && h_cnt<426) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[7]&&h_cnt>426 && h_cnt<444) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[8]&&h_cnt>444 && h_cnt<462) RGB <= 3'd000;
				else if(v_cnt>60&&v_cnt<80&&y18[9]&&h_cnt>462 && h_cnt<480) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>500&& h_cnt<520) RGB <= 3'd000;
				else if(v_cnt>365&&v_cnt<370&&h_cnt>500&& h_cnt<520) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>500&& h_cnt<520) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<370&&h_cnt>515&& h_cnt<520) RGB <= 3'd000;
				else if(v_cnt>370&&v_cnt<385&&h_cnt>500&& h_cnt<505) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>530&& h_cnt<550) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>530&& h_cnt<550) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>530&& h_cnt<535) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>545&& h_cnt<550) RGB <= 3'd000;

				else if(v_cnt>350&&v_cnt<385&&h_cnt>565&& h_cnt<570) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>580&& h_cnt<600) RGB <= 3'd000;
				else if(v_cnt>365&&v_cnt<370&&h_cnt>580&& h_cnt<600) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>580&& h_cnt<600) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<370&&h_cnt>580&& h_cnt<585) RGB <= 3'd000;
				else if(v_cnt>370&&v_cnt<385&&h_cnt>595&& h_cnt<600) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>610&& h_cnt<630) RGB <= 3'd000;
				else if(v_cnt>365&&v_cnt<370&&h_cnt>610&& h_cnt<630) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>610&& h_cnt<630) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>610&& h_cnt<615) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>625&& h_cnt<630) RGB <= 3'd000;
				
				else if(v_cnt>365&&v_cnt<370&&h_cnt>640&& h_cnt<660) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<370&&h_cnt>640&& h_cnt<645) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>655&& h_cnt<660) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>670&& h_cnt<690) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>670&& h_cnt<690) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>670&& h_cnt<675) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>685&& h_cnt<690) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>700&& h_cnt<720) RGB <= 3'd000;
				else if(v_cnt>365&&v_cnt<370&&h_cnt>700&& h_cnt<720) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>700&& h_cnt<720) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<370&&h_cnt>700&& h_cnt<705) RGB <= 3'd000;
				else if(v_cnt>370&&v_cnt<385&&h_cnt>715&& h_cnt<720) RGB <= 3'd000;
				
				else if(v_cnt>350&&v_cnt<355&&h_cnt>730&& h_cnt<750) RGB <= 3'd000;
				else if(v_cnt>380&&v_cnt<385&&h_cnt>730&& h_cnt<750) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>730&& h_cnt<735) RGB <= 3'd000;
				else if(v_cnt>350&&v_cnt<385&&h_cnt>745&& h_cnt<750) RGB <= 3'd000;
				
				
				else if(v_cnt>200&&v_cnt<205&&h_cnt>560&& h_cnt<580&&over==1) RGB <= 3'd000;
				else if(v_cnt>230&&v_cnt<235&&h_cnt>560&& h_cnt<580&&over==1) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<235&&h_cnt>560&& h_cnt<565&&over==1) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<235&&h_cnt>575&& h_cnt<580&&over==1) RGB <= 3'd000;
				
				else if(v_cnt>200&&v_cnt<=205&&h_cnt>590&& h_cnt<594&&over==1) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<=205&&h_cnt>606&& h_cnt<610&&over==1) RGB <= 3'd000;
				else if(v_cnt>205&&v_cnt<=209&&h_cnt>591&& h_cnt<595&&over==1) RGB <= 3'd000;
				else if(v_cnt>205&&v_cnt<=209&&h_cnt>605&& h_cnt<609&&over==1) RGB <= 3'd000;
				else if(v_cnt>209&&v_cnt<=212&&h_cnt>592&& h_cnt<596&&over==1) RGB <= 3'd000;
				else if(v_cnt>209&&v_cnt<=212&&h_cnt>604&& h_cnt<608&&over==1) RGB <= 3'd000;
				else if(v_cnt>212&&v_cnt<=216&&h_cnt>593&& h_cnt<597&&over==1) RGB <= 3'd000;
				else if(v_cnt>212&&v_cnt<=216&&h_cnt>603&& h_cnt<607&&over==1) RGB <= 3'd000;
				else if(v_cnt>216&&v_cnt<=219&&h_cnt>594&& h_cnt<598&&over==1) RGB <= 3'd000;
				else if(v_cnt>216&&v_cnt<=219&&h_cnt>602&& h_cnt<606&&over==1) RGB <= 3'd000;
				else if(v_cnt>219&&v_cnt<=222&&h_cnt>595&& h_cnt<599&&over==1) RGB <= 3'd000;
				else if(v_cnt>219&&v_cnt<=222&&h_cnt>601&& h_cnt<605&&over==1) RGB <= 3'd000;
				else if(v_cnt>222&&v_cnt<=226&&h_cnt>596&& h_cnt<600&&over==1) RGB <= 3'd000;
				else if(v_cnt>222&&v_cnt<=226&&h_cnt>600&& h_cnt<604&&over==1) RGB <= 3'd000;
				else if(v_cnt>226&&v_cnt<=229&&h_cnt>597&& h_cnt<601&&over==1) RGB <= 3'd000;
				else if(v_cnt>226&&v_cnt<=229&&h_cnt>599&& h_cnt<603&&over==1) RGB <= 3'd000;
				else if(v_cnt>229&&v_cnt<=232&&h_cnt>598&& h_cnt<602&&over==1) RGB <= 3'd000;
				else if(v_cnt>229&&v_cnt<=232&&h_cnt>598&& h_cnt<602&&over==1) RGB <= 3'd000;
		
				
				else if(v_cnt>200&&v_cnt<=205&&h_cnt>620&& h_cnt<640&&over==1) RGB <= 3'd000;
				else if(v_cnt>217&&v_cnt<=222&&h_cnt>620&& h_cnt<640&&over==1) RGB <= 3'd000;
				else if(v_cnt>230&&v_cnt<=235&&h_cnt>620&& h_cnt<640&&over==1) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<=235&&h_cnt>620&& h_cnt<625&&over==1) RGB <= 3'd000;
				
				else if(v_cnt>200&&v_cnt<=205&&h_cnt>650&& h_cnt<670&&over==1) RGB <= 3'd000;
				else if(v_cnt>217&&v_cnt<=222&&h_cnt>650&& h_cnt<670&&over==1) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<=235&&h_cnt>650&& h_cnt<655&&over==1) RGB <= 3'd000;
				else if(v_cnt>200&&v_cnt<=217&h_cnt>665&& h_cnt<670&&over==1) RGB <= 3'd000;
				
				else if(v_cnt>217&&v_cnt<=221&&h_cnt>650&& h_cnt<654&&over==1) RGB <= 3'd000;
				else if(v_cnt>218&&v_cnt<=222&&h_cnt>651&& h_cnt<655&&over==1) RGB <= 3'd000;
				else if(v_cnt>219&&v_cnt<=223&&h_cnt>652&& h_cnt<656&&over==1) RGB <= 3'd000;
				else if(v_cnt>220&&v_cnt<=224&&h_cnt>653&& h_cnt<657&&over==1) RGB <= 3'd000;
				else if(v_cnt>221&&v_cnt<=225&&h_cnt>654&& h_cnt<658&&over==1) RGB <= 3'd000;
				else if(v_cnt>222&&v_cnt<=226&&h_cnt>655&& h_cnt<659&&over==1) RGB <= 3'd000;
				else if(v_cnt>223&&v_cnt<=227&&h_cnt>656&& h_cnt<660&&over==1) RGB <= 3'd000;
				else if(v_cnt>224&&v_cnt<=228&&h_cnt>657&& h_cnt<661&&over==1) RGB <= 3'd000;
				else if(v_cnt>225&&v_cnt<=229&&h_cnt>658&& h_cnt<662&&over==1) RGB <= 3'd000;
				else if(v_cnt>226&&v_cnt<=230&&h_cnt>659&& h_cnt<663&&over==1) RGB <= 3'd000;
				else if(v_cnt>226&&v_cnt<=230&&h_cnt>659&& h_cnt<663&&over==1) RGB <= 3'd000;
				else if(v_cnt>227&&v_cnt<=231&&h_cnt>660&& h_cnt<664&&over==1) RGB <= 3'd000;
				else if(v_cnt>228&&v_cnt<=232&&h_cnt>661&& h_cnt<665&&over==1) RGB <= 3'd000;
				else if(v_cnt>229&&v_cnt<=233&&h_cnt>662&& h_cnt<666&&over==1) RGB <= 3'd000;
				else if(v_cnt>230&&v_cnt<=234&&h_cnt>663&& h_cnt<667&&over==1) RGB <= 3'd000;
				else if(v_cnt>231&&v_cnt<=235&&h_cnt>664&& h_cnt<668&&over==1) RGB <= 3'd000;

				else if((v_cnt>y && v_cnt<y+20 && h_cnt>x && h_cnt<x+18) )RGB <= 3'd000;	
				else if((v_cnt>y-20 && v_cnt<y && h_cnt>x && h_cnt<x+18)&&(n==1) )RGB <= 3'd000;	
				else if((v_cnt>y && v_cnt<y+20 && h_cnt>(x+18) && h_cnt<x+36)&&(n==2))RGB <= 3'd000;	
				else RGB <= 3'b111;

	end
end			
				



endmodule