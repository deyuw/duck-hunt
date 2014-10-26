//module project(KEY, segA, segB, segC, segD, segE, segF, segG, segDP);
//	input [0:0] KEY;
//	output segA, segB, segC, segD, segE, segF, segG, segDP;
//
//	// cnt is used as a prescaler
//	reg [23:0] cnt;
//	always @(posedge KEY[0]) cnt<=cnt+24'h1;
//	wire cntovf = &cnt;
//
//	// BCD is a counter that counts from 0 to 9
//	reg [3:0] BCD;
//	always @(posedge KEY[0]) if(cntovf) BCD <= (BCD==4'h9 ? 4'h0 : BCD+4'h1);
//
//	reg [7:0] SevenSeg;
//	always @(*)
//	case(BCD)
//		 4'h0: SevenSeg = 8'b11111100;
//		 4'h1: SevenSeg = 8'b01100000;
//		 4'h2: SevenSeg = 8'b11011010;
//		 4'h3: SevenSeg = 8'b11110010;
//		 4'h4: SevenSeg = 8'b01100110;
//		 4'h5: SevenSeg = 8'b10110110;
//		 4'h6: SevenSeg = 8'b10111110;
//		 4'h7: SevenSeg = 8'b11100000;
//		 4'h8: SevenSeg = 8'b11111110;
//		 4'h9: SevenSeg = 8'b11110110;
//		 default: SevenSeg = 8'b00000000;
//	endcase
//
//	assign {segA, segB, segC, segD, segE, segF, segG, segDP} = SevenSeg;
//endmodule


