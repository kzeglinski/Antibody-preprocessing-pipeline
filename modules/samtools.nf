/*
Utilize samtools to write SAM file to BAM file.
*/

//Enable typed processes
nextflow.preview.types = true

process samtools {
	tag "${name}"

		// conda 'bioconda::samtools'
	// conda (params.enable_conda ? 'bioconda::samtools=2.30' : null)
	
	// Docker container for conda samtools (linux/amd64)
	// container "community.wave.seqera.io/library/samtools:1.22.1--eccb42ff8fb55509"

	// Singularity container for conda samtools (linux/amd64)
	// container "oras://community.wave.seqera.io/library/samtools:1.22.1--9a10f06c24cdf05f"

	// Declare inputs required for the process
    input:
	aligned_read: Path
	name: String
	
	// Declare outputs
	output:
	aligned_sorted_read: Path = file("${name}_aligned_sorted.bam")

    script:
    """
	# View and convert file from SAM to BAM format
	# Sort alignments and outputs the file in BAM format
	samtools view -b "${aligned_read}" | samtools sort -o "${name}_aligned_sorted.bam"
	# Index BAM file for fast random access
	samtools index "${name}_aligned_sorted.bam"
	# Counts the number of alignments for each FLAG type
	samtools flagstat "${name}_aligned_sorted.bam" > "${name}_alignment_stats.txt"
    """
}

process samtools_view_sort {
	tag "${name}"

	// Declare inputs required for the process
    input:
	aligned_sorted_read: Path
	name: String
	
	// Declare outputs
	output:
	aligned_sorted_read: Path = file("${aligned_sorted_read}")

    script:
    """
    """
}