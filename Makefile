all: start.o nand.o main.o
	arm-linux-ld -Tlink.lds -o start.elf $^
	arm-linux-objcopy -O binary start.elf start.bin
	
%.o : %.S
	arm-linux-gcc -g -c $^
	
%.o : %.c
	arm-linux-gcc -g -c $^
	
.PHONY: clean
clean:
	rm *.o *.elf *.bin


