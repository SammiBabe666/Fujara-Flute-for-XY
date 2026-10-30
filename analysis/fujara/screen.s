.file "screen.cpp";
.text;
	.align 4
.type __ZN4opxy6screen12_GLOBAL__N_17destroyINS1_7DrawingIN12_GLOBAL__N_17MachineEE6ObjectEEEvPT_, STT_FUNC;
__ZN4opxy6screen12_GLOBAL__N_17destroyINS1_7DrawingIN12_GLOBAL__N_17MachineEE6ObjectEEEvPT_:
	[--sp] = ( p5:5 );

	P5 = R0;
	[--SP] = RETS;
	P2.H = 36177;
	P2.L = 64952;
	SP += -12;
	call (P2);
	R0 = 0 (X);
	P1 = 76 (X);
	[P5+16] = R0;
	P1 = P5 + P1;
	P2 = 36 (X);
	LSETUP (.L2, .L5) LC1 = P2;
.L2:
.L5:
	[P1++] = R0;
	SP += 12;
	RETS = [SP++];
	( p5:5 ) = [sp++];

	rts;
	.size	__ZN4opxy6screen12_GLOBAL__N_17destroyINS1_7DrawingIN12_GLOBAL__N_17MachineEE6ObjectEEEvPT_, .-__ZN4opxy6screen12_GLOBAL__N_17destroyINS1_7DrawingIN12_GLOBAL__N_17MachineEE6ObjectEEEvPT_
	.section	.rodata
	.align 4
.LC0:
	.long	0
	.long	1
	.long	3
	.long	4
	.long	6
	.long	7
.text;
	.align 4
.type __ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE5frameEPNS5_6ObjectEl, STT_FUNC;
__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE5frameEPNS5_6ObjectEl:
	[--sp] = ( r7:4, p5:3 );

	P5 = R0;
	LINK 176;
	R0 = [P5+8];
	cc =R0==0;
	[P5+208] = R1;
	if cc jump .L6;
	R4 = P5;
	R4 += 24;
	R5 = P5;
	[SP+24] = R4;
	R5 += 40;
	P2 = R4;
	P1 = 4 (X);
	LSETUP (.L8, .L143) LC1 = P1;
.L8:
	R0 = [P2++];
	cc =R0==0;
	if cc jump .L6;
	nop;
	nop;
	nop;
	R0 = [P2+12];
	cc =R0==0;
	if cc jump .L6;
.L143:
	nop;
	P2.H = 36173;
	P2.L = 28436;
	call (P2);
	P0 = 121 (X);
	P0 = P0 + SP;
	R1 = P0;
	R7 = 0 (X);
	[SP+116] = R0;
	call sdk_synth_shown;
	P2.H = 36173;
	P2.L = 29352;
	[SP+128] = R7;
	[SP+132] = R7;
	[SP+136] = R7;
	[SP+140] = R7;
	[SP+144] = R7;
	[SP+148] = R7;
	[SP+152] = R7;
	[SP+156] = R7;
	[SP+160] = R7;
	[SP+164] = R7;
	[SP+168] = R7;
	[SP+172] = R7;
	R0 = [SP+116];
	call (P2);
	P1 = R0;
	P4 = 80 (X);
	R1 = SP;
	R2 = 112 (X);
	P2 = SP + P4;
	R0 = R1 + R2;
	cc =P1==0;
	[SP+32] = R7;
	[SP+36] = P2;
	[SP+40] = R0;
	if cc jump .L9;
	FP = [P1+4];
	R1 = [SP+116];
	cc =FP==0;
	if cc jump .L10;
	nop;
	nop;
	nop;
	P0 = [P1+8];
	cc =FP<=P0 (iu);
	if !cc jump .L10;
	P0 -= FP;
	P4 = 15 (X);
	cc =P0<=P4 (iu);
	if cc jump .L10;
	R2 = FP;
	R0 = 3 (X);
	R0 = R2 & R0;
	cc =R0==0;
	if !cc jump .L10;
	P1 = 31 (X);
	cc =P0<=P1 (iu);
	if cc jump .L127 (bp);
	R7 = 8 (X);
