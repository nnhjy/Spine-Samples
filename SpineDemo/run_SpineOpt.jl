#=
run_spineopt_test:
- Julia version: 
- Author: jhjiang
- Date: 2020-10-01
=#
# syntax to run this script

using SpineOpt
# using IJulia

# command to run this script from a Julia console
# include("..\\spine\\Case_study_B3\\spine-cs-b3\\run_SpineOpt.jl")

# if isdefined(Main, :IJulia) && Main.IJulia.inited
#     Main.IJulia.stdio_bytes[] = 0
#     IJulia.set_max_stdio(1 << 20)
# end

input_db_url = ARGS[1]
output_db_url = ARGS[2]
# input_db_url = "sqlite:///$(@__DIR__)/toolbox_input/data_store.sqlite"
# output_db_url = "sqlite:///$(@__DIR__)/toolbox_output_predefined/output_db.sqlite"

@time begin
    m = run_spineopt(input_db_url, output_db_url)
end

# Show active variables and constraints
println("*** Active constraints: ***")
for key in keys(m.ext[:spineopt].constraints)
    !isempty(m.ext[:spineopt].constraints[key]) && println(key)
end
println("*** Active variables: ***")
for key in keys(m.ext[:spineopt].variables)
    !isempty(m.ext[:spineopt].variables[key]) && println(key)
end
