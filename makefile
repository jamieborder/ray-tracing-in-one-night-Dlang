files = ./main.d ./ray.d ./vector.d ./hitable.d ./sphere.d ./camera.d ./material.d

all : $(files)
	@dmd -ofoutput $(files)
	@./output