.L14:
	P0 = 144 (X);
	P4 = SP + P0;
	R0 = P4;
	P1 = 0 (X);
	P3 = 8 (X);
	LSETUP (.L16, .L142) LC1 = P3;
.L16:
	R2 = P1;
	cc =R7<=R2 (iu);
	if cc jump .L68 (bp);
	P0 = FP + (P1 << 2);
	R2 = [P0];
.L15:
	P0 = R0;
	P1 += 1;
	[P0++] = R2;
.L142:
	R0 = P0;
	P1 = 176 (X);
	FP = P1 + SP;
	P1 = P2;
.L17:
	nop;
	R0 = [P4++];
	cc =P4==FP;
	[P1++] = R0;
	if !cc jump .L17 (bp);
	P4 = 121 (X);
	P0 = 128 (X);
	P3 = P4 + SP;
	FP = SP + P0;
	R2 = 0 (X);
	P4 = 4 (X);
	LSETUP (.L20, .L141) LC1 = P4;
.L20:
	R0 = B [P3++] (Z);
	cc =R7<=R0 (iu);
	if !cc jump .L18 (bp);
	B [P3+-1] = R2;
	R0 = R2.B (Z);
.L18:
	P1 = R0;
	P0 = 176 (X);
	P0 = P0 + SP;
	R2 += 1;
	P1 = P0 + (P1 << 2);
	R0 = [P1+-32];
	[FP++] = R0;
.L141:
	[P2++] = R0;
	R0 = 1 (X);
	P1 = SP;
	B [SP+120] = R0;
	P1 += 32;
	jump.s .L21;
.L10:
	R0 = 0 (X);
	B [SP+120] = R0;
.L21:
	P2.H = 36180;
	R0 = R4;
	R2 = P1;
	P2.L = 26284;
	call (P2);
	R0 = B [SP+120] (Z);
	cc =R0==0;
	if cc jump .L26 (bp);
	P1 = 121 (X);
	R0 = SP;
	R1 = 128 (X);
	P4 = P1 + SP;
	R6 = R0 + R1;
	P3 = SP;
	R7 = R6;
	FP = P4;
	P3 += 56;
.L25:
	P0 = R7;
	R1 = B [FP++] (Z);
	R0 = [SP+116];
	R2 = [P0++];
	[SP+12] = P3;
	R7 = P0;
	call sdk_synth_value;
	R0 = R0.B (Z);
	cc =R0==0;
	if cc jump .L23;
	P1 = R4;
	P2.H = 36192;
	R1 = P3;
	P2.L = 4592;
	R0 = [P1];
	call (P2);
.L23:
	R4 += 4;
	cc =R4==R5;
	if !cc jump .L25 (bp);
	R0 = B [SP+120] (Z);
	cc =R0==0;
	if cc jump .L26;
	R1 = [SP+116];
	R0 = [P5+12];
	call sdk_screen_activation;
	cc =R0==0;
	R7 = R0;
	if cc jump .L28 (bp);
	P3.H = __ZN4opxy6screen12_GLOBAL__N_118display_activationE;
	P3.L = __ZN4opxy6screen12_GLOBAL__N_118display_activationE;
	R0 = [P3];
	cc =R7==R0;
	if cc jump .L28 (bp);
	R1.H = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	R0.H = __ZN4opxy6screen12_GLOBAL__N_113display_stateE;
	R0.L = __ZN4opxy6screen12_GLOBAL__N_113display_stateE;
	R1.L = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	call _fujara_display_reset;
	R0 = R0 -|- R0 ||
	[P3] = R7 ||
	nop;
	[P5+216] = R0;
.L28:
	P3.H = __ZN4opxy6screen12_GLOBAL__N_113display_inputE;
	P3.L = __ZN4opxy6screen12_GLOBAL__N_113display_inputE;
	P1 = P3;
	P0 = P3;
	P1 += 32;
	P2 = 4 (X);
	LSETUP (.L29, .L140) LC1 = P2;
