package main

import (
	"dagger.io/dagger"
)

dagger.#Plan & {
	client: network: "unix:///var/run/docker.sock": connect: dagger.#Socket

	actions: {
		// Perform an Old style build
		old: #Old & {
			socket: client.network."unix:///var/run/docker.sock".connect
		}

		// Perform a New style build
		new: #New & {
			socket: client.network."unix:///var/run/docker.sock".connect
		}
	}
}
