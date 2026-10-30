.file "voice.cpp";
	.section	.text._ZN6fujara12_GLOBAL__N_17partialEPlmmlll,"axG",@progbits,_ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm,comdat
	.align 4
.type __ZN6fujara12_GLOBAL__N_17partialEPlmmlll, STT_FUNC;
__ZN6fujara12_GLOBAL__N_17partialEPlmmlll:
	[--sp] = ( r7:4 );

	P0 = [SP+28];
	R7 = [SP+32];
	R4 = [SP+36];
	P2 = R0;
	R5 = 32767 (X);
	P1 = 64 (X);
	LSETUP (.L2, .L5) LC1 = P1;
.L2:
	R6 = R1 >>> 16;
	R0 = R1 >>> 31;
	R0 = R0 ^ R6;
	R3 = R5 - R0;
	R3 *= R6;
	R3 >>>= 13;
	R3 *= R7;
	R0 = [P2];
	R3 = R3 + R0;
	R0 = P0;
	R1 = R1 + R2;
	[P2++] = R3;
	R7 = R7 + R4;
.L5:
	R2 = R2 + R0;
	( r7:4 ) = [sp++];

	rts;
	.size	__ZN6fujara12_GLOBAL__N_17partialEPlmmlll, .-__ZN6fujara12_GLOBAL__N_17partialEPlmmlll
	.section	.text._ZN6fujara12_GLOBAL__N_114steady_partialEPlmmll,"axG",@progbits,_ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm,comdat
	.align 4
.type __ZN6fujara12_GLOBAL__N_114steady_partialEPlmmll, STT_FUNC;
__ZN6fujara12_GLOBAL__N_114steady_partialEPlmmll:
	[--sp] = ( r7:4 );

	R7 = [SP+28];
	R4 = [SP+32];
	P2 = R0;
	R5 = 32767 (X);
	P1 = 64 (X);
	LSETUP (.L7, .L9) LC1 = P1;
.L7:
	R6 = R1 >>> 16;
	R0 = R1 >>> 31;
	R0 = R0 ^ R6;
	R3 = R5 - R0;
	R3 *= R6;
	R3 >>>= 13;
	R3 *= R7;
	R0 = [P2];
	R3 = R3 + R0;
	[P2++] = R3;
	R7 = R7 + R4;
.L9:
	R1 = R1 + R2;
	( r7:4 ) = [sp++];

	rts;
	.size	__ZN6fujara12_GLOBAL__N_114steady_partialEPlmmll, .-__ZN6fujara12_GLOBAL__N_114steady_partialEPlmmll
.text;
	.align 4
.type _zero, STT_FUNC;
_zero:
	R0 = 0 (X);
	rts;
	.size	_zero, .-_zero
	.align 4
.type _noop, STT_FUNC;
_noop:
	rts;
	.size	_noop, .-_noop
	.align 4
.type __ZL5endedR4Slotm, STT_FUNC;
__ZL5endedR4Slotm:
	P1 = R0;
	P2 = [P1+2152];
	cc =P2==0;
	if cc jump .L13 (bp);
	P0.H = __ZL6blocks;
	P0.L = __ZL6blocks;
	R0 = W [P0] (X);
	P2 += -1;
	P0.H = __ZL7handles;
	P2 = P2 + (P2 << 1);
	P0.L = __ZL7handles;
	P2 = P0 + (P2 << 2);
	R2 = W [P2+4] (X);
	R2 = R0 - R2;
	R2 = R2.L (Z);
	cc =R2<=2 (iu);
	if cc jump .L19 (bp);
	R2 = W [P2+6] (X);
	R0 = R0 - R2;
	R0 = R0.L (Z);
	cc =R0<=2 (iu);
	if cc jump .L19 (bp);
	R0 = 0 (X);
	[P1+2152] = R0;
.L13:
	P2.H = __ZL7counted;
	P2.L = __ZL7counted;
	R0 = [P2];
	R0 = R1 - R0;
	R2 = 60 (X);
	cc =R0<=R2 (iu);
	if cc jump .L15 (bp);
	R0 = [P1+2148];
	R1 = R1 - R0;
	cc =R1<=R2 (iu);
	if cc jump .L15 (bp);
	R0 = 1 (X);
	rts;
.L15:
	P2.H = __ZL6blocks;
	P2.L = __ZL6blocks;
	R1 = W [P2] (X);
	P2 = [P1+2144];
	P0.H = __ZL7handles;
	P0.L = __ZL7handles;
	P2 += -1;
	P2 = P2 + (P2 << 1);
	P2 = P0 + (P2 << 2);
	R0 = W [P2+4] (X);
	R0 = R1 - R0;
	R0 = R0.L (Z);
	cc =R0<=2 (iu);
	if !cc jump .L23 (bp);
.L19:
	R0 = 0 (X);
	rts;
.L23:
	nop;
	R0 = W [P1+2156] (X);
	R1 = R1 - R0;
	R1 = R1.L (X);
	cc =R1<=2 (iu);
	R0 = CC;
	BITTGL (R0, 0);
	rts;
	.size	__ZL5endedR4Slotm, .-__ZL5endedR4Slotm
	.align 4
.type __ZL5beginR4SlotP6Handlem, STT_FUNC;
__ZL5beginR4SlotP6Handlem:
	[--sp] = ( r7:6, p5:5 );

	R7.H = __ZL7handles;
	R7.L = __ZL7handles;
	P5 = R0;
	R7 = R1 - R7;
	R0.H = 43690;
	R7 >>>= 2;
	R0.L = 43691;
	R7 *= R0;
	P2 = 2144 (X);
	R7 += 1;
	P1 = P5;
	P0 = P5 + P2;
	R3 = 0 (X);
	LSETUP (.L25, .L29) LC1 = P2;
.L25:
.L29:
	B [P1++] = R3;
	P2.H = __ZL6blocks;
	P2.L = __ZL6blocks;
	R6 = W [P2] (X);
	[P5+2148] = R2;
	R2.H = __ZL6voices;
	W [P5+2156] = R6;
	R2.L = __ZL6voices;
	R6 = P5;
	R2 = R6 - R2;
	R6.H = 57768;
	P2 = R1;
	R2 >>>= 4;
	R6.L = 50487;
	R1.H = 40503;
	R2 *= R6;
	R1.L = 31161;
	R1 *= R7;
	R0 = 0 (X);
	R2 += 1;
	[P5+2144] = R7;
	[P5+2152] = R0;
	B [P2+8] = R2;
	B [P2+9] = R3;
	[P5] = R1;
	R1.H = 40503;
	R1.L = 31153;
	R7 *= R1;
	P2 = 96 (X);
	BITSET (R7, 0);
	[P5+4] = R7;
	[P5+8] = R0;
	[P5+16] = R0;
	[P5+20] = R0;
	[P5+24] = R0;
	[P5+28] = R0;
	[P5+32] = R0;
	[P5+36] = R0;
	[P5+40] = R0;
	[P5+44] = R0;
	[P5+48] = R0;
	[P5+52] = R0;
	[P5+56] = R0;
	[P5+60] = R0;
	[P5+64] = R0;
	[P5+76] = R0;
	[P5+72] = R0;
	[P5+68] = R0;
	[P5+92] = R0;
	[P5+88] = R0;
	[P5+84] = R0;
	[P5+80] = R0;
	P2 = P5 + P2;
	R1 = 0 (X);
