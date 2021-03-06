module audio3(
  // Clock Input (50 MHz)
  input CLOCK_50, // 50 MHz
  input CLOCK_27, // 27 MHz
  //  Push Buttons
  input  [3:0]  KEY,
  //  DPDT Switches 
  input  [17:0]  SW,
  //  7-SEG Displays
  //  LEDs
  output  [8:0]  LEDG,  //  LED Green[8:0]
  // TV Decoder
  output TD_RESET, // TV Decoder Reset
  // I2C
  inout  I2C_SDAT, // I2C Data
  output I2C_SCLK, // I2C Clock
  // Audio CODEC
  output/*inout*/ AUD_ADCLRCK, // Audio CODEC ADC LR Clock
  input	 AUD_ADCDAT,  // Audio CODEC ADC Data
  output /*inout*/  AUD_DACLRCK, // Audio CODEC DAC LR Clock
  output AUD_DACDAT,  // Audio CODEC DAC Data
  inout	 AUD_BCLK,    // Audio CODEC Bit-Stream Clock
  output AUD_XCK,     // Audio CODEC Chip Clock
  input [31:0] freq1,
  input [31:0] freq2
);


wire [6:0] myclock;
wire RST;
assign RST = KEY[0];

// reset delay gives some time for peripherals to initialize
wire DLY_RST;
Reset_Delay r0(	.iCLK(CLOCK_50),.oRESET(DLY_RST) );

// Send switches to red leds 
//assign LEDR = SW;

// Turn off green leds
assign LEDG = 0;

// Turn off 7-segment displays
parameter BLANK = 7'h7f;
//assign HEX0 = BLANK;
//assign HEX1 = BLANK;
//assign HEX2 = BLANK;
//assign HEX3 = BLANK;
//assign HEX4 = BLANK;
//assign HEX5 = BLANK;
//assign HEX6 = BLANK;
//assign HEX7 = BLANK;

//hex_7seg d4(SW[17:16],HEX4);
//hex_7seg d3(SW[15:12],HEX3);
//hex_7seg d2(SW[11:8],HEX2);
//hex_7seg d1(SW[7:4],HEX1);
//hex_7seg d0(SW[3:0],HEX0);



assign	TD_RESET = 1'b1;  // Enable 27 MHz

VGA_Audio_PLL 	p1 (	
	.areset(~DLY_RST),
	.inclk0(CLOCK_27),
	.c0(VGA_CTRL_CLK),
	.c1(AUD_CTRL_CLK),
	.c2(VGA_CLK)
);

I2C_AV_Config u3(	
//	Host Side
  .iCLK(CLOCK_50),
  .iRST_N(KEY[0]),
//	I2C Side
  .I2C_SCLK(I2C_SCLK),
  .I2C_SDAT(I2C_SDAT)	
);

assign	AUD_ADCLRCK	=	AUD_DACLRCK;
assign	AUD_XCK		=	AUD_CTRL_CLK;

audio_clock u4(	
//	Audio Side
   .oAUD_BCK(AUD_BCLK),
   .oAUD_LRCK(AUD_DACLRCK),
//	Control Signals
  .iCLK_18_4(AUD_CTRL_CLK),
   .iRST_N(DLY_RST)	
);

audio_converter u5(
	// Audio side
	.AUD_BCK(AUD_BCLK),       // Audio bit clock
	.AUD_LRCK(AUD_DACLRCK), // left-right clock
	.AUD_ADCDAT(AUD_ADCDAT),
	.AUD_DATA(AUD_DACDAT),
	// Controller side
	.iRST_N(DLY_RST),  // reset
	.AUD_outL(audio_outL),
	.AUD_outR(audio_outR),
	.AUD_inL(audio_inL),
	.AUD_inR(audio_inR)
);

wire [15:0] audio_inL, audio_inR;
wire [15:0] audio_outL, audio_outR;
wire [15:0] signal;

//set up DDS frequency
//Use switches to set freq
wire [31:0] dds_incr;
//wire [31:0] freq = SW[3:0]+10*SW[7:4]+100*SW[11:8]+1000*SW[15:12]+10000*SW[17:16];
assign dds_incr = freq1 * 91626 ; //91626 = 2^32/46875 so SW is in Hz



reg [31:0] dds_phase;

always @(negedge AUD_DACLRCK or negedge DLY_RST)
	if (!DLY_RST) dds_phase <= 0;
	else dds_phase <= dds_phase + dds_incr;

wire [7:0] index = dds_phase[31:24];

sine_table sig1(
	.index(index),
	.signal(audio_outR)
);

//set up DDS frequency
//Use switches to set freq
wire [31:0] dds_incr2;
//wire [31:0] freq = SW[3:0]+10*SW[7:4]+100*SW[11:8]+1000*SW[15:12]+10000*SW[17:16];
assign dds_incr2 = freq2 * 91626 ; //91626 = 2^32/46875 so SW is in Hz



reg [31:0] dds_phase2;

always @(negedge AUD_DACLRCK or negedge DLY_RST)
	if (!DLY_RST) dds_phase2 <= 0;
	else dds_phase2 <= dds_phase2 + dds_incr2;

wire [7:0] index2 = dds_phase2[31:24];

sine_table sig2(
	.index(index2),
	.signal(audio_outL)
);

	//audio_outR <= audio_inR;

//always @(posedge AUD_DACLRCK)
//assign audio_outL = 15'h0000;


endmodule

//module Clk_392hz(Clk_50, reset, newClk);
//	reg [32:0] counter;
//	
//	always@(Clk)
//		begin
//		if counter > 127551;
//			begin
//			newClk = 1;
//			counter = 0;
//			end
//		else
//			begin
//			newClk = 0;
//			counter = counter + 1;
//			end
//		end
//endmodule