#
# Encapsulation of flags that need to be set for MAPTK under different
# circumstances.
#

include(CheckCXXCompilerFlag)

# Infrastructure for conveniently adding flags
define_property(GLOBAL PROPERTY MAPTK_CXX_FLAGS
  BRIEF_DOCS "Warning flags for MAPTK build"
  FULL_DOCS "List of warning flags MAPTK will build with."
  )

# Helper function for adding compiler flags
function(maptk_check_compiler_flag flag)
  string(REPLACE "+" "plus" safeflag "${flag}")
  check_cxx_compiler_flag("${flag}" "has_compiler_flag-${safeflag}")
  if( ${has_compiler_flag-${safeflag}} )
    set_property(GLOBAL APPEND PROPERTY MAPTK_CXX_FLAGS "${flag}")
  endif()
endfunction ()

# Check for platform/compiler specific flags
string(TOLOWER ${CMAKE_CXX_COMPILER_ID} lowerCID)
message(STATUS "Testing/Loading compiler flags from: maptk-flags-${lowerCID}")
if( EXISTS "${CMAKE_CURRENT_LIST_DIR}/maptk-flags-${lowerCID}.cmake" )
  include( maptk-flags-${lowerCID} )
else()
  message(WARNING "No flags configuration found for compiler: ${CMAKE_CXX_COMPILER_ID}")
endif()

# Adding set flags via convenience structure to appropriate CMake property
get_property(maptk_cxx_flags GLOBAL PROPERTY MAPTK_CXX_FLAGS)
message(STATUS "Setting additional CXX compiler flags: ${maptk_cxx_flags}")
string(REPLACE ";" " " maptk_cxx_flags "${maptk_cxx_flags}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${maptk_cxx_flags}")
message(STATUS "Amended CXX Compiler flags set: ${CMAKE_CXX_FLAGS}")
