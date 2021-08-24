# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Qt5Svg_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("Qt5Svg")
JLLWrappers.@generate_main_file("Qt5Svg", UUID("3af4ccab-a251-578e-a514-ea85a0ba79ee"))
end  # module Qt5Svg_jll