.L29:
	FP = R6;
	R0 = [FP++];
	[P0++] = R0;
	R0 = B [P4++] (X);
	R6 = FP;
.L140:
	B [P1++] = R0;
	P1 = 144 (X);
	P0 = SP + P1;
	P1.H = __ZN4opxy6screen12_GLOBAL__N_113display_inputE+36;
	P1.L = __ZN4opxy6screen12_GLOBAL__N_113display_inputE+36;
	P2 = 8 (X);
	LSETUP (.L30, .L139) LC1 = P2;
.L30:
	R0 = [P0++];
.L139:
	[P1++] = R0;
	R0 = [P5+208];
	[P3+16] = R0;
	R0 = [SP+116];
	cc =R0<=7 (iu);
	[P3+20] = R0;
	if !cc jump .L69;
	P2.H = 36173;
	P2.L = 27656;
	call (P2);
	R1 = R0;
	R0 = [SP+116];
.L31:
	[P3+24] = R1;
	R1.H = __ZN4opxy6screen12_GLOBAL__N_113display_inputE;
	R1.L = __ZN4opxy6screen12_GLOBAL__N_113display_inputE;
	call sdk_display_note_activity;
	P4.H = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	R0 = 0 (X);
	[P3+28] = R0;
	P4.L = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	R1.H = __ZN4opxy6screen12_GLOBAL__N_113display_inputE;
	R0.H = __ZN4opxy6screen12_GLOBAL__N_113display_stateE;
	R2 = P4;
	R1.L = __ZN4opxy6screen12_GLOBAL__N_113display_inputE;
	R0.L = __ZN4opxy6screen12_GLOBAL__N_113display_stateE;
	call _fujara_display_render;
	R0 = P4;
	call _fujara_display_validate;
	cc =R0==0;
	if !cc jump .L128;
.L26:
	P2.H = 36177;
	R1 = 0 (X);
	R0 = P5;
	P2.L = 65052;
	call (P2);
.L6:
	P1 = 176 (X);
	SP = SP + P1;
	FP = [SP++];
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	rts;
.L9:
	R0 = 0 (X);
	B [SP+120] = R0;
	R1 = [SP+116];
	jump.s .L21;
.L127:
	R7 = P0;
	R7 >>= 2;
	jump.s .L14;
.L128:
	R1 = [P5+216];
	R0 = [P4];
	cc =R1==R0;
	P1 = [P5+76];
	if cc jump .L33;
	cc =P1==0;
	if cc jump .L33;
	R1.H = 33804;
	R1.L = 19828;
	R0 = [P1];
	cc =R0==R1;
	if !cc jump .L33 (bp);
	P2 = [P1+120];
	cc =P2==0;
	if cc jump .L33;
	R2 = P2;
	R0 = 3 (X);
	R0 = R2 & R0;
	cc =R0==0;
	if !cc jump .L33;
	nop;
	nop;
	nop;
	P0 = [P1+124];
	cc =P2<=P0 (iu);
	if !cc jump .L33;
	nop;
	nop;
	nop;
	P3 = [P1+128];
	cc =P0<=P3 (iu);
	if !cc jump .L33;
	P0 -= P2;
	FP = 2080 (X);
	cc =P0==FP;
	if !cc jump .L33 (bp);
	P3 -= P2;
	P0 = 4096 (X);
	cc =P3<=P0 (iu);
	if !cc jump .L33;
	P0 = P2;
	R0 = 1 (X);
	jump.s .L34;
.L130:
	R1 = 64 (X);
	cc =R0==R1;
	if cc jump .L129;
.L36:
	P0 += 32;
	R0 += 1;
.L34:
	cc =R0==1;
	R1 = B [P0+24] (Z);
	if cc jump .L35;
	cc =R1==2;
	if cc jump .L130 (bp);
