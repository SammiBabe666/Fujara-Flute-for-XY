.file "display_binding.cpp";
.text;
	.align 4
.global _fujara_display_reset;
.type _fujara_display_reset, STT_FUNC;
_fujara_display_reset:
	P2 = R0;
	R2 = 0 (X);
	[P2] = R2;
	[P2+24] = R2;
	[P2+20] = R2;
	[P2+16] = R2;
	[P2+32] = R2;
	[P2+28] = R2;
	[P2+36] = R2;
	P2 = R1;
	[P2] = R2;
	rts;
	.size	_fujara_display_reset, .-_fujara_display_reset
.global ___divsi3;
.global ___modsi3;
.global ___udivsi3;
	.align 4
.global _fujara_display_render;
.type _fujara_display_render, STT_FUNC;
_fujara_display_render:
	P2 = R1;
	[--sp] = ( r7:4, p5:3 );

	LINK 120;
	[SP+156] = R0;
	[SP+164] = R2;
	R0 = 102 (X);
	R5 = [P2+16];
	R1 = [P2+68];
	R2 = 128 (X);
	R5 = min(R5,R0) ||
	R4 = [P2+28] ||
	nop;
	R0 = 0 (X);
	cc =R1<=R2 (iu);
	R5 = max(R5,R0);
	if !cc jump 4; jump.s .L4;
	P0 = [SP+156];
	[P0] = R0;
.L5:
	R1 = [P2+36];
	R6 = [P2+68];
	cc =R1<0;
	R6 += -1;
	if !cc jump 4 (bp); jump.s .L55;
	R0 = R1 >>> 16;
	P0 = R0;
	R7 = 9000 (X);
	R1 >>>= 25;
	R1 <<= 8;
	R1 += 1;
	P0 = P0 + (P0 << 1);
	R3 = P0;
	R2 = R3 >>> 14 ||
	[SP+40] = R1 ||
	nop;
	R2 += 6;
	[SP+60] = R2;
	R2 = 23767 (X);
	R2 *= R0;
	R2 >>>= 15;
	R7 = R2 + R7;
	R2 = 29167 (X);
	R2 *= R0;
	[SP+64] = R7;
	R2 >>>= 15;
	R7 = 3600 (X);
	R7 = R2 + R7;
	R3 >>>= 9;
	[SP+48] = R7;
	[SP+68] = R3;
.L6:
	R1 = [P2+40];
	cc =R1<0;
	if !cc jump 4 (bp); jump.s .L56;
	R1 >>>= 16;
	R2 = 20767 (X);
	R2 *= R1;
	R3 = 12000 (X);
	R2 >>>= 15;
	R3 = R2 + R3;
	R2 = 5000 (X);
	R1 *= R2;
	R2 = 11585 (X);
	R1 >>>= 15;
	R2 = R1 + R2;
	[SP+72] = R3;
	[SP+52] = R2;
.L7:
	R7 = [P2+44];
	cc =R7<0;
	if !cc jump 4 (bp); jump.s .L57;
	R7 >>>= 16;
	P0 = R7;
	R2 = 512 (X);
	P0 = P0 + (P0 << 2);
	R1 = P0;
	R1 >>>= 7;
	R2 = R1 + R2;
	R1 = -200 (X);
	R1 *= R7;
	cc =R1<0;
	[SP+76] = R2;
	if !cc jump 4 (bp); jump.s .L76;
.L9:
	R1 >>>= 15;
	R2 = 460 (X);
	R2 = R1 + R2;
	R1 = 19000 (X);
	R1 *= R7;
	[SP+80] = R2;
	R1 >>>= 15;
	R2 = 32767 (X);
	R1 = R2 - R1;
	[SP+44] = R1;
	R1 = 17000 (X);
	R1 *= R7;
	R1 >>>= 15;
	R1 = R2 - R1;
	[SP+56] = R1;
	R1 = 22000 (X);
	R7 *= R1;
	R7 >>>= 15;
	[SP+84] = R7;