.L26:
	W [P2++] = R1;
	cc =P2==P0;
	if !cc jump .L26 (bp);
	R0 = 1 (X);
	[P5+12] = R0;
	( r7:6, p5:5 ) = [sp++];

	rts;
	.size	__ZL5beginR4SlotP6Handlem, .-__ZL5beginR4SlotP6Handlem
	.align 4
.type __ZL5sweepm, STT_FUNC;
__ZL5sweepm:
	[--sp] = ( r7:6, p5:3 );

	P5.H = __ZL6voices;
	P5.L = __ZL6voices;
	P4 = 19440 (X);
	P3.H = __ZL7handles;
	LINK 12;
	R7 = R0;
	P4 = P5 + P4;
	R6 = 0 (X);
	P3.L = __ZL7handles;
	FP = 2160 (X);
	jump.s .L34;
.L32:
	P5 = P5 + FP;
	cc =P5==P4;
	if cc jump .L42;
	nop;
	nop;
	nop;
.L34:
	R0 = [P5+2144];
	cc =R0==0;
	if cc jump .L32 (bp);
	R1 = R7;
	R0 = P5;
	call __ZL5endedR4Slotm;
	R0 = R0.B (Z);
	cc =R0==0;
	if cc jump .L32 (bp);
	P2 = [P5+2152];
	[P5+2144] = R6;
	cc =P2==0;
	if cc jump .L32 (bp);
	P2 += -1;
	P2 = P2 + (P2 << 1);
	P2 = P3 + (P2 << 2);
	R2 = R7;
	R1 = P2;
	R0 = P5;
	call __ZL5beginR4SlotP6Handlem;
	jump.s .L32;
.L42:
	SP += 12;
	FP = [SP++];
	RETS = [SP++];
	( r7:6, p5:3 ) = [sp++];

	rts;
	.size	__ZL5sweepm, .-__ZL5sweepm
	.align 4
.type __ZL7acquireP6Handlemb, STT_FUNC;
__ZL7acquireP6Handlemb:
	[--sp] = ( r7:4, p5:3 );

	LINK 20;
	R6 = R2.B (Z);
	FP.H = __ZL6voices;
	FP.L = __ZL6voices;
	P4 = 19440 (X);
	cc =R6==0;
	R4 = R0;
	R7 = R1;
	B [SP+19] = R2;
	P4 = FP + P4;
	P5 = 0 (X);
	R5 = 0 (X);
	R6 = CC;
	P3 = 2160 (X);
	jump.s .L50;
.L77:
	cc =R5==0;
	if cc jump .L75;
.L46:
	FP = FP + P3;
	cc =P4==FP;
	if cc jump .L76;
	nop;
	nop;
.L50:
	P1 = FP;
	R0 = [FP+2144];
	cc =R0==0;
	if cc jump .L44;
	R1 = R7;
	R0 = FP;
	call __ZL5endedR4Slotm;
	R0 = R0.B (Z);
	cc =R0==0;
	if !cc jump .L77 (bp);
	CC = R6;
	if cc jump .L46 (bp);
	cc =P5==0;
	if cc jump .L57;
	nop;
	nop;
	nop;
	R0 = [FP+2152];
	cc =R0==0;
	R2 = [P5+2152];
	R1 = CC;
	cc =R2==0;
	R2 = CC;
	cc =R1==R2;
	R0 = R1;
	if !cc jump .L47 (bp);
	P2.H = __ZL6blocks;
	P2.L = __ZL6blocks;
	R2 = W [P2] (X);
	R0 = W [FP+2156] (X);
	R0 = R2 - R0;
	R1 = W [P5+2156] (X);
	R0 = R0.L (Z);
	R1 = R2 - R1;
	cc =R0<=7 (iu);
	R1 = R1.L (Z);
	R3 = CC;
	cc =R1<=7 (iu);
	P1 = R3;
	R3 = CC;
	P2 = R3;
	cc =P1==P2;
	if cc jump .L48 (bp);
	R0 = P1;
	BITTGL (R0, 0);
.L47:
	cc = !BITTST (R0,0);
	if !cc P5 = FP;
	jump.s .L46;
.L75:
	R5 = FP;
	jump.s .L46;
.L76:
	cc =R5==0;
	if !cc jump .L78;
	P2 = R4;
	R1 = 256 (X);
	R0 = B [SP+19] (Z);
	cc =R0==0;
	W [P2+8] = R1;
	if cc jump .L43;
	nop;
	nop;
	nop;
	P2 = [P5+2152];
	cc =P2==0;
	if !cc jump .L79 (bp);
.L56:
	R0.H = __ZL7handles;
	R0.L = __ZL7handles;
	R0 = R4 - R0;
	R1.H = 43690;
	R1.L = 43691;
	R0 >>>= 2;
	R0 *= R1;
	R2.H = __ZL6voices;
	R0 += 1;
	R1 = P5;
	R2.L = __ZL6voices;
	[P5+2152] = R0;
	R0 = R1 - R2;
	R1.H = 57768;
	P2 = R4;
	R0 >>>= 4;
	R1.L = 50487;
	R0 *= R1;
	R0 += 1;
	B [P2+8] = R0;
	P2.H = __ZL6blocks;
	P2.L = __ZL6blocks;
	R0 = W [P2] (X);
	P2 = R4;
	W [P2+6] = R0;
	R0 = 0 (X);
	B [P2+9] = R0;
.L43:
	SP += 20;
	FP = [SP++];
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	rts;
.L78:
	P1 = R5;
.L44:
	R0 = [P1+2144];
	cc =R0==0;
	if cc jump .L53 (bp);
	P2 = [P1+2152];
	R0 = 0 (X);
	[P1+2144] = R0;
	cc =P2==0;
	if !cc jump .L80;
.L53:
	SP += 20;
	R2 = R7;
	R1 = R4;
	FP = [SP++];
	R0 = P1;
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	jump.l __ZL5beginR4SlotP6Handlem;
.L57:
	P5 = FP;
	jump.s .L46;
.L48:
	P2.H = __ZL7handles;
	P1 = [FP+2144];
	P2.L = __ZL7handles;
	P1 += -1;
	P1 = P1 + (P1 << 1);
	P1 = P2 + (P1 << 2);
	R3 = W [P1+4] (X);
	P1 = [P5+2144];
	R3 = R2 - R3;
	R3 = R3.L (Z);
	P0 = R3;
	P1 += -1;
	P1 = P1 + (P1 << 1);
	P1 = P2 + (P1 << 2);
	R3 = W [P1+4] (X);
	P1 = R3;
	R3 = P1;
	R2 = R2 - R3;
	R2 = R2.L (Z);
	R3 = P0;
	cc =R3==R2;
	if cc jump .L49 (bp);
	cc =R2<R3 (iu);
	R0 = CC;
	cc = !BITTST (R0,0);
	if !cc P5 = FP;
	jump.s .L46;
.L79:
	P2 += -1;
	P1.H = __ZL7handles+8;
	P2 = P2 + (P2 << 1);
	P1.L = __ZL7handles+8;
	P2 = P1 + (P2 << 2);
	W [P2] = R1;
	jump.s .L56;
.L49:
	cc =R1<R0 (iu);
	R0 = CC;
	cc = !BITTST (R0,0);
	if !cc P5 = FP;
	jump.s .L46;