.L33:
	P4 = 116 (X);
	FP.H = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	R4 = 76 (X);
	R3 = P5;
	P4 = P5 + P4;
	R7.H = .LC0;
	FP.L = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	R4 = R3 + R4;
	[SP+28] = P4;
	R7.L = .LC0;
.L61:
	R0 = [FP+540];
	cc =R0==0;
	if !cc jump .L131;
.L39:
	cc =P1==0;
	if cc jump .L41;
	nop;
	nop;
.L42:
	nop;
	R2 = [FP+524];
	R1 = [FP+528];
	R1 *= R2;
	cc =R1<0;
	R0 = R1;
	if !cc jump .L51 (bp);
	R0 = 1023 (X);
	R0 = R1 + R0;
.L51:
	cc =R1<0;
	R0 >>>= 10;
	if cc jump .L132;
	nop;
	nop;
.L52:
	nop;
	R1 = [FP+532];
	R2 *= R1;
	cc =R2<0;
	R1 = R2;
	if !cc jump .L53 (bp);
	R1 = 1023 (X);
	R1 = R2 + R1;
.L53:
	cc =R2<0;
	R1 >>>= 10;
	if cc jump .L133;
.L54:
	I0 = R7;
	P0 = SP;
	P2 = 5 (X);
	P0 += 32;
	M0 = 24 (X);
	R3 = [I0++]; lsetup (1f, 1f) LC1 = P2; 1: MNOP || [P0++] = R3 || R3 = [I0++]; [P0++] = R3;
	P2 = 56 (X);
	[SP+60] = R1;
	P0 = SP;
	R1 = -R1;
	P2 = P2 + SP;
	P0 += 32;
	[SP+64] = R1;
	I0 = P2;
	R1 = [FP+516];
	[SP+72] = R1;
	I0 += 4;
	R1 = [FP+520];
	I1 = P0;
	[SP+56] = R0;
	[SP+68] = R0;
	[SP+76] = R1;
	I1 += M0;
	I3 = I0;
	P3 = P0;
	R3 = R0;
	P4 = 6 (X);
	jump.s .L57;
.L107:
	P2 = I3;
	R3 = [P2++];
	I3 = P2;
.L57:
	P2 = [P3++];
	P2 = P1 + (P2 << 2);
	R2 = [P2+4];
	cc =R2==R3;
	if cc jump .L134;
	P4 = P1;
	P2 = 80 (X);
	P3 = SP + P2;
	P4 += 4;
	P2 = 9 (X);
	LSETUP (.L58, .L138) LC1 = P2;
.L58:
	R3 = [P4++];
.L138:
	[P3++] = R3;
	jump.s .L60;
.L135:
	P4 = I0;
	R0 = [P4++];
	I0 = P4;
.L60:
	P2 = [P0++];
	P4 = 176 (X);
	P4 = P4 + SP;
	P2 = P4 + (P2 << 2);
	[P2+-96] = R0;
	P2 = I1;
	cc =P2==P0;
	if !cc jump .L135 (bp);
	P0 = 80 (X);
	P0 = P0 + SP;
	P2.H = 36191;
	R1 = P0;
	R0 = P1;
	P2.L = 1702;
	call (P2);
.L41:
	R4 += 4;
	R2 = [SP+28];
	cc =R2==R4;
	FP += 28;
	if cc jump .L136;
	nop;
	nop;
	P2 = R4;
	P1 = [P2];
	jump.s .L61;
.L68:
	R2 = 0 (X);
	jump.s .L15;
.L134:
	P4 += -1;
	cc =P4==0;
	if !cc jump .L107;
	jump.s .L41;
