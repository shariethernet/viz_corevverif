/*
 * Copyright 2018 Google LLC
 * Copyright 2023 Thales
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//-----------------------------------------------------------------------------
// RISC-V assembly program generator configuration class
//-----------------------------------------------------------------------------

class cva6_instr_gen_config_c extends riscv_instr_gen_config;

  //-----------------------------------------------------------------------------
  // Random instruction generation option
  //-----------------------------------------------------------------------------

  // cvxif extension support
  bit                     enable_x_extension ;

    `uvm_object_utils_begin(cva6_instr_gen_config_c)
      `uvm_field_int(enable_x_extension, UVM_DEFAULT)
    `uvm_object_utils_end

  function new (string name = "");
    super.new(name);
    get_bool_arg_value("+enable_x_extension=", enable_x_extension);
  endfunction

endclass : cva6_instr_gen_config_c
