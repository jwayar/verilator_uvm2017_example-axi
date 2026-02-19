package utils_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class in_order_comparator #(
      type T = uvm_sequence_item
  ) extends uvm_component;

    `uvm_component_param_utils(in_order_comparator #(T))

    uvm_analysis_export #(T) before_export;
    uvm_analysis_export #(T) after_export;

    uvm_tlm_analysis_fifo #(T) before_fifo;
    uvm_tlm_analysis_fifo #(T) after_fifo;

    int m_matches;
    int m_misses;
    // Allows to configure a tolerance for left data in FIFO
    // that was not compared.
    int fifo_not_empty_tolerance = 0;

    function new(string name, uvm_component parent);
      super.new(name, parent);

      m_matches = 0;
      m_misses  = 0;
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      before_export = new("before_export", this);
      after_export = new("after_export", this);

      before_fifo = new("before_fifo", this);
      after_fifo = new("after_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      before_export.connect(before_fifo.analysis_export);
      after_export.connect(after_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      string msg;
      T before_item, after_item;

      forever begin
        before_fifo.get(before_item);
        after_fifo.get(after_item);

        if (!before_item.compare(after_item)) begin
          msg = "\n";
          msg = {msg, $sformatf("Expected: %s", before_item.convert2string())};
          msg = {msg, $sformatf("Received: %s", after_item.convert2string())};
          uvm_report_error(get_name, msg);
          m_misses++;
        end else begin
          m_matches++;
        end
      end
    endtask : run_phase

    function void report_phase(uvm_phase phase);
      string msg = "\n";
      msg = {msg, $sformatf("Matches: %0d\n", m_matches)};
      msg = {msg, $sformatf("Misses: %0d\n", m_misses)};
      if (before_fifo.used() > fifo_not_empty_tolerance)
        msg = {msg, $sformatf("Before FIFO count: %0d\n", before_fifo.used())};
      if (after_fifo.used() > fifo_not_empty_tolerance)
        msg = {msg, $sformatf("After FIFO count: %0d\n", after_fifo.used())};
      `uvm_info(get_name, msg, UVM_NONE);

      assert (before_fifo.used() <= fifo_not_empty_tolerance)
      else `uvm_error(get_name, "Before FIFO not empty.");
      assert (after_fifo.used() <= fifo_not_empty_tolerance)
      else `uvm_error(get_name, "After FIFO not empty.");
    endfunction : report_phase

  endclass

  virtual class queued_subscriber #(
      type T = uvm_sequence_item
  ) extends uvm_component;

    uvm_analysis_export #(T)   analysis_export;
    uvm_tlm_analysis_fifo #(T) seq_item_fifo;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      analysis_export = new("analysis_export", this);
      seq_item_fifo   = new("seq_item_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      analysis_export.connect(seq_item_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      forever begin
        T seq_item;
        seq_item_fifo.get(seq_item);
        write(seq_item);
      end
    endtask

    pure virtual task write(T t);

  endclass


endpackage
