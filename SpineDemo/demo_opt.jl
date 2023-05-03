using SpineInterface
using JuMP
using Cbc
using Dates

t1 = DateTime(2000)
t2 = DateTime(2001)

# TimeSlice from SpineInterface
ts = TimeSlice(t1, t2) # [2000, 2001)

url = ARGS[1]

using_spinedb(url)

function setup_snapshot_model(ts::TimeSlice)
	opt = optimizer_with_attributes(Cbc.Optimizer, "loglevel" => 0)
	m = Model(opt)
	
	@variable(m, flow[(u,n) in unit__node()], lower_bound=0)

	@constraint(m, dem[n in node()], sum(flow[(unit=u, node=n)] for u in unit__node(node=n)) == demand[(node=n, t=ts)])
	# demand[(node=node(:node1), t=ts)]: {demand(node=node1, t=2001-01-01T00:00~>2002-01-01T00:00) = 110.0}
	# demand(node=n, t=ts): 110.0
	@constraint(m, cap[u in unit()], sum(flow[(unit=u, node=n)] for n in unit__node(unit=u)) <= capacity(unit=u))

	@objective(m, Min, sum(cost(unit=u) * flow[(unit=u, node=n)] for (u, n) in unit__node()))

	m
end

function solve(m::JuMP.Model)
	println(m)
	optimize!(m)

	for k in unit__node()
		print("flow$(k): ", value(m[:flow][k]), "\n")
	end

	@show objective_value(m)
end

m = setup_snapshot_model(ts)

solve(m)

for i in 2:6
	println("\nRoll time slice $i\n")
	roll!(ts, Year(1))
	m = setup_snapshot_model(ts)

	solve(m)
end

# call entity classes in Spine DB to see all affiliated elements
# node(), unit(), unit__node()

# call a single element in object class
# n1 = node(:node1)
# n2 = node(:node2)

# use element of object class as filter in relationship class to obtain related elements from other object classes
# unit__node(node=n1)

# call defined variables
# demand(node = n1)