module proj(SW, KEY, HEX0, HEX1, HEX2, HEX3, CLOCK_50, LEDR, CLOCK_27, // 27 MHz
  //  7-SEG Displays
  HEX4, HEX5, HEX6, HEX7,
  //  LEDs
	LEDG,  //  LED Green[8:0]
  // TV Decoder
	TD_RESET, // TV Decoder Reset
  // I2C
  I2C_SDAT, // I2C Data
  I2C_SCLK, // I2C Clock
  // Audio CODEC
  AUD_ADCLRCK, // Audio CODEC ADC LR Clock
  AUD_ADCDAT,  // Audio CODEC ADC Data
  AUD_DACLRCK, // Audio CODEC DAC LR Clock
  AUD_DACDAT,  // Audio CODEC DAC Data
  AUD_BCLK,    // Audio CODEC Bit-Stream Clock
  AUD_XCK,     // Audio CODEC Chip Clock
  GPIO_0
);
  input CLOCK_27; // 27 MHz
  //  7-SEG Displays
  //  LEDs
  output  [8:0]  LEDG;  //  LED Green[8:0]
  // TV Decoder
  output TD_RESET; // TV Decoder Reset
  // I2C
  inout  I2C_SDAT; // I2C Data
  output I2C_SCLK; // I2C Clock
  // Audio CODEC
  output/*inout*/ AUD_ADCLRCK; // Audio CODEC ADC LR Clock
  input	 AUD_ADCDAT;  // Audio CODEC ADC Data
  output /*inout*/  AUD_DACLRCK; // Audio CODEC DAC LR Clock
  output AUD_DACDAT;  // Audio CODEC DAC Data
  inout	 AUD_BCLK;    // Audio CODEC Bit-Stream Clock
  output AUD_XCK;     // Audio CODEC Chip Clock
  inout [19:0] GPIO_0;
  
  
  //SANDBOX
  
  
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	wire [3:0] d0, d1, d2, d3, d4, d5, d6, d7;
	wire o1, o2, o3, o4, o5, o6, o7;
	
	
	
	wire [9:0] inInitial;
	assign inInitial[0] = GPIO_0[0];
	assign inInitial[1] = GPIO_0[2];
	assign inInitial[2] = GPIO_0[4];
	assign inInitial[3] = GPIO_0[6];
	assign inInitial[4] = GPIO_0[8];
	assign inInitial[5] = GPIO_0[10];
	assign inInitial[6] = GPIO_0[12];
	assign inInitial[7] = GPIO_0[14];
	assign inInitial[8] = GPIO_0[16];
	assign inInitial[9] = GPIO_0[18];

	wire [9:0] pulse;
	
	signal_to_pulse(inInitial[0], CLOCK_50, pulse[0]);
	signal_to_pulse(inInitial[1], CLOCK_50, pulse[1]);
	signal_to_pulse(inInitial[2], CLOCK_50, pulse[2]);
	signal_to_pulse(inInitial[3], CLOCK_50, pulse[3]);
	signal_to_pulse(inInitial[4], CLOCK_50, pulse[4]);
	signal_to_pulse(inInitial[5], CLOCK_50, pulse[5]);
	signal_to_pulse(inInitial[6], CLOCK_50, pulse[6]);
	signal_to_pulse(inInitial[7], CLOCK_50, pulse[7]);
	signal_to_pulse(inInitial[8], CLOCK_50, pulse[8]);
	signal_to_pulse(inInitial[9], CLOCK_50, pulse[9]);
	
	wire [9:0] allow;
	
	cooldown(pulse[0] & allow[0], CLOCK_50, allow[0]);
	cooldown(pulse[1] & allow[1], CLOCK_50, allow[1]);
	cooldown(pulse[2] & allow[2], CLOCK_50, allow[2]);
	cooldown(pulse[3] & allow[3], CLOCK_50, allow[3]);
	cooldown(pulse[4] & allow[4], CLOCK_50, allow[4]);
	cooldown(pulse[5] & allow[5], CLOCK_50, allow[5]);
	cooldown(pulse[6] & allow[6], CLOCK_50, allow[6]);
	cooldown(pulse[7] & allow[7], CLOCK_50, allow[7]);
	cooldown(pulse[8] & allow[8], CLOCK_50, allow[8]);
	cooldown(pulse[9] & allow[9], CLOCK_50, allow[9]);
	

	assign GPIO_0[1] = allow[0];
	assign GPIO_0[3] = allow[1];
	assign GPIO_0[5] = allow[2];
	assign GPIO_0[7] = allow[3];
	assign GPIO_0[9] = allow[4];
	assign GPIO_0[11] = allow[5];
	assign GPIO_0[13] = allow[6];
	assign GPIO_0[15] = allow[7];
	assign GPIO_0[17] = allow[8];
	assign GPIO_0[19] = allow[9];
	
	


	wire [9:0] in;
  
	signal_to_pulse(pulse[0] & allow[0], CLOCK_50, in[0]);
	signal_to_pulse(pulse[1] & allow[1], CLOCK_50, in[1]);
	signal_to_pulse(pulse[2] & allow[2], CLOCK_50, in[2]);
	signal_to_pulse(pulse[3] & allow[3], CLOCK_50, in[3]);
	signal_to_pulse(pulse[4] & allow[4], CLOCK_50, in[4]);
	signal_to_pulse(pulse[5] & allow[5], CLOCK_50, in[5]);
	signal_to_pulse(pulse[6] & allow[6], CLOCK_50, in[6]);
	signal_to_pulse(pulse[7] & allow[7], CLOCK_50, in[7]);
	signal_to_pulse(pulse[8] & allow[8], CLOCK_50, in[8]);
	signal_to_pulse(pulse[9] & allow[9], CLOCK_50, in[9]);
  
	wire inP1;
	assign inP1 = in[0] | in[1] | in[2] | in[3] | in[4];
	wire inP2;
	assign inP2 = in[5] | in[6] | in[7] | in[8] | in[9];
	
	wire [31:0] freq1;
	beep_clock_p1(CLOCK_50, inP1, freq1);
	wire [31:0] freq2;
	beep_clock_p2(CLOCK_50, inP2, freq2);

	audio3(CLOCK_50,CLOCK_27,KEY,SW,LEDG,TD_RESET,
		I2C_SDAT,I2C_SCLK,/*inout*/ AUD_ADCLRCK,AUD_ADCDAT,/*inout*/  AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, AUD_XCK, freq1, freq2);
  
  assign re = SW[0];
  
	// Score counters.
	counter_dec(inP1, re, d0, o1);
	counter_dec(o1, re, d1, o2);
	counter_dec(o2, re, d2, o3);
	counter_dec(o3, re, d3, o4);
	
	counter_dec(inP2, re, d4, o5);
	counter_dec(o5, re, d5, o6);
	counter_dec(o6, re, d6, o7);
	counter_dec(o7, re, d7, o8);

	// Score display.
	decoder_7seg_dec(d0, HEX4);
	decoder_7seg_dec(d1, HEX5);

	decoder_7seg_dec(d4, HEX6);
	decoder_7seg_dec(d5, HEX7);
  
  
  //END SANDBOX
  
	input [1:0] SW;
	input [0:0] KEY;
	input CLOCK_50;
	
	output [17:0] LEDR;
	//assign LEDR[1] = KEY[0];
