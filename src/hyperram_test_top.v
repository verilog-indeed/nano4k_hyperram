module hyperram_test_top(
						input crystalClock,
						input reset_n,

						//HyperRAM lines
						output     [0:0]  O_hpram_ck      ,
						output     [0:0]  O_hpram_ck_n    ,
						output     [0:0]  O_hpram_cs_n    ,
						output     [0:0]  O_hpram_reset_n ,
						inout      [7:0]  IO_hpram_dq     ,
						inout      [0:0]  IO_hpram_rwds   
						);
	wire memoryClock;
	wire interfaceClock;
	wire userClock;
	wire pllLock;
	wire initCalibrationComplete;
	wire readDataValid;
	wire[31:0] readReg;
	reg commandEnable;
	reg writeCmd; //1 to perform a write , 0 to perform a read
	reg[21:0] memAddr;
	reg[7:0] writeReg;
	reg[6:0] testStateCounter;

	initial begin
		testStateCounter <= 0;
		commandEnable <= 0;
		writeCmd <= 0;
		memAddr <= 0;
		writeReg <= 8'hFF;
	end	

	Gowin_PLLVR pll(
        .clkout(memoryClock), //primary output 159MHz
        .lock(pllLock), //output lock
        .clkin(crystalClock) //input xtal 27MHz
    );
	
	HyperRAM_Memory_Interface_Top your_instance_name(
		.clk(crystalClock), //crystal reference clock for phase alignement (27MHz)
		.memory_clk(memoryClock), //serial hyperram clock (159MHz)
		.pll_lock(pllLock), //waits for PLL to achieve lock on
		.rst_n(reset_n), //input rst_n

		//-hyperram chip wires-----
		.O_hpram_ck(O_hpram_ck), //output [0:0] O_hpram_ck
		.O_hpram_ck_n(O_hpram_ck_n), //output [0:0] O_hpram_ck_n
		.IO_hpram_dq(IO_hpram_dq), //inout [7:0] IO_hpram_dq
		.IO_hpram_rwds(IO_hpram_rwds), //inout [0:0] IO_hpram_rwds
		.O_hpram_cs_n(O_hpram_cs_n), //output [0:0] O_hpram_cs_n
		.O_hpram_reset_n(O_hpram_reset_n), //output [0:0] O_hpram_reset_n
		//-------------------------

		.wr_data(writeReg), //input [31:0] wr_data
		.rd_data(readReg), //output [31:0] rd_data
		.rd_data_valid(readDataValid), //output rd_data_valid
		.addr(memAddr), //input [21:0] addr, word size is 16-bit (word-addressable)
		.cmd(writeCmd), //input cmd
		.cmd_en(commandEnable), //input cmd_en
		.init_calib(initCalibrationComplete), //goes high when the interface is ready

		//memory_clk divided by 2 (79.5MHz), blocks that use hyperram interface operations should be clocked in this domain
		.clk_out(userClock),
		.data_mask(4'b0) //input [3:0] data_mask (no masking)
	);
	
	always@(posedge userClock) begin
		if (!reset_n || !initCalibrationComplete) begin
			testStateCounter <= 0;
			commandEnable <= 0;
			writeReg <= 8'hFF;
		end else begin
			testStateCounter <= testStateCounter + 1;
			writeReg <= writeReg - 1;
			case (testStateCounter)
			//TODO why is 16 burst not working?
			//TODO test Tcmd timings correctness
				0: begin
					commandEnable <= 0;
					writeReg <= 0;
				end
				1: begin
					memAddr <= 22'hA0;
					writeCmd <= 1;
					commandEnable <= 1;
				end
				2: begin
					commandEnable <= 0;
				end
				19: begin
					memAddr <= 22'hE0;
					writeCmd <= 1;
					commandEnable <= 1;
				end
				20: begin
					commandEnable <= 0;
				end
				50: begin
					commandEnable <= 0;
					writeReg <= 0;
				end
				51: begin
					memAddr <= 22'hA0;
					writeCmd <= 0;
					commandEnable <= 1;
				end
				52: begin
					commandEnable <= 0;
				end

				//19 userClock cycles after last assertion of commandEnable
				69: begin
					memAddr <= 22'hE0;
					writeCmd <= 0;
					commandEnable <= 1;
				end
				70: begin
					commandEnable <= 0;
				end
				default:;
			endcase;
		end
	end
endmodule