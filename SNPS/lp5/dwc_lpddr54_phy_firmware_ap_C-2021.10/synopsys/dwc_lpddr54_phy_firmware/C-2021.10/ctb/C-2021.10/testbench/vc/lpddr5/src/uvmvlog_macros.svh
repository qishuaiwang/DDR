//=======================================================================
// COPYRIGHT (C) 2014 SYNOPSYS INC.
// This software and the associated documentation are confidential and
// proprietary to Synopsys, Inc. Your use or disclosure of this software
// is subject to the terms and conditions of a written license agreement
// between you, or your company, and Synopsys, Inc. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//-----------------------------------------------------------------------

`define UVMVLOG_DEBUG_SIGNAL( val, signal ) \
   begin                            \
     val = signal;                  \
     while(1) begin                 \
       @( signal );                 \
       val = signal ;               \
     end                            \
   end                              \