//	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
//	wire [3:0] d0, d1, d2, d3;
//	wire o1, o2, o3, o4;
//	
//	// Score reset.
//	wire re;
//	assign re = SW[0];
//	
//	assign LEDR[17:6] = GPIO_0[13:2];
//	assign GPIO_0[31] = 0;
//	assign GPIO_0[30] = 1;
//	
//	// From photoresistor reaction
//	wire inInitial;
//	assign inInitial = GPIO_0[0];
//	assign LEDR[0] = GPIO_0[0];
//	
//	// Turn laser input into single (<1 clock cycle) pulse
//	wire pulse;
//	signal_to_pulse(inInitial, CLOCK_50, pulse);
//	
//	// On pulse, disable input for 3 seconds.
//	wire allow;	
//	cooldown(pulse & allow, CLOCK_50, allow);
//	
//	// Input to counter, sounds and lights (AFTER COOLDOWN AND PULSE).
//	wire in;
//	signal_to_pulse(pulse & allow, CLOCK_50, in);
//	
//	// LED
//	assign GPIO_0[1] = allow;
//	
//	// debug
//	assign LEDR[1] = allow;
//	assign LEDR[4] = pulse;
//	assign LEDR[5] = inInitial;
//	
//	// Frequency to pass onto audio decoder
//	wire [31:0] freq1;
//	wire [31:0] freq2;
//	beep_clock_p1(CLOCK_50, in, freq1);
//	beep_clock_p2(CLOCK_50, in, freq2);
//	
//	// Audio decoder from online lab examples
//	audio3(CLOCK_50,CLOCK_27,KEY,SW,LEDG,TD_RESET,
//		I2C_SDAT,I2C_SCLK,/*inout*/ AUD_ADCLRCK,AUD_ADCDAT,/*inout*/  AUD_DACLRCK, AUD_DACDAT, AUD_BCLK, AUD_XCK, freq1, freq2);
//	
//	// Flashing lights on input
//	//flash_clock(CLOCK_50, in, GPIO_0[1]);
//	
////	cooldown(CLK50, en, cl); 
//	
//	// Score counters.
//	counter_dec(in, re, d0, o1);
//	counter_dec(o1, re, d1, o2);
//	counter_dec(o2, re, d2, o3);
//	counter_dec(o3, re, d3, o4);
//	
//	// Score display.
//	decoder_7seg_dec(d0, HEX0);
//	decoder_7seg_dec(d1, HEX1);
//	decoder_7seg_dec(d2, HEX2);
//	decoder_7seg_dec(d3, HEX3);
	
endmodule

module beep_clock_p1(CLK, IN, FREQ);

	// Module assumes IN to be a single pulse.
	input CLK, IN;
	output reg [31:0] FREQ;
	
	reg [31:0] counter;
	reg EN;

	reg [31:0] tone1, tone2, tone3;
	
	initial
		begin
		EN <= 0;
		
		// Silent.
		FREQ <= 0;
		
		// Preset sound frequencies to use.
		tone1 <= 523;
		tone2 <= 659;
		tone3 <= 784;
		end
		
	always @(posedge CLK, posedge IN)
		begin
		
		// On input, reset current cycle and allow sounds to play.
		if (IN)
			begin
				counter <= 0;
				FREQ <= 0;
				EN <= 1;
			end

		else if (CLK)
			begin
			counter <= counter + 1;
				if (counter > 15000000)
					begin
					EN <= 0;
					FREQ <= 0;
					end
				else if (counter == 1000000 & EN)
					FREQ <= tone1;
				else if (counter == 5000000 & EN)
					FREQ <= tone2;
				else if (counter == 10000000 & EN)
					FREQ <= tone3;
			end
		end

endmodule

module beep_clock_p2(CLK, IN, FREQ);

	// Module assumes IN to be a single pulse.
	input CLK, IN;
	output reg [31:0] FREQ;
	
	reg [31:0] counter;
	reg EN;

	reg [31:0] tone1, tone2, tone3;
	
	initial
		begin
		EN <= 0;
		
		// Silent.
		FREQ <= 0;
		
		// Preset sound frequencies to use.
		tone1 <= 523;
		tone2 <= 659;
		tone3 <= 784;
		end
		
	always @(posedge CLK, posedge IN)
		begin
		
		// On input, reset current cycle and allow sounds to play.
		if (IN)
			begin
				counter <= 0;
				FREQ <= 0;
				EN <= 1;
			end

		else if (CLK)
			begin
			counter <= counter + 1;
				if (counter > 15000000)
					begin
					EN <= 0;
					FREQ <= 0;
					end
				else if (counter == 1000000 & EN)
					FREQ <= tone3;
				else if (counter == 5000000 & EN)
					FREQ <= tone2;
				else if (counter == 10000000 & EN)
					FREQ <= tone1;
			end
		end

endmodule

module cooldown(in, clk, out);
	// module assumes in is a single pulse.
	input in, clk;
	output reg out;
	reg [31:0] counter;
	
	initial
		out <= 1;
	
	always @(posedge clk, posedge in)
		begin
		if (in)
			begin
			counter <= 0;
			out <= 0;
			end
		else if (clk)
			begin
			counter <= counter + 1;
			if (counter == 150000000)
				out <= 1;
			end
		end

endmodule

