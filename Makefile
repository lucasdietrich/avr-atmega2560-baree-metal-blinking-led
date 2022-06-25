all: dis build/blinking.hex

build:
	mkdir -p $@

build/main.o: main.c build
	avr-gcc -o $@ -c -mmcu=atmega2560 -std=gnu11 -Wall -ffunction-sections -fdata-sections -Og -g -gdwarf-2 -DF_CPU=16000000L $<

build/func.o: func.c build
	avr-gcc -o $@ -c -mmcu=atmega2560 -std=gnu11 -Wall -ffunction-sections -fdata-sections -Og -g -gdwarf-2 -DF_CPU=16000000L $<

build/blinking.elf: build/main.o build/func.o
	avr-gcc -o $@ -mmcu=atmega2560 -std=gnu11 -Wall -ffunction-sections -fdata-sections -Og -g -gdwarf-2 -DF_CPU=16000000L $^

qemu: build/blinking.elf
	qemu-system-avr -M mega2560 -bios $^ -s -S -nographic

dis: build/main.o build/main.o build/func.o build/func.o build/blinking.elf
	avr-objdump -d build/main.o > build/main.dis.asm
	avr-objdump -S build/main.o > build/main.dis.src.asm
	avr-objdump -d build/func.o > build/func.dis.asm
	avr-objdump -S build/func.o > build/func.dis.src.asm
	avr-objdump -d build/blinking.elf > build/blinking.dis.asm
	avr-objdump -S build/blinking.elf > build/blinking.dis.src.asm

build/blinking.hex: build/blinking.elf
	avr-objcopy -R .eeprom -O ihex $< $@

flash: build/blinking.hex
	avrdude -c wiring -p atmega2560 -P /dev/ttyACM0 -U flash:w:$<:i

clean:
	rm -rf build