
class CodeRunner
	# This is a module which can be used for submitting 
	# arbitrary scripts on supercomputers using the 
	# CodeRunner framework (see coderunner.sourceforge.net
	# and coderunner on rubygems.org). It comes preinstalled
	# with CodeRunner. 
	#
	# An example paints a thousand words: 
	# here is how to use it from the command line
	# to submit a ruby script:
	# 	coderunner sub -W 60 -n 1x32 -C script -X '/usr/bin/env ruby' \
	# 		-p '{file_name: "my_script.rb", arguments: "my command line args", \
	# 			replace_tokens: {"TOKEN" => "replace"}'
	#
	# The parameter replace_tokens takes a hash of {string => string}
	# which will be used to modify the text in the script via
	# 	text.gsub!(Regexp.new(Regexp.escape("TOKEN")), replace)
	# Symbols may be used instead of strings
	
	class Script < Run

		# Make sure the basic defaults file exists
		#
		FileUtils.makedirs(ENV['HOME'] + '/.coderunner/scriptcrmod/defaults_files')
		FileUtils.touch(ENV['HOME'] + '/.coderunner/scriptcrmod/defaults_files/script_defaults.rb')
		
# @code = 'cubecalc'

@code_module_folder = File.expand_path(File.dirname(__FILE__))

@variables = [:file_name, :arguments, :preamble, :replace_tokens]

@naming_pars = []

@results = []

# e.g. number of iterations

@run_info = [ :percent_complete]

# @@executable_name = 'cubecalc'

@code_long = "Script Launcher"

@excluded_sub_folders = []

@defaults_file_name = "script_defaults.rb"

@modlet_required = false

@uses_mpi = false

def process_directory_code_specific
	if @running
		@status ||= :Incomplete
	else
		@status = :Complete
	end
	eval(File.read('script_outputs.rb')) if FileTest.exist? 'script_outputs.rb'
end

def print_out_line
		line =  sprintf("%d:%d %30s %10s %s", @id, @job_no, @run_name, @status, @nprocs.to_s) 
		line += sprintf(" %3.1f\%", @percent_complete) if @percent_complete
		line += " -- #@comment" if @comment
		return line
end

def parameter_string
	file = @file_name.kind_of?(Array) ? @file_name[0] : @file_name
	return sprintf("%s %s", file, @arguments.to_s)
end

def generate_input_file

	if @file_name
		files = @file_name.kind_of?(Array) ? @file_name : [@file_name] 
		files.each do |file|
			ep ['Copying:', rcp.runner.root_folder + '/' + file, @directory + '/' + File.basename(file)]
			#FileUtils.cp(rcp.runner.root_folder + '/' + file, @directory + '/' + File.basename(file))
			text = File.read(rcp.runner.root_folder + '/' + file)
			if @replace_tokens
				@replace_tokens.each do |token, replace_str|
					text.gsub!(Regexp.new('\b' + Regexp.escape(token) + '\b'), replace_str.to_s)
				end
			end
			File.open(@directory + '/' + File.basename(file), 'w'){|file| file.puts text}
		end
	else
		eputs 'Running without a script file...'
	end
end
# @run_class.variables.keys[0]
def parameter_transition(run)
end

# Override whatever is in the system module
def run_command
	eputs "Warning: preamble does not end in a new line" unless !preamble or preamble =~ /\n\s*\Z/
	"#{preamble} #{executable_location}/#{executable_name} #{parameter_string}"
end

#def executable_location
	
#end
	

def generate_phantom_runs
end

def graphkit(name, options)
	case name
	when 'empty'
	else
		raise 'Unknown graph'
	end
end
		
		
	end
end

