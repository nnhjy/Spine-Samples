println("Hello")

# ARGS is an array of the command-line arguments
for (index, arg) in enumerate(ARGS)
    println("Argument $index: $arg")
end

# Install corresponding packages in working env if needed
# using Pkg; Pkg.add("CSV"); Pkg.add("DataFrames")
using CSV
using DataFrames

# Read the CSV file
df = CSV.read("sample_csv.csv", DataFrame)

# Print the DataFrame
println(df)
CSV.write("julia_output/julia_output.csv", df)