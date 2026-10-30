.file "registration.cpp";
.text;
	.align 4
.global fujara_screen_register;
.type fujara_screen_register, STT_FUNC;
fujara_screen_register:
	R1.H = __ZN12_GLOBAL__N_1L6screenE;
	R0.H = __ZN12_GLOBAL__N_1L6recordE;
	R1.L = __ZN12_GLOBAL__N_1L6screenE;
	R0.L = __ZN12_GLOBAL__N_1L6recordE;
	jump.l sdk_register_screen;
	.size	fujara_screen_register, .-fujara_screen_register
	.align 4
.global fujara_register;
.type fujara_register, STT_FUNC;
fujara_register:
	R0.H = __ZN12_GLOBAL__N_1L6recordE;
	R0.L = __ZN12_GLOBAL__N_1L6recordE;
	jump.l sdk_register_engine;
	.size	fujara_register, .-fujara_register
	.align 4
.global fujara_record_ready;
.type fujara_record_ready, STT_FUNC;
fujara_record_ready:
	R0.H = __ZN12_GLOBAL__N_1L6recordE;
	R1 = 0 (X);
	R0.L = __ZN12_GLOBAL__N_1L6recordE;
	jump.l sdk_engine_ready;
	.size	fujara_record_ready, .-fujara_record_ready
	.align 4
.global fujara_name_matches;
.type fujara_name_matches, STT_FUNC;
fujara_name_matches:
	R1 = R0;
	R0.H = __ZN12_GLOBAL__N_1L6recordE;
	R0.L = __ZN12_GLOBAL__N_1L6recordE;
	jump.l sdk_name_matches;
	.size	fujara_name_matches, .-fujara_name_matches
	.align 4
.global fujara_ready;
.type fujara_ready, STT_FUNC;
fujara_ready:
	R1.H = __ZN12_GLOBAL__N_1L6screenE;
	R0.H = __ZN12_GLOBAL__N_1L6recordE;
	R1.L = __ZN12_GLOBAL__N_1L6screenE;
	R0.L = __ZN12_GLOBAL__N_1L6recordE;
	jump.l sdk_engine_ready;
	.size	fujara_ready, .-fujara_ready
	.section	.rodata
	.align 4
	.type	__ZN12_GLOBAL__N_1L6screenE, @object
	.size	__ZN12_GLOBAL__N_1L6screenE, 20
__ZN12_GLOBAL__N_1L6screenE:
	.long	fujara_screen_state
	.long	220
	.long	fujara_screen_vtable
	.long	fujara_screen_asset
	.long	fujara_screen_ctor
	.align 4
	.type	__ZN12_GLOBAL__N_1L6recordE, @object
	.size	__ZN12_GLOBAL__N_1L6recordE, 24
__ZN12_GLOBAL__N_1L6recordE:
	.long	fujara_factory
	.long	fujara_parameter_name
	.long	fujara_name
	.long	fujara_engine_id
	.long	fujara_page_id
	.long	0
	.ident	"GCC: (GNU) 8.0.0 20171013 (experimental)"
