build:
	@echo "Building Old Styled"
	@dagger do old
	@echo "Building New Styled"
	@dagger do new

compare:
	@echo "Comparing"
	@docker images | grep machinelearning-one/nested

run: build compare