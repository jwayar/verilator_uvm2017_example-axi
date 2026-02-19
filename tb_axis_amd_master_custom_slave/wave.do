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
add wave -noupdate -divider "AXI Stream Slave"

# 1. Globals
add wave -noupdate -expand -group "MST Interface"  /axis_tb_top/master_if/ARESET_N
add wave -noupdate -expand -group "MST Interface"  /axis_tb_top/master_if/ACLK

# 2. Control Handshake
add wave -noupdate -expand -group "MST Interface" -radix binary  /axis_tb_top/master_if/TVALID
add wave -noupdate -expand -group "MST Interface" -radix binary  /axis_tb_top/master_if/TREADY
add wave -noupdate -expand -group "MST Interface" -radix binary  /axis_tb_top/master_if/TLAST

# 3. Data Payload
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/TDATA
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/TSTRB
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/TKEEP

# 4. Sideband Signals
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/TID
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/TDEST
add wave -noupdate -expand -group "MST Interface" -radix hexadecimal  /axis_tb_top/master_if/TUSER

# ======================================================================
# INTERFACE 2: SLV
# ======================================================================
add wave -noupdate -divider "AXI Stream Slave"

# Note: The '-expand' flag forces the group to be open by default

# 1. Globals
add wave -noupdate -expand -group "SLV Interface"  /axis_tb_top/slave_if/aresetn
add wave -noupdate -expand -group "SLV Interface"  /axis_tb_top/slave_if/aclk

# 2. Control Handshake
add wave -noupdate -expand -group "SLV Interface" -radix binary  /axis_tb_top/slave_if/tvalid
add wave -noupdate -expand -group "SLV Interface" -radix binary  /axis_tb_top/slave_if/tready
add wave -noupdate -expand -group "SLV Interface" -radix binary  /axis_tb_top/slave_if/tlast

# 3. Data Payload 
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/tdata
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/tstrb
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/tkeep

# 4. Sideband Signals 
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/tid
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/tdest
add wave -noupdate -expand -group "SLV Interface" -radix hexadecimal  /axis_tb_top/slave_if/tuser


# ======================================================================
# FINISH
# ======================================================================
TreeUpdate [SetDefaultTree]