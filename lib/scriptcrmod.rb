
class CodeRunner
	class Script < Run
		
# @code = 'cubecalc'

@variables = [:file_name, :arguments]

@naming_pars = []

@results = []

# e.g. number of iterations

@run_info = []

# @@executable_name = 'cubecalc'

@code_long = "Script Launcher"

@excluded_sub_folders = []

@defaults_file_name = "script_defaults.rb"

@modlet_required = false

@uses_mpi = false

def process_directory_code_specific
	if @running
		@status = :Incomplete
	else
		@status = :Complete
	end
end

def print_out_line
		return sprintf("%d:%d %30s %10s", @id, @job_no, @run_name, @status)
end

def parameter_string
	return sprintf("%s %s", @file_name, @arguments)
end

def generate_input_file
	FileUtils.cp(@file_name, @directory + File.basename(@directory))
end
# @run_class.variables.keys[0]
def parameter_transition(run)
end

#def executable_location
	
#end
	

def generate_phantom_runs
end

def graphkit(name, options)
	case name
	else
		raise 'Unknown graph'
	end
end
		
		
	end
end