.L8:
	R1 = [P2+48];
	cc =R1<0;
	if !cc jump 4 (bp); jump.s .L58;
	R7 = [SP+40];
	R3 = R1 >>> 16;
	R1 >>>= 25;
	R7 = R7 + R1;
	[SP+40] = R7;
.L10:
	P0 = [SP+156];
	R1 = [P0+20];
	cc =R1==0;
	if cc jump .L11 (bp);
	R2 = [P0+24];
	R1 = [P2+20];
	cc =R2==R1;
	if !cc jump 4 (bp); jump.s .L12;
.L11:
	R1 = 1 (X);
	R7 = 128 (X);
	R2 = 0 (X);
	P1 = [SP+156];
	cc =R6<R7 (iu);
	[P1+20] = R1;
	R1 = [P2+20];
	[P1+24] = R1;
	R1 = [P2+24];
	[P1+16] = R1;
	R1 = 1024 (X);
	if cc R7 = R1; if !cc R7 = R2;
	[P1+28] = R2;
	R2 = 127 (X);
	cc =R6<=R2 (iu);
	[P1+32] = R7;
	if !cc jump 4; jump.s .L14;
.L15:
	cc =R4==0;
	R1 = R5 << 2;
	if !cc jump 4 (bp); jump.s .L75;
.L22:
	R1 = 0 (X);
	P0 = [SP+156];
	[P0+32] = R1;
.L27:
	R2 = [SP+40];
	P1 = [SP+156];
	R1 = [P1+36];
	cc =R1==R2;
	if !cc jump .L28;
	nop;
	nop;
	P0 = [SP+164];
	R1 = [P0];
	cc =R1==R2;
	if cc jump .L29;
.L28:
	R0 >>>= 9;
	R0 <<= 9;
	P1 = R0;
	R2 = 1024 (X);
	P4 = [SP+164];
	P0 = [SP+164];
	P5 = 508 (X);
	P1 = P1 + (P1 << 1);
	R1 = P1;
	R1 <<= 3;
	R1 = R1 - R0;
	R1 >>>= 14;
	R1 += 14;
	R1 <<= 10;
	[SP+24] = R1;
	R1 = R3 >>> 9;
	R1 <<= 9;
	P2 = R1;
	P4 += 4;
	P5 = P0 + P5;
	P3 = 0 (X);
	R4 = 5400 (X);
	P2 = P2 + (P2 << 2);
	R1 = P2;
	R1 >>>= 5;
	R2 = R1 + R2;
	R1 = 1228 (X);
	R0 *= R1;
	R1 = 1536 (X);
	R0 >>>= 15;
	R1 = R0 + R1;
	[SP+32] = R1;
	R1 = [SP+24];
	R1 = -R1;
	FP = R1;
	R1 = 1229 (X);
	R1 = R0 + R1;
	[SP+28] = R2;
	R2 = 1 (X);
	[SP+36] = R1;
	R6 = R6 -|- R6 ||
	[SP+20] = R2 ||
	nop;
	R0 = 0 (X);
	R5 = 0 (X);
	R7 = FP;
	jump.s .L30;
.L34:
	R0 = R7;
	R1 = 31 (X);
	call ___divsi3;
	R5 = R0;
	R1 = 31 (X);
	R0 = R4;
	call ___divsi3;
	R1 = 3600 (X);
	call ___modsi3;
	R1 = 1799 (X);
	cc =R0<=R1;
	P0 = -1 (X);
	R2 = 1 (X);
	if !cc R2 = P0;
	P0 = [SP+36];
	[SP+20] = R2;
	R1 = 5400 (X);
	R2 = [SP+24];
	R7 = R7 - R2;
	R4 = R4 + R1;
	P3 = P3 + P0;
	P4 += 8;
	P5 += -8;
.L30:
	R1 = 1800 (X);
	call ___modsi3;
	FP = R0;
	P1 = 900 (X);
	cc =FP<=P1;
	if cc jump .L32 (bp);
	P2 = 1800 (X);
	P2 -= FP;
	FP = P2;
