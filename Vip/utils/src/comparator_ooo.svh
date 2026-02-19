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
// Filename           : comparator_ooo.svh                                     :
// Date Last Modified : 2021 OCT 07                                            :
// Date Created       : 2021 OCT 07                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Generic out-of-order comparator                        :
// Author(s)          : Nicolas Bertolo                                        :
// Email              : nbertolo@emtech.com.ar                                 :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
// This comparator implements out-of-order comparisons between the `before`
// and `after` imports.
//
// It classifies sequence items according to their "kind" (see method
// `get_kind` and type parameter `Kind`).
// Sequence items with the same kind are compared in order.
//
// This class should be inherited-from and the subclass shall implement the
// `get_kind` and `kind2string` methods.
//
// See UVM Cookbook section "Comparing transactions out-of-order" a more complete
// description of a similar component.
//
// -----------------------------------------------------------------------------

`ifndef COMPARATOR_OOO_SVH
`define COMPARATOR_OOO_SVH

`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

virtual class comparator_ooo #(
    type Seq_Item,
    type Kind
) extends uvm_component;
  `uvm_component_param_utils(comparator_ooo#(Seq_Item, Kind))
  typedef comparator_ooo#(Seq_Item, Kind) this_type_t;

  uvm_analysis_imp_before #(Seq_Item, this_type_t) before_export;
  uvm_analysis_imp_after #(Seq_Item, this_type_t)  after_export;

  typedef Seq_Item seq_item_queue_t[$];

  seq_item_queue_t m_before[Kind];
  seq_item_queue_t m_after[Kind];

  int m_mismatches = 0;
  int m_matches = 0;

  function new(string name = "comparator_ooo", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  /* This function must be overridden by a subclass to provide an implementation
   * that shall classify a sequence item into an object of type `Kind`.
   */
  pure virtual function Kind get_kind(Seq_Item item);

  /* This function must be overridden by a subclass to provide an implementation
   * that shall convert an object of type `Kind` into a string.
   *
   * This method may be used in the report phase to report about a different item
   * between the `after` and `before` imports.
   */
  pure virtual function string kind2string(Kind kind);

  virtual function void write_before(Seq_Item item);
    Kind kind;
    kind = get_kind(item);
    m_before[kind].push_back(item);
    m_proc_data(kind);
  endfunction : write_before

  virtual function void write_after(Seq_Item item);
    Kind kind;
    kind = get_kind(item);
    m_after[kind].push_back(item);
    m_proc_data(kind);
  endfunction : write_after

  function void m_proc_data(Kind kind);
    if (m_after[kind].size() > 0 && m_before[kind].size() > 0) begin
      Seq_Item bef = m_before[kind].pop_front();
      Seq_Item aft = m_after[kind].pop_front();

      if (!bef.compare(aft)) begin
        m_mismatches++;
        handle_mismatch(bef, aft);
      end else begin
        m_matches++;
      end
    end
  endfunction : m_proc_data

  /* This method may be overridden to do something else when a mismatch occurs. */
  virtual function void handle_mismatch(Seq_Item bef, Seq_Item aft);
    `uvm_error("Comparator mismatch", $sformatf(
               "Before %s\n\ndoes not match\n After %s", bef.convert2string(), aft.convert2string()
               ))
  endfunction : handle_mismatch

  function void build_phase(uvm_phase phase);
    before_export = new("before_export", this);
    after_export  = new("after_export", this);
  endfunction : build_phase

  function void report_phase(uvm_phase phase);
    Kind all_kinds[$];

    `uvm_info("Comparator", $sformatf("Matches:\t\t%0d", m_matches), UVM_LOW);
    `uvm_info("Comparator", $sformatf("Mismatches:\t\t%0d", m_mismatches), UVM_LOW);

    // Get all kinds that have an associated queue.
    foreach (m_after[kind]) begin
      all_kinds.push_back(kind);
    end

    foreach (m_before[kind]) begin
      all_kinds.push_back(kind);
    end

    all_kinds = all_kinds.unique();
    all_kinds.sort();

    foreach (all_kinds[i]) begin
      if (m_after[all_kinds[i]].size() > 0) begin
        `uvm_error(
            "Comparator", {
            "After generated more sequence items than Before for kind ", kind2string(all_kinds[i])
            });
      end

      if (m_before[all_kinds[i]].size() > 0) begin
        `uvm_error(
            "Comparator", {
            "Before generated more sequence items than After for kind ", kind2string(all_kinds[i])
            });
      end
    end
  endfunction : report_phase

endclass : comparator_ooo

`endif
