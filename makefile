files = ./main.d ./ray.d ./vector.d ./hitable.d ./sphere.d ./camera.d

all : $(files)
	@dmd -ofoutput $(files)
	@./output
