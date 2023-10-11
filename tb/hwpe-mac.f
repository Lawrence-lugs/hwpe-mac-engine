#---------------
# Make sure to do bender script flist first
# So you can generate the dependencies
# Then make sure you get the paths right
#---------------

#---------------
# Include
#---------------
+incdir+../rtl

#---------------
# Tech cells
#---------------
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/rtl/tc_sram.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/rtl/tc_sram_impl.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/rtl/tc_clk.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/cluster_pwr_cells.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/generic_memory.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/generic_rom.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/pad_functional.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/pulp_buffer.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/pulp_pwr_cells.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/tc_pwr.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/pulp_clock_gating_async.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/cluster_clk_cells.sv
../.bender/git/checkouts/tech_cells_generic-7335caf8df10c550/src/deprecated/pulp_clk_cells.sv

#---------------
# HWPE Control
#---------------
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_interfaces.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_package.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_regfile_latch.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_seq_mult.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_uloop.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_regfile_latch_test_wrap.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_regfile.sv
../.bender/git/checkouts/hwpe-ctrl-f5690aefad1c3dcf/rtl/hwpe_ctrl_slave.sv

#---------------
# HWPE Stream
#---------------
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/hwpe_stream_interfaces.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/hwpe_stream_package.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_assign.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_buffer.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_demux_static.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_deserialize.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_fence.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_merge.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_mux_static.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_serialize.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/basic/hwpe_stream_split.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo_ctrl.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo_scm.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_addressgen.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_addressgen_v2.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_addressgen_v3.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_sink_realign.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_source_realign.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_strbgen.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_streamer_queue.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_assign.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_mux.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_mux_static.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_reorder.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_reorder_static.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo_earlystall.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo_earlystall_sidech.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo_scm_test_wrap.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo_sidech.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/fifo/hwpe_stream_fifo.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_fifo_load_sidech.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_source.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_fifo.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_fifo_load.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/tcdm/hwpe_stream_tcdm_fifo_store.sv
../.bender/git/checkouts/hwpe-stream-865c52d980484060/rtl/streamer/hwpe_stream_sink.sv

#---------------
# HWPE MAC Engine
#---------------
../rtl/mac_package.sv
../rtl/mac_engine.sv
../rtl/mac_fsm.sv
../rtl/mac_streamer.sv
../rtl/mac_ctrl.sv
../rtl/mac_top.sv
../wrap/mac_top_wrap.sv

#---------------
# HWPE MAC TB
#---------------
./tb_mac.sv