[![DOI](https://zenodo.org/badge/510028817.svg)](https://zenodo.org/doi/10.5281/zenodo.7802212)

# Overview
This repository consists of 4 [Spine-Toolbox](https://github.com/Spine-tools/Spine-Toolbox) projects.

## 1. Spine Demo
A project containing several Spine database to illustrate [SpineOpt.jl](https://github.com/Spine-tools/SpineOpt.jl) functionalities (demo `SpineOpt` models) and [SpineInterface.jl](https://github.com/spine-tools/SpineInterface.jl) utilities (incl. improvising Julia JuMP models using `SpineInterface` to interact with SpineDB)

## 2. SpinePython
A demo project of a workflow to run a Python `Tool` and exchange data with other tools: `Data Connection`, Julia `Tool`, and `Importer` for JSON and CSV files.
![image](https://github.com/nnhjy/Spine-Samples/assets/43530784/fd941256-548d-4d91-904e-30204d82433a)
The project workflow contains:

1. A dummy input CSV file in the "Input_files" `Data Connection`;

2. A Julia script wrapped in the "Julia" `Tool` that reads the given input CSV and writes to an output CSV file; the output CSV file is passed over to the "ImportCSV" `Importer` and other tools (see 3);

3. A Python script wrapped in the "Python" `Tool` that reads the given input CSV and the output csv from the Julia script and writes to a JSON file and another CSV file; the JSON output file is passed to the "ImportJSON" `Importer`. 


## 3. BuildTimeseries project 
A demo workflow to attach "DateTime" index to TimeSeries data

## 4. Hydro reservoir example
A sample [SpineOpt.jl](https://github.com/Spine-tools/SpineOpt.jl) model for hydro reservoir generation

# Set up working environment for Spine toolkits

## Python (virtual) environment setup
1. Download and install python interpreter
2. Create a virtual environment: "`X:\path\to\python\interpretor -m venv Y:\path\to\virtual_env_folder`"
3. In the Terminal, switch to the corresponding virtual environment
	- Run "`deactivate`" to exit current virenv
	- Run "`cd path\to\the\virenv\folder`"
	- Run "`.\Scripts\activate`" to activate the target virenv
	- Run "`pip install -e package`" in terminal under the activated virtual environment (the "`-e`" option is only needed for installing editable package, see [pip install options](https://pip.pypa.io/en/stable/cli/pip_install/#options))
When the ipython and ipykernel (maybe only ipykernel needed) packages are installed, command "`pip install -e local\package`" can be used in the Python console where the new virtual environment is launched. 

## Julia environment setup
1. Install julia
2. Modify the environment variable "julia" to the latest Julia installed
	- System environment variable (if you install Julia for all users):
	"Control Panel\All Control Panel Items\System --> Advanced system settings --> Advanced --> Environmental Variables --> Edit in `Path`" 
	    - under "User variables for `administrator_username`" (only for the administrator, under "System variables" for all users)
	- User environment variable (if you install Julia for the current user): 
	Search `environment variables` in the Windows taskbar --> "Edit environment variable for your account" --> Edit in `Path` under "User variables for `the_current_username`"
	- **Edit in `Path`**: Click `New` to add `X:\directory\to\Julia-x.x.x\bin` and delete the directory for old versions
    - In case the Jupyter notebook kernel needs updating, do: 
		```julia
		Pkg.update(); Pkg.build("IJulia")
		```
	- Renew the path of julia executable in VSCode
		- Settings --> Search "julia" --> Julia: Environment Path / Julia: Executable Path
3. Install Spine related jl package:
	- pkg> dev "...path to SpineOpt folder...", pkg> dev "...path to SpineInterface folder..."
4. Build `PyCall` environment

	There are 3 ways by which `PyCall.jl` could work for the `SpineInterface.jl` call use `spinedb-api`.
	- `pkg> add PyCall`
	- ***Option 1*** Install `spinedb_api` to the default conda python interpreter of Julia.
		- Confirm the default conda python is linked: 
		```julia
		julia> ENV["PYTHON"]=""
		julia> using PyCall, Pkg
		julia> Pkg.build("PyCall")
		```
		- [Find the conda python](https://github.com/nnhjy/julia-introduction#manage-julia-conda-environment)
		- "X:\path\to\the\conda\python\folder\Scripts\pip.exe install -e path/to/local/spinedb_api"
	
	- ***Option 2*** Install `spinedb_api` to **the parent python interpreter** on which the virtual env is built (ref. [PyCall documentation](https://github.com/JuliaPy/PyCall.jl) and [PyCall issue with virtual environment](https://github.com/JuliaPy/PyCall.jl/issues/706))
		- Run (with ipython and ipykernel installed) `pip install -e path/to/local/spinedb_api `
		- Otherwise, `X:\path\to\python\folder\Scripts\pip.exe install -e path/to/local/spinedb_api`
	- Build customised python interpreter: 
	- In Julia after activating the desired working environment:
		```julia
		julia> ENV["PYTHON"] = raw"C:\path\to\the\parent\python.exe"
		julia> import Pkg; Pkg.build("PyCall")
		```
	
	- ***Option 3*** For a dedicated virtual environment created by `venv` and `virtualenv`, PyCall could work provided that the Python executable used in the virtual environment is linked against the same libpython used by PyCall (`conda` environment not supported). See the explanation [here](https://github.com/JuliaPy/PyCall.jl#python-virtual-environments).
		- In command line: `virtual_env_folder\Scripts\Activate.ps1`
		- In Julia after activating the desired working environment:
		```julia
		julia> ENV["PYTHON"] = Sys.which("python")
		julia> ENV["PYCALL_JL_RUNTIME_PYTHON"] = Sys.which("python")
		julia> import Pkg; Pkg.build("PyCall")
		```
	
	- Relaunch Julia and check which python the PyCall is using: `PyCall.pyprogramname` or `PyCall.python`
	- Check packages that are available for the PyCall used python: 
		```julia
		julia> using PyCall; pyimport("sys").path
		py"""
		import pkgutil

		def get_available_packages():
    		available_packages = [name for _, name, _ in pkgutil.iter_modules()]
    		return available_packages
		"""
		available_packages = py"get_available_packages"()
		println(available_packages)
		```
		When `spinedb_api` package is in the list, it is good to go.

## (Recommanded) New approach to set up Spine working/development environment

**Warning!!!**: Under this configuration, only running the `spinetoolbox` requires activating the conda environment. Once the `PyCall.jl` is configured to use the conda python, there is no need to activate the conda environment for `julia` related tasks, e.g. ***updating environment packages (doing this with the conda activated causes unnecessary error)***.

**Note** When the `Python` version has a major change (e.g. 3.1x to 3.1y), its `conda` environment needs recreating with deleting the old environment first:

	```console
	conda remove -n env_name --all
	```

### Step 1 option 1. Build worry-free spinetoolbox in `conda` environment with `git`:
- prerequisites: 
	- **python 3.12** from [miniconda](https://docs.conda.io/en/latest/miniconda.html) or [Anaconda](https://www.anaconda.com/products/distribution)
	- [git](https://git-scm.com/downloads)

- In OS terminal (cmd or PowerShell):

	```console
	conda create -n spine-tools python=3.12
	conda activate spine-tools
	```

- Install the active dev version `spinetoolbox` (need `git` installed):

    ```console
    pip install git+https://github.com/spine-tools/spinetoolbox-dev
    ```
- Update package to the latest commit: reinstall the package using the same command.

### Step 1 option 2. Conda environment for spine development
- prequisites:
	- **python 3.12** from [miniconda](https://docs.conda.io/en/latest/miniconda.html)
	- [git](https://git-scm.com/downloads)

- Create a new conda virtual environment:

	```console
	conda create -n spine-dev python=3.12
	```

- install the python packages of spine-tools:

	```console
	conda activate spine-dev
	pip install -e .\path\to\local\Spine-Database-API
	pip install -e .\path\to\local\spine-engine
	pip install -e .\path\to\local\spine-items
	pip install -e .\path\to\local\Spine-Toolbox
	```
	Update packages to the latest commits: 
	1. Pull from the GitHub repositories
	2. Rerun the above commands

### Step 2. Assign the configured conda `Python` to `PyCall` in the `Julia` environment where `SpineOpt.jl` and `SpineInterface.jl` are installed

This step is required for both options (the `spine-dev` and `spine-tools` conda env) unless you install `SpineOpt.jl` and `SpineInterface.jl` through the default channel of Spine toolbox.
	
- In OS terminal (cmd or PowerShell)
	
	```console
	conda activate spine-dev 
	cd path\to\the\working\julia\enviroment
	```

- In Julia console
	
	```julia
	# activate the working environment
	cd("path\\to\\the\\working\\julia\\enviroment")
	using Pkg; Pkg.activate(".")
	
	# the python of current console environment, also works with non-conda python
	ENV["PYTHON"] = Sys.which("python")
	# or when a conda environment is activated
	# ENV["PYTHON"] = ENV["CONDA_PREFIX"] * "\\python.exe"
	using Pkg; Pkg.build("PyCall")
	```
- Relaunch Julia and check which `Python` is being used by `PyCall`: `PyCall.pyprogramname` or `PyCall.python`