.L32:
	R0 = FP;
	R1 = 10 (X);
	call ___divsi3;
	P0 = R0;
	R1 = 89 (X);
	P1.H = __ZN4opxy4drawL8sine_q10E;
	P1.L = __ZN4opxy4drawL8sine_q10E;
	R0 = min(R0,R1);
	P2 = P1 + (P0 << 1);
	P0 = R0;
	R3 = W [P2] (Z);
	R1 = 10 (X);
	R0 = FP;
	[SP+12] = R3;
	P2 = P1 + (P0 << 1);
	R2 = W [P2+2] (Z);
	R2 = R2 - R3;
	[SP+16] = R2;
	call ___modsi3;
	R2 = [SP+16];
	R0 *= R2;
	R1 = 10 (X);
	call ___divsi3;
	R3 = [SP+12];
	R2 = [SP+20];
	R0 = R0 + R3;
	R0 *= R2;
	R2 = [SP+28];
	R0 *= R2;
	cc =R0<0;
	if !cc jump .L33 (bp);
	R1 = 1023 (X);
	R0 = R0 + R1;
.L33:
	R0 >>>= 10;
	R0 *= R6;
	R1 = 31 (X);
	call ___divsi3;
	FP = R0;
	R1 = -31 (X);
	R0 = P3;
	R6 += 1;
	call ___divsi3;
	R2 = [SP+32];
	R0 = R0 + R2;
	R2 = FP;
	R1 = R2 - R0;
	R0 = R2 + R0;
	[P4] = R1;
	[P4+4] = R5;
	[P5] = R0;
	R0 = 32 (X);
	cc =R6==R0;
	[P5+4] = R5;
	if !cc jump .L34 (bp);
	P0 = [SP+164];
	P1 = [SP+156];
	R2 = [SP+40];
	[P0] = R2;
	[P1+36] = R2;
.L29:
	P1 = [SP+164];
	P0 = [SP+156];
	R0 = 107 (X);
	R0 <<= 11;
	R2 = [P0+32];
	[P1+516] = R0;
	R0 = 119 (X);
	R0 <<= 10;
	[SP+20] = R2;
	[P1+520] = R0;
	R0 = 1024 (X);
	R2 <<= 1;
	[P1+524] = R0;
	[P1+528] = R0;
	R7 = [SP+20];
	R0 = R0 -|- R0 ||
	[SP+28] = R2 ||
	nop;
	[P1+532] = R0;
	R0 = R2 + R7;
	cc =R0<0;
	if !cc jump .L35 (bp);
	R1 = 1023 (X);
	R0 = R0 + R1;
.L35:
	R2 = [SP+60];
	P0 = [SP+164];
	R0 >>>= 10;
	R0 = R0 + R2;
	R1 = 15 (X);
	P1 = [SP+156];
	R0 = min(R0,R1);
	R1 = 0 (X);
	R0 = max(R0,R1);
	[P0+536] = R0;
	R0 = 1 (X);
	[P0+540] = R0;
	R2 = [SP+64];
	R0 = [P1+28];
	R0 *= R2;
	cc =R0<0;
	if !cc jump .L36 (bp);
	R1 = 1023 (X);
	R0 = R0 + R1;
.L36:
	R0 >>>= 10;
	P0 = R0;
	P0 = P0 + (P0 << 1);
	R1 = P0;
	R1 <<= 8;
	cc =R1<0;
	if !cc jump .L37 (bp);
	R2 = 32767 (X);
	R1 = R1 + R2;
.L37:
	R6 = R1 >>> 15;
	R2 = [SP+68];
	R6 = R6 + R2;
	P0 = R6;
	R1 = 20000 (X);
	P2 = [SP+76];
	R0 *= R1;
	cc =R0<0;
	P1 = P0 + P2;
	if !cc jump .L38 (bp);
	R1 = 32767 (X);
	R0 = R0 + R1;
