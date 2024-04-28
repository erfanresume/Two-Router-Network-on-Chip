transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/routing_unit.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/register_file.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/NoC.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/fifo_input_buffer.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/fifo_controller.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/arbiter.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/crossbar.vhd}
vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/router.vhd}

vcom -93 -work work {F:/installed program/Quartus II/quartus/bin/Altera_SRC/2Router_NoC_version4/NoC_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  noc_tb

add wave *
view structure
view signals
run -all