.L131:
	P2 = [FP+536];
	P2 = P5 + (P2 << 2);
	R1 = [P2+144];
	cc =R1==0;
	if cc jump .L39;
	cc =P1==0;
	if cc jump .L41;
	R3.H = 33804;
	R3.L = 19828;
	R2 = [P1];
	cc =R2==R3;
	if !cc jump .L42 (bp);
	cc =R0==2;
	R2 = R1 >> 16;
	if !cc jump .L43 (bp);
	R0 = W [P1+112] (Z);
	cc =R0==0;
	if cc jump .L43 (bp);
	R1 = R1.L (Z);
	cc =R1==R0;
	if cc jump .L43;
	P2.H = 36191;
	R0 = P1;
	[SP+20] = R2;
	[SP+16] = P1;
	P2.L = 43398;
	call (P2);
	P1 = [SP+16];
	R2 = [SP+20];
	R0 = W [P1+114] (Z);
	cc =R0==R2;
	if cc jump .L46;
.L47:
	P2.H = 36191;
	R0 = P1;
	[SP+16] = P1;
	R1 = R2;
	P2.L = 43366;
	call (P2);
	P1 = [SP+16];
.L46:
	P2.H = 36191;
	R0 = P1;
	P2.L = 43460;
	call (P2);
	P0 = R4;
	P1 = [P0];
	jump.s .L39;
.L133:
	R3 = 1023 (X);
	R2 = R2 & R3;
	cc =R2==0;
	if cc jump .L54 (bp);
	R1 += -1;
	jump.s .L54;
.L132:
	R3 = 1023 (X);
	R1 = R1 & R3;
	cc =R1==0;
	if cc jump .L52 (bp);
	R0 += -1;
	jump.s .L52;
.L136:
	P4.H = __ZN4opxy6screen12_GLOBAL__N_113display_frameE+832;
	P3.H = 36192;
	P4.L = __ZN4opxy6screen12_GLOBAL__N_113display_frameE+832;
	P3.L = 4592;
.L64:
	nop;
	R0 = B [P4] (X);
	cc =R0==0;
	if cc jump .L62 (bp);
	FP = [SP+24];
	P2 = [FP];
	cc =P2==0;
	if cc jump .L62;
	R1.H = 33804;
	R1.L = 20824;
	R0 = [P2];
	cc =R0==R1;
	if !cc jump .L62;
	R1 = P4;
	R0 = P2;
	call (P3);
.L62:
	P0 = [SP+24];
	P4 += 8;
	P0 += 4;
	R3 = P0;
	cc =R3==R5;
	[SP+24] = P0;
	if !cc jump .L64 (bp);
	jump.s .L26;
.L69:
	R1 = 0 (X);
	jump.s .L31;
.L43:
	nop;
	R0 = W [P1+114] (Z);
	cc =R2==R0;
	if !cc jump .L47 (bp);
	jump.s .L42;
.L129:
	R0 = B [P2+2072] (Z);
	R2 = 5 (X);
	cc =R0==R2;
	if !cc jump .L33 (bp);
	P0 = [P5+212];
	cc =P0==P2;
	if !cc jump .L33 (bp);
	P1.H = __ZN4opxy6screen12_GLOBAL__N_113display_frameE+4;
	P1.L = __ZN4opxy6screen12_GLOBAL__N_113display_frameE+4;
	P0 = 64 (X);
	LSETUP (.L38, .L137) LC1 = P0;
.L38:
	P1 += 8;
	R0 = [P1+-8];
	[P2] = R0;
	R0 = [P1+-4];
	[P2+4] = R0;
.L137:
	P2 += 32;
	P2.H = 36191;
	R0 = [P5+76];
	P2.L = 43460;
	call (P2);
	R0 = [P4];
	[P5+216] = R0;
	P1 = [P5+76];
	jump.s .L33;
.L35:
	cc =R1==1;
	if cc jump .L36 (bp);
	jump.s .L33;
	.size	__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE5frameEPNS5_6ObjectEl, .-__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE5frameEPNS5_6ObjectEl
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC1:
	.string	"fujara_node_0"
	.align 4
.LC2:
	.string	"fujara_palette_0"
.text;
	.align 4
