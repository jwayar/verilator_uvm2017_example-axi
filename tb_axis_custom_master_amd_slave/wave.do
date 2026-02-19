# ======================================================================
# GENERAL CONFIGURATION
# ======================================================================

# Configure to show only the signal name (hide the long path)
configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits ns

# ======================================================================
# INTERFACE 1: MST
# ======================================================================
add wave -noupdate -divider "AXI Stream Master"

# Note: The '-expand' flag forces the group to be open by default

# 1. Globals
add wave -noupdate -expand -group "MST Interface"  /axis_tb_top/master_if/aresetn
add wave -noupdate -expand -group "MST Interface"  /axis_tb_top/master_if/aclk

# 2. Control Handshake
add wave -noupdate -expand -group "MST Interface" -radix binary  /axis_tb_top/master_if/tvalid
add wave -noupdate -expand -group "MST Interface" -radix binary  /axis_tb_top/master_if/tready
add wave -noupdate -expand -group "MST Interface" -radix binary  /axis_tb_top/master_if/tlast

# 3. Data Payload 
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/tdata
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/tstrb
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/tkeep

# 4. Sideband Signals 
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/tid
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/tdest
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/tuser

# ======================================================================
# INTERFACE 2: SLAVE
# ======================================================================
add wave -noupdate -divider "AXI Stream Slave"

# 1. Globals
add wave -noupdate -expand -group "SLV Interface"  /axis_tb_top/slave_if/ARESET_N
add wave -noupdate -expand -group "SLV Interface"  /axis_tb_top/slave_if/ACLK

# 2. Control Handshake
add wave -noupdate -expand -group "SLV Interface" -radix binary  /axis_tb_top/slave_if/TVALID
add wave -noupdate -expand -group "SLV Interface" -radix binary  /axis_tb_top/slave_if/TREADY
add wave -noupdate -expand -group "SLV Interface" -radix binary  /axis_tb_top/slave_if/TLAST

# 3. Data Payload
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/TDATA
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/TSTRB
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/TKEEP

# 4. Sideband Signals
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/TID
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/TDEST
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/TUSER


# ======================================================================
# VISUAL CHECKS
# ======================================================================
add wave -noupdate -divider "Live Checks"

# if (Valid=1 y Ready=1) -> data comparison --> 1=pass / 0=fail
# if (Valid=0 o Ready=0) -> 1 (Assuming OK --> IDLE state).

virtual function -install /axis_tb_top { \
    ( /axis_tb_top/master_if/tvalid == 1 && /axis_tb_top/master_if/tready == 1 ) ? \
    ( (/axis_tb_top/master_if/tdata == /axis_tb_top/slave_if/TDATA) ? 1 : 0 ) : \
    1 \
} SMART_MATCH

add wave -noupdate -expand -group "Visual Checks" -radix unsigned -format logic -color "magenta" -height 30 /axis_tb_top/SMART_MATCH

# ======================================================================
# FINISH
# ======================================================================
TreeUpdate [SetDefaultTree]