.L80:
	P2 += -1;
	P0.H = __ZL7handles;
	P0.L = __ZL7handles;
	P2 = P2 + (P2 << 1);
	P2 = P0 + (P2 << 2);
	R0 = P1;
	R2 = R7;
	R1 = P2;
	[SP+12] = P1;
	call __ZL5beginR4SlotP6Handlem;
	P1 = [SP+12];
	jump.s .L53;
	.size	__ZL7acquireP6Handlemb, .-__ZL7acquireP6Handlemb
	.align 4
.global _fujara_start;
.type _fujara_start, STT_FUNC;
_fujara_start:
	[--sp] = ( r7:6, p5:5 );

	[--SP] = RETS;
	SP += -12;
	P5 = R0;
	call sdk_voice_ticks;
	P2.H = __ZL7counted;
	P2.L = __ZL7counted;
	R7 = ROT R0 BY 0 ||
	R0 = [P2] ||
	nop;
	R0 = R7 - R0;
	R1 = 60 (X);
	cc =R0<=R1 (iu);
	if !cc jump .L93;
	nop;
	nop;
	nop;
.L82:
	R0 = B [P5+8] (Z);
	cc =R0==0;
	if cc jump .L83 (bp);
	R0 += -1;
	R1 = 2160 (X);
	R1 *= R0;
	R3.H = __ZL6voices;
	R3.L = __ZL6voices;
	R1 = R3 + R1;
	P2 = R1;
	R1.H = __ZL7handles;
	R6 = P5;
	R1.L = __ZL7handles;
	R2 = R6 - R1;
	P1 = [P2+2144];
	R6.H = 43690;
	R2 >>>= 2;
	R6.L = 43691;
	R2 *= R6;
	cc =P1==0;
	R2 += 1;
	if cc jump .L84 (bp);
	R6 = [P2+2152];
	cc =R6==R2;
	if cc jump .L85;
.L84:
	R6 = P1;
	cc =R6==R2;
	if cc jump .L94;
.L83:
	R1 = R7;
	R2 = 1 (X);
	R0 = P5;
	call __ZL7acquireP6Handlemb;
.L85:
	SP += 12;
	RETS = [SP++];
	R0 = 0 (X);
	( r7:6, p5:5 ) = [sp++];

	rts;
.L94:
	R2 = 2160 (X);
	R0 *= R2;
	R3 = R3 + R0;
	P2 = R3;
	R0 = [P2+2152];
	cc =R0==0;
	if cc jump .L95;
	P1 = 2144 (X);
	P1 = P2 + P1;
	R2 = 0 (X);
	[P1] = R2;
	P1 = R0;
	P0 = R1;
	R2 = R7;
	R0 = R3;
	P1 += -1;
	P1 = P1 + (P1 << 1);
	P1 = P0 + (P1 << 2);
	R1 = P1;
	call __ZL5beginR4SlotP6Handlem;
	jump.s .L83;
.L93:
	R0 = R7;
	call __ZL5sweepm;
	jump.s .L82;
.L95:
	P1.H = __ZL6blocks;
	P1.L = __ZL6blocks;
	R0 = W [P1] (X);
	W [P2+2156] = R0;
	R0 = 1 (X);
	[P2+2148] = R7;
	[P2+12] = R0;
	jump.s .L85;
	.size	_fujara_start, .-_fujara_start
	.align 4
.type _end, STT_FUNC;
_end:
	[--sp] = ( r7:7, p5:3 );

	P5 = R0;
	[--SP] = RETS;
	SP += -12;
	R0 = B [P5+8] (Z);
	cc =R0==0;
	if cc jump .L98 (bp);
	R1 = 2160 (X);
	R0 += -1;
	R0 *= R1;
	R7.H = __ZL7handles;
	P1 = R0;
	R1 = P5;
	R7.L = __ZL7handles;
	R2 = R1 - R7;
	R1.H = 43690;
	P4.H = __ZL6voices;
	R2 >>>= 2;
	R1.L = 43691;
	P4.L = __ZL6voices;
	R2 *= R1;
	P4 = P4 + P1;
	P3 = 2144 (X);
	P3 = P4 + P3;
	R0 = [P3];
	R2 += 1;
	cc =R0==R2;
	if cc jump .L107;
	cc =R0==0;
	if cc jump .L98 (bp);
	R0 = 2152 (X);
	P2 = R0;
	P4 = P4 + P2;
	R0 = [P4];
	cc =R2==R0;
	if cc jump .L108;
.L98:
	SP += 12;
	R0 = 0 (X);
	W [P5+8] = R0;
	RETS = [SP++];
	( r7:7, p5:3 ) = [sp++];

	rts;
.L107:
	call sdk_voice_ticks;
	P2 = [P4+2152];
	R1 = 0 (X);
	[P3] = R1;
	cc =P2==0;
	if cc jump .L98 (bp);
	P1 = R7;
	P2 += -1;
	P2 = P2 + (P2 << 1);
	R2 = R0;
	R0 = P4;
	P2 = P1 + (P2 << 2);
	R1 = P2;
	call __ZL5beginR4SlotP6Handlem;
	jump.s .L98;
.L108:
	R0 = 0 (X);
	[P4] = R0;
	jump.s .L98;
	.size	_end, .-_end
	.align 4
.global _fujara_destroy;
.type _fujara_destroy, STT_FUNC;
_fujara_destroy:
	[--SP] = RETS;
	SP += -12;
	call _end;
	SP += 12;
	RETS = [SP++];
	R0 = 0 (X);
	rts;
	.size	_fujara_destroy, .-_fujara_destroy
.global ___divsi3;
.global ___udivsi3;
	.section	.text._ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm,"axG",@progbits,_ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm,comdat
	.align 4
	.weak	__ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm
.type __ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm, STT_FUNC;
__ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm:
	P0 = R0;
	[--sp] = ( r7:4, p5:3 );

	LINK 920;
	[SP+956] = R0;
	P1 = [SP+976];
	R1 = [P0+16];
	cc =R1==0;
	P5 = [SP+972];
	P0 += 20;
	R3 = 0 (X);
	R1 = CC;
	P2 = 4 (X);
	LSETUP (.L113, .L196) LC1 = P2;
.L113:
	CC = R1;
	R0 = [P5++];
	R0 = max(R0,R3);
	if cc jump .L111 (bp);
	R2 = [P0];
	R0 = R0 - R2;
	cc =R0<0;
	if !cc jump .L112 (bp);
	R0 += 7;
.L112:
	R0 >>>= 3;
	R0 = R0 + R2;
.L111:
.L196:
	[P0++] = R0;
	P0 = [SP+956];
	R0 = 1 (X);
	[P0+16] = R0;
	R0 = [P0+20];
	cc =R0<0;
	if !cc jump 4 (bp); jump.s .L155;
	R0 >>>= 16;
	P3 = R0;
	R1 = R0 >>> 4;
	P2 = R1;
	R2 = 1760 (X);
	P0 = P3 + (P3 << 1);
	R1 = P0;
	R1 >>>= 9;
	P5 = R1;
	R1 = 4390 (X);
	R1 *= R0;
	R1 >>>= 15;
	R2 = R1 + R2;
	I0 = R2;
	R2 = R0;
	P3 = P3 + (P0 << 2);
	R2 *= R0;
	R6 = P3;
	R1 = 11264 (X);
	R6 >>>= 5;
	R6 = R6 + R1;
	R2 >>>= 15;
	R1 = -10672 (X);
	R1 *= R2;
	cc =R1<0;
	if !cc jump 4 (bp); jump.s .L184;
