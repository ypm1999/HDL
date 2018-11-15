TOOL_CHAIN = /opt/riscv/bin
CROSS_COMPILE = $(TOOL_CHAIN)/riscv32-unknown-elf-

%.o: %.s 
	$(CROSS_COMPILE)as $< -o $@ -march=rv32i
	
%.o: %.S 
	$(CROSS_COMPILE)as $< -o $@ -march=rv32i
	
%.om: %.o
	$(CROSS_COMPILE)ld $< -o $@
%.data: %.om
	$(CROSS_COMPILE)objcopy -O verilog $<  $@
clean:
	rm -f *.o *.om *.data