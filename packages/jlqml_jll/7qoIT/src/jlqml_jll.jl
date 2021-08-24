# Use baremodule to shave off a few KB from the serialized `.ji` file
baremodule jlqml_jll
using Base
using Base: UUID
import JLLWrappers

JLLWrappers.@generate_main_file_header("jlqml")
JLLWrappers.@generate_main_file("jlqml", UUID("6b5019fb-a83d-5b4e-a9f7-678a36c28df7"))
end  # module jlqml_jll
