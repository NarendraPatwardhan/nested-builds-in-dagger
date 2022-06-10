package main

import (
	"universe.dagger.io/docker"

	"list"
)

// Modular build API for Docker containers
#Build: {
	steps: [#Step, ...#Step]
	output: docker.#Image

	// Generate build DAG from linear steps
	_dag: {
		for idx, step in list.FlattenN(steps, 1) {
			"\(idx)": step & {
				// connect input to previous output
				if idx > 0 {
					// FIXME: the intermediary `output` is needed because of a possible CUE bug.
					// `._dag."0".output: 1 errors in empty disjunction::`
					// See: https://github.com/cue-lang/cue/issues/1446
					// input: _dag["\(idx-1)"].output
					_output: _dag["\(idx-1)"].output
					input:   _output
				}
			}
		}
	}

	if len(_dag) > 0 {
		output: _dag["\(len(_dag)-1)"].output
	}
}

// A process is anything that produces a docker image
#Process: {
	input?: docker.#Image
	output: docker.#Image
	...
}

// A build step is a process or a sequence of processes
#Step: *#Process | [#Process, ...#Process]
