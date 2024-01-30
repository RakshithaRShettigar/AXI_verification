compile:
	vlib work;
	vlog -sv \
	+acc \
	+cover \
	+fcover \
	axi_master_top.sv 
 
simulate:
	vsim -vopt work.axi_master_top \
	-voptargs=+acc=npr \
	-assertdebug \
	-l axi_master.log \
	-sva \
	-coverage \
	-c -do "log -r /*; add wave -r /*; coverage save -onexit -assert -directive -cvg -codeAll axi_coverage.ucdb; run -all; exit" \
	-wlf axi_waveform.wlf
	wlf2vcd -o axi_waveform.vcd axi_waveform.wlf
	gtkwave axi_waveform.vcd

clean:
	rm -rf work/ *.ucdb *.wlf *.vcd *.log *.vstf transcript
all:
	make compile
	make simulate