.type __ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE4initEPNS5_6ObjectE, STT_FUNC;
__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE4initEPNS5_6ObjectE:
	[--sp] = ( r7:4, p5:3 );

	P4 = R0;
	P3 = 76 (X);
	LINK 12;
	R0 = 0 (X);
	P2 = 36 (X);
	P3 = P4 + P3;
	P1 = P3;
	LSETUP (.L145, .L184) LC1 = P2;
.L145:
.L184:
	[P1++] = R0;
	P2.H = __ZN4opxy6screen12_GLOBAL__N_118display_activationE;
	P2.L = __ZN4opxy6screen12_GLOBAL__N_118display_activationE;
	[P2] = R0;
	R1.H = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	R0.H = __ZN4opxy6screen12_GLOBAL__N_113display_stateE;
	R0.L = __ZN4opxy6screen12_GLOBAL__N_113display_stateE;
	R1.L = __ZN4opxy6screen12_GLOBAL__N_113display_frameE;
	call _fujara_display_reset;
	R0 = [P4+8];
	cc =R0==0;
	if cc jump .L144;
	R0 = P4;
	P2.H = 36178;
	P5.H = __ZN12_GLOBAL__N_17Machine3idsE+4;
	R1 = P4;
	R2 = 0 (X);
	R0 += 24;
	P2.L = 5892;
	P5.L = __ZN12_GLOBAL__N_17Machine3idsE+4;
	call (P2);
	R7 = P5;
	R1.H = .LC1;
	FP.H = 36178;
	R7 += 36;
	R1.L = .LC1;
	FP.L = 776;
	R6 = 0 (X);
	jump.s .L150;
.L180:
	R1.H = 33804;
	R0 = [P2];
	R1.L = 19828;
	cc =R0==R1;
	if !cc P2 = R6;
.L147:
	R2 = P5;
	cc =R7==R2;
	[P3++] = P2;
	if cc jump .L179;
	nop;
	nop;
	nop;
	R1 = [P5++];
.L150:
	R2 = 1 (X);
	R0 = P4;
	call (FP);
	P2 = R0;
	cc =P2==0;
	if !cc jump .L180 (bp);
	P2 = 0 (X);
	jump.s .L147;
.L152:
	P2 = [P4+76];
	cc =P2==0;
	if cc jump .L174;
	R1.H = 33804;
	R1.L = 19828;
	R0 = [P2];
	cc =R0==R1;
	if cc jump .L181;
.L174:
	R0 = 0 (X);
.L153:
	[P4+212] = R0;
.L144:
	SP += 12;
	FP = [SP++];
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	rts;
.L179:
	P5.H = __ZN12_GLOBAL__N_17Machine3idsE+44;
	P5.L = __ZN12_GLOBAL__N_17Machine3idsE+44;
	R6 = 144 (X);
	R3 = P4;
	FP = P5;
	R1.H = .LC2;
	P3.H = 36178;
	R6 = R3 + R6;
	FP += 60;
	R1.L = .LC2;
	P3.L = 776;
	R7 = 20 (X);
.L149:
	R2 = 1 (X);
	R0 = P4;
	call (P3);
	P2 = R0;
	cc =P2==0;
	if cc jump .L170;
	R4.H = 33804;
	R4.L = 19828;
	R0 = [P2];
	cc =R0==R4;
	if !cc jump .L170 (bp);
	R1 = W [P2+112] (X);
	R2 = W [P2+114] (X);
	cc =R1<=0;
	R0 = R2.L (Z);
	if cc jump .L170;
	cc =R0==0;
	if cc jump .L170;
	nop;
	nop;
	nop;
	P2 = [P4+8];
	R3 = [P2+100];
	cc =R3==0;
	if cc jump .L170;
	nop;
	nop;
	nop;
	P1 = [P2+104];
	R5 = P1;
	cc =R3<=R5 (iu);
	if !cc jump .L170;
	nop;
	nop;
	nop;
	P0 = [P2+108];
	cc =P1<=P0 (iu);
	if !cc jump .L170;
	R3 = R5 - R3;
	R5 = R1 << 2;
	cc =R3<R5 (iu);
	if cc jump .L170;
	nop;
	nop;
	nop;
	R3 = [P2+132];
	cc =R3==0;
	if cc jump .L170;
	nop;
	nop;
	nop;
	R5 = [P2+136];
	cc =R3<=R5 (iu);
	if !cc jump .L170;
	nop;
	nop;
	nop;
	P2 = [P2+140];
	R4 = P2;
	cc =R5<=R4 (iu);
	if !cc jump .L170;
	R3 = R5 - R3;
	R2 = R2.L * R7.L (FU);
	cc =R3<R2 (iu);
	if cc jump .L170;
	R0 <<= 16;
	R0 = R0 | R1;
	jump.s .L151;
