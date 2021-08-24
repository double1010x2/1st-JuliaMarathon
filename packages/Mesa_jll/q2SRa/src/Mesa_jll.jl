# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Mesa_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("Mesa")
JLLWrappers.@generate_main_file("Mesa", UUID("78dcde23-ec64-5e07-a917-6fe22bbc0f45"))
end  # module Mesa_jll