.L115:
	R1 >>>= 15;
	R3 = 28672 (X);
	R3 = R1 + R3;
	R1 = R2 << 3;
	R1 = R1 - R2;
	R1 >>>= 4;
	R2 = 8192 (X);
	R2 = R1 + R2;
	R1 = 11767 (X);
	R1 *= R0;
	[SP+92] = R2;
	R1 >>>= 15;
	R2 = 21000 (X);
	R1 = R1 + R2;
	R2 = 9500 (X);
	R1 *= R2;
	R1 >>>= 15;
	[SP+96] = R1;
	R1 = 29167 (X);
	R1 *= R0;
	R2 = 3600 (X);
	R1 >>>= 15;
	R2 = R1 + R2;
	[SP+88] = R3;
	[SP+60] = R2;
.L114:
	P0 = [SP+956];
	R2 = [P0+24];
	cc =R2<0;
	if !cc jump 4 (bp); jump.s .L156;
	R2 >>>= 16;
	R1 = 13800 (X);
	R1 *= R2;
	R3 = 17000 (X);
	R1 >>>= 15;
	R3 = R1 + R3;
	[SP+68] = R3;
	R1 = [SP+68];
	R3 = 32767 (X);
	R1 = R3 - R1;
	[SP+100] = R1;
	R1 = -12000 (X);
	R1 *= R2;
	cc =R1<0;
	if !cc jump 4 (bp); jump.s .L185;
.L117:
	R1 >>>= 15;
	R4 = 26000 (X);
	R3 = 27000 (X);
	R3 = R1 + R3;
	R4 = R1 + R4;
	R1 = 14000 (X);
	R1 *= R2;
	[SP+64] = R3;
	R1 >>>= 15;
	R3 = 30000 (X);
	R3 = R1 + R3;
	R1 = 5000 (X);
	R1 *= R2;
	[SP+104] = R3;
	R1 >>>= 15;
	R3 = 11585 (X);
	R3 = R1 + R3;
	R1 = 20767 (X);
	R2 *= R1;
	R1 = 12000 (X);
	R2 >>>= 15;
	[SP+116] = R3;
	R2 = R2 + R1;
	R3 = [SP+64];
	R1 = 32767 (X);
	R1 = R1 - R3;
	R1 <<= 8;
	[SP+108] = R1;
.L116:
	P0 = [SP+956];
	R1 = [P0+28];
	cc =R1<0;
	if !cc jump 4 (bp); jump.s .L157;
	R1 >>>= 16;
	R3 = 17000 (X);
	P4 = R1;
	R3 *= R1;
	R7 = 32767 (X);
	R3 >>>= 15;
	R3 = R7 - R3;
	P3 = P4 + (P4 << 2);
	[SP+40] = R3;
	R3 = P3;
	R3 >>>= 7;
	P3 = R3;
	R3 = 512 (X);
	P0 = R3;
	R3 = -200 (X);
	R3 *= R1;
	cc =R3<0;
	P3 = P3 + P0;
	if !cc jump 4 (bp); jump.s .L186;
.L119:
	R3 >>>= 15;
	R7 = 460 (X);
	R7 = R3 + R7;
	[SP+44] = R7;
	R3 = 22000 (X);
	R7 = 19000 (X);
	R3 *= R1;
	R1 *= R7;
	R7 = 32767 (X);
	R1 >>>= 15;
	R3 >>>= 15;
	R7 = R7 - R1;
	[SP+56] = R3;
	[SP+48] = R7;
	FP = R3;
.L118:
	P0 = [SP+956];
	R1 = [P0+32];
	cc =R1<0;
	if !cc jump 4 (bp); jump.s .L158;
	R1 >>>= 16;
	P4 = R1;
	R7 = 2600 (X);
	P0 = P4 + (P4 << 2);
	P0 = P0 + (P0 << 2);
	R5 = P0;
	R5 >>>= 7;
	R5 = R5 + R7;
	R7 = 52000 (Z);
	R7 *= R1;
	R7 >>>= 15;
	[SP+112] = R7;
	R7 = 46152 (Z);
	R7 *= R1;
	R1 = 3000 (X);
	R7 >>>= 15;
	R7 = R7 + R1;
.L120:
	P0 = [SP+956];
	R1 = [P0+12];
	cc =R1==0;
	if cc jump 4; jump.s .L121;
	P4 = [P0+72];
	R0 = [P0+76];
	P0 = 63 (X);
	cc =P4<=P0;
	if cc jump 4 (bp); jump.s .L122;
	FP = 0 (X);
.L123:
	I1 = -16384 (X);
	R3 = I1;
	P0 = [SP+956];
	P4 = [SP+956];
	P3 = P5 + P3;
	P5 = 256 (X);
	[P0+72] = R1;
	R1 = 31130 (X);
	R0 *= R1;
	R0 >>>= 15;
	P0 = R0;
	[P4+76] = R0;
	R0.H = 25;
	R1 = [P4+4];
	R0.L = 26125;
	R1 *= R0;
	R0.H = 15470;
	R0.L = 62303;
	R1 = R1 + R0;
	[P4+4] = R1;
	R1 >>= 17;
	R0 = [P4+68];
	R1 = R1 + R3;
	R1 = R1 - R0;
	R1 >>>= 5;
	R0 = R1 + R0;
	R1 = I0;
	[P4+68] = R0;
	R0 *= R1;
	R3 = P2;
	R1 = 10240 (X);
	P2 = P0 + (P0 << 2);
	R0 >>>= 12;
	P2 = P0 + (P2 << 1);
	R0 = min(R0,R1);
	R1 = -10240 (X);
	R0 = max(R0,R1);
	R1 = P2;
	R0 = R0 + R3;
	R1 >>>= 6;
	R1 = R0 - R1;
	P2 = R1;
	P4 = [P1+252];
	P0 = P2 + (P2 << 2);
	P0 = P0 << 2;
	P0 -= P2;
	R0 = P0;
	P0 = [P1];
	R1 = R0 << 8 ||
	[SP+28] = R2 ||
	nop;
	R1 = R1 - R0;
	R0 = P0;
	R0 >>= 1;
// 12 "D:\a\Fujara-Flute-for-XY\Fujara-Flute-for-XY\sdk\sdk\include/opxy/q31.hpp" 1
	R0 = R0 * R1 (T);
// 0 "" 2
	P1 = R0;
	R0 = P4;
	R0 >>= 1;
// 12 "D:\a\Fujara-Flute-for-XY\Fujara-Flute-for-XY\sdk\sdk\include/opxy/q31.hpp" 1
	R0 = R0 * R1 (T);
