/////////////////////////////////////////////////////////////////
// MODULE sha256_system
/////////////////////////////////////////////////////////////////
module sha256_system
(
   input logic clock,
   input logic clock2x,
   input logic resetn,
   // AVS avs_sha256_cra
   input logic avs_sha256_cra_read,
   input logic avs_sha256_cra_write,
   input logic [3:0] avs_sha256_cra_address,
   input logic [63:0] avs_sha256_cra_writedata,
   input logic [7:0] avs_sha256_cra_byteenable,
   output logic avs_sha256_cra_waitrequest,
   output logic [63:0] avs_sha256_cra_readdata,
   output logic avs_sha256_cra_readdatavalid,
   output logic kernel_irq,
   // AVM avm_memgmem0_port_0_0_rw
   output logic avm_memgmem0_port_0_0_rw_read,
   output logic avm_memgmem0_port_0_0_rw_write,
   output logic [4:0] avm_memgmem0_port_0_0_rw_burstcount,
   output logic [29:0] avm_memgmem0_port_0_0_rw_address,
   output logic [255:0] avm_memgmem0_port_0_0_rw_writedata,
   output logic [31:0] avm_memgmem0_port_0_0_rw_byteenable,
   input logic avm_memgmem0_port_0_0_rw_waitrequest,
   input logic [255:0] avm_memgmem0_port_0_0_rw_readdata,
   input logic avm_memgmem0_port_0_0_rw_readdatavalid,
   input logic avm_memgmem0_port_0_0_rw_writeack
);
   logic kernel_irqs;
   logic avm_kernel_rd_read [3];
   logic avm_kernel_rd_write [3];
   logic [4:0] avm_kernel_rd_burstcount [3];
   logic [29:0] avm_kernel_rd_address [3];
   logic [255:0] avm_kernel_rd_writedata [3];
   logic [31:0] avm_kernel_rd_byteenable [3];
   logic avm_kernel_rd_waitrequest [3];
   logic [255:0] avm_kernel_rd_readdata [3];
   logic avm_kernel_rd_readdatavalid [3];
   logic avm_kernel_rd_writeack [3];
   logic avm_kernel_wr_read [2];
   logic avm_kernel_wr_write [2];
   logic [4:0] avm_kernel_wr_burstcount [2];
   logic [29:0] avm_kernel_wr_address [2];
   logic [255:0] avm_kernel_wr_writedata [2];
   logic [31:0] avm_kernel_wr_byteenable [2];
   logic avm_kernel_wr_waitrequest [2];
   logic [255:0] avm_kernel_wr_readdata [2];
   logic avm_kernel_wr_readdatavalid [2];
   logic avm_kernel_wr_writeack [2];
   logic ic_avm_read [1];
   logic ic_avm_write [1];
   logic [4:0] ic_avm_burstcount [1];
   logic [29:0] ic_avm_address [1];
   logic [255:0] ic_avm_writedata [1];
   logic [31:0] ic_avm_byteenable [1];
   logic ic_avm_waitrequest [1];
   logic [255:0] ic_avm_readdata [1];
   logic ic_avm_readdatavalid [1];
   logic ic_avm_writeack [1];

   // INST sha256 of sha256_top_wrapper
   sha256_top_wrapper sha256
   (
      .clock(clock),
      .clock2x(clock2x),
      .resetn(resetn),
      .cra_irq(kernel_irqs),
      // AVS avs_cra
      .avs_cra_read(avs_sha256_cra_read),
      .avs_cra_write(avs_sha256_cra_write),
      .avs_cra_address(avs_sha256_cra_address),
      .avs_cra_writedata(avs_sha256_cra_writedata),
      .avs_cra_byteenable(avs_sha256_cra_byteenable),
      .avs_cra_waitrequest(avs_sha256_cra_waitrequest),
      .avs_cra_readdata(avs_sha256_cra_readdata),
      .avs_cra_readdatavalid(avs_sha256_cra_readdatavalid),
      // AVM avm_local_bb0_ld__inst0
      .avm_local_bb0_ld__inst0_read(avm_kernel_rd_read[0]),
      .avm_local_bb0_ld__inst0_write(avm_kernel_rd_write[0]),
      .avm_local_bb0_ld__inst0_burstcount(avm_kernel_rd_burstcount[0]),
      .avm_local_bb0_ld__inst0_address(avm_kernel_rd_address[0]),
      .avm_local_bb0_ld__inst0_writedata(avm_kernel_rd_writedata[0]),
      .avm_local_bb0_ld__inst0_byteenable(avm_kernel_rd_byteenable[0]),
      .avm_local_bb0_ld__inst0_waitrequest(avm_kernel_rd_waitrequest[0]),
      .avm_local_bb0_ld__inst0_readdata(avm_kernel_rd_readdata[0]),
      .avm_local_bb0_ld__inst0_readdatavalid(avm_kernel_rd_readdatavalid[0]),
      .avm_local_bb0_ld__inst0_writeack(avm_kernel_rd_writeack[0]),
      // AVM avm_local_bb0_st__inst0
      .avm_local_bb0_st__inst0_read(avm_kernel_wr_read[0]),
      .avm_local_bb0_st__inst0_write(avm_kernel_wr_write[0]),
      .avm_local_bb0_st__inst0_burstcount(avm_kernel_wr_burstcount[0]),
      .avm_local_bb0_st__inst0_address(avm_kernel_wr_address[0]),
      .avm_local_bb0_st__inst0_writedata(avm_kernel_wr_writedata[0]),
      .avm_local_bb0_st__inst0_byteenable(avm_kernel_wr_byteenable[0]),
      .avm_local_bb0_st__inst0_waitrequest(avm_kernel_wr_waitrequest[0]),
      .avm_local_bb0_st__inst0_readdata(avm_kernel_wr_readdata[0]),
      .avm_local_bb0_st__inst0_readdatavalid(avm_kernel_wr_readdatavalid[0]),
      .avm_local_bb0_st__inst0_writeack(avm_kernel_wr_writeack[0]),
      // AVM avm_local_bb4_ld_memcoalesce_key_load_0_inst0
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_read(avm_kernel_rd_read[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_write(avm_kernel_rd_write[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_burstcount(avm_kernel_rd_burstcount[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_address(avm_kernel_rd_address[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writedata(avm_kernel_rd_writedata[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_byteenable(avm_kernel_rd_byteenable[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_waitrequest(avm_kernel_rd_waitrequest[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdata(avm_kernel_rd_readdata[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdatavalid(avm_kernel_rd_readdatavalid[1]),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writeack(avm_kernel_rd_writeack[1]),
      // AVM avm_local_bb5_ld_memcoalesce_key_load_02_inst0
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_read(avm_kernel_rd_read[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_write(avm_kernel_rd_write[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_burstcount(avm_kernel_rd_burstcount[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_address(avm_kernel_rd_address[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writedata(avm_kernel_rd_writedata[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_byteenable(avm_kernel_rd_byteenable[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_waitrequest(avm_kernel_rd_waitrequest[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdata(avm_kernel_rd_readdata[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdatavalid(avm_kernel_rd_readdatavalid[2]),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writeack(avm_kernel_rd_writeack[2]),
      // AVM avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_read(avm_kernel_wr_read[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_write(avm_kernel_wr_write[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_burstcount(avm_kernel_wr_burstcount[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_address(avm_kernel_wr_address[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writedata(avm_kernel_wr_writedata[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_byteenable(avm_kernel_wr_byteenable[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_waitrequest(avm_kernel_wr_waitrequest[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdata(avm_kernel_wr_readdata[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdatavalid(avm_kernel_wr_readdatavalid[1]),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writeack(avm_kernel_wr_writeack[1])
   );

   assign kernel_irq = |kernel_irqs;
   // INST lsu_ic_top of lsu_ic_top
   lsu_ic_top
   #(
      .AWIDTH(30),
      .SHIFT(30),
      .MWIDTH_BYTES(32),
      .BURST_CNT_W(5),
      .NUM_RD_PORT(3),
      .NUM_WR_PORT(2),
      .NUM_DIMM(1),
      .ENABLE_DUAL_RING(0),
      .ENABLE_MULTIPLE_WR_RING(0),
      .ENABLE_LAST_WAIT(0),
      .ENABLE_REORDER(0),
      .NUM_REORDER(1)
   )
   lsu_ic_top
   (
      .clk(clock),
      .resetn(resetn),
      .i_rd_request(avm_kernel_rd_read),
      .i_rd_address(avm_kernel_rd_address),
      .i_rd_burstcount(avm_kernel_rd_burstcount),
      .i_wr_byteenable(avm_kernel_wr_byteenable),
      .i_wr_address(avm_kernel_wr_address),
      .i_wr_request(avm_kernel_wr_write),
      .i_wr_burstcount(avm_kernel_wr_burstcount),
      .i_wr_writedata(avm_kernel_wr_writedata),
      .i_avm_waitrequest(ic_avm_waitrequest),
      .i_avm_readdata(ic_avm_readdata),
      .i_avm_readdatavalid(ic_avm_readdatavalid),
      .o_avm_byteenable(ic_avm_byteenable),
      .o_avm_address(ic_avm_address),
      .o_avm_read(ic_avm_read),
      .o_avm_write(ic_avm_write),
      .o_avm_burstcount(ic_avm_burstcount),
      .o_wr_waitrequest(avm_kernel_wr_waitrequest),
      .o_avm_writedata(ic_avm_writedata),
      .o_avm_writeack(avm_kernel_wr_writeack),
      .o_rd_waitrequest(avm_kernel_rd_waitrequest),
      .o_avm_readdata(avm_kernel_rd_readdata),
      .o_avm_readdatavalid(avm_kernel_rd_readdatavalid)
   );

   assign avm_memgmem0_port_0_0_rw_read = ic_avm_read[0];
   assign avm_memgmem0_port_0_0_rw_write = ic_avm_write[0];
   assign avm_memgmem0_port_0_0_rw_burstcount = ic_avm_burstcount[0];
   assign avm_memgmem0_port_0_0_rw_address = ic_avm_address[0];
   assign avm_memgmem0_port_0_0_rw_writedata = ic_avm_writedata[0];
   assign avm_memgmem0_port_0_0_rw_byteenable = ic_avm_byteenable[0];
   assign ic_avm_waitrequest[0] = avm_memgmem0_port_0_0_rw_waitrequest;
   assign ic_avm_readdata[0] = avm_memgmem0_port_0_0_rw_readdata;
   assign ic_avm_readdatavalid[0] = avm_memgmem0_port_0_0_rw_readdatavalid;
endmodule

/////////////////////////////////////////////////////////////////
// MODULE sha256_top_wrapper
/////////////////////////////////////////////////////////////////
module sha256_top_wrapper
(
   input logic clock,
   input logic clock2x,
   input logic resetn,
   output logic cra_irq,
   // AVS avs_cra
   input logic avs_cra_read,
   input logic avs_cra_write,
   input logic [3:0] avs_cra_address,
   input logic [63:0] avs_cra_writedata,
   input logic [7:0] avs_cra_byteenable,
   output logic avs_cra_waitrequest,
   output logic [63:0] avs_cra_readdata,
   output logic avs_cra_readdatavalid,
   // AVM avm_local_bb0_ld__inst0
   output logic avm_local_bb0_ld__inst0_read,
   output logic avm_local_bb0_ld__inst0_write,
   output logic [4:0] avm_local_bb0_ld__inst0_burstcount,
   output logic [29:0] avm_local_bb0_ld__inst0_address,
   output logic [255:0] avm_local_bb0_ld__inst0_writedata,
   output logic [31:0] avm_local_bb0_ld__inst0_byteenable,
   input logic avm_local_bb0_ld__inst0_waitrequest,
   input logic [255:0] avm_local_bb0_ld__inst0_readdata,
   input logic avm_local_bb0_ld__inst0_readdatavalid,
   input logic avm_local_bb0_ld__inst0_writeack,
   // AVM avm_local_bb0_st__inst0
   output logic avm_local_bb0_st__inst0_read,
   output logic avm_local_bb0_st__inst0_write,
   output logic [4:0] avm_local_bb0_st__inst0_burstcount,
   output logic [29:0] avm_local_bb0_st__inst0_address,
   output logic [255:0] avm_local_bb0_st__inst0_writedata,
   output logic [31:0] avm_local_bb0_st__inst0_byteenable,
   input logic avm_local_bb0_st__inst0_waitrequest,
   input logic [255:0] avm_local_bb0_st__inst0_readdata,
   input logic avm_local_bb0_st__inst0_readdatavalid,
   input logic avm_local_bb0_st__inst0_writeack,
   // AVM avm_local_bb4_ld_memcoalesce_key_load_0_inst0
   output logic avm_local_bb4_ld_memcoalesce_key_load_0_inst0_read,
   output logic avm_local_bb4_ld_memcoalesce_key_load_0_inst0_write,
   output logic [4:0] avm_local_bb4_ld_memcoalesce_key_load_0_inst0_burstcount,
   output logic [29:0] avm_local_bb4_ld_memcoalesce_key_load_0_inst0_address,
   output logic [255:0] avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writedata,
   output logic [31:0] avm_local_bb4_ld_memcoalesce_key_load_0_inst0_byteenable,
   input logic avm_local_bb4_ld_memcoalesce_key_load_0_inst0_waitrequest,
   input logic [255:0] avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdata,
   input logic avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdatavalid,
   input logic avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writeack,
   // AVM avm_local_bb5_ld_memcoalesce_key_load_02_inst0
   output logic avm_local_bb5_ld_memcoalesce_key_load_02_inst0_read,
   output logic avm_local_bb5_ld_memcoalesce_key_load_02_inst0_write,
   output logic [4:0] avm_local_bb5_ld_memcoalesce_key_load_02_inst0_burstcount,
   output logic [29:0] avm_local_bb5_ld_memcoalesce_key_load_02_inst0_address,
   output logic [255:0] avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writedata,
   output logic [31:0] avm_local_bb5_ld_memcoalesce_key_load_02_inst0_byteenable,
   input logic avm_local_bb5_ld_memcoalesce_key_load_02_inst0_waitrequest,
   input logic [255:0] avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdata,
   input logic avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdatavalid,
   input logic avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writeack,
   // AVM avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0
   output logic avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_read,
   output logic avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_write,
   output logic [4:0] avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_burstcount,
   output logic [29:0] avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_address,
   output logic [255:0] avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writedata,
   output logic [31:0] avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_byteenable,
   input logic avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_waitrequest,
   input logic [255:0] avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdata,
   input logic avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdatavalid,
   input logic avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writeack
);
   genvar i;
   genvar j;
   logic lmem_invalid_single_bit;
   logic lmem_invalid_aspaces;
   logic local_avm_aspace5_read [1][10];
   logic local_avm_aspace5_write [1][10];
   logic local_avm_aspace5_burstcount [1][10];
   logic [31:0] local_avm_aspace5_address [1][10];
   logic [511:0] local_avm_aspace5_writedata [1][10];
   logic [63:0] local_avm_aspace5_byteenable [1][10];
   logic local_avm_aspace5_waitrequest [1][10];
   logic [511:0] local_avm_aspace5_readdata [1][10];
   logic local_avm_aspace5_readdatavalid [1][10];
   logic local_avm_aspace5_writeack [1][10];

   // INST kernel of sha256_function_wrapper
   sha256_function_wrapper kernel
   (
      .local_router_hang(lmem_invalid_single_bit),
      .clock(clock),
      .clock2x(clock2x),
      .resetn(resetn),
      .cra_irq(cra_irq),
      // AVS avs_cra
      .avs_cra_read(avs_cra_read),
      .avs_cra_write(avs_cra_write),
      .avs_cra_address(avs_cra_address),
      .avs_cra_writedata(avs_cra_writedata),
      .avs_cra_byteenable(avs_cra_byteenable),
      .avs_cra_waitrequest(avs_cra_waitrequest),
      .avs_cra_readdata(avs_cra_readdata),
      .avs_cra_readdatavalid(avs_cra_readdatavalid),
      // AVM avm_local_bb0_ld__inst0
      .avm_local_bb0_ld__inst0_read(avm_local_bb0_ld__inst0_read),
      .avm_local_bb0_ld__inst0_write(avm_local_bb0_ld__inst0_write),
      .avm_local_bb0_ld__inst0_burstcount(avm_local_bb0_ld__inst0_burstcount),
      .avm_local_bb0_ld__inst0_address(avm_local_bb0_ld__inst0_address),
      .avm_local_bb0_ld__inst0_writedata(avm_local_bb0_ld__inst0_writedata),
      .avm_local_bb0_ld__inst0_byteenable(avm_local_bb0_ld__inst0_byteenable),
      .avm_local_bb0_ld__inst0_waitrequest(avm_local_bb0_ld__inst0_waitrequest),
      .avm_local_bb0_ld__inst0_readdata(avm_local_bb0_ld__inst0_readdata),
      .avm_local_bb0_ld__inst0_readdatavalid(avm_local_bb0_ld__inst0_readdatavalid),
      .avm_local_bb0_ld__inst0_writeack(avm_local_bb0_ld__inst0_writeack),
      // AVM avm_local_bb0_st__inst0
      .avm_local_bb0_st__inst0_read(avm_local_bb0_st__inst0_read),
      .avm_local_bb0_st__inst0_write(avm_local_bb0_st__inst0_write),
      .avm_local_bb0_st__inst0_burstcount(avm_local_bb0_st__inst0_burstcount),
      .avm_local_bb0_st__inst0_address(avm_local_bb0_st__inst0_address),
      .avm_local_bb0_st__inst0_writedata(avm_local_bb0_st__inst0_writedata),
      .avm_local_bb0_st__inst0_byteenable(avm_local_bb0_st__inst0_byteenable),
      .avm_local_bb0_st__inst0_waitrequest(avm_local_bb0_st__inst0_waitrequest),
      .avm_local_bb0_st__inst0_readdata(avm_local_bb0_st__inst0_readdata),
      .avm_local_bb0_st__inst0_readdatavalid(avm_local_bb0_st__inst0_readdatavalid),
      .avm_local_bb0_st__inst0_writeack(avm_local_bb0_st__inst0_writeack),
      // AVM avm_local_bb4_ld_memcoalesce_key_load_0_inst0
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_read(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_read),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_write(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_write),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_burstcount(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_burstcount),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_address(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_address),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writedata(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writedata),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_byteenable(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_byteenable),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_waitrequest(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_waitrequest),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdata(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdata),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdatavalid(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_readdatavalid),
      .avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writeack(avm_local_bb4_ld_memcoalesce_key_load_0_inst0_writeack),
      // AVM avm_local_bb5_ld_memcoalesce_key_load_02_inst0
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_read(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_read),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_write(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_write),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_burstcount(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_burstcount),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_address(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_address),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writedata(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writedata),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_byteenable(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_byteenable),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_waitrequest(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_waitrequest),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdata(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdata),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdatavalid(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_readdatavalid),
      .avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writeack(avm_local_bb5_ld_memcoalesce_key_load_02_inst0_writeack),
      // AVM avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_read(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_read),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_write(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_write),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_burstcount(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_burstcount),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_address(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_address),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writedata(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writedata),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_byteenable(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_byteenable),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_waitrequest(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_waitrequest),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdata(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdata),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdatavalid(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_readdatavalid),
      .avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writeack(avm_local_bb7_st_memcoalesce_digest_insertValue_17_inst0_writeack),
      // AVM avm_local_bb2_st__inst0
      .avm_local_bb2_st__inst0_read(local_avm_aspace5_read[0][0]),
      .avm_local_bb2_st__inst0_write(local_avm_aspace5_write[0][0]),
      .avm_local_bb2_st__inst0_burstcount(local_avm_aspace5_burstcount[0][0]),
      .avm_local_bb2_st__inst0_address(local_avm_aspace5_address[0][0]),
      .avm_local_bb2_st__inst0_writedata(local_avm_aspace5_writedata[0][0]),
      .avm_local_bb2_st__inst0_byteenable(local_avm_aspace5_byteenable[0][0]),
      .avm_local_bb2_st__inst0_waitrequest(local_avm_aspace5_waitrequest[0][0]),
      .avm_local_bb2_st__inst0_readdata(local_avm_aspace5_readdata[0][0]),
      .avm_local_bb2_st__inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][0]),
      .avm_local_bb2_st__inst0_writeack(local_avm_aspace5_writeack[0][0]),
      // AVM avm_local_bb4_st_reduction_2_inst0
      .avm_local_bb4_st_reduction_2_inst0_read(local_avm_aspace5_read[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_write(local_avm_aspace5_write[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_burstcount(local_avm_aspace5_burstcount[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_address(local_avm_aspace5_address[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_writedata(local_avm_aspace5_writedata[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_byteenable(local_avm_aspace5_byteenable[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_waitrequest(local_avm_aspace5_waitrequest[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_readdata(local_avm_aspace5_readdata[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][1]),
      .avm_local_bb4_st_reduction_2_inst0_writeack(local_avm_aspace5_writeack[0][1]),
      // AVM avm_local_bb5_st__113_inst0
      .avm_local_bb5_st__113_inst0_read(local_avm_aspace5_read[0][2]),
      .avm_local_bb5_st__113_inst0_write(local_avm_aspace5_write[0][2]),
      .avm_local_bb5_st__113_inst0_burstcount(local_avm_aspace5_burstcount[0][2]),
      .avm_local_bb5_st__113_inst0_address(local_avm_aspace5_address[0][2]),
      .avm_local_bb5_st__113_inst0_writedata(local_avm_aspace5_writedata[0][2]),
      .avm_local_bb5_st__113_inst0_byteenable(local_avm_aspace5_byteenable[0][2]),
      .avm_local_bb5_st__113_inst0_waitrequest(local_avm_aspace5_waitrequest[0][2]),
      .avm_local_bb5_st__113_inst0_readdata(local_avm_aspace5_readdata[0][2]),
      .avm_local_bb5_st__113_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][2]),
      .avm_local_bb5_st__113_inst0_writeack(local_avm_aspace5_writeack[0][2]),
      // AVM avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_read(local_avm_aspace5_read[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_write(local_avm_aspace5_write[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_burstcount(local_avm_aspace5_burstcount[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_address(local_avm_aspace5_address[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_writedata(local_avm_aspace5_writedata[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_byteenable(local_avm_aspace5_byteenable[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_waitrequest(local_avm_aspace5_waitrequest[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_readdata(local_avm_aspace5_readdata[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][3]),
      .avm_local_bb5_st_memcoalesce_null_insertValue_0_inst0_writeack(local_avm_aspace5_writeack[0][3]),
      // AVM avm_local_bb6_ld__inst0
      .avm_local_bb6_ld__inst0_read(local_avm_aspace5_read[0][4]),
      .avm_local_bb6_ld__inst0_write(local_avm_aspace5_write[0][4]),
      .avm_local_bb6_ld__inst0_burstcount(local_avm_aspace5_burstcount[0][4]),
      .avm_local_bb6_ld__inst0_address(local_avm_aspace5_address[0][4]),
      .avm_local_bb6_ld__inst0_writedata(local_avm_aspace5_writedata[0][4]),
      .avm_local_bb6_ld__inst0_byteenable(local_avm_aspace5_byteenable[0][4]),
      .avm_local_bb6_ld__inst0_waitrequest(local_avm_aspace5_waitrequest[0][4]),
      .avm_local_bb6_ld__inst0_readdata(local_avm_aspace5_readdata[0][4]),
      .avm_local_bb6_ld__inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][4]),
      .avm_local_bb6_ld__inst0_writeack(local_avm_aspace5_writeack[0][4]),
      // AVM avm_local_bb6_ld__pre65_inst0
      .avm_local_bb6_ld__pre65_inst0_read(local_avm_aspace5_read[0][5]),
      .avm_local_bb6_ld__pre65_inst0_write(local_avm_aspace5_write[0][5]),
      .avm_local_bb6_ld__pre65_inst0_burstcount(local_avm_aspace5_burstcount[0][5]),
      .avm_local_bb6_ld__pre65_inst0_address(local_avm_aspace5_address[0][5]),
      .avm_local_bb6_ld__pre65_inst0_writedata(local_avm_aspace5_writedata[0][5]),
      .avm_local_bb6_ld__pre65_inst0_byteenable(local_avm_aspace5_byteenable[0][5]),
      .avm_local_bb6_ld__pre65_inst0_waitrequest(local_avm_aspace5_waitrequest[0][5]),
      .avm_local_bb6_ld__pre65_inst0_readdata(local_avm_aspace5_readdata[0][5]),
      .avm_local_bb6_ld__pre65_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][5]),
      .avm_local_bb6_ld__pre65_inst0_writeack(local_avm_aspace5_writeack[0][5]),
      // AVM avm_local_bb6_ld__u41_inst0
      .avm_local_bb6_ld__u41_inst0_read(local_avm_aspace5_read[0][6]),
      .avm_local_bb6_ld__u41_inst0_write(local_avm_aspace5_write[0][6]),
      .avm_local_bb6_ld__u41_inst0_burstcount(local_avm_aspace5_burstcount[0][6]),
      .avm_local_bb6_ld__u41_inst0_address(local_avm_aspace5_address[0][6]),
      .avm_local_bb6_ld__u41_inst0_writedata(local_avm_aspace5_writedata[0][6]),
      .avm_local_bb6_ld__u41_inst0_byteenable(local_avm_aspace5_byteenable[0][6]),
      .avm_local_bb6_ld__u41_inst0_waitrequest(local_avm_aspace5_waitrequest[0][6]),
      .avm_local_bb6_ld__u41_inst0_readdata(local_avm_aspace5_readdata[0][6]),
      .avm_local_bb6_ld__u41_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][6]),
      .avm_local_bb6_ld__u41_inst0_writeack(local_avm_aspace5_writeack[0][6]),
      // AVM avm_local_bb6_ld__u42_inst0
      .avm_local_bb6_ld__u42_inst0_read(local_avm_aspace5_read[0][7]),
      .avm_local_bb6_ld__u42_inst0_write(local_avm_aspace5_write[0][7]),
      .avm_local_bb6_ld__u42_inst0_burstcount(local_avm_aspace5_burstcount[0][7]),
      .avm_local_bb6_ld__u42_inst0_address(local_avm_aspace5_address[0][7]),
      .avm_local_bb6_ld__u42_inst0_writedata(local_avm_aspace5_writedata[0][7]),
      .avm_local_bb6_ld__u42_inst0_byteenable(local_avm_aspace5_byteenable[0][7]),
      .avm_local_bb6_ld__u42_inst0_waitrequest(local_avm_aspace5_waitrequest[0][7]),
      .avm_local_bb6_ld__u42_inst0_readdata(local_avm_aspace5_readdata[0][7]),
      .avm_local_bb6_ld__u42_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][7]),
      .avm_local_bb6_ld__u42_inst0_writeack(local_avm_aspace5_writeack[0][7]),
      // AVM avm_local_bb6_ld__u43_inst0
      .avm_local_bb6_ld__u43_inst0_read(local_avm_aspace5_read[0][8]),
      .avm_local_bb6_ld__u43_inst0_write(local_avm_aspace5_write[0][8]),
      .avm_local_bb6_ld__u43_inst0_burstcount(local_avm_aspace5_burstcount[0][8]),
      .avm_local_bb6_ld__u43_inst0_address(local_avm_aspace5_address[0][8]),
      .avm_local_bb6_ld__u43_inst0_writedata(local_avm_aspace5_writedata[0][8]),
      .avm_local_bb6_ld__u43_inst0_byteenable(local_avm_aspace5_byteenable[0][8]),
      .avm_local_bb6_ld__u43_inst0_waitrequest(local_avm_aspace5_waitrequest[0][8]),
      .avm_local_bb6_ld__u43_inst0_readdata(local_avm_aspace5_readdata[0][8]),
      .avm_local_bb6_ld__u43_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][8]),
      .avm_local_bb6_ld__u43_inst0_writeack(local_avm_aspace5_writeack[0][8]),
      // AVM avm_local_bb6_st_reduction_9_inst0
      .avm_local_bb6_st_reduction_9_inst0_read(local_avm_aspace5_read[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_write(local_avm_aspace5_write[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_burstcount(local_avm_aspace5_burstcount[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_address(local_avm_aspace5_address[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_writedata(local_avm_aspace5_writedata[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_byteenable(local_avm_aspace5_byteenable[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_waitrequest(local_avm_aspace5_waitrequest[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_readdata(local_avm_aspace5_readdata[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_readdatavalid(local_avm_aspace5_readdatavalid[0][9]),
      .avm_local_bb6_st_reduction_9_inst0_writeack(local_avm_aspace5_writeack[0][9])
   );

   assign lmem_invalid_single_bit = |lmem_invalid_aspaces;
   generate
   begin:local_mem_system_aspace5
      logic local_icm_arb_request [1][10];
      logic local_icm_arb_read [1][10];
      logic local_icm_arb_write [1][10];
      logic local_icm_arb_burstcount [1][10];
      logic [2:0] local_icm_arb_address [1][10];
      logic [511:0] local_icm_arb_writedata [1][10];
      logic [63:0] local_icm_arb_byteenable [1][10];
      logic local_icm_arb_stall [1][10];
      logic local_icm_wrp_ack [1][10];
      logic local_icm_rrp_datavalid [1][10];
      logic [511:0] local_icm_rrp_data [1][10];
      logic invalid_access_grps;

      for( i = 0; i < 1; i = i + 1 )
      begin:local_mem_group
         logic [2:0] invalid_access_terms;

         for( j = 0; j < 10; j = j + 1 )
         begin:master
            // INST avm_to_ic of acl_avm_to_ic
            acl_avm_to_ic
            #(
               .DATA_W(512),
               .WRITEDATA_W(512),
               .BURSTCOUNT_W(1),
               .ADDRESS_W(32),
               .BYTEENA_W(64)
            )
            avm_to_ic
            (
               // AVM avm
               .avm_read(local_avm_aspace5_read[i][j]),
               .avm_write(local_avm_aspace5_write[i][j]),
               .avm_burstcount(local_avm_aspace5_burstcount[i][j]),
               .avm_address(local_avm_aspace5_address[i][j]),
               .avm_writedata(local_avm_aspace5_writedata[i][j]),
               .avm_byteenable(local_avm_aspace5_byteenable[i][j]),
               .avm_waitrequest(local_avm_aspace5_waitrequest[i][j]),
               .avm_readdata(local_avm_aspace5_readdata[i][j]),
               .avm_readdatavalid(local_avm_aspace5_readdatavalid[i][j]),
               .avm_writeack(local_avm_aspace5_writeack[i][j]),
               // ICM ic
               .ic_arb_request(local_icm_arb_request[i][j]),
               .ic_arb_read(local_icm_arb_read[i][j]),
               .ic_arb_write(local_icm_arb_write[i][j]),
               .ic_arb_burstcount(local_icm_arb_burstcount[i][j]),
               .ic_arb_address(local_icm_arb_address[i][j]),
               .ic_arb_writedata(local_icm_arb_writedata[i][j]),
               .ic_arb_byteenable(local_icm_arb_byteenable[i][j]),
               .ic_arb_stall(local_icm_arb_stall[i][j]),
               .ic_wrp_ack(local_icm_wrp_ack[i][j]),
               .ic_rrp_datavalid(local_icm_rrp_datavalid[i][j]),
               .ic_rrp_data(local_icm_rrp_data[i][j])
            );

         end

         for( j = 0; j < 4; j = j + 1 )
         begin:bank
            logic port_read [1:4];
            logic port_write [1:4];
            logic port_address [1:4];
            logic [511:0] port_writedata [1:4];
            logic [63:0] port_byteenable [1:4];
            logic port_waitrequest [1:4];
            logic [511:0] port_readdata [1:4];
            logic port_readdatavalid [1:4];

            // INST mem0 of acl_mem2x
            acl_mem2x
            #(
               .DEPTH_WORDS(2),
               .WIDTH(512),
               .RDW_MODE("DONT_CARE"),
               .RAM_OPERATION_MODE("BIDIR_DUAL_PORT"),
               .RAM_BLOCK_TYPE("M10K")
            )
            mem0
            (
               .clk(clock),
               .clk2x(clock2x),
               .resetn(resetn),
               // AVS avs_port1
               .avs_port1_read(port_read[1]),
               .avs_port1_write(port_write[1]),
               .avs_port1_address(port_address[1]),
               .avs_port1_writedata(port_writedata[1]),
               .avs_port1_byteenable(port_byteenable[1]),
               .avs_port1_waitrequest(port_waitrequest[1]),
               .avs_port1_readdata(port_readdata[1]),
               .avs_port1_readdatavalid(port_readdatavalid[1]),
               // AVS avs_port2
               .avs_port2_read(port_read[2]),
               .avs_port2_write(port_write[2]),
               .avs_port2_address(port_address[2]),
               .avs_port2_writedata(port_writedata[2]),
               .avs_port2_byteenable(port_byteenable[2]),
               .avs_port2_waitrequest(port_waitrequest[2]),
               .avs_port2_readdata(port_readdata[2]),
               .avs_port2_readdatavalid(port_readdatavalid[2]),
               // AVS avs_port3
               .avs_port3_read(port_read[3]),
               .avs_port3_write(port_write[3]),
               .avs_port3_address(port_address[3]),
               .avs_port3_writedata(port_writedata[3]),
               .avs_port3_byteenable(port_byteenable[3]),
               .avs_port3_waitrequest(port_waitrequest[3]),
               .avs_port3_readdata(port_readdata[3]),
               .avs_port3_readdatavalid(port_readdatavalid[3]),
               // AVS avs_port4
               .avs_port4_read(port_read[4]),
               .avs_port4_write(port_write[4]),
               .avs_port4_address(port_address[4]),
               .avs_port4_writedata(port_writedata[4]),
               .avs_port4_byteenable(port_byteenable[4]),
               .avs_port4_waitrequest(port_waitrequest[4]),
               .avs_port4_readdata(port_readdata[4]),
               .avs_port4_readdatavalid(port_readdatavalid[4])
            );

         end

         for( j = 0; j < 10; j = j + 1 )
         begin:router
            logic b_arb_request [4];
            logic b_arb_read [4];
            logic b_arb_write [4];
            logic b_arb_burstcount [4];
            logic b_arb_address [4];
            logic [511:0] b_arb_writedata [4];
            logic [63:0] b_arb_byteenable [4];
            logic b_arb_stall [4];
            logic b_wrp_ack [4];
            logic b_rrp_datavalid [4];
            logic [511:0] b_rrp_data [4];
            logic [3:0] bank_select;

            // INST router of acl_ic_local_mem_router
            acl_ic_local_mem_router
            #(
               .DATA_W(512),
               .BURSTCOUNT_W(1),
               .ADDRESS_W(3),
               .BYTEENA_W(64),
               .NUM_BANKS(4)
            )
            router
            (
               .clock(clock),
               .resetn(resetn),
               .bank_select(bank_select),
               // ICM m
               .m_arb_request(local_icm_arb_request[i][j]),
               .m_arb_read(local_icm_arb_read[i][j]),
               .m_arb_write(local_icm_arb_write[i][j]),
               .m_arb_burstcount(local_icm_arb_burstcount[i][j]),
               .m_arb_address(local_icm_arb_address[i][j]),
               .m_arb_writedata(local_icm_arb_writedata[i][j]),
               .m_arb_byteenable(local_icm_arb_byteenable[i][j]),
               .m_arb_stall(local_icm_arb_stall[i][j]),
               .m_wrp_ack(local_icm_wrp_ack[i][j]),
               .m_rrp_datavalid(local_icm_rrp_datavalid[i][j]),
               .m_rrp_data(local_icm_rrp_data[i][j]),
               // ICM b
               .b_arb_request(b_arb_request),
               .b_arb_read(b_arb_read),
               .b_arb_write(b_arb_write),
               .b_arb_burstcount(b_arb_burstcount),
               .b_arb_address(b_arb_address),
               .b_arb_writedata(b_arb_writedata),
               .b_arb_byteenable(b_arb_byteenable),
               .b_arb_stall(b_arb_stall),
               .b_wrp_ack(b_wrp_ack),
               .b_rrp_datavalid(b_rrp_datavalid),
               .b_rrp_data(b_rrp_data)
            );

            assign bank_select[0] = (local_icm_arb_address[i][j][2:1] == 2'b00);
            assign bank_select[1] = (local_icm_arb_address[i][j][2:1] == 2'b01);
            assign bank_select[2] = (local_icm_arb_address[i][j][2:1] == 2'b10);
            assign bank_select[3] = (local_icm_arb_address[i][j][2:1] == 2'b11);
         end

         assign invalid_access_grps = |invalid_access_terms;
         // INST acl_ic_local_mem_router_terminator_m3b1 of acl_ic_local_mem_router_terminator
         acl_ic_local_mem_router_terminator
         #(
            .DATA_W(512)
         )
         acl_ic_local_mem_router_terminator_m3b1
         (
            .clock(clock),
            .resetn(resetn),
            .b_arb_request(router[3].b_arb_request[1]),
            .b_arb_read(router[3].b_arb_read[1]),
            .b_arb_write(router[3].b_arb_write[1]),
            .b_arb_stall(router[3].b_arb_stall[1]),
            .b_wrp_ack(router[3].b_wrp_ack[1]),
            .b_rrp_datavalid(router[3].b_rrp_datavalid[1]),
            .b_rrp_data(router[3].b_rrp_data[1]),
            .b_invalid_access(invalid_access_terms[0])
         );

         // INST acl_ic_local_mem_router_terminator_m3b2 of acl_ic_local_mem_router_terminator
         acl_ic_local_mem_router_terminator
         #(
            .DATA_W(512)
         )
         acl_ic_local_mem_router_terminator_m3b2
         (
            .clock(clock),
            .resetn(resetn),
            .b_arb_request(router[3].b_arb_request[2]),
            .b_arb_read(router[3].b_arb_read[2]),
            .b_arb_write(router[3].b_arb_write[2]),
            .b_arb_stall(router[3].b_arb_stall[2]),
            .b_wrp_ack(router[3].b_wrp_ack[2]),
            .b_rrp_datavalid(router[3].b_rrp_datavalid[2]),
            .b_rrp_data(router[3].b_rrp_data[2]),
            .b_invalid_access(invalid_access_terms[1])
         );

         // INST acl_ic_local_mem_router_terminator_m3b3 of acl_ic_local_mem_router_terminator
         acl_ic_local_mem_router_terminator
         #(
            .DATA_W(512)
         )
         acl_ic_local_mem_router_terminator_m3b3
         (
            .clock(clock),
            .resetn(resetn),
            .b_arb_request(router[3].b_arb_request[3]),
            .b_arb_read(router[3].b_arb_read[3]),
            .b_arb_write(router[3].b_arb_write[3]),
            .b_arb_stall(router[3].b_arb_stall[3]),
            .b_wrp_ack(router[3].b_wrp_ack[3]),
            .b_rrp_datavalid(router[3].b_rrp_datavalid[3]),
            .b_rrp_data(router[3].b_rrp_data[3]),
            .b_invalid_access(invalid_access_terms[2])
         );

         for( j = 0; j < 1; j = j + 1 )
         begin:port1bank0
            logic icm_in_arb_request [3];
            logic icm_in_arb_read [3];
            logic icm_in_arb_write [3];
            logic icm_in_arb_burstcount [3];
            logic icm_in_arb_address [3];
            logic [511:0] icm_in_arb_writedata [3];
            logic [63:0] icm_in_arb_byteenable [3];
            logic icm_in_arb_stall [3];
            logic icm_in_wrp_ack [3];
            logic icm_in_rrp_datavalid [3];
            logic [511:0] icm_in_rrp_data [3];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[0].b_arb_request[0];
            assign icm_in_arb_read[0] = router[0].b_arb_read[0];
            assign icm_in_arb_write[0] = router[0].b_arb_write[0];
            assign icm_in_arb_burstcount[0] = router[0].b_arb_burstcount[0];
            assign icm_in_arb_address[0] = router[0].b_arb_address[0];
            assign icm_in_arb_writedata[0] = router[0].b_arb_writedata[0];
            assign icm_in_arb_byteenable[0] = router[0].b_arb_byteenable[0];
            assign router[0].b_arb_stall[0] = icm_in_arb_stall[0];
            assign router[0].b_wrp_ack[0] = icm_in_wrp_ack[0];
            assign router[0].b_rrp_datavalid[0] = icm_in_rrp_datavalid[0];
            assign router[0].b_rrp_data[0] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[8].b_arb_request[0];
            assign icm_in_arb_read[1] = router[8].b_arb_read[0];
            assign icm_in_arb_write[1] = router[8].b_arb_write[0];
            assign icm_in_arb_burstcount[1] = router[8].b_arb_burstcount[0];
            assign icm_in_arb_address[1] = router[8].b_arb_address[0];
            assign icm_in_arb_writedata[1] = router[8].b_arb_writedata[0];
            assign icm_in_arb_byteenable[1] = router[8].b_arb_byteenable[0];
            assign router[8].b_arb_stall[0] = icm_in_arb_stall[1];
            assign router[8].b_wrp_ack[0] = icm_in_wrp_ack[1];
            assign router[8].b_rrp_datavalid[0] = icm_in_rrp_datavalid[1];
            assign router[8].b_rrp_data[0] = icm_in_rrp_data[1];
            assign icm_in_arb_request[2] = router[9].b_arb_request[0];
            assign icm_in_arb_read[2] = router[9].b_arb_read[0];
            assign icm_in_arb_write[2] = router[9].b_arb_write[0];
            assign icm_in_arb_burstcount[2] = router[9].b_arb_burstcount[0];
            assign icm_in_arb_address[2] = router[9].b_arb_address[0];
            assign icm_in_arb_writedata[2] = router[9].b_arb_writedata[0];
            assign icm_in_arb_byteenable[2] = router[9].b_arb_byteenable[0];
            assign router[9].b_arb_stall[0] = icm_in_arb_stall[2];
            assign router[9].b_wrp_ack[0] = icm_in_wrp_ack[2];
            assign router[9].b_rrp_datavalid[0] = icm_in_rrp_datavalid[2];
            assign router[9].b_rrp_data[0] = icm_in_rrp_data[2];
            // INST data_ic of interconnect_0
            interconnect_0 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[0].port_read[1] = icm_out_arb_read;
            assign bank[0].port_write[1] = icm_out_arb_write;
            assign bank[0].port_address[1] = icm_out_arb_address;
            assign bank[0].port_writedata[1] = icm_out_arb_writedata;
            assign bank[0].port_byteenable[1] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[0].port_waitrequest[1];
            assign icm_out_rrp_data = bank[0].port_readdata[1];
            assign icm_out_rrp_datavalid = bank[0].port_readdatavalid[1];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port1bank1
            logic icm_in_arb_request [3];
            logic icm_in_arb_read [3];
            logic icm_in_arb_write [3];
            logic icm_in_arb_burstcount [3];
            logic icm_in_arb_address [3];
            logic [511:0] icm_in_arb_writedata [3];
            logic [63:0] icm_in_arb_byteenable [3];
            logic icm_in_arb_stall [3];
            logic icm_in_wrp_ack [3];
            logic icm_in_rrp_datavalid [3];
            logic [511:0] icm_in_rrp_data [3];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[0].b_arb_request[1];
            assign icm_in_arb_read[0] = router[0].b_arb_read[1];
            assign icm_in_arb_write[0] = router[0].b_arb_write[1];
            assign icm_in_arb_burstcount[0] = router[0].b_arb_burstcount[1];
            assign icm_in_arb_address[0] = router[0].b_arb_address[1];
            assign icm_in_arb_writedata[0] = router[0].b_arb_writedata[1];
            assign icm_in_arb_byteenable[0] = router[0].b_arb_byteenable[1];
            assign router[0].b_arb_stall[1] = icm_in_arb_stall[0];
            assign router[0].b_wrp_ack[1] = icm_in_wrp_ack[0];
            assign router[0].b_rrp_datavalid[1] = icm_in_rrp_datavalid[0];
            assign router[0].b_rrp_data[1] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[5].b_arb_request[1];
            assign icm_in_arb_read[1] = router[5].b_arb_read[1];
            assign icm_in_arb_write[1] = router[5].b_arb_write[1];
            assign icm_in_arb_burstcount[1] = router[5].b_arb_burstcount[1];
            assign icm_in_arb_address[1] = router[5].b_arb_address[1];
            assign icm_in_arb_writedata[1] = router[5].b_arb_writedata[1];
            assign icm_in_arb_byteenable[1] = router[5].b_arb_byteenable[1];
            assign router[5].b_arb_stall[1] = icm_in_arb_stall[1];
            assign router[5].b_wrp_ack[1] = icm_in_wrp_ack[1];
            assign router[5].b_rrp_datavalid[1] = icm_in_rrp_datavalid[1];
            assign router[5].b_rrp_data[1] = icm_in_rrp_data[1];
            assign icm_in_arb_request[2] = router[7].b_arb_request[1];
            assign icm_in_arb_read[2] = router[7].b_arb_read[1];
            assign icm_in_arb_write[2] = router[7].b_arb_write[1];
            assign icm_in_arb_burstcount[2] = router[7].b_arb_burstcount[1];
            assign icm_in_arb_address[2] = router[7].b_arb_address[1];
            assign icm_in_arb_writedata[2] = router[7].b_arb_writedata[1];
            assign icm_in_arb_byteenable[2] = router[7].b_arb_byteenable[1];
            assign router[7].b_arb_stall[1] = icm_in_arb_stall[2];
            assign router[7].b_wrp_ack[1] = icm_in_wrp_ack[2];
            assign router[7].b_rrp_datavalid[1] = icm_in_rrp_datavalid[2];
            assign router[7].b_rrp_data[1] = icm_in_rrp_data[2];
            // INST data_ic of interconnect_1
            interconnect_1 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[1].port_read[1] = icm_out_arb_read;
            assign bank[1].port_write[1] = icm_out_arb_write;
            assign bank[1].port_address[1] = icm_out_arb_address;
            assign bank[1].port_writedata[1] = icm_out_arb_writedata;
            assign bank[1].port_byteenable[1] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[1].port_waitrequest[1];
            assign icm_out_rrp_data = bank[1].port_readdata[1];
            assign icm_out_rrp_datavalid = bank[1].port_readdatavalid[1];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port1bank2
            logic icm_in_arb_request [3];
            logic icm_in_arb_read [3];
            logic icm_in_arb_write [3];
            logic icm_in_arb_burstcount [3];
            logic icm_in_arb_address [3];
            logic [511:0] icm_in_arb_writedata [3];
            logic [63:0] icm_in_arb_byteenable [3];
            logic icm_in_arb_stall [3];
            logic icm_in_wrp_ack [3];
            logic icm_in_rrp_datavalid [3];
            logic [511:0] icm_in_rrp_data [3];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[0].b_arb_request[2];
            assign icm_in_arb_read[0] = router[0].b_arb_read[2];
            assign icm_in_arb_write[0] = router[0].b_arb_write[2];
            assign icm_in_arb_burstcount[0] = router[0].b_arb_burstcount[2];
            assign icm_in_arb_address[0] = router[0].b_arb_address[2];
            assign icm_in_arb_writedata[0] = router[0].b_arb_writedata[2];
            assign icm_in_arb_byteenable[0] = router[0].b_arb_byteenable[2];
            assign router[0].b_arb_stall[2] = icm_in_arb_stall[0];
            assign router[0].b_wrp_ack[2] = icm_in_wrp_ack[0];
            assign router[0].b_rrp_datavalid[2] = icm_in_rrp_datavalid[0];
            assign router[0].b_rrp_data[2] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[5].b_arb_request[2];
            assign icm_in_arb_read[1] = router[5].b_arb_read[2];
            assign icm_in_arb_write[1] = router[5].b_arb_write[2];
            assign icm_in_arb_burstcount[1] = router[5].b_arb_burstcount[2];
            assign icm_in_arb_address[1] = router[5].b_arb_address[2];
            assign icm_in_arb_writedata[1] = router[5].b_arb_writedata[2];
            assign icm_in_arb_byteenable[1] = router[5].b_arb_byteenable[2];
            assign router[5].b_arb_stall[2] = icm_in_arb_stall[1];
            assign router[5].b_wrp_ack[2] = icm_in_wrp_ack[1];
            assign router[5].b_rrp_datavalid[2] = icm_in_rrp_datavalid[1];
            assign router[5].b_rrp_data[2] = icm_in_rrp_data[1];
            assign icm_in_arb_request[2] = router[7].b_arb_request[2];
            assign icm_in_arb_read[2] = router[7].b_arb_read[2];
            assign icm_in_arb_write[2] = router[7].b_arb_write[2];
            assign icm_in_arb_burstcount[2] = router[7].b_arb_burstcount[2];
            assign icm_in_arb_address[2] = router[7].b_arb_address[2];
            assign icm_in_arb_writedata[2] = router[7].b_arb_writedata[2];
            assign icm_in_arb_byteenable[2] = router[7].b_arb_byteenable[2];
            assign router[7].b_arb_stall[2] = icm_in_arb_stall[2];
            assign router[7].b_wrp_ack[2] = icm_in_wrp_ack[2];
            assign router[7].b_rrp_datavalid[2] = icm_in_rrp_datavalid[2];
            assign router[7].b_rrp_data[2] = icm_in_rrp_data[2];
            // INST data_ic of interconnect_1
            interconnect_1 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[2].port_read[1] = icm_out_arb_read;
            assign bank[2].port_write[1] = icm_out_arb_write;
            assign bank[2].port_address[1] = icm_out_arb_address;
            assign bank[2].port_writedata[1] = icm_out_arb_writedata;
            assign bank[2].port_byteenable[1] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[2].port_waitrequest[1];
            assign icm_out_rrp_data = bank[2].port_readdata[1];
            assign icm_out_rrp_datavalid = bank[2].port_readdatavalid[1];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port1bank3
            logic icm_in_arb_request [3];
            logic icm_in_arb_read [3];
            logic icm_in_arb_write [3];
            logic icm_in_arb_burstcount [3];
            logic icm_in_arb_address [3];
            logic [511:0] icm_in_arb_writedata [3];
            logic [63:0] icm_in_arb_byteenable [3];
            logic icm_in_arb_stall [3];
            logic icm_in_wrp_ack [3];
            logic icm_in_rrp_datavalid [3];
            logic [511:0] icm_in_rrp_data [3];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[0].b_arb_request[3];
            assign icm_in_arb_read[0] = router[0].b_arb_read[3];
            assign icm_in_arb_write[0] = router[0].b_arb_write[3];
            assign icm_in_arb_burstcount[0] = router[0].b_arb_burstcount[3];
            assign icm_in_arb_address[0] = router[0].b_arb_address[3];
            assign icm_in_arb_writedata[0] = router[0].b_arb_writedata[3];
            assign icm_in_arb_byteenable[0] = router[0].b_arb_byteenable[3];
            assign router[0].b_arb_stall[3] = icm_in_arb_stall[0];
            assign router[0].b_wrp_ack[3] = icm_in_wrp_ack[0];
            assign router[0].b_rrp_datavalid[3] = icm_in_rrp_datavalid[0];
            assign router[0].b_rrp_data[3] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[5].b_arb_request[3];
            assign icm_in_arb_read[1] = router[5].b_arb_read[3];
            assign icm_in_arb_write[1] = router[5].b_arb_write[3];
            assign icm_in_arb_burstcount[1] = router[5].b_arb_burstcount[3];
            assign icm_in_arb_address[1] = router[5].b_arb_address[3];
            assign icm_in_arb_writedata[1] = router[5].b_arb_writedata[3];
            assign icm_in_arb_byteenable[1] = router[5].b_arb_byteenable[3];
            assign router[5].b_arb_stall[3] = icm_in_arb_stall[1];
            assign router[5].b_wrp_ack[3] = icm_in_wrp_ack[1];
            assign router[5].b_rrp_datavalid[3] = icm_in_rrp_datavalid[1];
            assign router[5].b_rrp_data[3] = icm_in_rrp_data[1];
            assign icm_in_arb_request[2] = router[7].b_arb_request[3];
            assign icm_in_arb_read[2] = router[7].b_arb_read[3];
            assign icm_in_arb_write[2] = router[7].b_arb_write[3];
            assign icm_in_arb_burstcount[2] = router[7].b_arb_burstcount[3];
            assign icm_in_arb_address[2] = router[7].b_arb_address[3];
            assign icm_in_arb_writedata[2] = router[7].b_arb_writedata[3];
            assign icm_in_arb_byteenable[2] = router[7].b_arb_byteenable[3];
            assign router[7].b_arb_stall[3] = icm_in_arb_stall[2];
            assign router[7].b_wrp_ack[3] = icm_in_wrp_ack[2];
            assign router[7].b_rrp_datavalid[3] = icm_in_rrp_datavalid[2];
            assign router[7].b_rrp_data[3] = icm_in_rrp_data[2];
            // INST data_ic of interconnect_1
            interconnect_1 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[3].port_read[1] = icm_out_arb_read;
            assign bank[3].port_write[1] = icm_out_arb_write;
            assign bank[3].port_address[1] = icm_out_arb_address;
            assign bank[3].port_writedata[1] = icm_out_arb_writedata;
            assign bank[3].port_byteenable[1] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[3].port_waitrequest[1];
            assign icm_out_rrp_data = bank[3].port_readdata[1];
            assign icm_out_rrp_datavalid = bank[3].port_readdatavalid[1];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port2bank0
            logic icm_in_arb_request [3];
            logic icm_in_arb_read [3];
            logic icm_in_arb_write [3];
            logic icm_in_arb_burstcount [3];
            logic icm_in_arb_address [3];
            logic [511:0] icm_in_arb_writedata [3];
            logic [63:0] icm_in_arb_byteenable [3];
            logic icm_in_arb_stall [3];
            logic icm_in_wrp_ack [3];
            logic icm_in_rrp_datavalid [3];
            logic [511:0] icm_in_rrp_data [3];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[1].b_arb_request[0];
            assign icm_in_arb_read[0] = router[1].b_arb_read[0];
            assign icm_in_arb_write[0] = router[1].b_arb_write[0];
            assign icm_in_arb_burstcount[0] = router[1].b_arb_burstcount[0];
            assign icm_in_arb_address[0] = router[1].b_arb_address[0];
            assign icm_in_arb_writedata[0] = router[1].b_arb_writedata[0];
            assign icm_in_arb_byteenable[0] = router[1].b_arb_byteenable[0];
            assign router[1].b_arb_stall[0] = icm_in_arb_stall[0];
            assign router[1].b_wrp_ack[0] = icm_in_wrp_ack[0];
            assign router[1].b_rrp_datavalid[0] = icm_in_rrp_datavalid[0];
            assign router[1].b_rrp_data[0] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[5].b_arb_request[0];
            assign icm_in_arb_read[1] = router[5].b_arb_read[0];
            assign icm_in_arb_write[1] = router[5].b_arb_write[0];
            assign icm_in_arb_burstcount[1] = router[5].b_arb_burstcount[0];
            assign icm_in_arb_address[1] = router[5].b_arb_address[0];
            assign icm_in_arb_writedata[1] = router[5].b_arb_writedata[0];
            assign icm_in_arb_byteenable[1] = router[5].b_arb_byteenable[0];
            assign router[5].b_arb_stall[0] = icm_in_arb_stall[1];
            assign router[5].b_wrp_ack[0] = icm_in_wrp_ack[1];
            assign router[5].b_rrp_datavalid[0] = icm_in_rrp_datavalid[1];
            assign router[5].b_rrp_data[0] = icm_in_rrp_data[1];
            assign icm_in_arb_request[2] = router[7].b_arb_request[0];
            assign icm_in_arb_read[2] = router[7].b_arb_read[0];
            assign icm_in_arb_write[2] = router[7].b_arb_write[0];
            assign icm_in_arb_burstcount[2] = router[7].b_arb_burstcount[0];
            assign icm_in_arb_address[2] = router[7].b_arb_address[0];
            assign icm_in_arb_writedata[2] = router[7].b_arb_writedata[0];
            assign icm_in_arb_byteenable[2] = router[7].b_arb_byteenable[0];
            assign router[7].b_arb_stall[0] = icm_in_arb_stall[2];
            assign router[7].b_wrp_ack[0] = icm_in_wrp_ack[2];
            assign router[7].b_rrp_datavalid[0] = icm_in_rrp_datavalid[2];
            assign router[7].b_rrp_data[0] = icm_in_rrp_data[2];
            // INST data_ic of interconnect_1
            interconnect_1 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[0].port_read[2] = icm_out_arb_read;
            assign bank[0].port_write[2] = icm_out_arb_write;
            assign bank[0].port_address[2] = icm_out_arb_address;
            assign bank[0].port_writedata[2] = icm_out_arb_writedata;
            assign bank[0].port_byteenable[2] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[0].port_waitrequest[2];
            assign icm_out_rrp_data = bank[0].port_readdata[2];
            assign icm_out_rrp_datavalid = bank[0].port_readdatavalid[2];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port2bank1
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[1].b_arb_request[1];
            assign icm_in_arb_read[0] = router[1].b_arb_read[1];
            assign icm_in_arb_write[0] = router[1].b_arb_write[1];
            assign icm_in_arb_burstcount[0] = router[1].b_arb_burstcount[1];
            assign icm_in_arb_address[0] = router[1].b_arb_address[1];
            assign icm_in_arb_writedata[0] = router[1].b_arb_writedata[1];
            assign icm_in_arb_byteenable[0] = router[1].b_arb_byteenable[1];
            assign router[1].b_arb_stall[1] = icm_in_arb_stall[0];
            assign router[1].b_wrp_ack[1] = icm_in_wrp_ack[0];
            assign router[1].b_rrp_datavalid[1] = icm_in_rrp_datavalid[0];
            assign router[1].b_rrp_data[1] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[6].b_arb_request[1];
            assign icm_in_arb_read[1] = router[6].b_arb_read[1];
            assign icm_in_arb_write[1] = router[6].b_arb_write[1];
            assign icm_in_arb_burstcount[1] = router[6].b_arb_burstcount[1];
            assign icm_in_arb_address[1] = router[6].b_arb_address[1];
            assign icm_in_arb_writedata[1] = router[6].b_arb_writedata[1];
            assign icm_in_arb_byteenable[1] = router[6].b_arb_byteenable[1];
            assign router[6].b_arb_stall[1] = icm_in_arb_stall[1];
            assign router[6].b_wrp_ack[1] = icm_in_wrp_ack[1];
            assign router[6].b_rrp_datavalid[1] = icm_in_rrp_datavalid[1];
            assign router[6].b_rrp_data[1] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[1].port_read[2] = icm_out_arb_read;
            assign bank[1].port_write[2] = icm_out_arb_write;
            assign bank[1].port_address[2] = icm_out_arb_address;
            assign bank[1].port_writedata[2] = icm_out_arb_writedata;
            assign bank[1].port_byteenable[2] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[1].port_waitrequest[2];
            assign icm_out_rrp_data = bank[1].port_readdata[2];
            assign icm_out_rrp_datavalid = bank[1].port_readdatavalid[2];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port2bank2
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[1].b_arb_request[2];
            assign icm_in_arb_read[0] = router[1].b_arb_read[2];
            assign icm_in_arb_write[0] = router[1].b_arb_write[2];
            assign icm_in_arb_burstcount[0] = router[1].b_arb_burstcount[2];
            assign icm_in_arb_address[0] = router[1].b_arb_address[2];
            assign icm_in_arb_writedata[0] = router[1].b_arb_writedata[2];
            assign icm_in_arb_byteenable[0] = router[1].b_arb_byteenable[2];
            assign router[1].b_arb_stall[2] = icm_in_arb_stall[0];
            assign router[1].b_wrp_ack[2] = icm_in_wrp_ack[0];
            assign router[1].b_rrp_datavalid[2] = icm_in_rrp_datavalid[0];
            assign router[1].b_rrp_data[2] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[6].b_arb_request[2];
            assign icm_in_arb_read[1] = router[6].b_arb_read[2];
            assign icm_in_arb_write[1] = router[6].b_arb_write[2];
            assign icm_in_arb_burstcount[1] = router[6].b_arb_burstcount[2];
            assign icm_in_arb_address[1] = router[6].b_arb_address[2];
            assign icm_in_arb_writedata[1] = router[6].b_arb_writedata[2];
            assign icm_in_arb_byteenable[1] = router[6].b_arb_byteenable[2];
            assign router[6].b_arb_stall[2] = icm_in_arb_stall[1];
            assign router[6].b_wrp_ack[2] = icm_in_wrp_ack[1];
            assign router[6].b_rrp_datavalid[2] = icm_in_rrp_datavalid[1];
            assign router[6].b_rrp_data[2] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[2].port_read[2] = icm_out_arb_read;
            assign bank[2].port_write[2] = icm_out_arb_write;
            assign bank[2].port_address[2] = icm_out_arb_address;
            assign bank[2].port_writedata[2] = icm_out_arb_writedata;
            assign bank[2].port_byteenable[2] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[2].port_waitrequest[2];
            assign icm_out_rrp_data = bank[2].port_readdata[2];
            assign icm_out_rrp_datavalid = bank[2].port_readdatavalid[2];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port2bank3
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[1].b_arb_request[3];
            assign icm_in_arb_read[0] = router[1].b_arb_read[3];
            assign icm_in_arb_write[0] = router[1].b_arb_write[3];
            assign icm_in_arb_burstcount[0] = router[1].b_arb_burstcount[3];
            assign icm_in_arb_address[0] = router[1].b_arb_address[3];
            assign icm_in_arb_writedata[0] = router[1].b_arb_writedata[3];
            assign icm_in_arb_byteenable[0] = router[1].b_arb_byteenable[3];
            assign router[1].b_arb_stall[3] = icm_in_arb_stall[0];
            assign router[1].b_wrp_ack[3] = icm_in_wrp_ack[0];
            assign router[1].b_rrp_datavalid[3] = icm_in_rrp_datavalid[0];
            assign router[1].b_rrp_data[3] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[6].b_arb_request[3];
            assign icm_in_arb_read[1] = router[6].b_arb_read[3];
            assign icm_in_arb_write[1] = router[6].b_arb_write[3];
            assign icm_in_arb_burstcount[1] = router[6].b_arb_burstcount[3];
            assign icm_in_arb_address[1] = router[6].b_arb_address[3];
            assign icm_in_arb_writedata[1] = router[6].b_arb_writedata[3];
            assign icm_in_arb_byteenable[1] = router[6].b_arb_byteenable[3];
            assign router[6].b_arb_stall[3] = icm_in_arb_stall[1];
            assign router[6].b_wrp_ack[3] = icm_in_wrp_ack[1];
            assign router[6].b_rrp_datavalid[3] = icm_in_rrp_datavalid[1];
            assign router[6].b_rrp_data[3] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[3].port_read[2] = icm_out_arb_read;
            assign bank[3].port_write[2] = icm_out_arb_write;
            assign bank[3].port_address[2] = icm_out_arb_address;
            assign bank[3].port_writedata[2] = icm_out_arb_writedata;
            assign bank[3].port_byteenable[2] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[3].port_waitrequest[2];
            assign icm_out_rrp_data = bank[3].port_readdata[2];
            assign icm_out_rrp_datavalid = bank[3].port_readdatavalid[2];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port3bank0
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[3].b_arb_request[0];
            assign icm_in_arb_read[0] = router[3].b_arb_read[0];
            assign icm_in_arb_write[0] = router[3].b_arb_write[0];
            assign icm_in_arb_burstcount[0] = router[3].b_arb_burstcount[0];
            assign icm_in_arb_address[0] = router[3].b_arb_address[0];
            assign icm_in_arb_writedata[0] = router[3].b_arb_writedata[0];
            assign icm_in_arb_byteenable[0] = router[3].b_arb_byteenable[0];
            assign router[3].b_arb_stall[0] = icm_in_arb_stall[0];
            assign router[3].b_wrp_ack[0] = icm_in_wrp_ack[0];
            assign router[3].b_rrp_datavalid[0] = icm_in_rrp_datavalid[0];
            assign router[3].b_rrp_data[0] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[6].b_arb_request[0];
            assign icm_in_arb_read[1] = router[6].b_arb_read[0];
            assign icm_in_arb_write[1] = router[6].b_arb_write[0];
            assign icm_in_arb_burstcount[1] = router[6].b_arb_burstcount[0];
            assign icm_in_arb_address[1] = router[6].b_arb_address[0];
            assign icm_in_arb_writedata[1] = router[6].b_arb_writedata[0];
            assign icm_in_arb_byteenable[1] = router[6].b_arb_byteenable[0];
            assign router[6].b_arb_stall[0] = icm_in_arb_stall[1];
            assign router[6].b_wrp_ack[0] = icm_in_wrp_ack[1];
            assign router[6].b_rrp_datavalid[0] = icm_in_rrp_datavalid[1];
            assign router[6].b_rrp_data[0] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[0].port_read[3] = icm_out_arb_read;
            assign bank[0].port_write[3] = icm_out_arb_write;
            assign bank[0].port_address[3] = icm_out_arb_address;
            assign bank[0].port_writedata[3] = icm_out_arb_writedata;
            assign bank[0].port_byteenable[3] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[0].port_waitrequest[3];
            assign icm_out_rrp_data = bank[0].port_readdata[3];
            assign icm_out_rrp_datavalid = bank[0].port_readdatavalid[3];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port3bank1
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[2].b_arb_request[1];
            assign icm_in_arb_read[0] = router[2].b_arb_read[1];
            assign icm_in_arb_write[0] = router[2].b_arb_write[1];
            assign icm_in_arb_burstcount[0] = router[2].b_arb_burstcount[1];
            assign icm_in_arb_address[0] = router[2].b_arb_address[1];
            assign icm_in_arb_writedata[0] = router[2].b_arb_writedata[1];
            assign icm_in_arb_byteenable[0] = router[2].b_arb_byteenable[1];
            assign router[2].b_arb_stall[1] = icm_in_arb_stall[0];
            assign router[2].b_wrp_ack[1] = icm_in_wrp_ack[0];
            assign router[2].b_rrp_datavalid[1] = icm_in_rrp_datavalid[0];
            assign router[2].b_rrp_data[1] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[4].b_arb_request[1];
            assign icm_in_arb_read[1] = router[4].b_arb_read[1];
            assign icm_in_arb_write[1] = router[4].b_arb_write[1];
            assign icm_in_arb_burstcount[1] = router[4].b_arb_burstcount[1];
            assign icm_in_arb_address[1] = router[4].b_arb_address[1];
            assign icm_in_arb_writedata[1] = router[4].b_arb_writedata[1];
            assign icm_in_arb_byteenable[1] = router[4].b_arb_byteenable[1];
            assign router[4].b_arb_stall[1] = icm_in_arb_stall[1];
            assign router[4].b_wrp_ack[1] = icm_in_wrp_ack[1];
            assign router[4].b_rrp_datavalid[1] = icm_in_rrp_datavalid[1];
            assign router[4].b_rrp_data[1] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[1].port_read[3] = icm_out_arb_read;
            assign bank[1].port_write[3] = icm_out_arb_write;
            assign bank[1].port_address[3] = icm_out_arb_address;
            assign bank[1].port_writedata[3] = icm_out_arb_writedata;
            assign bank[1].port_byteenable[3] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[1].port_waitrequest[3];
            assign icm_out_rrp_data = bank[1].port_readdata[3];
            assign icm_out_rrp_datavalid = bank[1].port_readdatavalid[3];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port3bank2
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[2].b_arb_request[2];
            assign icm_in_arb_read[0] = router[2].b_arb_read[2];
            assign icm_in_arb_write[0] = router[2].b_arb_write[2];
            assign icm_in_arb_burstcount[0] = router[2].b_arb_burstcount[2];
            assign icm_in_arb_address[0] = router[2].b_arb_address[2];
            assign icm_in_arb_writedata[0] = router[2].b_arb_writedata[2];
            assign icm_in_arb_byteenable[0] = router[2].b_arb_byteenable[2];
            assign router[2].b_arb_stall[2] = icm_in_arb_stall[0];
            assign router[2].b_wrp_ack[2] = icm_in_wrp_ack[0];
            assign router[2].b_rrp_datavalid[2] = icm_in_rrp_datavalid[0];
            assign router[2].b_rrp_data[2] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[4].b_arb_request[2];
            assign icm_in_arb_read[1] = router[4].b_arb_read[2];
            assign icm_in_arb_write[1] = router[4].b_arb_write[2];
            assign icm_in_arb_burstcount[1] = router[4].b_arb_burstcount[2];
            assign icm_in_arb_address[1] = router[4].b_arb_address[2];
            assign icm_in_arb_writedata[1] = router[4].b_arb_writedata[2];
            assign icm_in_arb_byteenable[1] = router[4].b_arb_byteenable[2];
            assign router[4].b_arb_stall[2] = icm_in_arb_stall[1];
            assign router[4].b_wrp_ack[2] = icm_in_wrp_ack[1];
            assign router[4].b_rrp_datavalid[2] = icm_in_rrp_datavalid[1];
            assign router[4].b_rrp_data[2] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[2].port_read[3] = icm_out_arb_read;
            assign bank[2].port_write[3] = icm_out_arb_write;
            assign bank[2].port_address[3] = icm_out_arb_address;
            assign bank[2].port_writedata[3] = icm_out_arb_writedata;
            assign bank[2].port_byteenable[3] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[2].port_waitrequest[3];
            assign icm_out_rrp_data = bank[2].port_readdata[3];
            assign icm_out_rrp_datavalid = bank[2].port_readdatavalid[3];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port3bank3
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[2].b_arb_request[3];
            assign icm_in_arb_read[0] = router[2].b_arb_read[3];
            assign icm_in_arb_write[0] = router[2].b_arb_write[3];
            assign icm_in_arb_burstcount[0] = router[2].b_arb_burstcount[3];
            assign icm_in_arb_address[0] = router[2].b_arb_address[3];
            assign icm_in_arb_writedata[0] = router[2].b_arb_writedata[3];
            assign icm_in_arb_byteenable[0] = router[2].b_arb_byteenable[3];
            assign router[2].b_arb_stall[3] = icm_in_arb_stall[0];
            assign router[2].b_wrp_ack[3] = icm_in_wrp_ack[0];
            assign router[2].b_rrp_datavalid[3] = icm_in_rrp_datavalid[0];
            assign router[2].b_rrp_data[3] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[4].b_arb_request[3];
            assign icm_in_arb_read[1] = router[4].b_arb_read[3];
            assign icm_in_arb_write[1] = router[4].b_arb_write[3];
            assign icm_in_arb_burstcount[1] = router[4].b_arb_burstcount[3];
            assign icm_in_arb_address[1] = router[4].b_arb_address[3];
            assign icm_in_arb_writedata[1] = router[4].b_arb_writedata[3];
            assign icm_in_arb_byteenable[1] = router[4].b_arb_byteenable[3];
            assign router[4].b_arb_stall[3] = icm_in_arb_stall[1];
            assign router[4].b_wrp_ack[3] = icm_in_wrp_ack[1];
            assign router[4].b_rrp_datavalid[3] = icm_in_rrp_datavalid[1];
            assign router[4].b_rrp_data[3] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[3].port_read[3] = icm_out_arb_read;
            assign bank[3].port_write[3] = icm_out_arb_write;
            assign bank[3].port_address[3] = icm_out_arb_address;
            assign bank[3].port_writedata[3] = icm_out_arb_writedata;
            assign bank[3].port_byteenable[3] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[3].port_waitrequest[3];
            assign icm_out_rrp_data = bank[3].port_readdata[3];
            assign icm_out_rrp_datavalid = bank[3].port_readdatavalid[3];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port4bank0
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[2].b_arb_request[0];
            assign icm_in_arb_read[0] = router[2].b_arb_read[0];
            assign icm_in_arb_write[0] = router[2].b_arb_write[0];
            assign icm_in_arb_burstcount[0] = router[2].b_arb_burstcount[0];
            assign icm_in_arb_address[0] = router[2].b_arb_address[0];
            assign icm_in_arb_writedata[0] = router[2].b_arb_writedata[0];
            assign icm_in_arb_byteenable[0] = router[2].b_arb_byteenable[0];
            assign router[2].b_arb_stall[0] = icm_in_arb_stall[0];
            assign router[2].b_wrp_ack[0] = icm_in_wrp_ack[0];
            assign router[2].b_rrp_datavalid[0] = icm_in_rrp_datavalid[0];
            assign router[2].b_rrp_data[0] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[4].b_arb_request[0];
            assign icm_in_arb_read[1] = router[4].b_arb_read[0];
            assign icm_in_arb_write[1] = router[4].b_arb_write[0];
            assign icm_in_arb_burstcount[1] = router[4].b_arb_burstcount[0];
            assign icm_in_arb_address[1] = router[4].b_arb_address[0];
            assign icm_in_arb_writedata[1] = router[4].b_arb_writedata[0];
            assign icm_in_arb_byteenable[1] = router[4].b_arb_byteenable[0];
            assign router[4].b_arb_stall[0] = icm_in_arb_stall[1];
            assign router[4].b_wrp_ack[0] = icm_in_wrp_ack[1];
            assign router[4].b_rrp_datavalid[0] = icm_in_rrp_datavalid[1];
            assign router[4].b_rrp_data[0] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_2
            interconnect_2 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[0].port_read[4] = icm_out_arb_read;
            assign bank[0].port_write[4] = icm_out_arb_write;
            assign bank[0].port_address[4] = icm_out_arb_address;
            assign bank[0].port_writedata[4] = icm_out_arb_writedata;
            assign bank[0].port_byteenable[4] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[0].port_waitrequest[4];
            assign icm_out_rrp_data = bank[0].port_readdata[4];
            assign icm_out_rrp_datavalid = bank[0].port_readdatavalid[4];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port4bank1
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[8].b_arb_request[1];
            assign icm_in_arb_read[0] = router[8].b_arb_read[1];
            assign icm_in_arb_write[0] = router[8].b_arb_write[1];
            assign icm_in_arb_burstcount[0] = router[8].b_arb_burstcount[1];
            assign icm_in_arb_address[0] = router[8].b_arb_address[1];
            assign icm_in_arb_writedata[0] = router[8].b_arb_writedata[1];
            assign icm_in_arb_byteenable[0] = router[8].b_arb_byteenable[1];
            assign router[8].b_arb_stall[1] = icm_in_arb_stall[0];
            assign router[8].b_wrp_ack[1] = icm_in_wrp_ack[0];
            assign router[8].b_rrp_datavalid[1] = icm_in_rrp_datavalid[0];
            assign router[8].b_rrp_data[1] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[9].b_arb_request[1];
            assign icm_in_arb_read[1] = router[9].b_arb_read[1];
            assign icm_in_arb_write[1] = router[9].b_arb_write[1];
            assign icm_in_arb_burstcount[1] = router[9].b_arb_burstcount[1];
            assign icm_in_arb_address[1] = router[9].b_arb_address[1];
            assign icm_in_arb_writedata[1] = router[9].b_arb_writedata[1];
            assign icm_in_arb_byteenable[1] = router[9].b_arb_byteenable[1];
            assign router[9].b_arb_stall[1] = icm_in_arb_stall[1];
            assign router[9].b_wrp_ack[1] = icm_in_wrp_ack[1];
            assign router[9].b_rrp_datavalid[1] = icm_in_rrp_datavalid[1];
            assign router[9].b_rrp_data[1] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_3
            interconnect_3 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[1].port_read[4] = icm_out_arb_read;
            assign bank[1].port_write[4] = icm_out_arb_write;
            assign bank[1].port_address[4] = icm_out_arb_address;
            assign bank[1].port_writedata[4] = icm_out_arb_writedata;
            assign bank[1].port_byteenable[4] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[1].port_waitrequest[4];
            assign icm_out_rrp_data = bank[1].port_readdata[4];
            assign icm_out_rrp_datavalid = bank[1].port_readdatavalid[4];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port4bank2
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[8].b_arb_request[2];
            assign icm_in_arb_read[0] = router[8].b_arb_read[2];
            assign icm_in_arb_write[0] = router[8].b_arb_write[2];
            assign icm_in_arb_burstcount[0] = router[8].b_arb_burstcount[2];
            assign icm_in_arb_address[0] = router[8].b_arb_address[2];
            assign icm_in_arb_writedata[0] = router[8].b_arb_writedata[2];
            assign icm_in_arb_byteenable[0] = router[8].b_arb_byteenable[2];
            assign router[8].b_arb_stall[2] = icm_in_arb_stall[0];
            assign router[8].b_wrp_ack[2] = icm_in_wrp_ack[0];
            assign router[8].b_rrp_datavalid[2] = icm_in_rrp_datavalid[0];
            assign router[8].b_rrp_data[2] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[9].b_arb_request[2];
            assign icm_in_arb_read[1] = router[9].b_arb_read[2];
            assign icm_in_arb_write[1] = router[9].b_arb_write[2];
            assign icm_in_arb_burstcount[1] = router[9].b_arb_burstcount[2];
            assign icm_in_arb_address[1] = router[9].b_arb_address[2];
            assign icm_in_arb_writedata[1] = router[9].b_arb_writedata[2];
            assign icm_in_arb_byteenable[1] = router[9].b_arb_byteenable[2];
            assign router[9].b_arb_stall[2] = icm_in_arb_stall[1];
            assign router[9].b_wrp_ack[2] = icm_in_wrp_ack[1];
            assign router[9].b_rrp_datavalid[2] = icm_in_rrp_datavalid[1];
            assign router[9].b_rrp_data[2] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_3
            interconnect_3 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[2].port_read[4] = icm_out_arb_read;
            assign bank[2].port_write[4] = icm_out_arb_write;
            assign bank[2].port_address[4] = icm_out_arb_address;
            assign bank[2].port_writedata[4] = icm_out_arb_writedata;
            assign bank[2].port_byteenable[4] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[2].port_waitrequest[4];
            assign icm_out_rrp_data = bank[2].port_readdata[4];
            assign icm_out_rrp_datavalid = bank[2].port_readdatavalid[4];
         end

         for( j = 0; j < 1; j = j + 1 )
         begin:port4bank3
            logic icm_in_arb_request [2];
            logic icm_in_arb_read [2];
            logic icm_in_arb_write [2];
            logic icm_in_arb_burstcount [2];
            logic icm_in_arb_address [2];
            logic [511:0] icm_in_arb_writedata [2];
            logic [63:0] icm_in_arb_byteenable [2];
            logic icm_in_arb_stall [2];
            logic icm_in_wrp_ack [2];
            logic icm_in_rrp_datavalid [2];
            logic [511:0] icm_in_rrp_data [2];
            logic icm_out_arb_request;
            logic icm_out_arb_read;
            logic icm_out_arb_write;
            logic icm_out_arb_burstcount;
            logic icm_out_arb_address;
            logic [511:0] icm_out_arb_writedata;
            logic [63:0] icm_out_arb_byteenable;
            logic icm_out_arb_stall;
            logic icm_out_wrp_ack;
            logic icm_out_rrp_datavalid;
            logic [511:0] icm_out_rrp_data;

            assign icm_in_arb_request[0] = router[8].b_arb_request[3];
            assign icm_in_arb_read[0] = router[8].b_arb_read[3];
            assign icm_in_arb_write[0] = router[8].b_arb_write[3];
            assign icm_in_arb_burstcount[0] = router[8].b_arb_burstcount[3];
            assign icm_in_arb_address[0] = router[8].b_arb_address[3];
            assign icm_in_arb_writedata[0] = router[8].b_arb_writedata[3];
            assign icm_in_arb_byteenable[0] = router[8].b_arb_byteenable[3];
            assign router[8].b_arb_stall[3] = icm_in_arb_stall[0];
            assign router[8].b_wrp_ack[3] = icm_in_wrp_ack[0];
            assign router[8].b_rrp_datavalid[3] = icm_in_rrp_datavalid[0];
            assign router[8].b_rrp_data[3] = icm_in_rrp_data[0];
            assign icm_in_arb_request[1] = router[9].b_arb_request[3];
            assign icm_in_arb_read[1] = router[9].b_arb_read[3];
            assign icm_in_arb_write[1] = router[9].b_arb_write[3];
            assign icm_in_arb_burstcount[1] = router[9].b_arb_burstcount[3];
            assign icm_in_arb_address[1] = router[9].b_arb_address[3];
            assign icm_in_arb_writedata[1] = router[9].b_arb_writedata[3];
            assign icm_in_arb_byteenable[1] = router[9].b_arb_byteenable[3];
            assign router[9].b_arb_stall[3] = icm_in_arb_stall[1];
            assign router[9].b_wrp_ack[3] = icm_in_wrp_ack[1];
            assign router[9].b_rrp_datavalid[3] = icm_in_rrp_datavalid[1];
            assign router[9].b_rrp_data[3] = icm_in_rrp_data[1];
            // INST data_ic of interconnect_3
            interconnect_3 data_ic
            (
               .clock(clock),
               .resetn(resetn),
               // ICM m
               .m_arb_request(icm_in_arb_request),
               .m_arb_read(icm_in_arb_read),
               .m_arb_write(icm_in_arb_write),
               .m_arb_burstcount(icm_in_arb_burstcount),
               .m_arb_address(icm_in_arb_address),
               .m_arb_writedata(icm_in_arb_writedata),
               .m_arb_byteenable(icm_in_arb_byteenable),
               .m_arb_stall(icm_in_arb_stall),
               .m_wrp_ack(icm_in_wrp_ack),
               .m_rrp_datavalid(icm_in_rrp_datavalid),
               .m_rrp_data(icm_in_rrp_data),
               // ICM mout
               .mout_arb_request(icm_out_arb_request),
               .mout_arb_read(icm_out_arb_read),
               .mout_arb_write(icm_out_arb_write),
               .mout_arb_burstcount(icm_out_arb_burstcount),
               .mout_arb_address(icm_out_arb_address),
               .mout_arb_writedata(icm_out_arb_writedata),
               .mout_arb_byteenable(icm_out_arb_byteenable),
               .mout_arb_id(),
               .mout_arb_stall(icm_out_arb_stall),
               .mout_wrp_ack(icm_out_wrp_ack),
               .mout_rrp_datavalid(icm_out_rrp_datavalid),
               .mout_rrp_data(icm_out_rrp_data)
            );

            assign bank[3].port_read[4] = icm_out_arb_read;
            assign bank[3].port_write[4] = icm_out_arb_write;
            assign bank[3].port_address[4] = icm_out_arb_address;
            assign bank[3].port_writedata[4] = icm_out_arb_writedata;
            assign bank[3].port_byteenable[4] = icm_out_arb_byteenable;
            assign icm_out_arb_stall = bank[3].port_waitrequest[4];
            assign icm_out_rrp_data = bank[3].port_readdata[4];
            assign icm_out_rrp_datavalid = bank[3].port_readdatavalid[4];
         end

      end

      assign lmem_invalid_aspaces = |invalid_access_grps;
   end
   endgenerate

endmodule

/////////////////////////////////////////////////////////////////
// MODULE interconnect_0
/////////////////////////////////////////////////////////////////
module interconnect_0
(
   input logic clock,
   input logic resetn,
   // ICM m
   input logic m_arb_request [3],
   input logic m_arb_read [3],
   input logic m_arb_write [3],
   input logic m_arb_burstcount [3],
   input logic m_arb_address [3],
   input logic [511:0] m_arb_writedata [3],
   input logic [63:0] m_arb_byteenable [3],
   output logic m_arb_stall [3],
   output logic m_wrp_ack [3],
   output logic m_rrp_datavalid [3],
   output logic [511:0] m_rrp_data [3],
   // ICM mout
   output logic mout_arb_request,
   output logic mout_arb_read,
   output logic mout_arb_write,
   output logic mout_arb_burstcount,
   output logic mout_arb_address,
   output logic [511:0] mout_arb_writedata,
   output logic [63:0] mout_arb_byteenable,
   output logic [1:0] mout_arb_id,
   input logic mout_arb_stall,
   input logic mout_wrp_ack,
   input logic mout_rrp_datavalid,
   input logic [511:0] mout_rrp_data
);
   genvar i;
   generate
      for( i = 0; i < 3; i = i + 1 )
      begin:m
         logic [1:0] id;
         acl_ic_master_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) m_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) arb_intf();
         acl_ic_wrp_intf
         #(
            .ID_W(2)
         ) wrp_intf();
         acl_ic_rrp_intf
         #(
            .DATA_W(512),
            .ID_W(2)
         ) rrp_intf();

         assign id = i;
         // INST m_endp of acl_ic_master_endpoint
         acl_ic_master_endpoint
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2),
            .TOTAL_NUM_MASTERS(3),
            .ID(i)
         )
         m_endp
         (
            .clock(clock),
            .resetn(resetn),
            .m_intf(m_intf),
            .arb_intf(arb_intf),
            .wrp_intf(wrp_intf),
            .rrp_intf(rrp_intf)
         );

         assign m_intf.arb.req.request = m_arb_request[i];
         assign m_intf.arb.req.read = m_arb_read[i];
         assign m_intf.arb.req.write = m_arb_write[i];
         assign m_intf.arb.req.burstcount = m_arb_burstcount[i];
         assign m_intf.arb.req.address = m_arb_address[i];
         assign m_intf.arb.req.writedata = m_arb_writedata[i];
         assign m_intf.arb.req.byteenable = m_arb_byteenable[i];
         assign m_arb_stall[i] = m_intf.arb.stall;
         assign m_wrp_ack[i] = m_intf.wrp.ack;
         assign m_rrp_datavalid[i] = m_intf.rrp.datavalid;
         assign m_rrp_data[i] = m_intf.rrp.data;
         assign m_intf.arb.req.id = id;
      end

   endgenerate

   generate
   begin:s
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(2)
      ) in_arb_intf();
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(2)
      ) out_arb_intf();
      acl_ic_wrp_intf
      #(
         .ID_W(2)
      ) wrp_intf();
      acl_ic_rrp_intf
      #(
         .DATA_W(512),
         .ID_W(2)
      ) rrp_intf();

      // INST s_endp of acl_ic_slave_endpoint
      acl_ic_slave_endpoint
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(2),
         .NUM_MASTERS(3),
         .PIPELINE_RETURN_PATHS(0),
         .WRP_FIFO_DEPTH(0),
         .RRP_FIFO_DEPTH(0),
         .RRP_USE_LL_FIFO(1),
         .SLAVE_FIXED_LATENCY(4),
         .SEPARATE_READ_WRITE_STALLS(0)
      )
      s_endp
      (
         .clock(clock),
         .resetn(resetn),
         .m_intf(in_arb_intf),
         .s_intf(out_arb_intf),
         .s_readdatavalid(mout_rrp_datavalid),
         .s_readdata(mout_rrp_data),
         .s_writeack(mout_wrp_ack),
         .wrp_intf(wrp_intf),
         .rrp_intf(rrp_intf)
      );

   end
   endgenerate

   generate
   begin:wrp
      assign m[0].wrp_intf.ack = s.wrp_intf.ack;
      assign m[0].wrp_intf.id = s.wrp_intf.id;
      assign m[2].wrp_intf.ack = s.wrp_intf.ack;
      assign m[2].wrp_intf.id = s.wrp_intf.id;
   end
   endgenerate

   generate
   begin:rrp
      assign m[1].rrp_intf.datavalid = s.rrp_intf.datavalid;
      assign m[1].rrp_intf.data = s.rrp_intf.data;
      assign m[1].rrp_intf.id = s.rrp_intf.id;
   end
   endgenerate

   generate
      for( i = 0; i < 2; i = i + 1 )
      begin:a
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) m0_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) m1_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) mout_intf();

         // INST a of acl_arb2
         acl_arb2
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2),
            .PIPELINE("none"),
            .KEEP_LAST_GRANT(0),
            .NO_STALL_NETWORK(0)
         )
         a
         (
            .clock(clock),
            .resetn(resetn),
            .m0_intf(m0_intf),
            .m1_intf(m1_intf),
            .mout_intf(mout_intf)
         );

      end

   endgenerate

   generate
      for( i = 0; i < 1; i = i + 1 )
      begin:dp
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) in_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) out_intf();

         // INST dp of acl_arb_pipeline_reg
         acl_arb_pipeline_reg
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         )
         dp
         (
            .clock(clock),
            .resetn(resetn),
            .in_intf(in_intf),
            .out_intf(out_intf)
         );

      end

   endgenerate

   assign mout_arb_request = s.out_arb_intf.req.request;
   assign mout_arb_read = s.out_arb_intf.req.read;
   assign mout_arb_write = s.out_arb_intf.req.write;
   assign mout_arb_burstcount = s.out_arb_intf.req.burstcount;
   assign mout_arb_address = s.out_arb_intf.req.address;
   assign mout_arb_writedata = s.out_arb_intf.req.writedata;
   assign mout_arb_byteenable = s.out_arb_intf.req.byteenable;
   assign mout_arb_id = s.out_arb_intf.req.id;
   assign s.out_arb_intf.stall = mout_arb_stall;
   assign s.in_arb_intf.req = dp[0].out_intf.req;
   assign dp[0].out_intf.stall = s.in_arb_intf.stall;
   assign dp[0].in_intf.req = a[1].mout_intf.req;
   assign a[1].mout_intf.stall = dp[0].in_intf.stall;
   assign a[1].m0_intf.req = a[0].mout_intf.req;
   assign a[0].mout_intf.stall = a[1].m0_intf.stall;
   assign a[1].m1_intf.req = m[2].arb_intf.req;
   assign m[2].arb_intf.stall = a[1].m1_intf.stall;
   assign a[0].m0_intf.req = m[1].arb_intf.req;
   assign m[1].arb_intf.stall = a[0].m0_intf.stall;
   assign a[0].m1_intf.req = m[0].arb_intf.req;
   assign m[0].arb_intf.stall = a[0].m1_intf.stall;
endmodule

/////////////////////////////////////////////////////////////////
// MODULE interconnect_1
/////////////////////////////////////////////////////////////////
module interconnect_1
(
   input logic clock,
   input logic resetn,
   // ICM m
   input logic m_arb_request [3],
   input logic m_arb_read [3],
   input logic m_arb_write [3],
   input logic m_arb_burstcount [3],
   input logic m_arb_address [3],
   input logic [511:0] m_arb_writedata [3],
   input logic [63:0] m_arb_byteenable [3],
   output logic m_arb_stall [3],
   output logic m_wrp_ack [3],
   output logic m_rrp_datavalid [3],
   output logic [511:0] m_rrp_data [3],
   // ICM mout
   output logic mout_arb_request,
   output logic mout_arb_read,
   output logic mout_arb_write,
   output logic mout_arb_burstcount,
   output logic mout_arb_address,
   output logic [511:0] mout_arb_writedata,
   output logic [63:0] mout_arb_byteenable,
   output logic [1:0] mout_arb_id,
   input logic mout_arb_stall,
   input logic mout_wrp_ack,
   input logic mout_rrp_datavalid,
   input logic [511:0] mout_rrp_data
);
   genvar i;
   generate
      for( i = 0; i < 3; i = i + 1 )
      begin:m
         logic [1:0] id;
         acl_ic_master_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) m_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) arb_intf();
         acl_ic_wrp_intf
         #(
            .ID_W(2)
         ) wrp_intf();
         acl_ic_rrp_intf
         #(
            .DATA_W(512),
            .ID_W(2)
         ) rrp_intf();

         assign id = i;
         // INST m_endp of acl_ic_master_endpoint
         acl_ic_master_endpoint
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2),
            .TOTAL_NUM_MASTERS(3),
            .ID(i)
         )
         m_endp
         (
            .clock(clock),
            .resetn(resetn),
            .m_intf(m_intf),
            .arb_intf(arb_intf),
            .wrp_intf(wrp_intf),
            .rrp_intf(rrp_intf)
         );

         assign m_intf.arb.req.request = m_arb_request[i];
         assign m_intf.arb.req.read = m_arb_read[i];
         assign m_intf.arb.req.write = m_arb_write[i];
         assign m_intf.arb.req.burstcount = m_arb_burstcount[i];
         assign m_intf.arb.req.address = m_arb_address[i];
         assign m_intf.arb.req.writedata = m_arb_writedata[i];
         assign m_intf.arb.req.byteenable = m_arb_byteenable[i];
         assign m_arb_stall[i] = m_intf.arb.stall;
         assign m_wrp_ack[i] = m_intf.wrp.ack;
         assign m_rrp_datavalid[i] = m_intf.rrp.datavalid;
         assign m_rrp_data[i] = m_intf.rrp.data;
         assign m_intf.arb.req.id = id;
      end

   endgenerate

   generate
   begin:s
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(2)
      ) in_arb_intf();
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(2)
      ) out_arb_intf();
      acl_ic_wrp_intf
      #(
         .ID_W(2)
      ) wrp_intf();
      acl_ic_rrp_intf
      #(
         .DATA_W(512),
         .ID_W(2)
      ) rrp_intf();

      // INST s_endp of acl_ic_slave_endpoint
      acl_ic_slave_endpoint
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(2),
         .NUM_MASTERS(3),
         .PIPELINE_RETURN_PATHS(0),
         .WRP_FIFO_DEPTH(0),
         .RRP_FIFO_DEPTH(0),
         .RRP_USE_LL_FIFO(1),
         .SLAVE_FIXED_LATENCY(4),
         .SEPARATE_READ_WRITE_STALLS(0)
      )
      s_endp
      (
         .clock(clock),
         .resetn(resetn),
         .m_intf(in_arb_intf),
         .s_intf(out_arb_intf),
         .s_readdatavalid(mout_rrp_datavalid),
         .s_readdata(mout_rrp_data),
         .s_writeack(mout_wrp_ack),
         .wrp_intf(wrp_intf),
         .rrp_intf(rrp_intf)
      );

   end
   endgenerate

   generate
   begin:wrp
      assign m[0].wrp_intf.ack = s.wrp_intf.ack;
      assign m[0].wrp_intf.id = s.wrp_intf.id;
   end
   endgenerate

   generate
   begin:rrp
      assign m[1].rrp_intf.datavalid = s.rrp_intf.datavalid;
      assign m[1].rrp_intf.data = s.rrp_intf.data;
      assign m[1].rrp_intf.id = s.rrp_intf.id;
      assign m[2].rrp_intf.datavalid = s.rrp_intf.datavalid;
      assign m[2].rrp_intf.data = s.rrp_intf.data;
      assign m[2].rrp_intf.id = s.rrp_intf.id;
   end
   endgenerate

   generate
      for( i = 0; i < 2; i = i + 1 )
      begin:a
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) m0_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) m1_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) mout_intf();

         // INST a of acl_arb2
         acl_arb2
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2),
            .PIPELINE("none"),
            .KEEP_LAST_GRANT(0),
            .NO_STALL_NETWORK(0)
         )
         a
         (
            .clock(clock),
            .resetn(resetn),
            .m0_intf(m0_intf),
            .m1_intf(m1_intf),
            .mout_intf(mout_intf)
         );

      end

   endgenerate

   generate
      for( i = 0; i < 1; i = i + 1 )
      begin:dp
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) in_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         ) out_intf();

         // INST dp of acl_arb_pipeline_reg
         acl_arb_pipeline_reg
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(2)
         )
         dp
         (
            .clock(clock),
            .resetn(resetn),
            .in_intf(in_intf),
            .out_intf(out_intf)
         );

      end

   endgenerate

   assign mout_arb_request = s.out_arb_intf.req.request;
   assign mout_arb_read = s.out_arb_intf.req.read;
   assign mout_arb_write = s.out_arb_intf.req.write;
   assign mout_arb_burstcount = s.out_arb_intf.req.burstcount;
   assign mout_arb_address = s.out_arb_intf.req.address;
   assign mout_arb_writedata = s.out_arb_intf.req.writedata;
   assign mout_arb_byteenable = s.out_arb_intf.req.byteenable;
   assign mout_arb_id = s.out_arb_intf.req.id;
   assign s.out_arb_intf.stall = mout_arb_stall;
   assign s.in_arb_intf.req = dp[0].out_intf.req;
   assign dp[0].out_intf.stall = s.in_arb_intf.stall;
   assign dp[0].in_intf.req = a[1].mout_intf.req;
   assign a[1].mout_intf.stall = dp[0].in_intf.stall;
   assign a[1].m0_intf.req = a[0].mout_intf.req;
   assign a[0].mout_intf.stall = a[1].m0_intf.stall;
   assign a[1].m1_intf.req = m[0].arb_intf.req;
   assign m[0].arb_intf.stall = a[1].m1_intf.stall;
   assign a[0].m0_intf.req = m[1].arb_intf.req;
   assign m[1].arb_intf.stall = a[0].m0_intf.stall;
   assign a[0].m1_intf.req = m[2].arb_intf.req;
   assign m[2].arb_intf.stall = a[0].m1_intf.stall;
endmodule

/////////////////////////////////////////////////////////////////
// MODULE interconnect_2
/////////////////////////////////////////////////////////////////
module interconnect_2
(
   input logic clock,
   input logic resetn,
   // ICM m
   input logic m_arb_request [2],
   input logic m_arb_read [2],
   input logic m_arb_write [2],
   input logic m_arb_burstcount [2],
   input logic m_arb_address [2],
   input logic [511:0] m_arb_writedata [2],
   input logic [63:0] m_arb_byteenable [2],
   output logic m_arb_stall [2],
   output logic m_wrp_ack [2],
   output logic m_rrp_datavalid [2],
   output logic [511:0] m_rrp_data [2],
   // ICM mout
   output logic mout_arb_request,
   output logic mout_arb_read,
   output logic mout_arb_write,
   output logic mout_arb_burstcount,
   output logic mout_arb_address,
   output logic [511:0] mout_arb_writedata,
   output logic [63:0] mout_arb_byteenable,
   output logic mout_arb_id,
   input logic mout_arb_stall,
   input logic mout_wrp_ack,
   input logic mout_rrp_datavalid,
   input logic [511:0] mout_rrp_data
);
   genvar i;
   generate
      for( i = 0; i < 2; i = i + 1 )
      begin:m
         logic id;
         acl_ic_master_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) m_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) arb_intf();
         acl_ic_wrp_intf
         #(
            .ID_W(1)
         ) wrp_intf();
         acl_ic_rrp_intf
         #(
            .DATA_W(512),
            .ID_W(1)
         ) rrp_intf();

         assign id = i;
         // INST m_endp of acl_ic_master_endpoint
         acl_ic_master_endpoint
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1),
            .TOTAL_NUM_MASTERS(2),
            .ID(i)
         )
         m_endp
         (
            .clock(clock),
            .resetn(resetn),
            .m_intf(m_intf),
            .arb_intf(arb_intf),
            .wrp_intf(wrp_intf),
            .rrp_intf(rrp_intf)
         );

         assign m_intf.arb.req.request = m_arb_request[i];
         assign m_intf.arb.req.read = m_arb_read[i];
         assign m_intf.arb.req.write = m_arb_write[i];
         assign m_intf.arb.req.burstcount = m_arb_burstcount[i];
         assign m_intf.arb.req.address = m_arb_address[i];
         assign m_intf.arb.req.writedata = m_arb_writedata[i];
         assign m_intf.arb.req.byteenable = m_arb_byteenable[i];
         assign m_arb_stall[i] = m_intf.arb.stall;
         assign m_wrp_ack[i] = m_intf.wrp.ack;
         assign m_rrp_datavalid[i] = m_intf.rrp.datavalid;
         assign m_rrp_data[i] = m_intf.rrp.data;
         assign m_intf.arb.req.id = id;
      end

   endgenerate

   generate
   begin:s
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(1)
      ) in_arb_intf();
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(1)
      ) out_arb_intf();
      acl_ic_wrp_intf
      #(
         .ID_W(1)
      ) wrp_intf();
      acl_ic_rrp_intf
      #(
         .DATA_W(512),
         .ID_W(1)
      ) rrp_intf();

      // INST s_endp of acl_ic_slave_endpoint
      acl_ic_slave_endpoint
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(1),
         .NUM_MASTERS(2),
         .PIPELINE_RETURN_PATHS(0),
         .WRP_FIFO_DEPTH(0),
         .RRP_FIFO_DEPTH(0),
         .RRP_USE_LL_FIFO(1),
         .SLAVE_FIXED_LATENCY(4),
         .SEPARATE_READ_WRITE_STALLS(0)
      )
      s_endp
      (
         .clock(clock),
         .resetn(resetn),
         .m_intf(in_arb_intf),
         .s_intf(out_arb_intf),
         .s_readdatavalid(mout_rrp_datavalid),
         .s_readdata(mout_rrp_data),
         .s_writeack(mout_wrp_ack),
         .wrp_intf(wrp_intf),
         .rrp_intf(rrp_intf)
      );

   end
   endgenerate

   generate
   begin:wrp
      assign m[0].wrp_intf.ack = s.wrp_intf.ack;
      assign m[0].wrp_intf.id = s.wrp_intf.id;
   end
   endgenerate

   generate
   begin:rrp
      assign m[1].rrp_intf.datavalid = s.rrp_intf.datavalid;
      assign m[1].rrp_intf.data = s.rrp_intf.data;
      assign m[1].rrp_intf.id = s.rrp_intf.id;
   end
   endgenerate

   generate
      for( i = 0; i < 1; i = i + 1 )
      begin:a
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) m0_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) m1_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) mout_intf();

         // INST a of acl_arb2
         acl_arb2
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1),
            .PIPELINE("none"),
            .KEEP_LAST_GRANT(0),
            .NO_STALL_NETWORK(0)
         )
         a
         (
            .clock(clock),
            .resetn(resetn),
            .m0_intf(m0_intf),
            .m1_intf(m1_intf),
            .mout_intf(mout_intf)
         );

      end

   endgenerate

   generate
      for( i = 0; i < 1; i = i + 1 )
      begin:dp
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) in_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) out_intf();

         // INST dp of acl_arb_pipeline_reg
         acl_arb_pipeline_reg
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         )
         dp
         (
            .clock(clock),
            .resetn(resetn),
            .in_intf(in_intf),
            .out_intf(out_intf)
         );

      end

   endgenerate

   assign mout_arb_request = s.out_arb_intf.req.request;
   assign mout_arb_read = s.out_arb_intf.req.read;
   assign mout_arb_write = s.out_arb_intf.req.write;
   assign mout_arb_burstcount = s.out_arb_intf.req.burstcount;
   assign mout_arb_address = s.out_arb_intf.req.address;
   assign mout_arb_writedata = s.out_arb_intf.req.writedata;
   assign mout_arb_byteenable = s.out_arb_intf.req.byteenable;
   assign mout_arb_id = s.out_arb_intf.req.id;
   assign s.out_arb_intf.stall = mout_arb_stall;
   assign s.in_arb_intf.req = dp[0].out_intf.req;
   assign dp[0].out_intf.stall = s.in_arb_intf.stall;
   assign dp[0].in_intf.req = a[0].mout_intf.req;
   assign a[0].mout_intf.stall = dp[0].in_intf.stall;
   assign a[0].m0_intf.req = m[1].arb_intf.req;
   assign m[1].arb_intf.stall = a[0].m0_intf.stall;
   assign a[0].m1_intf.req = m[0].arb_intf.req;
   assign m[0].arb_intf.stall = a[0].m1_intf.stall;
