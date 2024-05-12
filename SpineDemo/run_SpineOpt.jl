#=
run_spineopt_sample_script:
- Julia version: 
- Author: Huang, Jiangyi
- Date: 2022-10-13
=#

using SpineOpt
# using IJulia

# command to run this script from a Julia console
# include("path\\to\\run_SpineOpt.jl")
# e.g. include("..\\Spine-Samples\SpineDemo\\run_SpineOpt.jl")

# if isdefined(Main, :IJulia) && Main.IJulia.inited
#     Main.IJulia.stdio_bytes[] = 0
#     IJulia.set_max_stdio(1 << 20)
# end

input_db_url = ARGS[1]
output_db_url = ARGS[2]
# input_db_url = "sqlite:///$(@__DIR__)/toolbox_input/data_store.sqlite"
# output_db_url = "sqlite:///$(@__DIR__)/toolbox_output_predefined/output_db.sqlite"

@time begin
    m = run_spineopt(input_db_url, output_db_url, upgrade=true, ARGS[3:end]...)
end

# Show active variables and constraints
println("*** Unlisted active values: ***")
for key in setdiff(keys(m.ext[:spineopt].values), keys(m.ext[:spineopt].outputs))
    !isempty(m.ext[:spineopt].values[key]) && println(key)
end

"""
A function to print the active items in the built SpineOpt model.
"""
function print_active(m, item::Symbol)
    println("*** Active $item: ***")
    eval(
        :(for key in keys(m.ext[:spineopt].$item)
            !(isempty(m.ext[:spineopt].$item[key]) || isequal(m.ext[:spineopt].$item[key], (0, 0))) && println(key)
        end)
    )
end

items = [:variables, :constraints, :objective_terms]
for i in items
    print_active(m, i)
end