// 0 "" 2
	P2 = R0;
	P1 = P0 + (P1 << 1);
	[SP+32] = P1;
	[SP+36] = P0;
	P0 = [SP+32];
	P1 = P4 + (P2 << 1);
	R1 = 63 (X);
	P1 -= P0;
	R0 = P1;
	call ___divsi3;
	P0 = 32767 (X);
	R3 = [SP+56];
	[SP+52] = R0;
	R0 = P0;
	R0 = min(R3,R0) ||
	R2 = [SP+28] ||
	nop;
	R3 = [SP+40];
	P1 = [SP+36];
	R2 *= R3;
	R2 >>>= 15;
	cc =P1<P4 (iu);
	P2 = P1;
	P1 = R2;
	I0 = P3;
	M0 = FP;
	if cc P2 = P4;
	I0 += M0;
	P4 = 120 (X);
	P3 = SP + P4;
	FP.H = __ZN6fujara12_GLOBAL__N_1L6kLimitE+4;
	P4 = I0;
	P5 -= P4;
	FP.L = __ZN6fujara12_GLOBAL__N_1L6kLimitE+4;
	[SP+56] = R0;
	R2 = R2 -|- R2 ||
	[SP+40] = P5 ||
	nop;
	R0.H = 22282;
	R3 = 0 (X);
	P0.H = __ZN6fujara7voicingL7rolloffE;
	[SP+72] = P3;
	P4 = P3;
	[SP+76] = R6;
	P3 = FP;
	[SP+80] = R4;
	[SP+84] = R5;
	R0.L = 15729;
	P0.L = __ZN6fujara7voicingL7rolloffE;
	P5 = P2;
	R6 = R2;
	R4 = P1;
	R5 = R3;
	FP = R7;
	jump.s .L124;
.L187:
	cc =R6==0;
	if !cc jump .L126 (bp);
	[P4] = R4;
	R5 = R5 + R4;
.L127:
	R6 += 1;
	R0 = [P3++];
	P4 += 4;
.L124:
	R1 = P5;
	cc =R1<R0 (iu);
	if cc jump .L187 (bp);
	R0 = 0 (X);
.L125:
	[P4] = R0;
	R0 = 7 (X);
	cc =R6==R0;
	if !cc jump .L127 (bp);
	P3 = [SP+72];
	R3 = R5;
	R0 = 1 (X);
	R0 = max(R3,R0);
	P4 = P3;
	R6 = [SP+76];
	R4 = [SP+80];
	R5 = [SP+84];
	P5 = R0;
	P4 += 32;
	R7 = [SP+96];
.L133:
	R1 = P5;
	R0 = [P3++];
	R0 *= R7;
	call ___divsi3;
	R1 = 7 (X);
	cc =R0<=R1;
	if !cc jump .L132 (bp);
	R0 = 0 (X);
.L132:
	cc =P4==P3;
	[P3+-4] = R0;
	if !cc jump .L133 (bp);
	P0 = 152 (X);
	P1 = 408 (X);
	P5 = SP + P0;
	P4 = SP + P1;
	R7 = FP;
	P1 = P5;
	R0 = 0 (X);
	P2 = 64 (X);
	LSETUP (.L134, .L195) LC1 = P2;
.L134:
.L195:
	[P1++] = R0;
	P2 = [SP+956];
	P0 = [SP+52];
	FP = 68 (X);
	P1.H = __ZN6fujara12_GLOBAL__N_1L7kOffsetE;
	P3 = P2;
	R1 = [P2];
	P1.L = __ZN6fujara12_GLOBAL__N_1L7kOffsetE;
	P2 = P2 + FP;
	R3 = [SP+32];
	FP = 0 (X);
	[SP+44] = P5;
	[SP+48] = R6;
	[SP+40] = R4;
	R6 = FP;
	[SP+56] = R5;
	[SP+60] = R7;
	P3 += 36;
	P5 = P2;
	FP = P1;
	R4 = R3;
	R5 = P0;
	R7 = P0;
	jump.s .L138;
.L189:
	P2 = 152 (X);
	P2 = P2 + SP;
	[SP+16] = R0;
	[SP+12] = R3;
	R2 = R4;
	R0 = P2;
	call __ZN6fujara12_GLOBAL__N_114steady_partialEPlmmll;
	P0 = [SP+956];
	R1 = [P0];
.L135:
	R3 = [SP+32];
	cc =P5==P3;
	R4 = R4 + R3;
	R5 = R5 + R7;
	FP += 4;
	if cc jump .L188;
.L138:
	P0 = R6;
	P1 = 120 (X);
	P1 = P1 + SP;
	R3 = [P3];
	R6 += 1;
	P2 = P1 + (P0 << 2);
	R0 = [P2];
	R2 = R0 | R3;
	cc =R2==0;
	[P3++] = R0;
	if cc jump .L135;
	R0 = R0 - R3;
	cc =R0<0;
	if !cc jump .L136 (bp);
	R0 += 63;
.L136:
	R1 *= R6;
	R2 = [FP];
	cc =R7==0;
	R0 >>>= 6;
	R1 = R1 + R2;
	if cc jump .L189 (bp);
	P1 = 152 (X);
	P1 = P1 + SP;
	[SP+20] = R0;
	[SP+16] = R3;
	[SP+12] = R5;
	R2 = R4;
	R0 = P1;
	call __ZN6fujara12_GLOBAL__N_17partialEPlmmlll;
	P2 = [SP+956];
	R1 = [P2];
	jump.s .L135;
.L126:
	cc =R6==1;
	if cc jump .L160;
	P1 = R6;
	R2 = [SP+60];
	P2 = P0 + (P1 << 2);
	R7 = [P2];
	R7 *= R2;
	cc =R7<0;
	if cc jump .L190;
.L129:
	R7 >>>= 15;
.L128:
	R0 = R6 << 8 ||
	R2 = [SP+40] ||
	nop;
	R0 = R0 + R2;
	R0 = abs R0 ||
	R3 = [SP+44] ||
	nop;
	R0 = R3 - R0;
	cc =R0<=0;
	if cc jump .L161;
	R1 = R0 << 15;
	R0 = R1 - R0;
	R1 = R3;
	[SP+28] = P0;
	call ___divsi3;
	R2 = [SP+56];
	R0 *= R2;
	R3 = 30000 (X);
	R0 >>>= 15;
	R0 *= R3;
	P0 = [SP+28];
	R0 >>>= 15;
.L130:
	R2 = [SP+48];
	R7 *= R2;
	cc =R7<0;
	if !cc jump .L131 (bp);
	R3 = 32767 (X);
	R7 = R7 + R3;
.L131:
	R7 >>>= 15;
	R0 = R7 + R0;
	R5 = R5 + R0;
	jump.s .L125;
.L188:
	R2 = [SP+52];
	R0 = ROT R3 BY 0 ||
	R3 = [SP+52] ||
	nop;
	R2 <<= 6;
	P0 = [SP+956];
	R2 = R2 - R3;
	R2 <<= 5;
	R0 <<= 6;
	R0 = R0 + R2;
	P1 = 408 (X);
	R1 = R0 + R1;
	P2 = SP + P1;
	P3 = 664 (X);
	I0.H = 25;
	FP.H = 15470;
	[P0] = R1;
	R2 = [P0+80];
	R1 = [P0+4];
	P1 = SP + P3;
	P5 = [SP+44];
	R6 = [SP+48];
	R4 = [SP+40];
	R5 = [SP+56];
	R7 = [SP+60];
	P3 = P2;
	I0.L = 26125;
	FP.L = 62303;
	R3 = -8192 (X);
	P0 = 64 (X);
	LSETUP (.L139, .L194) LC1 = P0;
.L139:
	R0 = I0;
	R1 *= R0;
	R0 = FP;
	R1 = R1 + R0;
	R0 = R1 >> 18;
	R0 = R0 + R3;
	R0 = R0 - R2;
	R0 *= R5;
	R0 >>>= 15;
	R2 = R2 + R0;
