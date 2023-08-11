const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

// Define the path for the dependency tree file
const dependencyTreeFilePath = path.join(
	__dirname,
	'../.github',
	'bashbrew.json',
);

// Read and parse the JSON data from the file
const dependencyTreeData = JSON.parse(
	fs.readFileSync(dependencyTreeFilePath, 'utf-8'),
);

let allJobsArray = [];

// Function to add a job to allJobsArray after checking if the library exists
const addJob = (
	jobName,
	dependencies,
	platform,
	runner,
	library,
	aliases,
	distro = '',
	language = '',
) => {
	if (!fs.existsSync(path.join(__dirname, '../library', library))) {
		return;
	}
	allJobsArray.push({
		jobName,
		dependencies,
		platform,
		runner,
		library,
		aliases,
		distro,
		language,
	});
};

// Function to fetch all dependencies of a job
const getAllDependencies = (currentJobName, checkedNames = []) => {
	let dependencies = [];
	if (checkedNames.includes(currentJobName)) {
		return dependencies;
	} // avoid infinite loops
	checkedNames.push(currentJobName);

	const jobData = allJobsArray.find((job) => job.jobName === currentJobName);
	if (jobData && jobData.dependencies.length > 0) {
		dependencies = [...dependencies, ...jobData.dependencies];
		for (const dep of jobData.dependencies) {
			dependencies = [
				...dependencies,
				...getAllDependencies(dep, checkedNames),
			];
		}
	}
	return [...new Set(dependencies)];
};

// Function to get the top-level dependency for a job
const getTopDependency = (currentJobName, checkedNames = []) => {
	if (checkedNames.includes(currentJobName)) {
		return currentJobName;
	} // avoid infinite loops
	checkedNames.push(currentJobName);

	const jobData = allJobsArray.find((job) => job.jobName === currentJobName);
	if (jobData && jobData.dependencies.length > 0) {
		// Get the top-level dependency for each dependency
		const dependenciesTopDependencies = jobData.dependencies.map((dep) =>
			getTopDependency(dep, checkedNames),
		);

		// Return the top-level dependency with the smallest name (for consistent results)
		return dependenciesTopDependencies.sort()[0];
	}

	// If no dependencies, return the job name
	return currentJobName;
};

// Function to generate the run command for bashbrew build
const createRunCommand = (currentLibrary, currentPlatform, currentAliases) => {
	let runCmd = `./bashbrew.sh build "${currentLibrary}" --src=$(pwd)/src --logs=$(pwd)/logs --library=$(pwd)/../library`;
	runCmd += ` --namespaces="\${{ inputs.namespaces }}"`;

	if (currentPlatform) {
		runCmd += ` --platform="${currentPlatform}"`;
	}

	if (currentAliases) {
		runCmd += ` --alias="${currentAliases.join(' ')}"`;
	}

	return (runCmd += ` $EXTRA_OPTS`);
};

// Function to create a GitHub action job
const createJob = (
	currentJobName,
	currentDependencies,
	currentPlatform,
	currentRunner,
	currentLibrary,
	currentAliases,
) => {
	// Get all dependencies and dependent jobs for this job
	const allDeps = getAllDependencies(currentJobName);
	const dependentJobsList = allJobsArray
		.filter(({ dependencies }) => dependencies.includes(currentJobName))
		.map(({ jobName }) => jobName);

	// Construct the if conditions for the job
	const ifConditionsArray = [
		`inputs.target_job == '${currentJobName}'`, // if the target job is the job in question, it must run
		`inputs.target_job == 'all'`, // if the target job is 'all', the job must run
		...dependentJobsList.map((job) => `inputs.target_job == '${job}'`), // if the target job is one of its dependents, the job must run
	];

	// If there are dependencies, add conditions for them considering include_dependents
	if (allDeps.length > 0) {
		ifConditionsArray.push(
			`(inputs.include_dependents && (` +
				allDeps.map((dep) => `inputs.target_job == '${dep}'`).join(' || ') +
				`))`, // if the target job is one of its dependencies, it should only run when include_dependents is true
		);
	}

	// Define the steps and conditions for each job
	return {
		'runs-on': currentRunner,
		'timeout-minutes': 240,
		needs: currentDependencies.length > 0 ? currentDependencies : [],
		if: ifConditionsArray.join(' || '),
		steps: [
			{
				name: 'Checkout code',
				uses: 'actions/checkout@v3',
				with: {
					'fetch-depth': 0,
					// submodules: "recursive",
				},
			},
			...(!currentRunner.includes('self-hosted')
				? [
						{
							name: 'Setup QEMU',
							uses: 'docker/setup-qemu-action@v2',
							with: {
								platforms: 'all',
								image: 'tonistiigi/binfmt:qemu-v6.2.0',
							},
						},
				  ]
				: []),
			{
				name: 'Disable build',
				if: '${{ inputs.no_build }}',
				run: `echo "EXTRA_OPTS=$EXTRA_OPTS --no-build" >> $GITHUB_ENV`,
			},
			{
				name: 'Disable push',
				if: '${{ inputs.no_push }}',
				run: `echo "EXTRA_OPTS=$EXTRA_OPTS --no-push" >> $GITHUB_ENV`,
			},
			{
				name: 'Login to DockerHub',
				uses: 'docker/login-action@v2',
				with: {
					registry: 'docker.io',
					username: '${{ secrets.BALENAIMAGES_USER }}',
					password: '${{ secrets.BALENAIMAGES_TOKEN }}',
				},
			},
			{
				name: 'Run bashbrew build',
				'working-directory': 'bashbrew',
				// "continue-on-error": true,
				run: createRunCommand(currentLibrary, currentPlatform, currentAliases),
			},
			{
				name: 'Upload logs',
				uses: 'actions/upload-artifact@v3',
				with: {
					name: 'logs',
					path: 'bashbrew/logs/*/*.log',
					'retention-days': 90,
				},
			},
		],
	};
};

