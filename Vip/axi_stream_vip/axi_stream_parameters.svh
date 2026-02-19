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
// Filename           : axi_stream_parameters.svh                              :
// Date Last Modified : 2025 SEP 1                                             :
// Date Created       : 2025 JUL 25                                            :
// Device             : Generic                                                :
// Design Name        : Generic                                                :
// Purpose            : Stream parameters class                                :
// Author(s)          : Juan Doctorovich,           Fernando Gerbino           :
// Email              : jdoctorovich@emtech.com.ar, fgerbino@emtech.com.ar     :
//                                                :
// :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//
// Detailed Description:
//
//
// -----------------------------------------------------------------------------
`ifndef AXI_STREAM_PARAMETERS_SV
`define AXI_STREAM_PARAMETERS_SV

// Timeout parameters
parameter int TREADY_TIMEOUT_DEFAULT        = 15000;
parameter int TVALID_TIMEOUT_DEFAULT        = 15000;

// Delays parameters
parameter int DELAY_CYCLES_MIN_DEFAULT      = 0;
parameter int DELAY_CYCLES_MAX_DEFAULT      = 10;

parameter int TREADY_DELAY_MIN_DEFAULT      = 0;
parameter int TREADY_DELAY_MAX_DEFAULT      = 10;

parameter int TVALID_DELAY_MIN_DEFAULT      = 0;
parameter int TVALID_DELAY_MAX_DEFAULT      = 10;

parameter int TREADY_HIGH_DELAY_MIN_DEFAULT = 0;
parameter int TREADY_HIGH_DELAY_MAX_DEFAULT = 10;

// Transaction length parameters
parameter int TRANS_LENGTH_MIN_DEFAULT       = 1;
parameter int TRANS_LENGTH_MAX_DEFAULT       = 1024;

`endif
