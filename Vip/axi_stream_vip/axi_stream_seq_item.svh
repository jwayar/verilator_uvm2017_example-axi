// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//                    ______          __            __                         :
//                   / ____/___ ___  / /____  _____/ /_                        :
//                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \                       :
//                 / /___/ / / / / / /_/  __/ /__/ / / /                       :
//                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/                        :
//                                                                             :
// This file contains confidential and proprietary information of Emtech SA.   :
// Any unauthorized copying, alteration, distribution, transmission,           :
// performance, display or other use of this material is prohibited.           :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//                                                                             :
// Client             :                                                        :
// Version            : 1.0                                                    :
// Application        : Generic                                                :
// Filename           : axi_stream_seq_item.svh                                :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream sequence item class                             :
// Author(s)          : Juan Doctorovich,            Fernando Gerbino          :
// Email              : jdoctorovich@emtech.com.ar,  fgerbino@emtech.com.ar    :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------

`ifndef AXI_STREAM_SEQ_ITEM_SVH
`define AXI_STREAM_SEQ_ITEM_SVH

class axi_stream_seq_item #(
    parameter PARM_DATA_WIDTH = 64,
    parameter PARM_ID_WIDTH   = 4,
    parameter PARM_DEST_WIDTH = 4,
    parameter PARM_USER_WIDTH = 32
) extends uvm_sequence_item;

  typedef axi_stream_seq_item #(
      .PARM_DATA_WIDTH(PARM_DATA_WIDTH),
      .PARM_ID_WIDTH(PARM_ID_WIDTH),
      .PARM_DEST_WIDTH(PARM_DEST_WIDTH),
      .PARM_USER_WIDTH(PARM_USER_WIDTH)
  ) axi_stream_seq_item_t ;

  `uvm_object_param_utils(axi_stream_seq_item_t)

  rand logic [PARM_DATA_WIDTH   -1 : 0] tdata [];
  rand logic [PARM_DATA_WIDTH/8 -1 : 0] tstrb [];
  rand logic [PARM_DATA_WIDTH/8 -1 : 0] tkeep [];
  rand logic [PARM_USER_WIDTH   -1 : 0] tuser [];
  rand logic [PARM_DEST_WIDTH   -1 : 0] tdest [];
  rand logic [PARM_ID_WIDTH     -1 : 0] tid   [];

  rand int                              trans_length     ;
  rand int                              trans_length_min ;
  rand int                              trans_length_max ;

  rand int                              delay_cycles     ;
  rand int                              delay_cycles_min ;
  rand int                              delay_cycles_max ;

  rand int                              tready_delay     ;
  rand int                              tready_delay_min ;
  rand int                              tready_delay_max ;

  rand int                              tvalid_delay     ;
  rand int                              tvalid_delay_min ;
  rand int                              tvalid_delay_max ;

  rand int                              tready_high_delay     ;
  rand int                              tready_high_delay_min ;
  rand int                              tready_high_delay_max ;

  rand bit                              send_counter_data  ;
  rand int                              counter_start_data ;
  rand int                              counter_step_data  ;

  // Time stamp field
  realtime                              timestamp ;
  int                                   id ;

  constraint c_delays_default {
    soft delay_cycles_min == DELAY_CYCLES_MIN_DEFAULT ;
    soft delay_cycles_max == DELAY_CYCLES_MAX_DEFAULT ;

    soft tready_delay_min == TREADY_DELAY_MIN_DEFAULT ;
    soft tready_delay_max == TREADY_DELAY_MAX_DEFAULT ;

    soft tvalid_delay_min == TVALID_DELAY_MIN_DEFAULT ;
    soft tvalid_delay_max == TVALID_DELAY_MAX_DEFAULT ;

    soft tready_high_delay_min == TREADY_HIGH_DELAY_MIN_DEFAULT ;
    soft tready_high_delay_max == TREADY_HIGH_DELAY_MAX_DEFAULT;

    delay_cycles      inside {[delay_cycles_min      : delay_cycles_max     ]};
    tready_delay      inside {[tready_delay_min      : tready_delay_max     ]};
    tvalid_delay      inside {[tvalid_delay_min      : tvalid_delay_max     ]};
    tready_high_delay inside {[tready_high_delay_min : tready_high_delay_max]};
  }

  constraint c_axi_protocol_rules {
  // Invalid byte (TKEEP=0) cannot be a position byte (TSTRB=1).
    foreach (tkeep[i]) {
        (tstrb[i] & ~tkeep[i]) == 0; //check bit level
    }
  }

  constraint c_trans_length {
    soft trans_length_min == TRANS_LENGTH_MIN_DEFAULT ;
    soft trans_length_max == TRANS_LENGTH_MAX_DEFAULT ;

    soft trans_length inside {[trans_length_min : trans_length_max]};
  }

  constraint c_signals_consistency {
    // Control signals must match data size
    tdata.size() == trans_length;
    tstrb.size() == trans_length;
    tkeep.size() == trans_length;
    tuser.size() == trans_length;
    tid.size()   == trans_length;
    tdest.size() == trans_length;
  }

  constraint c_stable_signals_per_packet {
      foreach (tid[i])   soft tid[i]   == tid[0];
      foreach (tdest[i]) soft tdest[i] == tdest[0];
  }

  constraint c_avoid_tkeep_sparse {
    foreach (tkeep[i]) {
      (i < tkeep.size() - 1) ?
          (tkeep[i] == '1) :        // Intermediate transfers: Must be full
          ($onehot0(tkeep[i] + 1)); // Last transfers: Could be partial but must be contiguous (no sparse)
    }
  }

  constraint c_counter_data {

    soft send_counter_data == 0;
    soft counter_start_data inside {[1:1024]};
    soft counter_step_data  inside {1,256,512};

    //TODOjw: Unsupported in Verilator
    // (send_counter_data == 1) -> {
    //   foreach(tdata[i]) tdata[i] == counter_start_data + (i*counter_step_data);
    // }
  }

  //TODOjw: solution for Verilator unsupported feature (?)
  function void post_randomize();
    super.post_randomize();

    if (send_counter_data) begin
      for (int i = 0; i < tdata.size(); i++) begin
        tdata[i] = counter_start_data + (i * counter_step_data);
      end
    end
  endfunction

  extern function new(string name = "axi_stream_transaction");
  extern function void do_copy(uvm_object rhs);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();
  extern function void do_pack(uvm_packer packer);
  extern function void do_unpack(uvm_packer packer);
  extern function void do_print(uvm_printer printer);
endclass : axi_stream_seq_item

function axi_stream_seq_item::new(string name = "axi_stream_transaction");
  super.new(name);
endfunction : new

function void axi_stream_seq_item::do_copy(uvm_object rhs);
  axi_stream_seq_item_t  rhs_;

  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal({this.get_name(), ".do_copy()"}, "Cast failed!")
    return;
  end

  super.do_copy(rhs);

  this.tdata             = rhs_.tdata;
  this.tstrb             = rhs_.tstrb;
  this.tkeep             = rhs_.tkeep;
  this.tid               = rhs_.tid;
  this.tdest             = rhs_.tdest;
  this.tuser             = rhs_.tuser;
  this.delay_cycles      = rhs_.delay_cycles;
  this.tready_delay      = rhs_.tready_delay;
  this.tvalid_delay      = rhs_.tvalid_delay;
  this.tready_high_delay = rhs_.tready_high_delay;

endfunction : do_copy

function bit axi_stream_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  axi_stream_seq_item_t  rhs_;
  string s = "";
  bit status;
  int i = 0;

  if (!$cast(rhs_, rhs)) begin
    `uvm_fatal({this.get_name(), ".do_compare()"}, "Cast failed!")
    return 0;
  end

  status = super.do_compare(rhs, comparer);

  // TDATA
  if (tdata.size() != rhs_.tdata.size()) `uvm_fatal({this.get_name(), ".do_compare()"}, $sformatf("TDATA Size Mismatch: Expected %0d, Got %0d", tdata.size(), rhs_.tdata.size()))
  foreach (tdata[i]) status &= comparer.compare_field($sformatf("tdata[%0d]", i), tdata[i], rhs_.tdata[i], $bits(tdata[i]));

  //TID
  if (tid.size() != rhs_.tid.size()) `uvm_fatal({this.get_name(), ".do_compare()"}, $sformatf("TID Size Mismatch: Expected %0d, Got %0d", tid.size(), rhs_.tid.size()))
  foreach (tid[i]) status &= comparer.compare_field($sformatf("tid[%0d]", i), tid[i], rhs_.tid[i], $bits(tid[i]));

  //TDEST
  if (tdest.size() != rhs_.tdest.size()) `uvm_fatal({this.get_name(), ".do_compare()"}, $sformatf("TDEST Size Mismatch: Expected %0d, Got %0d", tdest.size(), rhs_.tdest.size()))
  foreach (tdest[i]) status &= comparer.compare_field($sformatf("tdest[%0d]", i), tdest[i], rhs_.tdest[i], $bits(tdest[i]));

  //TUSER
  if (tuser.size() != rhs_.tuser.size()) `uvm_fatal({this.get_name(), ".do_compare()"}, $sformatf("TUSER Size Mismatch: Expected %0d, Got %0d", tuser.size(), rhs_.tuser.size()))
  foreach (tuser[i]) status &= comparer.compare_field($sformatf("tuser[%0d]", i), tuser[i], rhs_.tuser[i], $bits(tuser[i]));

  return status;