.L194:
	[P3++] = R2;
	P0 = [SP+956];
	P3 = P5;
	[P0+80] = R2;
	[P0+4] = R1;
	R2 = [P0+84];
	P0 = P2;
.L140:
	nop;
	R1 = [P0];
	R0 = R1 - R2;
	R0 >>>= 5;
	R2 = R2 + R0;
	R0 = [P3];
	R3 = R0 >>> 15;
	R0 >>>= 16;
	R0 = R0 + R6;
	R1 = R1 - R2;
	R0 *= R1;
	R0 >>>= 15;
	[P0++] = R0;
	cc =P1==P0;
	[P3++] = R3;
	if !cc jump .L140 (bp);
	P1 = [SP+956];
	P0 = 664 (X);
	P3 = SP + P0;
	P0 = P3;
	[P1+84] = R2;
	R3 = [SP+100];
	P1 = P5;
	R6 = [SP+112];
.L141:
	nop;
	R2 = [P2++];
	R0 = ROT R2 BY 0 ||
	R1 = [P1] ||
	nop;
	R0 *= R7;
	R0 >>>= 15;
	R0 = R0 + R1;
	R2 *= R6;
	R1 *= R4;
	R0 *= R3;
	R1 = R1 + R2;
	R1 >>>= 15;
	[P1++] = R1;
	R0 >>>= 15;
	cc =P4==P1;
	[P0++] = R0;
	if !cc jump .L141 (bp);
	P1 = [SP+36];
	P2.H = 0;
	P2.L = 65535;
	cc =P1<=P2 (iu);
	if cc jump .L162 (bp);
	R1 = P1;
	R0 = -1 (X);
	call ___udivsi3;
	R6 = ROT R0 BY 0 ||
	R0 = [SP+36] ||
	nop;
	R0 *= R6;
	R1 = [SP+36];
	R1 >>= 8;
	R0 = ~R0;
	R1 += 1;
	call ___udivsi3;
	R6 <<= 8;
	R7 = R0 + R6;
	R0 = 125 (X);
	R0 <<= 11;
	cc =R7<=R0 (iu);
	if cc jump .L143;
.L144:
	R1 = 125 (X);
	R7 >>= 1;
	R1 <<= 11;
	cc =R7<=R1 (iu);
	if !cc jump .L144 (bp);
.L142:
	R1 = [SP+64];
	R0 = [SP+108];
	call ___divsi3;
.L145:
	P0 = [SP+956];
	R7 = R7 - R0;
	R4 = R7 >> 8;
	R6 = R7.B (Z);
	FP = 96 (X);
	R1 = R1 -|- R1 ||
	R3 = [P0+8] ||
	nop;
	B1 = R4;
	M0 = R6;
	FP = P0 + FP;
	R2 = [P0+88];
	B0 = 64 (X);
	R7 = 1023 (X);
	R6 = R1;
	I0 = P3;
	I2 = P5;
	R5 = [SP+68];
	R4 = [SP+64];
.L147:
	P1 = R3;
	R0 = B0;
	R1 = R0 - R6;
	R0 = B1;
	cc =R1<=R0 (iu);
	P0 = B1;
	if cc R0 = R1;
	P1 -= P0;
	B2 = R0;
	R0 = P1;
	R0 += -1;
	R0 = R0 & R7;
	P2 = R0;
	R1 = B2;
	R1 = R1 + R6;
	cc =R1<=R6 (iu);
	B3 = R1;
	P2 = FP + (P2 << 1);
	R0 = W [P2] (X);
	if cc jump .L163;
	R6 <<= 2;
	P3 = R6;
	P0 = 408 (X);
	P0 = P0 + SP;
	I3 = R6;
	P2 = P0 + P3;
	P0 = P2;
	P3 = B2;
	LSETUP (.L150, .L193) LC1 = P3;
.L150:
	R6 = P1;
	R1 = R6 & R7;
	P5 = R1;
	R6 = M0;
	P1 += 1;
	P5 = FP + (P5 << 1);
	R1 = W [P5] (X);
	R1 = R1.L (X);
	R0 = R0 - R1;
	R0 *= R6;
	R0 >>>= 8;
	R0 = R0 + R1;
	[P0++] = R0;
.L193:
	R0 = R1;
	R0 = B2;
	P0 = 664 (X);
	P0 = P0 + SP;
	R0 = R0 + R3;
	P1 = I3;
	P3 = P0 + P1;
	P5 = R0;
	P0 = R3;
	B2 = R0;
	P5 -= P0;
	LSETUP (.L153, .L192) LC1 = P5;
.L153:
	R0 = [P2++];
	R0 = R0 - R2;
	R0 *= R4;
	R0 >>>= 15;
	R2 = R2 + R0;
	R0 = ROT R2 BY 0 ||
	R1 = [P3] ||
	nop;
	R0 *= R5;
	R0 >>>= 15;
	R0 = R0 + R1;
	R1 = R3 & R7;
	P1 = R1;
	[P3++] = R0;
	R3 += 1;
	P1 = FP + (P1 << 1);
.L192:
	W [P1] = R0;
	R0 = B3;
	R1 = 63 (X);
	cc =R0<=R1 (iu);
	if !cc jump .L191;
.L148:
	R6 = B3;
	R3 = B2;
	jump.s .L147;
.L191:
	P0 = [SP+956];
	R3 = B2;
	R7 = R3 & R7;
	P3 = I0;
	[P0+8] = R7;
	[P0+88] = R2;
	R3 = [P0+92];
	P5 = I2;
	P2 = [SP+968];
	R7 = 32767 (X);
	R6 = -32767 (X);
	P0 = [SP+88];
	R5 = [SP+92];
	R4 = [SP+104];
.L154:
	nop;
	R0 = [P3++];
	R0 *= R4;
	R1 = [P5++];
	R0 >>>= 15;
	R0 = R0 + R1;
	R0 *= R5;
	R1 = R0 >>> 13;
	R1 = min(R1,R7);
	R1 = max(R1,R6);
	R0 = R1;
	R0 *= R1;
	R0 >>>= 15;
	R2 = R1 >>> 1;
	R0 = R7 - R0;
	R0 *= R2;
	R0 >>>= 15;
	R0 = R0 + R1;
	R1 = P0;
	R0 *= R1;
	R1 = R3 >>> 10;
	R0 >>>= 15;
	R0 = R0 - R1;
	R1 = R0 >>> 1;
	R0 = min(R0,R7);
	R0 = max(R0,R6);
	R0 <<= 15;
	cc =P4==P5;
	R3 = R3 + R1;
	[P2++] = R0;
	if !cc jump .L154 (bp);
	P0 = [SP+956];
	P1 = 920 (X);
	SP = SP + P1;
	[P0+92] = R3;
	FP = [SP++];
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	rts;
.L163:
	B2 = R3;
	jump.s .L148;
.L161:
	R0 = 0 (X);
	jump.s .L130;
.L160:
	R7 = [SP+116];
	jump.s .L128;
.L121:
	R1 = 23767 (X);
	R1 *= R0;
	R3 = 9000 (X);
	R1 >>>= 15;
	R3 = R1 + R3;
	P4 = R3;
	R3 = 18767 (X);
	R0 *= R3;
	P0 = [SP+956];
	R3 = 14000 (X);
	R0 >>>= 15;
	R0 = R0 + R3;
	R3 = 0 (X);
	[P0+12] = R3;