.L38:
	R0 >>>= 15;
	R2 = [SP+84];
	R7 = R0 + R2;
	R0 = 32767 (X);
	R7 = min(R7,R0);
	[SP+24] = R7;
	R5 = [SP+72];
	R7 = [SP+56];
	R5 *= R7;
	P0 = 88 (X);
	R6 = 256 (X);
	R1 = P1;
	R6 = R6 - R1;
	P5 = SP + P0;
	R7 = R7 -|- R7 ||
	[SP+32] = P5 ||
	nop;
	P4.H = __ZN6fujara7voicingL7rolloffE;
	FP = R6;
	R5 >>>= 15;
	P3 = R0;
	P4.L = __ZN6fujara7voicingL7rolloffE;
	R4 = [SP+80];
	R6 = R7;
	jump.s .L39;
.L77:
	[P5] = R5;
.L41:
	R6 += 1;
	P5 += 4;
.L39:
	cc =R6==0;
	if cc jump .L77 (bp);
	cc =R6==1;
	if cc jump .L63;
	P0 = R6;
	R2 = [SP+48];
	P1 = P4 + (P0 << 2);
	R0 = [P1];
	R0 *= R2;
	cc =R0<0;
	if !cc jump .L43 (bp);
	R7 = P3;
	R0 = R0 + R7;
.L43:
	R7 = R0 >>> 15;
.L42:
	R0 = R6 << 8;
	R1 = FP;
	R0 = R1 + R0;
	R0 = abs R0;
	R0 = R4 - R0;
	cc =R0<=0;
	if cc jump .L64;
	R1 = R0 << 15;
	R0 = R1 - R0;
	R1 = R4;
	call ___divsi3;
	R2 = [SP+24];
	R0 *= R2;
	cc =R0<0;
	if !cc jump .L45 (bp);
	R1 = P3;
	R0 = R0 + R1;
.L45:
	R0 >>>= 15;
	R2 = 30000 (X);
	R0 *= R2;
	cc =R0<0;
	if !cc jump .L46 (bp);
	R1 = P3;
	R0 = R0 + R1;
.L46:
	R1 = R0 >>> 15;
.L44:
	R0 = [SP+44];
	R0 *= R7;
	cc =R0<0;
	if !cc jump .L47 (bp);
	R2 = P3;
	R0 = R0 + R2;
.L47:
	R0 >>>= 15;
	R7 = 7 (X);
	R0 = R0 + R1;
	cc =R6==R7;
	[P5] = R0;
	if !cc jump .L41 (bp);
	P5 = [SP+32];
	R6 = 1 (X);
	P2 = 8 (X);
	P1 = P5;
	LSETUP (.L48, .L80) LC1 = P2;
.L48:
	R0 = [P1++];
.L80:
	R6 = max(R6,R0);
	P0 = [SP+164];
	P1 = 544 (X);
	P3.H = 2;
	P3.L = 37888;
	P4 = P0 + P1;
	R4 = 1024 (X);
	R5 = 0 (X);
	R7 = 22528 (X);
.L50:
	R1 = R6;
	R0 = [P5++];
	R0 <<= 6;
	call ___divsi3;
	FP = R0;
	P1.H = 3;
	P1.L = 4096;
	[P4+4] = P1;
	[P4] = P3;
	R0 <<= 10;
	R1 = 96 (X);
	call ___divsi3;
	P0 = R0;
	FP = FP + (FP << 1);
	R0 = FP;
	P1 = 576 (X);
	R0 <<= 2;
	P2 = P0 + P1;
	cc =R0<0;
	[P4+8] = P2;
	[P4+12] = R4;
	[P4+16] = R5;
	if !cc jump .L49 (bp);
	R0 += 63;