endfunction : do_compare

function string axi_stream_seq_item::convert2string();
  string s = "";

  s = super.convert2string();
  s = {s, "\n---------------------------------------------------------------------\n"};
  s = {s, "Name                Size (transfers)    Value (Array Content)\n"};
  s = {s, "---------------------------------------------------------------------\n"};


  s = {s, $sformatf("tdata               %0d             %p\n" , tdata.size(), tdata)};
  s = {s, $sformatf("tstrb               %0d             %p\n" , tstrb.size(), tstrb)};
  s = {s, $sformatf("tkeep               %0d             %p\n" , tkeep.size(), tkeep)};
  s = {s, $sformatf("tid                 %0d             %p\n" , tid.size()  , tid  )};
  s = {s, $sformatf("tdest               %0d             %p\n" , tdest.size(), tdest)};
  s = {s, $sformatf("tuser               %0d             %p\n" , tuser.size(), tuser)};
  s = {s, $sformatf("trans_length        1               %0d\n", trans_length       )};
  s = {s, $sformatf("send_counter_data   1               %0d\n", send_counter_data  )};
  s = {s, $sformatf("counter_start_data  1               %0d\n", counter_start_data )};
  s = {s, $sformatf("counter_step_data   1               %0d\n", counter_step_data  )};
  s = {s, $sformatf("delay_cycles        1               %0d\n", delay_cycles       )};
  s = {s, $sformatf("tready_delay        1               %0d\n", tready_delay       )};
  s = {s, $sformatf("tvalid_delay        1               %0d\n", tvalid_delay       )};
  s = {s, $sformatf("tready_high_delay   1               %0d\n", tready_high_delay  )};

  s = {s, "-----------------------------------------------------------------------\n"};

  return s;