.L122:
	R3 = 32374 (X);
	R1 = P4;
	R1 *= R3;
	R3 = 20000 (X);
	R1 >>>= 15;
	R3 *= R1;
	R3 >>>= 15;
	P0 = R3;
	P4 = R1;
	P0 = P0 + FP;
	FP = P4 + (P4 << 1);
	R3 = FP;
	R3 >>>= 7;
	[SP+56] = P0;
	FP = R3;
	jump.s .L123;
.L162:
	R7 = 125 (X);
	R7 <<= 11;
	jump.s .L142;
.L190:
	R3 = 32767 (X);
	R7 = R7 + R3;
	jump.s .L129;
.L186:
	R3 = R3 + R7;
	jump.s .L119;
.L185:
	R1 = R1 + R3;
	jump.s .L117;
.L184:
	R3 = 32767 (X);
	R1 = R1 + R3;
	jump.s .L115;
.L156:
	R3 = 5767 (X);
	R3 <<= 8;
	[SP+108] = R3;
	R3 = 30000 (X);
	[SP+104] = R3;
	R3 = 17000 (X);
	[SP+68] = R3;
	R3 = 27000 (X);
	P3 = 11585 (X);
	[SP+64] = R3;
	R3 = 15767 (X);
	R2 = 12000 (X);
	[SP+116] = P3;
	R4 = 26000 (X);
	[SP+100] = R3;
	jump.s .L116;
.L155:
	R3 = 6088 (X);
	R6 = 8192 (X);
	R2 = 3600 (X);
	[SP+96] = R3;
	R3 = 28672 (X);
	[SP+92] = R6;
	[SP+60] = R2;
	[SP+88] = R3;
	R6 = 11264 (X);
	I0 = 1760 (X);
	P5 = 0 (X);
	P2 = 0 (X);
	R0 = 0 (X);
	jump.s .L114;
.L158:
	R3 = 0 (X);
	R7 = 3000 (X);
	[SP+112] = R3;
	R5 = 2600 (X);
	jump.s .L120;
.L157:
	R3 = 32767 (X);
	[SP+48] = R3;
	R3 = 0 (X);
	[SP+56] = R3;
	R3 = 460 (X);
	[SP+44] = R3;
	R3 = 32767 (X);
	FP = 0 (X);
	P3 = 512 (X);
	[SP+40] = R3;
	jump.s .L118;
.L143:
	R1 = [SP+64];
	R0 = [SP+108];
	call ___divsi3;
	P0 = R0;
	P2 = 768 (X);
	P2 = P0 + P2;
	R1 = P2;
	cc =R1<=R7 (iu);
	if cc jump .L145;
.L146:
	R7 <<= 1;
	R2 = P2;
	cc =R2<=R7 (iu);
	if !cc jump .L146 (bp);
	jump.s .L145;
	.size	__ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm, .-__ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm
.text;
	.align 4
.global _fujara_render;
.type _fujara_render, STT_FUNC;
_fujara_render:
	[--sp] = ( r7:4, p5:3 );

	P5 = R0;
	P4.H = __ZL6blocks;
	LINK 24;
	P4.L = __ZL6blocks;
	R7 = ROT R1 BY 0 ||
	R1 = W [P4] (X) ||
	nop;
	P3 = R2;
	R0 = R1.L (Z);
	R2 = W [P5+4] (Z);
	cc =R2==R0;
	if cc jump .L198;
	P2.H = __ZL7counted;
	P2.L = __ZL7counted;
	R4 = [P2];
.L199:
	R6 = B [P5+8] (Z);
	cc =R6==0;
	W [P5+4] = R1;
	if cc jump .L200 (bp);
	R3 = R6;
	R3 += -1;
	R0 = 2160 (X);
	R0 *= R3;
	R5.H = __ZL6voices;
	R5.L = __ZL6voices;
	R0 = R5 + R0;
	P2 = R0;
	P1 = 2144 (X);
	P1 = P2 + P1;
	R0 = [P1];
	cc =R0==0;
	I0 = R0;
	if !cc jump .L237 (bp);
	P4.H = __ZL7handles;
	P4.L = __ZL7handles;
.L201:
	nop;
	R1 = B [P5+9] (Z);
	cc =R1==0;
	if cc jump .L214 (bp);
.L213:
	R0 = 2160 (X);
	R0 *= R3;
	R2 = P4;
	R0 = R5 + R0;
	R3 = P5;
	P2 = R0;
	R0 = R3 - R2;
	R2.H = 43690;
	R0 >>>= 2;
	R2.L = 43691;
	R0 *= R2;
	R1 = [P2+2144];
	R0 += 1;
	cc =R1==R0;
	if cc jump .L204;
	cc =R1==0;
	if !cc jump .L238 (bp);
.L205:
	R1 = R4;
	R2 = 0 (X);
	R0 = P5;
	call __ZL7acquireP6Handlemb;
	R6 = B [P5+8] (X);
.L202:
	R6 = R6.B (Z);
	cc =R6==0;
	if cc jump .L206;
	R5.H = __ZL6voices;
	P4.H = __ZL7handles;
	R5.L = __ZL6voices;
	P4.L = __ZL7handles;
.L214:
	P5 -= P4;
	R0 = P5;
	R1.H = 43690;
	R0 >>>= 2;
	R1.L = 43691;
	R0 *= R1;
	R0 += 1;
.L215:
	R6 += -1;
	R1 = 2160 (X);
	R1 *= R6;
	R1 = R5 + R1;
	P5 = R1;
	R2 = [P5+2144];
	cc =R2==R0;
	if cc jump .L239;
.L206:
	P1 = R7;
	R0 = 0 (X);
	P2 = 64 (X);
	LSETUP (.L212, .L242) LC1 = P2;
.L212:
.L242:
	[P1++] = R0;
.L223:
	SP += 24;
	FP = [SP++];
	R0 = 0 (X);
	RETS = [SP++];
	( r7:4, p5:3 ) = [sp++];

	rts;
.L200:
	nop;
	R0 = B [P5+9] (Z);
	cc =R0==0;
	if cc jump .L206 (bp);
	jump.s .L205;
.L237:
	P4.H = __ZL7handles;
	P4.L = __ZL7handles;
	P0 = P5;
	P0 -= P4;
	R0 = P0;
	P0.H = 43690;
	P0.L = 43691;
	R2 = P0;
	FP = [P2+2152];
	R0 >>>= 2;
	R0 *= R2;
	R2 = FP;
	R0 += 1;
	cc =R2==R0;
	if !cc jump .L201 (bp);
	P0 = I0;
	P0 += -1;
	P0 = P0 + (P0 << 1);
	P0 = P4 + (P0 << 2);
	R0 = W [P0+4] (X);
	R0 = R1 - R0;
	R0 = R0.L (Z);
	cc =R0<=2 (iu);
	if cc jump .L201 (bp);
	R0 = W [P2+2156] (X);
	R1 = R1 - R0;
	R1 = R1.L (Z);
	cc =R1<=2 (iu);
	if cc jump .L201 (bp);
	R0 = 0 (X);
	cc =FP==0;
	[P1] = R0;
	if cc jump .L201 (bp);
	FP += -1;
	FP = FP + (FP << 1);
	FP = P4 + (FP << 2);
	R0 = P2;
	R2 = R4;
	R1 = FP;
	call __ZL5beginR4SlotP6Handlem;
	R0 = B [P5+9] (Z);
	cc =R0==0;
	R6 = B [P5+8] (X);
	if cc jump .L202;
	R6 = R6.B (Z);
	R3 = R6;
	cc =R6==0;
	R3 += -1;
	if !cc jump .L213 (bp);
	jump.s .L205;