module signal_to_pulse(in, clk, out);

	input in, clk;
	output reg out;
	reg en;
	
	initial
		en = 0;
		
	always@(posedge clk, posedge in)
		begin
		if (in)
			begin
			out = en^in;
			en = 1;
			end
		else if (clk)
			begin
			out = 0;
			en = 0;
			end
		end
		
endmodule

module flash_clock(CLK, IN, FLASH);
	reg [31:0] counter;
	reg EN;
	
	input CLK, IN;
	output reg FLASH;
	
	initial
		begin
		EN <= 0;
		FLASH <= 0;
		end
		
	always @(posedge CLK, posedge IN)
		begin
		if (IN)
			begin
			counter <= 0;
			EN <= 1;
			FLASH <= 0;
			end
		else if (CLK)
		
			// Alternating on and off to simulate flashing.
			begin
			counter <= counter + 1;
			if (counter == 100000001)
				begin
				FLASH <= 0;
				EN <= 0;
				end
			else if (counter % 10000000 == 500000 && EN)
				FLASH <= ~FLASH;
			end
		end

		
endmodule

module counter_dec(IN, RESET, OUT, OVERFLOW);
	input IN, RESET;
	output reg [3:0] OUT;
	output reg OVERFLOW;
	
	always @(posedge IN, posedge RESET)
		begin
		if (RESET)
			begin
			OUT <= 0;
			OVERFLOW <= 0;
			end
		else if (IN)
			begin
			if (OUT < 9)
				begin
				OVERFLOW <= 0;
				OUT <= OUT + 1;
				end
			else
				begin
				OUT <= 0;
				OVERFLOW <= 1;
				end
			end
		end
endmodule


//module project(SW, KEY, HEX0, HEX1, HEX2, HEX3);
//	input [1:0] SW;
//	input [0:0] KEY;
//	reg [15:0] Q;
//	output [6:0] HEX0, HEX1, HEX2, HEX3;
//	
//	reg [23:0] cnt;
//	always @(posedge KEY[0]) cnt<=cnt+24'h1;
//	wire cntovf = &cnt;
//	reg [3:0] dec0, dec1, dec2, dec3;
//	always @(posedge KEY[0]) if(cntovf) dec0 <= (dec0==4'h9 ? 4'h0 : dec0+4'h1);
//	//missing carries
//	
//	reg [3:0] counter;
//	
//	always @(negedge KEY[0])
//		begin
//		if (SW[1])
//			Q <= 0;
//		else if (SW[0])
//			begin
//			if (counter < 4'b1001)
//				begin
//				Q <= Q + 1;
//				counter <= counter + 1;
//				end
//			else
//				begin
//				Q <= Q + 7;
//				counter <= 4'b0000;
//				end
//			end
//		end
//	
////	decoder_7seg_dec(dec0, HEX0);
//	decoder_7seg_dec(Q[3:0], HEX0);
//	decoder_7seg_dec(Q[7:4], HEX1);
//	decoder_7seg_dec(Q[11:8], HEX2);
//	decoder_7seg_dec(Q[15:12], HEX3);		
//endmodule

module decoder_7seg_dec(number, pattern);
	input [3:0] number;
	output reg [6:0] pattern;
	
	always @(number)
		begin
		if (number == 4'b0000)
			pattern = 7'b1000000;
		else if (number == 4'b0001)
			pattern = 7'b1111001;
		else if (number == 4'b0010)
			pattern = 7'b0100100;
		else if (number == 4'b0011)
			pattern = 7'b0110000;
		else if (number == 4'b0100)
			pattern = 7'b0011001;
		else if (number == 4'b0101)
			pattern = 7'b0010010;	
		else if (number == 4'b0110)
			pattern = 7'b0000010;
		else if (number == 4'b0111)
			pattern = 7'b1111000;
		else if (number == 4'b1000)
			pattern = 7'b0000000;
		else if (number == 4'b1001)
			pattern = 7'b0010000;
//		else if (number == 4'b1010)
//			pattern = 7'b1000000;
//		else if (number == 4'b1011)
//			begin
//				pattern = 7'b1111001;
//			end
//		else if (number == 4'b1100)
//			begin
//				pattern = 7'b0100100;
//				pattern2 = 7'b1111001;
//			end
//		else if (number == 4'b1101)
//			begin
//				pattern = 7'b0110000;
//				pattern2 = 7'b1111001;
//			end
//		else if (number == 4'b1110)
//			begin
//				pattern = 7'b0011001;
//				pattern2 = 7'b1111001;
//			end
//		else if (number == 4'b1111)
//			begin
//				pattern = 7'b0010010;
//				pattern2 = 7'b1111001;
//			end
		else if (number == 4'b1111)
			pattern = 7'b1000000;
		end
endmodule