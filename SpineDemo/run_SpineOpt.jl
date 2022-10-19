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
# e.g. include("..\\spine\\Case_study_B3\\spine-cs-b3\\run_SpineOpt.jl")

# if isdefined(Main, :IJulia) && Main.IJulia.inited
#     Main.IJulia.stdio_bytes[] = 0
#     IJulia.set_max_stdio(1 << 20)
# end

input_db_url = ARGS[1]
output_db_url = ARGS[2]
# input_db_url = "sqlite:///$(@__DIR__)/toolbox_input/data_store.sqlite"
# output_db_url = "sqlite:///$(@__DIR__)/toolbox_output_predefined/output_db.sqlite"

@time begin
    m = run_spineopt(input_db_url, output_db_url, ARGS[3:end]...)
end

# Run SpineOpt with different solver settings

# using CPLEX
# using JuMP

# m = run_spineopt(
# 		ARGS...,
# 		mip_solver=optimizer_with_attributes(CPLEX.Optimizer, "CPX_PARAM_EPGAP" => 0.01),
# 		lp_solver=optimizer_with_attributes(CPLEX.Optimizer)
# 	  )

#####################
### The above uses the CPLEX solver. Other solvers follow a similar form.
#####################

# using SpineOpt
# run_spineopt(ARGS...)

#####################
### The above uses the default solvers which are currently CLP for LP problems and Cbc for MIP problems.
#####################

# Show active variables and constraints
println("*** Active variables: ***")
for key in keys(m.ext[:spineopt].variables)
    !isempty(m.ext[:spineopt].variables[key]) && println(key)
end
println("*** Active constraints: ***")
for key in keys(m.ext[:spineopt].constraints)
    !isempty(m.ext[:spineopt].constraints[key]) && println(key)
end
println("*** Unlisted active values: ***")
for key in setdiff(keys(m.ext[:spineopt].values), keys(m.ext[:spineopt].outputs))
    !isempty(m.ext[:spineopt].values[key]) && println(key)
end