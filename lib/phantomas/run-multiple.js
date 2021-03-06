#!/usr/bin/env node
/**
 * This is a helper NodeJS script allowing you to run phantomas multiple times and
 * get a nice looking table with all the metrics + avg / median / min / max values
 *
 * Usage:
 *  ./run-multiple.js
 *	--url=<page to check>
 *	--runs=<number of runs, defaults to 3>
 *	--timeout=<in seconds (for each run), default to 15>
 *	[--modules=moduleOne,moduleTwo]
 *	[--format=plain|json] (plain is default)
 *	  note: json format, prints only errorrs or the
 *			  results in json format, no other
 *			  messaging
 *
 * @version 0.1
 */
var exec = require('child_process').exec,
	args = process.argv.slice(2),
	params = require('./lib/args').parse(args),
	pads = require('./core/pads'),
	lpad = pads.lpad,
	rpad = pads.rpad;

// handle --url and --runs CLI parameters
var url = params.url,
	runs = parseInt(params.runs, 10) || 3,
	format = params.format || 'plain',
	remainingRuns = runs,
	metrics = [];

function runPhantomas(params, callback) {
	var timeMs = Date.now(),
		cmd = 'phantomjs phantomas.js --format=json --url=' + params.url;

	if (params.timeout > 0) {
		cmd += ' --timeout=' + params.timeout;
	}

	if (params.modules) {
		cmd += ' --modules=' + params.modules;
	}

	// @see http://nodejs.org/api/child_process.html#child_process_child_process_exec_command_options_callback
	exec(cmd, function(error, stdout, stderr) {
		var res = false;

		try {
			res = JSON.parse(stdout) || false;
		} catch(e) {
			console.log("Unable to parse JSON from phantomas!");
		}

		if (res === false) {
			console.log(stdout);
		}

		if (typeof callback === 'function') {
			callback(res, Date.now() - timeMs);
		}
	});
}

function run() {
	if (remainingRuns--) {
		if (format === 'plain') {
			console.log('Remaining runs: ' + (remainingRuns + 1));
		}

		runPhantomas(params, function(res, timeMs) {
			if (res) {
				metrics.push(res.metrics);
			}

			if (format === 'plain') {
				console.log('Run completed in ' + (timeMs/1000).toFixed(2) + ' s');
			}
			run();
		});
	} else {
		if (format === 'plain') {
			console.log('Done');
		}
		formatResults(metrics);
	}
}

function formatResults(metrics) {
	var entries = {},
		entry,
		metric;

	// prepare entries
	for(metric in metrics[0]) {
		entries[metric] = {
			values: [],
			sum: 0,
			min: 0,
			max: 0,
			median: 0,
			average: 0
		};
	}

	// process all runs
	metrics.forEach(function(data) {
		var metric;
		for (metric in data) {
			entries[metric].values.push(data[metric]);
		}
	});

	// calculate stats
	for (metric in entries) {
		entry = entries[metric];

		entry.values = entry.values.
			filter(function(element) {
				return element !== null;
			}).
			sort(function (a, b) {
				return a - b;
			});

		if (entry.values.length === 0) {
			continue;
		}

		entry.min = entry.values.slice(0, 1).pop();
		entry.max = entry.values.slice(-1).pop();

		for (var i=0, len = entry.values.length++; i<len; i++) {
			entry.sum += entry.values[i];
		}

		entry.average = len && (entry.sum / len).toFixed(2);
		entry.median = ( (len % 2 === 0) ? ((entry.values[len >> 1] + entry.values[len >> 1 + 1])/2) : entry.values[len >> 1] ).toFixed(2);
	}

	// print out a nice table
	if (format === 'plain') {
		console.log("-------------------------------------------------------------------------------------------");
		console.log("| " + rpad("Report from " + runs + " run(s) for <" + params.url + ">", 87) + " |");
		console.log("-------------------------------------------------------------------------------------------");
		console.log("| Metric					  | Min		  | Max		  | Average	  | Median	   |");
		console.log("-------------------------------------------------------------------------------------------");

		for (metric in entries) {
			entry = entries[metric];

			console.log("| "+
				[
					rpad(metric, 27),
					lpad(entry.min, 12),
					lpad(entry.max, 12),
					lpad(entry.average, 12),
					lpad(entry.median, 12)
				].join(" | ") +
				" |");
		}

		console.log("-------------------------------------------------------------------------------------------");
	} else {
		console.log(JSON.stringify(metrics));
	}
}

if (typeof url === 'undefined') {
	console.log('--url argument must be provided!');
	process.exit(1);
}

if (format === 'plain') {
	console.log('Performing ' + runs + ' phantomas run(s) for <' + params.url + '>...');
}
run();