endfunction : convert2string

function void axi_stream_seq_item::do_pack(uvm_packer packer);
  super.do_pack(packer);
endfunction

function void axi_stream_seq_item::do_unpack(uvm_packer packer);
  super.do_unpack(packer);
endfunction

function void axi_stream_seq_item::do_print(uvm_printer printer);
    string s = "";
    int i;
    super.do_print(printer);

    // Variables
    printer.print_int("trans_length"       ,trans_length       ,32 , UVM_DEC);
    printer.print_int("send_counter_data"  ,send_counter_data  ,32 , UVM_DEC);
    printer.print_int("counter_start_data" ,counter_start_data ,32 , UVM_DEC);
    printer.print_int("counter_step_data " ,counter_step_data  ,32 , UVM_DEC);
    printer.print_int("delay_cycles"       ,delay_cycles       ,32 , UVM_DEC);
    printer.print_int("tready_delay"       ,tready_delay       ,32 , UVM_DEC);
    printer.print_int("tvalid_delay"       ,tvalid_delay       ,32 , UVM_DEC);
    printer.print_int("tready_high_delay"  ,tready_high_delay  ,32 , UVM_DEC);
    printer.print_int("id"                 ,id                 ,32 , UVM_DEC);

    // Interface signals
    // TDATA
    s = $sformatf("(%0d transfers): ", tdata.size());
    foreach (tdata[i]) s = {s, $sformatf("0x%0h ", tdata[i])};
    printer.print_string("tdata", s);

    // TSTRB
    s = $sformatf("(%0d transfers): ", tstrb.size());
    foreach (tstrb[i]) s = {s, $sformatf("0x%0h ", tstrb[i])};
    printer.print_string("tstrb", s);

    // TKEEP
    s = $sformatf("(%0d transfers): ", tkeep.size());
    foreach (tkeep[i]) s = {s, $sformatf("0x%0h ", tkeep[i])};
    printer.print_string("tkeep", s);

    // TID
    s = $sformatf("(%0d transfers): ", tid.size());
    foreach (tid[i]) s = {s, $sformatf("0x%0h ", tid[i])};
    printer.print_string("tid", s);

    // TDEST
    s = $sformatf("(%0d transfers): ", tdest.size());
    foreach (tdest[i]) s = {s, $sformatf("0x%0h ", tdest[i])};
    printer.print_string("tdest", s);

    // TUSER
    s = $sformatf("(%0d transfers): ", tuser.size());
    foreach (tuser[i]) s = {s, $sformatf("0x%0h ", tuser[i])};
    printer.print_string("tuser", s);

endfunction : do_print


`endif