.L170:
	R0 = 0 (X);
.L151:
	P2 = R6;
	cc =P5==FP;
	[P2++] = R0;
	R6 = P2;
	if cc jump .L152;
	nop;
	nop;
	nop;
	R1 = [P5++];
	jump.s .L149;
.L181:
	R1 = [P2+120];
	cc =R1==0;
	if cc jump .L174;
	R0 = 3 (X);
	R0 = R1 & R0;
	cc =R0==0;
	if !cc jump .L174;
	nop;
	nop;
	nop;
	R2 = [P2+124];
	cc =R1<=R2 (iu);
	if !cc jump .L153;
	nop;
	nop;
	nop;
	R3 = [P2+128];
	cc =R2<=R3 (iu);
	if !cc jump .L153;
	R2 = R2 - R1;
	R4 = 2080 (X);
	cc =R2==R4;
	if !cc jump .L153 (bp);
	R3 = R3 - R1;
	R5 = 4096 (X);
	cc =R3<=R5 (iu);
	if !cc jump .L153;
	P2 = R1;
	R2 = 1 (X);
	jump.s .L154;
.L183:
	cc =R3==2;
	if !cc jump .L153;
	R7 = 64 (X);
	cc =R2==R7;
	if cc jump .L182;
.L156:
	P2 += 32;
	R2 += 1;
.L154:
	cc =R2==1;
	R3 = B [P2+24] (Z);
	if !cc jump .L183 (bp);
	cc =R3==1;
	if cc jump .L156 (bp);
	jump.s .L153;
.L182:
	P2 = R1;
	R3 = 5 (X);
	R2 = B [P2+2072] (Z);
	cc =R2==R3;
	if cc R0 = R1;
	jump.s .L153;
	.size	__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE4initEPNS5_6ObjectE, .-__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE4initEPNS5_6ObjectE
	.align 4
.global fujara_screen_ctor;
.type fujara_screen_ctor, STT_FUNC;
fujara_screen_ctor:
	[--sp] = ( p5:5 );

	P5 = R0;
	R0 = R1;
	R0 += -1;
	R2 = 254 (X);
	[--SP] = RETS;
	cc =R0<=R2 (iu);
	SP += -12;
	if !cc jump .L187;
	R2.H = fujara_screen_asset;
	P2.H = 36178;
	R0 = P5;
	R2.L = fujara_screen_asset;
	P2.L = 2116;
	call (P2);
	R0.H = fujara_screen_vtable;
	R0.L = fujara_screen_vtable;
	[P5] = R0;
	R0 = P5;
.L185:
	SP += 12;
	RETS = [SP++];
	( p5:5 ) = [sp++];

	rts;
.L187:
	R0 = 0 (X);
	jump.s .L185;
	.size	fujara_screen_ctor, .-fujara_screen_ctor
.global fujara_screen_vtable;
	.section	.rodata
	.align 4
	.type	fujara_screen_vtable, @object
	.size	fujara_screen_vtable, 24
fujara_screen_vtable:
	.long	__ZN4opxy6screen12_GLOBAL__N_17destroyINS1_7DrawingIN12_GLOBAL__N_17MachineEE6ObjectEEEvPT_
	.long	__ZN4opxy6screen12_GLOBAL__N_17destroyINS1_7DrawingIN12_GLOBAL__N_17MachineEE6ObjectEEEvPT_
	.long	-1924006700
	.long	__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE5frameEPNS5_6ObjectEl
	.long	__ZN4opxy6screen12_GLOBAL__N_17DrawingIN12_GLOBAL__N_17MachineEE4initEPNS5_6ObjectE
	.long	-1945606160
