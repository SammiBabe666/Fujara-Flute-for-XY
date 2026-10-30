.file "synth_control_table.cpp";
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	""
.text;
	.align 4
.type __ZL13fujara_formatmlPc, STT_FUNC;
__ZL13fujara_formatmlPc:
	[--SP] = RETS;
	cc =R0==1;
	SP += -12;
	R3 = R2;
	if cc jump .L5;
	cc =R0==0;
	if cc jump .L5;
	cc =R0==2;
	if cc jump .L5;
	cc =R0==3;
	if cc jump .L5 (bp);
	SP += 12;
	RETS = [SP++];
	R0 = 0 (X);
	rts;
.L5:
	cc =R1<0;
	if cc jump .L14;
	R1 >>= 10;
	R0 = R1 << 5;
	R0 = R0 - R1;
	P1 = R0;
	P2 = R1;
	R0 = 1 (X);
	R0 <<= 20;
	P1 = P2 + (P1 << 2);
	R1 = P1;
	R1 <<= 3;
	R1 = R1 + R0;
	R1 >>= 21;
.L10:
	R2.H = .LC0;
	R0 = R3;
	R2.L = .LC0;
	call __ZN4opxy8platform14control_tenthsEPcmPKc;
	SP += 12;
	RETS = [SP++];
	R0 = 1 (X);
	rts;
.L14:
	R1 = 0 (X);
	jump.s .L10;
	.size	__ZL13fujara_formatmlPc, .-__ZL13fujara_formatmlPc
.global sdk_lfo_machine_count;
	.section	.rodata
	.align 4
	.type	sdk_lfo_machine_count, @object
	.size	sdk_lfo_machine_count, 4
sdk_lfo_machine_count:
	.long	1
.global sdk_lfo_machines;
	.align 4
	.type	sdk_lfo_machines, @object
	.size	sdk_lfo_machines, 40
sdk_lfo_machines:
	.long	fujara_engine_id
	.long	fujara_record_ready
	.long	4
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.zero	4
	.long	0
	.long	0
	.long	0
	.zero	8
.global sdk_synth_control_count;
	.align 4
	.type	sdk_synth_control_count, @object
	.size	sdk_synth_control_count, 4
sdk_synth_control_count:
	.long	1
.global sdk_synth_controls;
	.align 4
	.type	sdk_synth_controls, @object
	.size	sdk_synth_controls, 72
sdk_synth_controls:
	.long	fujara_engine_id
	.long	fujara_ready
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.long	15
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.long	__ZL13fujara_formatmlPc
	.byte	0
	.byte	0
	.zero	2
	.long	0
	.long	0
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.long	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.long	0
	.byte	0
	.byte	0
	.zero	2
	.ident	"GCC: (GNU) 8.0.0 20171013 (experimental)"
