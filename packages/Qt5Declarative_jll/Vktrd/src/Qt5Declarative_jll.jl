# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule Qt5Declarative_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("Qt5Declarative")
JLLWrappers.@generate_main_file("Qt5Declarative", UUID("c6373c32-5b88-5913-90f5-31d7686b42da"))
end  # module Qt5Declarative_jll