.L198:
	R1 += 1;
	W [P4] = R1;
	call sdk_voice_ticks;
	P2.H = __ZL7counted;
	P2.L = __ZL7counted;
	R4 = ROT R0 BY 0 ||
	[P2] = R0 ||
	nop;
	call __ZL5sweepm;
	R1 = W [P4] (X);
	jump.s .L199;
.L239:
	P2.H = sdk_benchmark_engine;
	P2.L = sdk_benchmark_engine;
	R0.H = fujara_engine_id;
	R1 = [P2];
	R0.L = fujara_engine_id;
	cc =R1==R0;
	if cc jump .L240;
.L207:
	R0.H = 4496;
	R0.L = 11264;
	R1.H = __ZL6shared;
	P2.H = __ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm;
	[SP+20] = R0;
	P2.L = __ZN6fujara6renderERNS_5VoiceERNS_6SharedEmPlPKlPKm;
	R0 = P5;
	[SP+16] = P3;
	[SP+12] = R7;
	R1.L = __ZL6shared;
	call (P2);
	R0 = 2160 (X);
	R0 *= R6;
	R0 = R5 + R0;
	P2 = R0;
	R0 = [P2+2152];
	cc =R0==0;
	if cc jump .L223 (bp);
	R1 = -2 (X);
	R2.H = 65015;
	P1 = R7;
	R1.H = 32767;
	R2.L = 57214;
	P2 = 64 (X);
	LSETUP (.L210, .L241) LC1 = P2;
.L210:
	R0 = [P1];
// 12 "D:\a\Fujara-Flute-for-XY\Fujara-Flute-for-XY\sdk\sdk\include/opxy/q31.hpp" 1
	R0 = R0 * R1 (T);
// 0 "" 2
	R1 = R1 + R2;
.L241:
	[P1++] = R0;
	R0 = 2160 (X);
	R6 *= R0;
	R5 = R5 + R6;
	P2 = R5;
	P1 = 2144 (X);
	R0 = 0 (X);
	P1 = P2 + P1;
	P2 = [P2+2152];
	[P1] = R0;
	cc =P2==0;
	if cc jump .L223 (bp);
	P2 += -1;
	P2 = P2 + (P2 << 1);
	P4 = P4 + (P2 << 2);
	R2 = R4;
	R1 = P4;
	R0 = P5;
	call __ZL5beginR4SlotP6Handlem;
	jump.s .L223;
.L238:
	nop;
	R1 = [P2+2152];
	cc =R0==R1;
	if !cc jump .L205 (bp);
.L204:
	R6 = B [P5+8] (Z);
	jump.s .L215;
.L240:
	P2.H = sdk_benchmark_parameters;
	P2.L = sdk_benchmark_parameters;
	R0 = [P2];
	cc =R0==0;
	if !cc P3 = R0;
	jump.s .L207;
	.size	_fujara_render, .-_fujara_render
	.align 4
.global fujara_factory;
.type fujara_factory, STT_FUNC;
fujara_factory:
	P2 = R0;
	[--sp] = ( p5:5 );

	P1 = 255 (X);
	[--SP] = RETS;
	SP += -12;
	cc =P2<=P1 (iu);
	if !cc jump .L245;
	P5.H = __ZL7handles;
	P2 = P2 + (P2 << 1);
	P5.L = __ZL7handles;
	P5 = P5 + (P2 << 2);
	R0 = P5;
	call _end;
	R0.H = _fujara_vtable;
	R0.L = _fujara_vtable;
	[P5] = R0;
.L243:
	SP += 12;
	RETS = [SP++];
	R0 = P5;
	( p5:5 ) = [sp++];

	rts;
.L245:
	P5 = 0 (X);
	jump.s .L243;
	.size	fujara_factory, .-fujara_factory
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align 4
.LC0:
	.string	""
.text;
	.align 4
.global fujara_parameter_name;
.type fujara_parameter_name, STT_FUNC;
fujara_parameter_name:
	P2 = R0;
	cc =P2<=3 (iu);
	if !cc jump .L248 (bp);
	P1.H = __ZZ21fujara_parameter_nameE6labels;
	P1.L = __ZZ21fujara_parameter_nameE6labels;
	P2 = P1 + (P2 << 2);
	R0 = [P2];
	rts;
.L248:
	R0.H = .LC0;
	R0.L = .LC0;
	rts;
	.size	fujara_parameter_name, .-fujara_parameter_name
.global _fujara_vtable;
	.section	.rodata
	.align 4
	.type	_fujara_vtable, @object
	.size	_fujara_vtable, 44
_fujara_vtable:
	.long	_fujara_destroy
	.long	_fujara_destroy
	.long	_fujara_render
	.long	_noop
	.long	_fujara_start
	.long	_noop
	.long	_zero
	.long	_noop
	.long	_zero
	.long	_zero
	.long	-1924116028
	.section	.rodata.str1.4
	.align 4
.LC1:
	.string	"breath"
	.align 4
.LC2:
	.string	"body"
	.align 4
.LC3:
	.string	"overtone"
	.align 4
.LC4:
	.string	"air"
	.section	.rodata
	.align 4
	.type	__ZZ21fujara_parameter_nameE6labels, @object
	.size	__ZZ21fujara_parameter_nameE6labels, 16
__ZZ21fujara_parameter_nameE6labels:
	.long	.LC1
	.long	.LC2
	.long	.LC3
	.long	.LC4
.global fujara_name;
	.align 4
	.type	fujara_name, @object
	.size	fujara_name, 7
fujara_name:
	.string	"fujara"
	.local	__ZL7counted
	.comm	__ZL7counted,4,4
.data;
	.align 2
	.type	__ZL6blocks, @object
	.size	__ZL6blocks, 2
__ZL6blocks:
	.short	1
	.local	__ZL6shared
	.comm	__ZL6shared,1,1
	.local	__ZL6voices
	.comm	__ZL6voices,19440,4
	.local	__ZL7handles
	.comm	__ZL7handles,3072,4
	.section	.rodata
	.align 4
	.type	__ZN6fujara12_GLOBAL__N_1L7kOffsetE, @object
	.size	__ZN6fujara12_GLOBAL__N_1L7kOffsetE, 32
__ZN6fujara12_GLOBAL__N_1L7kOffsetE:
	.long	0
	.long	704643072
	.long	1426063360
	.long	318767104
	.long	-1862270976
	.long	1023410176
	.long	-956301312
	.long	1795162112
	.align 4
	.type	__ZN6fujara12_GLOBAL__N_1L6kLimitE, @object
	.size	__ZN6fujara12_GLOBAL__N_1L6kLimitE, 32
__ZN6fujara12_GLOBAL__N_1L6kLimitE:
	.long	1460288881
	.long	730144440
	.long	486762960
	.long	365072220
	.long	292057776
	.long	243381480
	.long	208612697
	.long	182536110
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
	.ident	"GCC: (GNU) 8.0.0 20171013 (experimental)"