endmodule

/////////////////////////////////////////////////////////////////
// MODULE interconnect_3
/////////////////////////////////////////////////////////////////
module interconnect_3
(
   input logic clock,
   input logic resetn,
   // ICM m
   input logic m_arb_request [2],
   input logic m_arb_read [2],
   input logic m_arb_write [2],
   input logic m_arb_burstcount [2],
   input logic m_arb_address [2],
   input logic [511:0] m_arb_writedata [2],
   input logic [63:0] m_arb_byteenable [2],
   output logic m_arb_stall [2],
   output logic m_wrp_ack [2],
   output logic m_rrp_datavalid [2],
   output logic [511:0] m_rrp_data [2],
   // ICM mout
   output logic mout_arb_request,
   output logic mout_arb_read,
   output logic mout_arb_write,
   output logic mout_arb_burstcount,
   output logic mout_arb_address,
   output logic [511:0] mout_arb_writedata,
   output logic [63:0] mout_arb_byteenable,
   output logic mout_arb_id,
   input logic mout_arb_stall,
   input logic mout_wrp_ack,
   input logic mout_rrp_datavalid,
   input logic [511:0] mout_rrp_data
);
   genvar i;
   generate
      for( i = 0; i < 2; i = i + 1 )
      begin:m
         logic id;
         acl_ic_master_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) m_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) arb_intf();
         acl_ic_wrp_intf
         #(
            .ID_W(1)
         ) wrp_intf();
         acl_ic_rrp_intf
         #(
            .DATA_W(512),
            .ID_W(1)
         ) rrp_intf();

         assign id = i;
         // INST m_endp of acl_ic_master_endpoint
         acl_ic_master_endpoint
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1),
            .TOTAL_NUM_MASTERS(2),
            .ID(i)
         )
         m_endp
         (
            .clock(clock),
            .resetn(resetn),
            .m_intf(m_intf),
            .arb_intf(arb_intf),
            .wrp_intf(wrp_intf),
            .rrp_intf(rrp_intf)
         );

         assign m_intf.arb.req.request = m_arb_request[i];
         assign m_intf.arb.req.read = m_arb_read[i];
         assign m_intf.arb.req.write = m_arb_write[i];
         assign m_intf.arb.req.burstcount = m_arb_burstcount[i];
         assign m_intf.arb.req.address = m_arb_address[i];
         assign m_intf.arb.req.writedata = m_arb_writedata[i];
         assign m_intf.arb.req.byteenable = m_arb_byteenable[i];
         assign m_arb_stall[i] = m_intf.arb.stall;
         assign m_wrp_ack[i] = m_intf.wrp.ack;
         assign m_rrp_datavalid[i] = m_intf.rrp.datavalid;
         assign m_rrp_data[i] = m_intf.rrp.data;
         assign m_intf.arb.req.id = id;
      end

   endgenerate

   generate
   begin:s
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(1)
      ) in_arb_intf();
      acl_arb_intf
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(1)
      ) out_arb_intf();
      acl_ic_wrp_intf
      #(
         .ID_W(1)
      ) wrp_intf();
      acl_ic_rrp_intf
      #(
         .DATA_W(512),
         .ID_W(1)
      ) rrp_intf();

      // INST s_endp of acl_ic_slave_endpoint
      acl_ic_slave_endpoint
      #(
         .DATA_W(512),
         .BURSTCOUNT_W(1),
         .ADDRESS_W(1),
         .BYTEENA_W(64),
         .ID_W(1),
         .NUM_MASTERS(2),
         .PIPELINE_RETURN_PATHS(0),
         .WRP_FIFO_DEPTH(0),
         .RRP_FIFO_DEPTH(0),
         .RRP_USE_LL_FIFO(1),
         .SLAVE_FIXED_LATENCY(4),
         .SEPARATE_READ_WRITE_STALLS(0)
      )
      s_endp
      (
         .clock(clock),
         .resetn(resetn),
         .m_intf(in_arb_intf),
         .s_intf(out_arb_intf),
         .s_readdatavalid(mout_rrp_datavalid),
         .s_readdata(mout_rrp_data),
         .s_writeack(mout_wrp_ack),
         .wrp_intf(wrp_intf),
         .rrp_intf(rrp_intf)
      );

   end
   endgenerate

   generate
   begin:wrp
      assign m[1].wrp_intf.ack = s.wrp_intf.ack;
      assign m[1].wrp_intf.id = s.wrp_intf.id;
   end
   endgenerate

   generate
   begin:rrp
      assign m[0].rrp_intf.datavalid = s.rrp_intf.datavalid;
      assign m[0].rrp_intf.data = s.rrp_intf.data;
      assign m[0].rrp_intf.id = s.rrp_intf.id;
   end
   endgenerate

   generate
      for( i = 0; i < 1; i = i + 1 )
      begin:a
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) m0_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) m1_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) mout_intf();

         // INST a of acl_arb2
         acl_arb2
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1),
            .PIPELINE("none"),
            .KEEP_LAST_GRANT(0),
            .NO_STALL_NETWORK(0)
         )
         a
         (
            .clock(clock),
            .resetn(resetn),
            .m0_intf(m0_intf),
            .m1_intf(m1_intf),
            .mout_intf(mout_intf)
         );

      end

   endgenerate

   generate
      for( i = 0; i < 1; i = i + 1 )
      begin:dp
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) in_intf();
         acl_arb_intf
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         ) out_intf();

         // INST dp of acl_arb_pipeline_reg
         acl_arb_pipeline_reg
         #(
            .DATA_W(512),
            .BURSTCOUNT_W(1),
            .ADDRESS_W(1),
            .BYTEENA_W(64),
            .ID_W(1)
         )
         dp
         (
            .clock(clock),
            .resetn(resetn),
            .in_intf(in_intf),
            .out_intf(out_intf)
         );

      end

   endgenerate

   assign mout_arb_request = s.out_arb_intf.req.request;
   assign mout_arb_read = s.out_arb_intf.req.read;
   assign mout_arb_write = s.out_arb_intf.req.write;
   assign mout_arb_burstcount = s.out_arb_intf.req.burstcount;
   assign mout_arb_address = s.out_arb_intf.req.address;
   assign mout_arb_writedata = s.out_arb_intf.req.writedata;
   assign mout_arb_byteenable = s.out_arb_intf.req.byteenable;
   assign mout_arb_id = s.out_arb_intf.req.id;
   assign s.out_arb_intf.stall = mout_arb_stall;
   assign s.in_arb_intf.req = dp[0].out_intf.req;
   assign dp[0].out_intf.stall = s.in_arb_intf.stall;
   assign dp[0].in_intf.req = a[0].mout_intf.req;
   assign a[0].mout_intf.stall = dp[0].in_intf.stall;
   assign a[0].m0_intf.req = m[0].arb_intf.req;
   assign m[0].arb_intf.stall = a[0].m0_intf.stall;
   assign a[0].m1_intf.req = m[1].arb_intf.req;
   assign m[1].arb_intf.stall = a[0].m1_intf.stall;
endmodule

