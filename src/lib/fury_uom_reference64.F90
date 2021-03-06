!< FURY class definition of unit reference with float64 kind.

module fury_uom_reference64
!< FURY class definition of unit reference with float64 kind.
use, intrinsic :: iso_fortran_env, only : stderr => error_unit
use fury_uom_converter
use fury_uom_symbol64
use penf, RKP => R8P
use stringifor

#include "fury_uom_reference.inc"
endmodule fury_uom_reference64
