files = ./main.d ./ray.d ./vector.d ./hitable.d ./sphere.d

all : $(files)
	@dmd -ofoutput $(files)
	@./output