.global fujara_screen_asset;
	.align 4
	.type	fujara_screen_asset, @object
	.size	fujara_screen_asset, 11
fujara_screen_asset:
	.string	"fujara.svg"
.global fujara_screen_state;
	.section	.bss,"aw",@nobits
	.align 4
	.type	fujara_screen_state, @object
	.size	fujara_screen_state, 220
fujara_screen_state:
	.zero	220
	.section	.rodata.str1.4
	.align 4
.LC3:
	.string	"fujara_node_1"
	.align 4
.LC4:
	.string	"fujara_node_2"
	.align 4
.LC5:
	.string	"fujara_node_3"
	.align 4
.LC6:
	.string	"fujara_node_4"
	.align 4
.LC7:
	.string	"fujara_node_5"
	.align 4
.LC8:
	.string	"fujara_node_6"
	.align 4
.LC9:
	.string	"fujara_node_7"
	.align 4
.LC10:
	.string	"fujara_node_8"
	.align 4
.LC11:
	.string	"fujara_node_9"
	.align 4
.LC12:
	.string	"fujara_palette_1"
	.align 4
.LC13:
	.string	"fujara_palette_2"
	.align 4
.LC14:
	.string	"fujara_palette_3"
	.align 4
.LC15:
	.string	"fujara_palette_4"
	.align 4
.LC16:
	.string	"fujara_palette_5"
	.align 4
.LC17:
	.string	"fujara_palette_6"
	.align 4
.LC18:
	.string	"fujara_palette_7"
	.align 4
.LC19:
	.string	"fujara_palette_8"
	.align 4
.LC20:
	.string	"fujara_palette_9"
	.align 4
.LC21:
	.string	"fujara_palette_10"
	.align 4
.LC22:
	.string	"fujara_palette_11"
	.align 4
.LC23:
	.string	"fujara_palette_12"
	.align 4
.LC24:
	.string	"fujara_palette_13"
	.align 4
.LC25:
	.string	"fujara_palette_14"
	.align 4
.LC26:
	.string	"fujara_palette_15"
	.section	.rodata
	.align 4
	.type	__ZN12_GLOBAL__N_17Machine3idsE, @object
	.size	__ZN12_GLOBAL__N_17Machine3idsE, 104
__ZN12_GLOBAL__N_17Machine3idsE:
	.long	.LC1
	.long	.LC3
	.long	.LC4
	.long	.LC5
	.long	.LC6
	.long	.LC7
	.long	.LC8
	.long	.LC9
	.long	.LC10
	.long	.LC11
	.long	.LC2
	.long	.LC12
	.long	.LC13
	.long	.LC14
	.long	.LC15
	.long	.LC16
	.long	.LC17
	.long	.LC18
	.long	.LC19
	.long	.LC20
	.long	.LC21
	.long	.LC22
	.long	.LC23
	.long	.LC24
	.long	.LC25
	.long	.LC26
	.local	__ZN4opxy6screen12_GLOBAL__N_113display_frameE
	.comm	__ZN4opxy6screen12_GLOBAL__N_113display_frameE,864,4
	.local	__ZN4opxy6screen12_GLOBAL__N_113display_inputE
	.comm	__ZN4opxy6screen12_GLOBAL__N_113display_inputE,76,4
	.local	__ZN4opxy6screen12_GLOBAL__N_118display_activationE
	.comm	__ZN4opxy6screen12_GLOBAL__N_118display_activationE,4,4
	.local	__ZN4opxy6screen12_GLOBAL__N_113display_stateE
	.comm	__ZN4opxy6screen12_GLOBAL__N_113display_stateE,40,4
	.ident	"GCC: (GNU) 8.0.0 20171013 (experimental)"
