files = ./raytracer.d ./ray.d ./vector.d

all : $(files)
	@dmd -ofoutput $(files)
	@./output
