package main

import (
	"dagger.io/dagger"
	"universe.dagger.io/docker"
	"universe.dagger.io/docker/cli"
)

#Old: {
	// The local daemon for pushing the image
	socket: dagger.#Socket

	_source: "ubuntu:20.04"

	_build: docker.#Build & {
		steps: [
			// Define the base image
			docker.#Pull & {
				source: _source
			},
			docker.#Set & {
				config: env: DEBIAN_FRONTEND: "noninteractive"
			},
			docker.#Run & {
				command: {
					name: "apt"
					args: ["update"]
				}
			},
			docker.#Run & {
				command: {
					name: "apt"
					args: ["install", "-y", "--no-install-recommends", "locales"]
				}
			},
			docker.#Run & {
				command: {
					name: "sh"
					args: ["-c",
						"""
                            locale-gen en_US.UTF-8 &&
                            echo \"LANG=en_US.UTF-8\" > /etc/default/locale
                        """,
					]
				}
			},
			docker.#Set & {
				config: env: {
					LANG:     "en_US.UTF-8"
					LANGUAGE: "en_US:en"
					LC_ALL:   "en_US.UTF-8"
				}
			},
		]
	}

	// Load the image in local registry
	_load: cli.#Load & {
		image: _build.output
		host:  socket
		tag:   "machinelearning-one/nested:old"
	}
}

#New: {
	// The local daemon for pushing the image
	socket: dagger.#Socket

	_source: "ubuntu:20.04"

	_build: #Build & {
		steps: [
			// Define the base image
			[
				docker.#Pull & {
					source: _source
				},
				docker.#Set & {
					config: env: DEBIAN_FRONTEND: "noninteractive"
				},
			],
			#InstallLocales,
			docker.#Run & {
				command: {
					name: "sh"
					args: ["-c",
						"""
                            locale-gen en_US.UTF-8 &&
                            echo \"LANG=en_US.UTF-8\" > /etc/default/locale
                        """,
					]
				}
			},
			docker.#Set & {
				config: env: {
					LANG:     "en_US.UTF-8"
					LANGUAGE: "en_US:en"
					LC_ALL:   "en_US.UTF-8"
				}
			},
		]
	}

	// Load the image in local registry
	_load: cli.#Load & {
		image: _build.output
		host:  socket
		tag:   "machinelearning-one/nested:new"
	}
}

#InstallLocales: [
	docker.#Run & {
		command: {
			name: "apt"
			args: ["update"]
		}
	},
	docker.#Run & {
		command: {
			name: "apt"
			args: ["install", "-y", "--no-install-recommends", "locales"]
		}
	},
]
