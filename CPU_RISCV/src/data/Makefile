TOOL_CHAIN = /opt/riscv/bin
CROSS_COMPILE = $(TOOL_CHAIN)/riscv32-unknown-elf-
 
%.o: %.S
	$(CROSS_COMPILE)as $< -o $@ -march=rv32i
%.om: %.o
	$(CROSS_COMPILE)ld $< -o $@
%.data: %.om
	$(CROSS_COMPILE)objcopy -O verilog $<  $@
	$(CROSS_COMPILE)objdump -D $< > mytest.S -M no-aliases,numeric
	cp $@ ../$@
	rm -f *.om *.o
clean:
	rm -f *.o *.om *.bin *.data