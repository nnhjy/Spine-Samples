print("Hello")

import sys

# sys.argv[0] is the script name itself
for i in range(0, len(sys.argv)):
    print(f"Argument {i}: {sys.argv[i]}")

import pandas as pd

# Read the CSV file
df1 = pd.read_csv('csv_input/sample_csv.csv')
df2 = pd.read_csv('csv_input/julia_output.csv')

# Print the DataFrame
if df1.equals(df2):
	df = df1 + df2
	print(df)

df.to_json('py_output.json', orient='records')
df.to_csv('csv_output/py_output.csv', index=False)