.L49:
	P0 = R7;
	P1.H = 5;
	R0 >>>= 6;
	P1.L = 21504;
	R0 += 3;
	P3 = P3 + P0;
	P2 = 2 (X);
	cc =P3==P1;
	[P4+20] = R0;
	[P4+24] = P2;
	P4 += 28;
	if !cc jump .L50 (bp);
	P2 = [SP+164];
	R0 = 429 (X);
	R0 <<= 9;
	R2 = [SP+20];
	[P2+768] = R0;
	R0 = 31 (X);
	R0 <<= 12;
	[P2+772] = R0;
	R0 = 409 (X);
	R0 *= R2;
	cc =R0<0;
	if !cc jump .L51 (bp);
	R1 = 1023 (X);
	R0 = R0 + R1;
.L51:
	R0 >>>= 10;
	P0 = [SP+164];
	R1 = 1024 (X);
	R0 = R0 + R1;
	R2 = [SP+20];
	[P0+776] = R0;
	R0 = 0 (X);
	[P0+784] = R0;
	R0 = [SP+28];
	R0 = (R0 + R2) << 2;
	R0 = R0 + R2;
	cc =R0<0;
	[P0+780] = R1;
	if !cc jump .L52 (bp);
	R1 = 1023 (X);
	R0 = R0 + R1;
.L52:
	R0 >>>= 10;
	P0 = [SP+164];
	R0 += 2;
	SP += 60;
	SP += 60;
	[P0+788] = R0;
	R0 = 2 (X);
	[P0+792] = R0;
	R0 = 0 (X);
	B [P0+832] = R0;
	B [P0+840] = R0;
	B [P0+848] = R0;
	B [P0+856] = R0;
	FP = [SP++];
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	rts;
.L4:
	R0 = 1 (X);
	P1 = [SP+156];
	[P1] = R0;
	R0 = [P2+20];
	[P1+4] = R0;
	R0 = [P2+68];
	[P1+8] = R0;
	R0 = [P2+72];
	[P1+12] = R0;
	jump.s .L5;
.L14:
	cc =R4==0;
	if cc jump .L61;
.L54:
	R1 = 1024 (X);
	P0 = [SP+156];
	[P0+32] = R1;
.L24:
	R7 = 127 (X);
	cc =R6<=R7 (iu);
	if cc jump 4; jump.s .L27;
	P0 = [SP+156];
	R1 = 1024 (X);
	[P0+32] = R1;
	jump.s .L27;
.L76:
	R2 = 32767 (X);
	R1 = R1 + R2;
	jump.s .L9;
.L64:
	R1 = 0 (X);
	jump.s .L44;
.L63:
	R7 = [SP+52];
	jump.s .L42;
.L58:
	R3 = 0 (X);
	jump.s .L10;
.L57:
	R2 = 0 (X);
	R7 = 32767 (X);
	[SP+84] = R2;
	P1 = 512 (X);
	R2 = 460 (X);
	[SP+56] = R7;
	[SP+76] = P1;
	[SP+44] = R7;
	[SP+80] = R2;
	jump.s .L8;
.L56:
	P0 = 11585 (X);
	R2 = 12000 (X);
	[SP+52] = P0;
	[SP+72] = R2;
	jump.s .L7;
.L55:
	R2 = 1 (X);
	R7 = R7 -|- R7 ||
	[SP+40] = R2 ||
	nop;
	R2 = 3600 (X);
	[SP+68] = R7;
	[SP+48] = R2;
	R7 = 9000 (X);
	R2 = 6 (X);
	[SP+64] = R7;
	[SP+60] = R2;
	R0 = 0 (X);
	jump.s .L6;
.L75:
	R2 = 0 (X);
.L23:
	R5 = (R5 + R1) << 2;
	R4 = 1024 (X);
	R4 = min(R5,R4);
.L53:
	P1 = [SP+156];
	R7 = [P1+32];
	R1 = R2 - R7;
	R1 *= R4;
	cc =R1<0;
	if !cc jump .L25 (bp);
	R2 = 1023 (X);
	R1 = R1 + R2;
