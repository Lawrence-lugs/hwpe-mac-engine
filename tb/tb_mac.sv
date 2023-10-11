//-----------------------------------
// Simple MAC engine testbench
//-----------------------------------
`timescale 1ns/1ps

module tb_mac;

  //-----------------------------------
  // Localparameter declarations
  //-----------------------------------
  localparam int unsigned MemoryPorts = 4;
  localparam int unsigned DataWidth   = 32;
  localparam int unsigned AddrWidth   = 32;
  localparam int unsigned StrbWidth   = DataWidth/8;
  localparam int unsigned NumCores    = 1;
  localparam int unsigned IdWidth     = 5;

  //------------------------------
  // Register Declarations
  // How did I know this? Asking the right people :)
  // And digging through the code :'(
  // Also note that the CSR's are "memory-mapped"
  // hence the 4 byte jumps
  //------------------------------
  localparam int unsigned REGFILE_MANDATORY_TRIGGER   = 32'd0;      // This starts the accelerator
  localparam int unsigned REGFILE_MANDATORY_ACQUIRE   = 32'd4;
  localparam int unsigned REGFILE_MANDATORY_FINISHED  = 32'd8;
  localparam int unsigned REGFILE_MANDATORY_STATUS    = 32'd12;
  localparam int unsigned REGFILE_MANDATORY_RUNNING   = 32'd16;
  localparam int unsigned REGFILE_MANDATORY_SOFTCLEAR = 32'd20;
  localparam int unsigned REGFILE_MANDATORY_RESERVED  = 32'd24;
  localparam int unsigned REGFILE_MANDATORY_SWEVT     = 32'd28;

  // Generic registers means they are just read/write but does not
  // control anything within the MAC engine
  localparam int unsigned GENERIC_0 = 32'd32;
  localparam int unsigned GENERIC_1 = 32'd36;
  localparam int unsigned GENERIC_2 = 32'd40;
  localparam int unsigned GENERIC_3 = 32'd44;
  localparam int unsigned GENERIC_4 = 32'd48;
  localparam int unsigned GENERIC_5 = 32'd52;
  localparam int unsigned GENERIC_6 = 32'd56;
  localparam int unsigned GENERIC_7 = 32'd60;

  // The first 4 are obviously 3 input addresses and an output address
  // The NB_ITER is number of iterations, just do 1
  // LEN_ITER is the vector length or number of elements
  // Set LSB of simple mul to do multiply only and 0 if MAC
  // VECSTRIDE is unused
  localparam int unsigned MAC_REG_A_ADDR   = 32'd64;  
  localparam int unsigned MAC_REG_B_ADDR   = 32'd68;
  localparam int unsigned MAC_REG_C_ADDR   = 32'd72;
  localparam int unsigned MAC_REG_D_ADDR   = 32'd76;
  localparam int unsigned MAC_REG_NB_ITER  = 32'd80;
  localparam int unsigned MAC_REG_LEN_ITER = 32'd84;
  localparam int unsigned MAC_REG_SHIFT_SIMPLEMUL = 32'd88;
  localparam int unsigned MAC_REG_SHIFT_VECSTRIDE = 32'd92;

  //------------------------------
  // Clock and reset
  //------------------------------
  logic clk;
  logic rstn;

  //-----------------------------------
  // TCDM Wiring declaration
  // Sorry was lazy to fix this but I just copy
  // pasted from my other test bench
  //-----------------------------------
  typedef logic [AddrWidth-1:0] hwpe_mem_addr_t;
  typedef logic [DataWidth-1:0] mem_data_t;
  typedef logic [StrbWidth-1:0] mem_strb_t;

  typedef struct packed {
    logic           [MemoryPorts-1:0]  req;
    logic           [MemoryPorts-1:0]  gnt;
    hwpe_mem_addr_t [MemoryPorts-1:0]  add;
    logic           [MemoryPorts-1:0]  wen;
    mem_strb_t      [MemoryPorts-1:0]  be;
    mem_data_t      [MemoryPorts-1:0]  data;
    mem_data_t      [MemoryPorts-1:0]  r_data;
    logic           [MemoryPorts-1:0]  r_valid;
    logic                              r_opc;
    logic                              r_user;
  } loc_mem_t;

  loc_mem_t tcdm_port;

  //------------------------------
  // HWPE Peripheral Interface
  //------------------------------
  hwpe_ctrl_intf_periph #(
      .ID_WIDTH ( IdWidth )
  ) hwpe_periph (
      .clk ( clk )
  );


  //------------------------------
  // Clock driver
  //------------------------------
  always begin #10; clk <= !clk; end

  //------------------------------
  // Tasks
  //------------------------------
  logic [DataWidth-1:0] task_output;

  task csr_write (
    input logic [AddrWidth-1:0] csr_addr,
    input logic [DataWidth-1:0] csr_data
  );

    @(posedge clk); #1;
    
    hwpe_periph.req  = 1'b1;
    hwpe_periph.add  = csr_addr;
    hwpe_periph.wen  = 1'b0;
    hwpe_periph.be   = '1;
    hwpe_periph.data = csr_data;
    hwpe_periph.id   = '0;

    @(posedge clk); #1;

    hwpe_periph.req  = 1'b0;
    hwpe_periph.add  = '0;
    hwpe_periph.wen  = 1'b1;
    hwpe_periph.be   = '1;
    hwpe_periph.data = '0;
    hwpe_periph.id   = '0;

     #1;

  endtask


  task csr_read (
    input logic [AddrWidth-1:0] csr_addr
  );

    @(posedge clk); #1;

    hwpe_periph.req  = 1'b1;
    hwpe_periph.add  = csr_addr;
    hwpe_periph.wen  = 1'b1;
    hwpe_periph.be   = '1;
    hwpe_periph.data = '0;
    hwpe_periph.id   = '0;

    @(posedge clk); #1;

    hwpe_periph.req  = 1'b0;
    hwpe_periph.add  = '0;
    hwpe_periph.wen  = 1'b1;
    hwpe_periph.be   = '1;
    hwpe_periph.data = '0;
    hwpe_periph.id   = '0;

    #1;

    task_output <= hwpe_periph.r_data;

    $display("CSR value: %h", task_output);

  endtask


  //------------------------------
  // Synthetic TCDM Memory Control
  //------------------------------
  // Quick Cheat: Let's assume each TCDM port
  // is dedicated to 1 bank only. But in practice,
  // it should support any bank.
  //------------------------------

  logic [31:0] a_mem   [128];
  logic [31:0] b_mem   [128];
  logic [31:0] c_mem   [128];
  logic [31:0] out_mem [128];

  // Pre-load data
  initial begin
    $readmemh( "./a.mem",   a_mem   );
    $readmemh( "./b.mem",   b_mem   );
    $readmemh( "./c.mem",   c_mem   );
    $readmemh( "./out.mem", out_mem );
  end

  // Grant control
  always_ff @ (posedge clk or negedge rstn) begin
    if (!rstn) begin
      for ( int unsigned i = 0; i < MemoryPorts; i++) begin
        tcdm_port.gnt[i] <= 1'b0;
      end
    end else begin
      for ( int unsigned i = 0; i < MemoryPorts; i++) begin
        tcdm_port.gnt[i] <= tcdm_port.req[i];
      end
    end
  end


  // Write handler control
  // Note that this works for output memory only
  // The wen signal of the TDCM port is inverted
  // Whenever wen = 1'b0, we write
  // But when wen = 1'b1, we read
  // Don't ask me why since they built this not me :P - Ry
  // Address is divided by 4 since memory should be byte addressable
  // but in multiples of 4 (word wide)
  always_ff @ (posedge clk) begin
    if( tcdm_port.req[3] && tcdm_port.gnt[3] && !tcdm_port.wen[3] ) begin
      out_mem[tcdm_port.add[3] >> 2] <= tcdm_port.data[3];
    end
  end


  // Read control
  always_comb begin
    for ( int unsigned i = 0; i < MemoryPorts; i++) begin
      tcdm_port.r_valid[i] = tcdm_port.req[i] && tcdm_port.gnt[i] && tcdm_port.wen[i];
    end
    tcdm_port.r_data[0] =   a_mem[tcdm_port.add[0] >> 2];
    tcdm_port.r_data[1] =   b_mem[tcdm_port.add[1] >> 2];
    tcdm_port.r_data[2] =   c_mem[tcdm_port.add[2] >> 2];
    tcdm_port.r_data[3] = out_mem[tcdm_port.add[3] >> 2];
  end


  //------------------------------
  // MAC Engine
  //------------------------------
  mac_top_wrap #(
    .N_CORES        ( NumCores            ),
    .MP             ( MemoryPorts         ),
    .ID             ( IdWidth             )
  ) i_mac_top (
    .clk_i          ( clk                 ),
    .rst_ni         ( rstn                ),
    .test_mode_i    ( 1'b0                ),
    .evt_o          (                     ),      // Unused
    .tcdm_req       ( tcdm_port.req       ),
    .tcdm_gnt       ( tcdm_port.gnt       ),      // input
    .tcdm_add       ( tcdm_port.add       ),
    .tcdm_wen       ( tcdm_port.wen       ),
    .tcdm_be        ( tcdm_port.be        ),
    .tcdm_data      ( tcdm_port.data      ),
    .tcdm_r_data    ( tcdm_port.r_data    ),      // input
    .tcdm_r_valid   ( tcdm_port.r_valid   ),      // input
    .periph_req     ( hwpe_periph.req     ),
    .periph_gnt     ( hwpe_periph.gnt     ),
    .periph_add     ( hwpe_periph.add     ),
    .periph_wen     ( hwpe_periph.wen     ),
    .periph_be      ( hwpe_periph.be      ),
    .periph_data    ( hwpe_periph.data    ),
    .periph_id      ( hwpe_periph.id      ),
    .periph_r_data  ( hwpe_periph.r_data  ),
    .periph_r_valid ( hwpe_periph.r_valid ),
    .periph_r_id    ( hwpe_periph.r_id    )
  );

  initial begin

    clk = 0;
    rstn = 0;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    rstn = 1;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    // Set addresses and configuration
    csr_write(MAC_REG_A_ADDR, 32'd0);
    csr_write(MAC_REG_B_ADDR, 32'd0);
    csr_write(MAC_REG_C_ADDR, 32'd0);
    csr_write(MAC_REG_D_ADDR, 32'd0);
    csr_write(MAC_REG_NB_ITER, 32'd1);
    csr_write(MAC_REG_LEN_ITER, 32'd19);

    // Set me to one if you want simple mul, otherwise set me to 0 for MAC
    csr_write(MAC_REG_SHIFT_SIMPLEMUL, 32'd1);

    @(posedge clk);
    @(posedge clk);

    // Sanity check settings
    csr_read(MAC_REG_A_ADDR);
    csr_read(MAC_REG_B_ADDR);
    csr_read(MAC_REG_C_ADDR);
    csr_read(MAC_REG_D_ADDR);
    csr_read(MAC_REG_NB_ITER);
    csr_read(MAC_REG_LEN_ITER);

    @(posedge clk);
    @(posedge clk);

    // Start the engine
    csr_write(REGFILE_MANDATORY_TRIGGER, 32'd0);

    // Poll based on status
   for(int unsigned i = 0; i < 50; i++) begin
    csr_read(REGFILE_MANDATORY_STATUS);
    if(task_output == '0) break;
   end

    #500;

  end


endmodule