// Function to fetch an inherited attribute (like platform or runner) for a job
const getInheritedAttribute = (currentDependencies, attribute) => {
	for (const dependency of currentDependencies) {
		const jobData = allJobsArray.find((job) => job.jobName === dependency);
		if (jobData && jobData[attribute]) {
			return jobData[attribute];
		}
	}
	return '';
};

// Loop through the dependency tree and create jobs for each distro and language
for (const [jobBase, jobConfig] of Object.entries(dependencyTreeData)) {
	for (const distro of ['alpine', 'debian', 'fedora', 'ubuntu']) {
		const distroJobName = `${jobBase}-${distro}`;
		let dependencies = jobConfig.needs
			? jobConfig.needs.map((need) => `${need}-${distro}`)
			: [];
		let platform =
			jobConfig.platform || getInheritedAttribute(dependencies, 'platform');
		let runner =
			jobConfig.runner || getInheritedAttribute(dependencies, 'runner');
		let library =
			jobConfig.library || getInheritedAttribute(dependencies, 'library');
		let aliases =
			jobConfig.aliases || getInheritedAttribute(dependencies, 'aliases');
		addJob(
			distroJobName,
			dependencies,
			platform,
			runner,
			`${library}-${distro}`,
			aliases,
			distro,
		);

		for (const language of ['dotnet', 'golang', 'node', 'openjdk', 'python']) {
			const languageJobName = `${distroJobName}-${language}`;
			dependencies = [distroJobName];
			platform =
				jobConfig.platform || getInheritedAttribute(dependencies, 'platform');
			runner =
				jobConfig.runner || getInheritedAttribute(dependencies, 'runner');
			library =
				jobConfig.library || getInheritedAttribute(dependencies, 'library');
			aliases =
				jobConfig.aliases || getInheritedAttribute(dependencies, 'aliases');
			addJob(
				languageJobName,
				dependencies,
				platform,
				runner,
				`${library}-${distro}-${language}`,
				aliases,
				distro,
				language,
			);
		}
	}
}

// Verify each library has a corresponding job or alias
const libraryFilesList = fs.readdirSync(path.join(__dirname, '../library'));
for (const libraryFile of libraryFilesList) {
	const library = libraryFile.split('.')[0];
	const libraryJob = allJobsArray.find((job) => job.library === library);
	const aliasJob = allJobsArray.find((job) =>
		job.aliases
			? job.aliases.find((alias) =>
					job.language
						? `${alias}-${job.distro}-${job.language}` === library
						: `${alias}-${job.distro}` === library,
			  )
			: false,
	);
	if (!libraryJob && !aliasJob) {
		console.log(
			// eslint-disable-line no-console
			`WARNING: No job found for library ${libraryFile}`,
		);
	}
}

// Organize jobs into groups based on their top-level dependency
let jobGroups = {};

for (const {
	jobName,
	dependencies,
	platform,
	runner,
	library,
	aliases,
} of allJobsArray) {
	const topDependency = getTopDependency(jobName)
		.split('-')
		.slice(0, -1)
		.join('-');
	jobGroups[topDependency] = jobGroups[topDependency] || [];
	jobGroups[topDependency].push({
		jobName,
		dependencies,
		platform,
		runner,
		library,
		aliases,
	});
}

// Generate a GitHub action for each group
for (const [topDependency, jobGroupList] of Object.entries(jobGroups)) {
	let workflow = {
		// Declare the header inside the loop
		name: `Bashbrew (${topDependency})`,
		on: {
			// push: {},
      schedule: [
        // At 03:45, only on Saturday
        // { "cron": "45 3 * * 6" },
        // At 03:45, on day 6 of the month
        { "cron": "45 3 6 * *" },
      ],
			workflow_dispatch: {
				inputs: {
					target_job: {
						description: 'Target job to run',
						required: true,
						type: 'choice',
						default: 'all',
						options: [
							'all',
							...jobGroupList.map(({ jobName }) => jobName).sort(),
						],
					},
					namespaces: {
						description: 'Space separated list of image namespaces to act upon',
						required: true,
						type: 'string',
						default: 'balenalib',
					},
					include_dependents: {
						description: 'Whether to build jobs that depend on the target job',
						required: true,
						type: 'boolean',
						default: true,
					},
					no_build: {
						description: "Don't build, print what would build",
						required: false,
						type: 'boolean',
						default: false,
					},
					no_push: {
						description: "Don't push, print what would push",
						required: false,
						type: 'boolean',
						default: false,
					},
				},
			},
		},
		concurrency: {
			group: '${{ github.workflow }}-${{ inputs.namespaces }}',
			'cancel-in-progress': true,
		},
		jobs: {},
	};

	for (const {
		jobName,
		dependencies,
		platform,
		runner,
		library,
		aliases,
	} of jobGroupList) {
		workflow.jobs[jobName] = createJob(
			jobName,
			dependencies,
			platform,
			runner,
			library,
			aliases,
		);
	}

	let yamlOptions = {
		noRefs: true,
		lineWidth: -1,
	};

	const outputFile = path.join(
		__dirname,
		'../.github',
		'workflows',
		`bashbrew-${topDependency}.yml`,
	);

	// Add a header comment to the generated file
	const workflowContent =
		'# DO NOT EDIT MANUALLY - This file is auto-generated from bashbrew.json\n\n' +
		yaml.dump(workflow, yamlOptions);
	fs.writeFileSync(outputFile, workflowContent, 'utf-8');
}