.L25:
	R1 >>>= 10;
	P2 = [SP+156];
	R1 = R1 + R7;
	R2 = 7 (X);
	cc =R1<=R2;
	[P2+32] = R1;
	if cc jump .L78;
	R2 = 1016 (X);
	cc =R1<=R2;
	if !cc jump 4; jump.s .L27;
	jump.s .L24;
.L12:
	P0 = [SP+156];
	R1 = [P2+24];
	R2 = [P0+16];
	cc =R2==R1;
	if cc jump .L16;
	[P0+16] = R1;
	cc =R4==0;
	R1 = 0 (X);
	R2 = 1024 (X);
	if cc R1 = R2;
	[P0+28] = R1;
.L16:
	cc =R4==0;
	if !cc jump .L18;
	R1 = R5 << 2;
	R4 = R1;
	R2 = 1024 (X);
	P1 = [SP+156];
	R4 = (R4 + R5) << 2;
	R4 = min(R4,R2);
	R2 = R2 - R4;
	R7 = [P1+28];
	R2 *= R7;
	cc =R2<0;
	R7 = R2;
	if !cc jump .L19 (bp);
	R7 = 1023 (X);
	R7 = R2 + R7;
.L19:
	R7 >>>= 10;
	P2 = [SP+156];
	[P2+28] = R7;
	R7 = 16383 (X);
	cc =R2<=R7;
	if cc jump .L79;
	R2 = 127 (X);
	cc =R6<=R2 (iu);
	if !cc jump .L75 (bp);
	R2 = 1024 (X);
	jump.s .L53;
.L61:
	R2 = R1;
	R1 = R5 << 2;
	jump.s .L23;
.L78:
	R7 = 127 (X);
	cc =R6<=R7 (iu);
	if !cc jump 4; jump.s .L27;
	jump.s .L22;
.L18:
	P0 = [SP+156];
	R1 = 0 (X);
	[P0+28] = R1;
	R1 = 127 (X);
	cc =R6<=R1 (iu);
	if cc jump .L54 (bp);
	jump.s .L15;
.L79:
	P0 = [SP+156];
	R2 = 0 (X);
	[P0+28] = R2;
	R2 = 127 (X);
	cc =R6<=R2 (iu);
	if !cc jump .L75 (bp);
	R2 = 1024 (X);
	jump.s .L23;
	.size	_fujara_display_render, .-_fujara_display_render
	.align 4
.global _fujara_display_validate;
.type _fujara_display_validate, STT_FUNC;
_fujara_display_validate:
	[--sp] = ( r7:6, p5:3 );

	P5 = R0;
	R0 = [P5];
	cc =R0==0;
	if cc jump .L101;
	P2 = P5;
	R2 = 1 (X);
	P2 += 4;
	R2 <<= 16;
	P1 = 64 (X);
	LSETUP (.L84, .L114) LC1 = P1;
.L84:
	R0 = 1 (X);
	R1 = [P2];
	R1 = R1 + R2;
	R0 <<= 17;
	cc =R1<=R0 (iu);
	if !cc jump .L101;
	nop;
	nop;
	nop;
	R1 = [P2+4];
	R1 = R1 + R2;
	cc =R1<=R0 (iu);
	if !cc jump .L101;
.L114:
	P2 += 8;
	P1 = 516 (X);
	R7 = 1 (X);
	M0.H = 65521;
	P1 = P5 + P1;
	R7 <<= 16;
	R6 = 1024 (X);
	M0.L = 0;
	P0 = 10 (X);
	LSETUP (.L88, .L113) LC1 = P0;
