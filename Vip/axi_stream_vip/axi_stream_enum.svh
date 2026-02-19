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
// Filename           : axi_stream_enum.svh                                    :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream enum class                                      :
// Author(s)          : Juan Doctorovich                                       :
// Email              : jdoctorovich@emtech.com.ar                             :
//                                                                             :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------
`ifndef AXI_STREAM_ENUMS_SV
`define AXI_STREAM_ENUMS_SV

typedef enum {
  RECEIVER,
  TRANSMITTER
} rec_tran_e;

typedef enum {
  AXI_ST_WRITE,
  AXI_ST_IDLE
} axi4_st_trans_type_e;

`endif  // AXI_STREAM_e
