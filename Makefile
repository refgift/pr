.s.o:
	as --64 $< -o $@ -g -a=pr.txt

pr:	pr.o
	gcc $< -o $@  
	
clean:
	rm *.o