.L88:
	R0 = 11 (X);
	R1 = [P1];
	R1 = R1 + R7;
	R0 <<= 16;
	cc =R1<=R0 (iu);
	R2 = [P1+4];
	R3 = [P1+8];
	if !cc jump .L101;
	R1 = 3 (X);
	R2 = R2 + R7;
	R1 <<= 17;
	cc =R2<=R1 (iu);
	if !cc jump .L101;
	R3 += -1;
	R0 = 2047 (X);
	cc =R3<=R0 (iu);
	if !cc jump .L101;
	nop;
	nop;
	R0 = 2048 (X);
	R1 = [P1+12];
	R3 = R1 + R6;
	cc =R3<=R0 (iu);
	R2 = [P1+16];
	if !cc jump .L101;
	R0 = R2 + R6;
	R3 = 2048 (X);
	cc =R0<=R3 (iu);
	if !cc jump .L101;
	R1 *= R1;
	R2 *= R2;
	R1 = R1 + R2;
	P3 = R1;
	P4 = M0;
	P2 = P3 + P4;
	P3.H = 2;
	P3.L = 0;
	cc =P2<=P3 (iu);
	if !cc jump .L101;
	nop;
	nop;
	R1 = 15 (X);
	R0 = [P1+20];
	cc =R0<=R1 (iu);
	if !cc jump .L101;
	nop;
	nop;
	nop;
	R0 = [P1+24];
	cc =R0<=2 (iu);
	if !cc jump .L101;
.L113:
	P1 += 28;
	R0 = 840 (X);
	P2 = R0;
	P0 = 4 (X);
	P5 = P5 + P2;
	LSETUP (.L89, .L112) LC0 = P0;
.L89:
	P1 = P5;
	P1 += -8;
	P2 = 8 (X);
	LSETUP (.L86, .L111) LC1 = P2;
.L86:
	R0 = B [P1++] (X);
	cc =R0==0;
	if cc jump .L85;
.L111:
	nop;
.L101:
	R0 = 0 (X);
	( r7:6, p5:3 ) = [sp++];

	rts;
.L85:
.L112:
	P5 += 8;
	R0 = 1 (X);
	( r7:6, p5:3 ) = [sp++];

	rts;
	.size	_fujara_display_validate, .-_fujara_display_validate
	.section	.rodata
	.align 4
	.type	__ZN6fujara7voicingL7rolloffE, @object
	.size	__ZN6fujara7voicingL7rolloffE, 32
__ZN6fujara7voicingL7rolloffE:
	.long	32767
	.long	11585
	.long	6306
	.long	4096
	.long	2931
	.long	2229
	.long	1769
	.long	1448
	.align 2
	.type	__ZN4opxy4drawL8sine_q10E, @object
	.size	__ZN4opxy4drawL8sine_q10E, 182
__ZN4opxy4drawL8sine_q10E:
	.short	0
	.short	18
	.short	36
	.short	54
	.short	71
	.short	89
	.short	107
	.short	125
	.short	143
	.short	160
	.short	178
	.short	195
	.short	213
	.short	230
	.short	248
	.short	265
	.short	282
	.short	299
	.short	316
	.short	333
	.short	350
	.short	367
	.short	384
	.short	400
	.short	416
	.short	433
	.short	449
	.short	465
	.short	481
	.short	496
	.short	512
	.short	527
	.short	543
	.short	558
	.short	573
	.short	587
	.short	602
	.short	616
	.short	630
	.short	644
	.short	658
	.short	672
	.short	685
	.short	698
	.short	711
	.short	724
	.short	737
	.short	749
	.short	761
	.short	773
	.short	784
	.short	796
	.short	807
	.short	818
	.short	828
	.short	839
	.short	849
	.short	859
	.short	868
	.short	878
	.short	887
	.short	896
	.short	904
	.short	912
	.short	920
	.short	928
	.short	935
	.short	943
	.short	949
	.short	956
	.short	962
	.short	968
	.short	974
	.short	979
	.short	984
	.short	989
	.short	994
	.short	998
	.short	1002
	.short	1005
	.short	1008
	.short	1011
	.short	1014
	.short	1016
	.short	1018
	.short	1020
	.short	1022
	.short	1023
	.short	1023
	.short	1024
	.short	1024
	.ident	"GCC: (GNU) 8.0.0 20171013 (experimental)"
