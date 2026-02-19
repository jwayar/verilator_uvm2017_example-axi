package axis_tb_scoreboard_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import axi_stream_agent_pkg::*;
  import axis_tb_defn_pkg::*;
  import xilinxs_vip_pkg::*;

  // NOTE: 
  // This class converts transactions of type 
  // axi4stream_transaction (AMD transactions)
  // to axi_stream_seq_item (Custom transactions)
  // and retrieve the packet from the slave monitor

  class axis_tb_predictor extends uvm_component;
    `uvm_component_utils(axis_tb_predictor)
    
    axi4stream_slv_agent  m_axis_slave_agent; // Handler of slave agent
    axi4stream_transaction tr_in;             // AMD
    axi_st_seq_item        tr_out;            // Custom 

    uvm_analysis_port #(axi_st_seq_item) predicted_ap;

    // Aux queues to store data 
    logic [AXIS_MASTER_DATA_WIDTH-1:0]   q_tdata[$];
    logic [AXIS_MASTER_DATA_WIDTH/8-1:0] q_tkeep[$];
    logic [AXIS_MASTER_DATA_WIDTH/8-1:0] q_tstrb[$];
    logic [AXIS_MASTER_USER_WIDTH-1:0]   q_tuser[$];
    logic [AXIS_MASTER_ID_WIDTH-1:0]     q_tid  [$];
    logic [AXIS_MASTER_DEST_WIDTH-1:0]   q_tdest[$];
    
    function new(string name = "refmod", uvm_component parent);
      super.new(name, parent);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      predicted_ap    = new("predicted_ap", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
      
      axi4stream_transaction tr; //AMD transaction type
      
      forever begin
        
        // Retrieve transaction from Monitor
        // Note: item_collected_port only supports .get() method
        m_axis_slave_agent.monitor.item_collected_port.get(tr);

        // Cast and clone for safety
        if (!$cast(tr_in, tr.my_clone())) begin
          `uvm_fatal("PREDICTOR", "Cast failed on clone input transaction")
        end

        // Accumulate data into queues
        q_tdata.push_back(tr_in.get_data_beat());
        q_tkeep.push_back(tr_in.get_keep_beat());
        q_tstrb.push_back(tr_in.get_strb_beat());
        q_tuser.push_back(tr_in.get_user_beat());  
        q_tid.push_back  (tr_in.get_id()       );     
        q_tdest.push_back(tr_in.get_dest()     ); 

        // Check for TLAST (End of Packet)
        if(tr_in.get_last() === 1'b1) begin

          // Instantiate output packet
          tr_out = axi_st_seq_item::type_id::create("tr_out");

          // Populate output item with accumulated queues
          // Here is where the convertion is done 
          // (from axi4stream_transaction to axi_st_seq_item )
          tr_out.tdata = q_tdata;
          tr_out.tkeep = q_tkeep;
          tr_out.tstrb = q_tstrb;
          tr_out.tuser = q_tuser;
          tr_out.tid   = q_tid;
          tr_out.tdest = q_tdest;

          // Send packet to comparator
          predicted_ap.write(tr_out);

          // Flush queues for next packet
          q_tdata.delete();
          q_tkeep.delete();
          q_tstrb.delete();
          q_tuser.delete();
          q_tid.delete();
          q_tdest.delete();

        end // end if last
      end // end forever
    endtask: run_phase
  
  endclass: axis_tb_predictor

  class axis_tb_scoreboard extends uvm_component;
    `uvm_component_utils(axis_tb_scoreboard)
    
    uvm_analysis_export #(axi_st_seq_item) after_aexp;
    
    axis_tb_comparator cmp;
    axis_tb_predictor  prd;
  
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction: new
  
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      cmp = axis_tb_comparator::type_id::create("cmp",this);
      prd = axis_tb_predictor::type_id::create("prd", this);
      after_aexp  = new("after_aexp", this);
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
      prd.predicted_ap.connect(cmp.before_export);
      after_aexp.connect(cmp.after_export);
    endfunction: connect_phase
  
  endclass: axis_tb_scoreboard

endpackage: axis_tb_scoreboard_pkg