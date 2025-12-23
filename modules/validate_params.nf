/*
Validate parameters are valid paths.
*/

//Enable typed processes
nextflow.preview.types = true

process validate {

    input:
    paths_to_validate: Path
	parameter: String
    
	// Validate whether paths are valid
    script:
	"""
    IFS=',' read -ra paths <<< "${paths_to_validate}"

	missing_paths=()
	for path in "\${paths[@]}"; do

		# Enable nullglob so unmatched globs expand to nothing
		shopt -s nullglob
		files=(\${path})
		echo ""
		shopt -u nullglob

		# Check if glob matched any files
		if [ \${#files[@]} -eq 0 ]; then
			missing_paths+=("\${path}")
		fi
done

	if [ \${#missing_paths[@]} -gt 0 ]; then
		echo "Error: The following paths for the parameter '${parameter}' do not exist:"
		printf '  %s\n' "\${missing_paths[@]}"
		exit 1
	fi
    """


	// IFS=',' read -ra paths <<< "${pathsToValidate}"

	// missing_paths=()
	// for path in "\${paths[@]}"; do
	// 	if [ ! -e "\${path}" ]; then
	// 		missing_paths+=("\${path}")
	// 	fi
	// done

	// if [ \${#missing_paths[@]} -gt 0 ]; then
	// 	echo "Error: The following paths do not exist:"
	// 	printf '  %s\n' "\${missing_paths[@]}"
	// 	exit 1
	// fi

}

workflow validate_params {
	take: 
    read_files: String
	phagemid_ref: Path
	matchbox_script: Path

	main:
	// Join together all parameter paths
	channel.fromPath(read_files).collect().view()
	channel.fromPath(read_files).collect() + "," + phagemid_ref
	validate(channel.fromPath(read_files), "read_files")
	// validate(phagemid_ref, "phagemid_ref")
	// validate(matchbox_script, "Matchbox script")
}