/**
 * Author......: Jens Steube <jens.steube@gmail.com>
 * License.....: MIT
 */

#define _RIPEMD160_

#include "include/constants.h"
#include "include/kernel_vendor.h"

#define DGST_R0 0
#define DGST_R1 1
#define DGST_R2 2
#define DGST_R3 3

#include "include/kernel_functions.c"
#include "OpenCL/types_ocl.c"
#include "OpenCL/common.c"

#define COMPARE_S "OpenCL/check_single_comp4.c"
#define COMPARE_M "OpenCL/check_multi_comp4.c"

static void ripemd160_transform (const u32 w[16], u32 dgst[5])
{
  u32 a1 = dgst[0];
  u32 b1 = dgst[1];
  u32 c1 = dgst[2];
  u32 d1 = dgst[3];
  u32 e1 = dgst[4];

  RIPEMD160_STEP (RIPEMD160_F , a1, b1, c1, d1, e1, w[ 0], RIPEMD160C00, RIPEMD160S00);
  RIPEMD160_STEP (RIPEMD160_F , e1, a1, b1, c1, d1, w[ 1], RIPEMD160C00, RIPEMD160S01);
  RIPEMD160_STEP (RIPEMD160_F , d1, e1, a1, b1, c1, w[ 2], RIPEMD160C00, RIPEMD160S02);
  RIPEMD160_STEP (RIPEMD160_F , c1, d1, e1, a1, b1, w[ 3], RIPEMD160C00, RIPEMD160S03);
  RIPEMD160_STEP (RIPEMD160_F , b1, c1, d1, e1, a1, w[ 4], RIPEMD160C00, RIPEMD160S04);
  RIPEMD160_STEP (RIPEMD160_F , a1, b1, c1, d1, e1, w[ 5], RIPEMD160C00, RIPEMD160S05);
  RIPEMD160_STEP (RIPEMD160_F , e1, a1, b1, c1, d1, w[ 6], RIPEMD160C00, RIPEMD160S06);
  RIPEMD160_STEP (RIPEMD160_F , d1, e1, a1, b1, c1, w[ 7], RIPEMD160C00, RIPEMD160S07);
  RIPEMD160_STEP (RIPEMD160_F , c1, d1, e1, a1, b1, w[ 8], RIPEMD160C00, RIPEMD160S08);
  RIPEMD160_STEP (RIPEMD160_F , b1, c1, d1, e1, a1, w[ 9], RIPEMD160C00, RIPEMD160S09);
  RIPEMD160_STEP (RIPEMD160_F , a1, b1, c1, d1, e1, w[10], RIPEMD160C00, RIPEMD160S0A);
  RIPEMD160_STEP (RIPEMD160_F , e1, a1, b1, c1, d1, w[11], RIPEMD160C00, RIPEMD160S0B);
  RIPEMD160_STEP (RIPEMD160_F , d1, e1, a1, b1, c1, w[12], RIPEMD160C00, RIPEMD160S0C);
  RIPEMD160_STEP (RIPEMD160_F , c1, d1, e1, a1, b1, w[13], RIPEMD160C00, RIPEMD160S0D);
  RIPEMD160_STEP (RIPEMD160_F , b1, c1, d1, e1, a1, w[14], RIPEMD160C00, RIPEMD160S0E);
  RIPEMD160_STEP (RIPEMD160_F , a1, b1, c1, d1, e1, w[15], RIPEMD160C00, RIPEMD160S0F);

  RIPEMD160_STEP (RIPEMD160_Go, e1, a1, b1, c1, d1, w[ 7], RIPEMD160C10, RIPEMD160S10);
  RIPEMD160_STEP (RIPEMD160_Go, d1, e1, a1, b1, c1, w[ 4], RIPEMD160C10, RIPEMD160S11);
  RIPEMD160_STEP (RIPEMD160_Go, c1, d1, e1, a1, b1, w[13], RIPEMD160C10, RIPEMD160S12);
  RIPEMD160_STEP (RIPEMD160_Go, b1, c1, d1, e1, a1, w[ 1], RIPEMD160C10, RIPEMD160S13);
  RIPEMD160_STEP (RIPEMD160_Go, a1, b1, c1, d1, e1, w[10], RIPEMD160C10, RIPEMD160S14);
  RIPEMD160_STEP (RIPEMD160_Go, e1, a1, b1, c1, d1, w[ 6], RIPEMD160C10, RIPEMD160S15);
  RIPEMD160_STEP (RIPEMD160_Go, d1, e1, a1, b1, c1, w[15], RIPEMD160C10, RIPEMD160S16);
  RIPEMD160_STEP (RIPEMD160_Go, c1, d1, e1, a1, b1, w[ 3], RIPEMD160C10, RIPEMD160S17);
  RIPEMD160_STEP (RIPEMD160_Go, b1, c1, d1, e1, a1, w[12], RIPEMD160C10, RIPEMD160S18);
  RIPEMD160_STEP (RIPEMD160_Go, a1, b1, c1, d1, e1, w[ 0], RIPEMD160C10, RIPEMD160S19);
  RIPEMD160_STEP (RIPEMD160_Go, e1, a1, b1, c1, d1, w[ 9], RIPEMD160C10, RIPEMD160S1A);
  RIPEMD160_STEP (RIPEMD160_Go, d1, e1, a1, b1, c1, w[ 5], RIPEMD160C10, RIPEMD160S1B);
  RIPEMD160_STEP (RIPEMD160_Go, c1, d1, e1, a1, b1, w[ 2], RIPEMD160C10, RIPEMD160S1C);
  RIPEMD160_STEP (RIPEMD160_Go, b1, c1, d1, e1, a1, w[14], RIPEMD160C10, RIPEMD160S1D);
  RIPEMD160_STEP (RIPEMD160_Go, a1, b1, c1, d1, e1, w[11], RIPEMD160C10, RIPEMD160S1E);
  RIPEMD160_STEP (RIPEMD160_Go, e1, a1, b1, c1, d1, w[ 8], RIPEMD160C10, RIPEMD160S1F);

  RIPEMD160_STEP (RIPEMD160_H , d1, e1, a1, b1, c1, w[ 3], RIPEMD160C20, RIPEMD160S20);
  RIPEMD160_STEP (RIPEMD160_H , c1, d1, e1, a1, b1, w[10], RIPEMD160C20, RIPEMD160S21);
  RIPEMD160_STEP (RIPEMD160_H , b1, c1, d1, e1, a1, w[14], RIPEMD160C20, RIPEMD160S22);
  RIPEMD160_STEP (RIPEMD160_H , a1, b1, c1, d1, e1, w[ 4], RIPEMD160C20, RIPEMD160S23);
  RIPEMD160_STEP (RIPEMD160_H , e1, a1, b1, c1, d1, w[ 9], RIPEMD160C20, RIPEMD160S24);
  RIPEMD160_STEP (RIPEMD160_H , d1, e1, a1, b1, c1, w[15], RIPEMD160C20, RIPEMD160S25);
  RIPEMD160_STEP (RIPEMD160_H , c1, d1, e1, a1, b1, w[ 8], RIPEMD160C20, RIPEMD160S26);
  RIPEMD160_STEP (RIPEMD160_H , b1, c1, d1, e1, a1, w[ 1], RIPEMD160C20, RIPEMD160S27);
  RIPEMD160_STEP (RIPEMD160_H , a1, b1, c1, d1, e1, w[ 2], RIPEMD160C20, RIPEMD160S28);
  RIPEMD160_STEP (RIPEMD160_H , e1, a1, b1, c1, d1, w[ 7], RIPEMD160C20, RIPEMD160S29);
  RIPEMD160_STEP (RIPEMD160_H , d1, e1, a1, b1, c1, w[ 0], RIPEMD160C20, RIPEMD160S2A);
  RIPEMD160_STEP (RIPEMD160_H , c1, d1, e1, a1, b1, w[ 6], RIPEMD160C20, RIPEMD160S2B);
  RIPEMD160_STEP (RIPEMD160_H , b1, c1, d1, e1, a1, w[13], RIPEMD160C20, RIPEMD160S2C);
  RIPEMD160_STEP (RIPEMD160_H , a1, b1, c1, d1, e1, w[11], RIPEMD160C20, RIPEMD160S2D);
  RIPEMD160_STEP (RIPEMD160_H , e1, a1, b1, c1, d1, w[ 5], RIPEMD160C20, RIPEMD160S2E);
  RIPEMD160_STEP (RIPEMD160_H , d1, e1, a1, b1, c1, w[12], RIPEMD160C20, RIPEMD160S2F);

  RIPEMD160_STEP (RIPEMD160_Io, c1, d1, e1, a1, b1, w[ 1], RIPEMD160C30, RIPEMD160S30);
  RIPEMD160_STEP (RIPEMD160_Io, b1, c1, d1, e1, a1, w[ 9], RIPEMD160C30, RIPEMD160S31);
  RIPEMD160_STEP (RIPEMD160_Io, a1, b1, c1, d1, e1, w[11], RIPEMD160C30, RIPEMD160S32);
  RIPEMD160_STEP (RIPEMD160_Io, e1, a1, b1, c1, d1, w[10], RIPEMD160C30, RIPEMD160S33);
  RIPEMD160_STEP (RIPEMD160_Io, d1, e1, a1, b1, c1, w[ 0], RIPEMD160C30, RIPEMD160S34);
  RIPEMD160_STEP (RIPEMD160_Io, c1, d1, e1, a1, b1, w[ 8], RIPEMD160C30, RIPEMD160S35);
  RIPEMD160_STEP (RIPEMD160_Io, b1, c1, d1, e1, a1, w[12], RIPEMD160C30, RIPEMD160S36);
  RIPEMD160_STEP (RIPEMD160_Io, a1, b1, c1, d1, e1, w[ 4], RIPEMD160C30, RIPEMD160S37);
  RIPEMD160_STEP (RIPEMD160_Io, e1, a1, b1, c1, d1, w[13], RIPEMD160C30, RIPEMD160S38);
  RIPEMD160_STEP (RIPEMD160_Io, d1, e1, a1, b1, c1, w[ 3], RIPEMD160C30, RIPEMD160S39);
  RIPEMD160_STEP (RIPEMD160_Io, c1, d1, e1, a1, b1, w[ 7], RIPEMD160C30, RIPEMD160S3A);
  RIPEMD160_STEP (RIPEMD160_Io, b1, c1, d1, e1, a1, w[15], RIPEMD160C30, RIPEMD160S3B);
  RIPEMD160_STEP (RIPEMD160_Io, a1, b1, c1, d1, e1, w[14], RIPEMD160C30, RIPEMD160S3C);
  RIPEMD160_STEP (RIPEMD160_Io, e1, a1, b1, c1, d1, w[ 5], RIPEMD160C30, RIPEMD160S3D);
  RIPEMD160_STEP (RIPEMD160_Io, d1, e1, a1, b1, c1, w[ 6], RIPEMD160C30, RIPEMD160S3E);
  RIPEMD160_STEP (RIPEMD160_Io, c1, d1, e1, a1, b1, w[ 2], RIPEMD160C30, RIPEMD160S3F);

  RIPEMD160_STEP (RIPEMD160_J , b1, c1, d1, e1, a1, w[ 4], RIPEMD160C40, RIPEMD160S40);
  RIPEMD160_STEP (RIPEMD160_J , a1, b1, c1, d1, e1, w[ 0], RIPEMD160C40, RIPEMD160S41);
  RIPEMD160_STEP (RIPEMD160_J , e1, a1, b1, c1, d1, w[ 5], RIPEMD160C40, RIPEMD160S42);
  RIPEMD160_STEP (RIPEMD160_J , d1, e1, a1, b1, c1, w[ 9], RIPEMD160C40, RIPEMD160S43);
  RIPEMD160_STEP (RIPEMD160_J , c1, d1, e1, a1, b1, w[ 7], RIPEMD160C40, RIPEMD160S44);
  RIPEMD160_STEP (RIPEMD160_J , b1, c1, d1, e1, a1, w[12], RIPEMD160C40, RIPEMD160S45);
  RIPEMD160_STEP (RIPEMD160_J , a1, b1, c1, d1, e1, w[ 2], RIPEMD160C40, RIPEMD160S46);
  RIPEMD160_STEP (RIPEMD160_J , e1, a1, b1, c1, d1, w[10], RIPEMD160C40, RIPEMD160S47);
  RIPEMD160_STEP (RIPEMD160_J , d1, e1, a1, b1, c1, w[14], RIPEMD160C40, RIPEMD160S48);
  RIPEMD160_STEP (RIPEMD160_J , c1, d1, e1, a1, b1, w[ 1], RIPEMD160C40, RIPEMD160S49);
  RIPEMD160_STEP (RIPEMD160_J , b1, c1, d1, e1, a1, w[ 3], RIPEMD160C40, RIPEMD160S4A);
  RIPEMD160_STEP (RIPEMD160_J , a1, b1, c1, d1, e1, w[ 8], RIPEMD160C40, RIPEMD160S4B);
  RIPEMD160_STEP (RIPEMD160_J , e1, a1, b1, c1, d1, w[11], RIPEMD160C40, RIPEMD160S4C);
  RIPEMD160_STEP (RIPEMD160_J , d1, e1, a1, b1, c1, w[ 6], RIPEMD160C40, RIPEMD160S4D);
  RIPEMD160_STEP (RIPEMD160_J , c1, d1, e1, a1, b1, w[15], RIPEMD160C40, RIPEMD160S4E);
  RIPEMD160_STEP (RIPEMD160_J , b1, c1, d1, e1, a1, w[13], RIPEMD160C40, RIPEMD160S4F);

  u32 a2 = dgst[0];
  u32 b2 = dgst[1];
  u32 c2 = dgst[2];
  u32 d2 = dgst[3];
  u32 e2 = dgst[4];

  RIPEMD160_STEP_WORKAROUND_BUG (RIPEMD160_J , a2, b2, c2, d2, e2, w[ 5], RIPEMD160C50, RIPEMD160S50);
  RIPEMD160_STEP (RIPEMD160_J , e2, a2, b2, c2, d2, w[14], RIPEMD160C50, RIPEMD160S51);
  RIPEMD160_STEP (RIPEMD160_J , d2, e2, a2, b2, c2, w[ 7], RIPEMD160C50, RIPEMD160S52);
  RIPEMD160_STEP (RIPEMD160_J , c2, d2, e2, a2, b2, w[ 0], RIPEMD160C50, RIPEMD160S53);
  RIPEMD160_STEP (RIPEMD160_J , b2, c2, d2, e2, a2, w[ 9], RIPEMD160C50, RIPEMD160S54);
  RIPEMD160_STEP (RIPEMD160_J , a2, b2, c2, d2, e2, w[ 2], RIPEMD160C50, RIPEMD160S55);
  RIPEMD160_STEP (RIPEMD160_J , e2, a2, b2, c2, d2, w[11], RIPEMD160C50, RIPEMD160S56);
  RIPEMD160_STEP (RIPEMD160_J , d2, e2, a2, b2, c2, w[ 4], RIPEMD160C50, RIPEMD160S57);
  RIPEMD160_STEP (RIPEMD160_J , c2, d2, e2, a2, b2, w[13], RIPEMD160C50, RIPEMD160S58);
  RIPEMD160_STEP (RIPEMD160_J , b2, c2, d2, e2, a2, w[ 6], RIPEMD160C50, RIPEMD160S59);
  RIPEMD160_STEP (RIPEMD160_J , a2, b2, c2, d2, e2, w[15], RIPEMD160C50, RIPEMD160S5A);
  RIPEMD160_STEP (RIPEMD160_J , e2, a2, b2, c2, d2, w[ 8], RIPEMD160C50, RIPEMD160S5B);
  RIPEMD160_STEP (RIPEMD160_J , d2, e2, a2, b2, c2, w[ 1], RIPEMD160C50, RIPEMD160S5C);
  RIPEMD160_STEP (RIPEMD160_J , c2, d2, e2, a2, b2, w[10], RIPEMD160C50, RIPEMD160S5D);
  RIPEMD160_STEP (RIPEMD160_J , b2, c2, d2, e2, a2, w[ 3], RIPEMD160C50, RIPEMD160S5E);
  RIPEMD160_STEP (RIPEMD160_J , a2, b2, c2, d2, e2, w[12], RIPEMD160C50, RIPEMD160S5F);

  RIPEMD160_STEP (RIPEMD160_Io, e2, a2, b2, c2, d2, w[ 6], RIPEMD160C60, RIPEMD160S60);
  RIPEMD160_STEP (RIPEMD160_Io, d2, e2, a2, b2, c2, w[11], RIPEMD160C60, RIPEMD160S61);
  RIPEMD160_STEP (RIPEMD160_Io, c2, d2, e2, a2, b2, w[ 3], RIPEMD160C60, RIPEMD160S62);
  RIPEMD160_STEP (RIPEMD160_Io, b2, c2, d2, e2, a2, w[ 7], RIPEMD160C60, RIPEMD160S63);
  RIPEMD160_STEP (RIPEMD160_Io, a2, b2, c2, d2, e2, w[ 0], RIPEMD160C60, RIPEMD160S64);
  RIPEMD160_STEP (RIPEMD160_Io, e2, a2, b2, c2, d2, w[13], RIPEMD160C60, RIPEMD160S65);
  RIPEMD160_STEP (RIPEMD160_Io, d2, e2, a2, b2, c2, w[ 5], RIPEMD160C60, RIPEMD160S66);
  RIPEMD160_STEP (RIPEMD160_Io, c2, d2, e2, a2, b2, w[10], RIPEMD160C60, RIPEMD160S67);
  RIPEMD160_STEP (RIPEMD160_Io, b2, c2, d2, e2, a2, w[14], RIPEMD160C60, RIPEMD160S68);
  RIPEMD160_STEP (RIPEMD160_Io, a2, b2, c2, d2, e2, w[15], RIPEMD160C60, RIPEMD160S69);
  RIPEMD160_STEP (RIPEMD160_Io, e2, a2, b2, c2, d2, w[ 8], RIPEMD160C60, RIPEMD160S6A);
  RIPEMD160_STEP (RIPEMD160_Io, d2, e2, a2, b2, c2, w[12], RIPEMD160C60, RIPEMD160S6B);
  RIPEMD160_STEP (RIPEMD160_Io, c2, d2, e2, a2, b2, w[ 4], RIPEMD160C60, RIPEMD160S6C);
  RIPEMD160_STEP (RIPEMD160_Io, b2, c2, d2, e2, a2, w[ 9], RIPEMD160C60, RIPEMD160S6D);
  RIPEMD160_STEP (RIPEMD160_Io, a2, b2, c2, d2, e2, w[ 1], RIPEMD160C60, RIPEMD160S6E);
  RIPEMD160_STEP (RIPEMD160_Io, e2, a2, b2, c2, d2, w[ 2], RIPEMD160C60, RIPEMD160S6F);

  RIPEMD160_STEP (RIPEMD160_H , d2, e2, a2, b2, c2, w[15], RIPEMD160C70, RIPEMD160S70);
  RIPEMD160_STEP (RIPEMD160_H , c2, d2, e2, a2, b2, w[ 5], RIPEMD160C70, RIPEMD160S71);
  RIPEMD160_STEP (RIPEMD160_H , b2, c2, d2, e2, a2, w[ 1], RIPEMD160C70, RIPEMD160S72);
  RIPEMD160_STEP (RIPEMD160_H , a2, b2, c2, d2, e2, w[ 3], RIPEMD160C70, RIPEMD160S73);
  RIPEMD160_STEP (RIPEMD160_H , e2, a2, b2, c2, d2, w[ 7], RIPEMD160C70, RIPEMD160S74);
  RIPEMD160_STEP (RIPEMD160_H , d2, e2, a2, b2, c2, w[14], RIPEMD160C70, RIPEMD160S75);
  RIPEMD160_STEP (RIPEMD160_H , c2, d2, e2, a2, b2, w[ 6], RIPEMD160C70, RIPEMD160S76);
  RIPEMD160_STEP (RIPEMD160_H , b2, c2, d2, e2, a2, w[ 9], RIPEMD160C70, RIPEMD160S77);
  RIPEMD160_STEP (RIPEMD160_H , a2, b2, c2, d2, e2, w[11], RIPEMD160C70, RIPEMD160S78);
  RIPEMD160_STEP (RIPEMD160_H , e2, a2, b2, c2, d2, w[ 8], RIPEMD160C70, RIPEMD160S79);
  RIPEMD160_STEP (RIPEMD160_H , d2, e2, a2, b2, c2, w[12], RIPEMD160C70, RIPEMD160S7A);
  RIPEMD160_STEP (RIPEMD160_H , c2, d2, e2, a2, b2, w[ 2], RIPEMD160C70, RIPEMD160S7B);
  RIPEMD160_STEP (RIPEMD160_H , b2, c2, d2, e2, a2, w[10], RIPEMD160C70, RIPEMD160S7C);
  RIPEMD160_STEP (RIPEMD160_H , a2, b2, c2, d2, e2, w[ 0], RIPEMD160C70, RIPEMD160S7D);
  RIPEMD160_STEP (RIPEMD160_H , e2, a2, b2, c2, d2, w[ 4], RIPEMD160C70, RIPEMD160S7E);
  RIPEMD160_STEP (RIPEMD160_H , d2, e2, a2, b2, c2, w[13], RIPEMD160C70, RIPEMD160S7F);

  RIPEMD160_STEP (RIPEMD160_Go, c2, d2, e2, a2, b2, w[ 8], RIPEMD160C80, RIPEMD160S80);
  RIPEMD160_STEP (RIPEMD160_Go, b2, c2, d2, e2, a2, w[ 6], RIPEMD160C80, RIPEMD160S81);
  RIPEMD160_STEP (RIPEMD160_Go, a2, b2, c2, d2, e2, w[ 4], RIPEMD160C80, RIPEMD160S82);
  RIPEMD160_STEP (RIPEMD160_Go, e2, a2, b2, c2, d2, w[ 1], RIPEMD160C80, RIPEMD160S83);
  RIPEMD160_STEP (RIPEMD160_Go, d2, e2, a2, b2, c2, w[ 3], RIPEMD160C80, RIPEMD160S84);
  RIPEMD160_STEP (RIPEMD160_Go, c2, d2, e2, a2, b2, w[11], RIPEMD160C80, RIPEMD160S85);
  RIPEMD160_STEP (RIPEMD160_Go, b2, c2, d2, e2, a2, w[15], RIPEMD160C80, RIPEMD160S86);
  RIPEMD160_STEP (RIPEMD160_Go, a2, b2, c2, d2, e2, w[ 0], RIPEMD160C80, RIPEMD160S87);
  RIPEMD160_STEP (RIPEMD160_Go, e2, a2, b2, c2, d2, w[ 5], RIPEMD160C80, RIPEMD160S88);
  RIPEMD160_STEP (RIPEMD160_Go, d2, e2, a2, b2, c2, w[12], RIPEMD160C80, RIPEMD160S89);
  RIPEMD160_STEP (RIPEMD160_Go, c2, d2, e2, a2, b2, w[ 2], RIPEMD160C80, RIPEMD160S8A);
  RIPEMD160_STEP (RIPEMD160_Go, b2, c2, d2, e2, a2, w[13], RIPEMD160C80, RIPEMD160S8B);
  RIPEMD160_STEP (RIPEMD160_Go, a2, b2, c2, d2, e2, w[ 9], RIPEMD160C80, RIPEMD160S8C);
  RIPEMD160_STEP (RIPEMD160_Go, e2, a2, b2, c2, d2, w[ 7], RIPEMD160C80, RIPEMD160S8D);
  RIPEMD160_STEP (RIPEMD160_Go, d2, e2, a2, b2, c2, w[10], RIPEMD160C80, RIPEMD160S8E);
  RIPEMD160_STEP (RIPEMD160_Go, c2, d2, e2, a2, b2, w[14], RIPEMD160C80, RIPEMD160S8F);

  RIPEMD160_STEP (RIPEMD160_F , b2, c2, d2, e2, a2, w[12], RIPEMD160C90, RIPEMD160S90);
  RIPEMD160_STEP (RIPEMD160_F , a2, b2, c2, d2, e2, w[15], RIPEMD160C90, RIPEMD160S91);
  RIPEMD160_STEP (RIPEMD160_F , e2, a2, b2, c2, d2, w[10], RIPEMD160C90, RIPEMD160S92);
  RIPEMD160_STEP (RIPEMD160_F , d2, e2, a2, b2, c2, w[ 4], RIPEMD160C90, RIPEMD160S93);
  RIPEMD160_STEP (RIPEMD160_F , c2, d2, e2, a2, b2, w[ 1], RIPEMD160C90, RIPEMD160S94);
  RIPEMD160_STEP (RIPEMD160_F , b2, c2, d2, e2, a2, w[ 5], RIPEMD160C90, RIPEMD160S95);
  RIPEMD160_STEP (RIPEMD160_F , a2, b2, c2, d2, e2, w[ 8], RIPEMD160C90, RIPEMD160S96);
  RIPEMD160_STEP (RIPEMD160_F , e2, a2, b2, c2, d2, w[ 7], RIPEMD160C90, RIPEMD160S97);
  RIPEMD160_STEP (RIPEMD160_F , d2, e2, a2, b2, c2, w[ 6], RIPEMD160C90, RIPEMD160S98);
  RIPEMD160_STEP (RIPEMD160_F , c2, d2, e2, a2, b2, w[ 2], RIPEMD160C90, RIPEMD160S99);
  RIPEMD160_STEP (RIPEMD160_F , b2, c2, d2, e2, a2, w[13], RIPEMD160C90, RIPEMD160S9A);
  RIPEMD160_STEP (RIPEMD160_F , a2, b2, c2, d2, e2, w[14], RIPEMD160C90, RIPEMD160S9B);
  RIPEMD160_STEP (RIPEMD160_F , e2, a2, b2, c2, d2, w[ 0], RIPEMD160C90, RIPEMD160S9C);
  RIPEMD160_STEP (RIPEMD160_F , d2, e2, a2, b2, c2, w[ 3], RIPEMD160C90, RIPEMD160S9D);
  RIPEMD160_STEP (RIPEMD160_F , c2, d2, e2, a2, b2, w[ 9], RIPEMD160C90, RIPEMD160S9E);
  RIPEMD160_STEP (RIPEMD160_F , b2, c2, d2, e2, a2, w[11], RIPEMD160C90, RIPEMD160S9F);

  const u32 a = dgst[1] + c1 + d2;
  const u32 b = dgst[2] + d1 + e2;
  const u32 c = dgst[3] + e1 + a2;
  const u32 d = dgst[4] + a1 + b2;
  const u32 e = dgst[0] + b1 + c2;

  dgst[0] = a;
  dgst[1] = b;
  dgst[2] = c;
  dgst[3] = d;
  dgst[4] = e;
}

__kernel void m06000_m04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global netntlm_t *netntlm_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * modifier
   */

  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 wordl0[4];

  wordl0[0] = pws[gid].i[ 0];
  wordl0[1] = pws[gid].i[ 1];
  wordl0[2] = pws[gid].i[ 2];
  wordl0[3] = pws[gid].i[ 3];

  u32 wordl1[4];

  wordl1[0] = pws[gid].i[ 4];
  wordl1[1] = pws[gid].i[ 5];
  wordl1[2] = pws[gid].i[ 6];
  wordl1[3] = pws[gid].i[ 7];

  u32 wordl2[4];

  wordl2[0] = 0;
  wordl2[1] = 0;
  wordl2[2] = 0;
  wordl2[3] = 0;

  u32 wordl3[4];

  wordl3[0] = 0;
  wordl3[1] = 0;
  wordl3[2] = 0;
  wordl3[3] = 0;

  const u32 pw_l_len = pws[gid].pw_len;

  if (combs_mode == COMBINATOR_MODE_BASE_RIGHT)
  {
    append_0x80_2x4 (wordl0, wordl1, pw_l_len);

    switch_buffer_by_offset (wordl0, wordl1, wordl2, wordl3, combs_buf[0].pw_len);
  }

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < combs_cnt; il_pos++)
  {
    const u32 pw_r_len = combs_buf[il_pos].pw_len;

    const u32 pw_len = pw_l_len + pw_r_len;

    u32 wordr0[4];

    wordr0[0] = combs_buf[il_pos].i[0];
    wordr0[1] = combs_buf[il_pos].i[1];
    wordr0[2] = combs_buf[il_pos].i[2];
    wordr0[3] = combs_buf[il_pos].i[3];

    u32 wordr1[4];

    wordr1[0] = combs_buf[il_pos].i[4];
    wordr1[1] = combs_buf[il_pos].i[5];
    wordr1[2] = combs_buf[il_pos].i[6];
    wordr1[3] = combs_buf[il_pos].i[7];

    u32 wordr2[4];

    wordr2[0] = 0;
    wordr2[1] = 0;
    wordr2[2] = 0;
    wordr2[3] = 0;

    u32 wordr3[4];

    wordr3[0] = 0;
    wordr3[1] = 0;
    wordr3[2] = 0;
    wordr3[3] = 0;

    if (combs_mode == COMBINATOR_MODE_BASE_LEFT)
    {
      switch_buffer_by_offset (wordr0, wordr1, wordr2, wordr3, pw_l_len);
    }

    u32 w0[4];

    w0[0] = wordl0[0] | wordr0[0];
    w0[1] = wordl0[1] | wordr0[1];
    w0[2] = wordl0[2] | wordr0[2];
    w0[3] = wordl0[3] | wordr0[3];

    u32 w1[4];

    w1[0] = wordl1[0] | wordr1[0];
    w1[1] = wordl1[1] | wordr1[1];
    w1[2] = wordl1[2] | wordr1[2];
    w1[3] = wordl1[3] | wordr1[3];

    u32 w2[4];

    w2[0] = wordl2[0] | wordr2[0];
    w2[1] = wordl2[1] | wordr2[1];
    w2[2] = wordl2[2] | wordr2[2];
    w2[3] = wordl2[3] | wordr2[3];

    u32 w3[4];

    w3[0] = wordl3[0] | wordr3[0];
    w3[1] = wordl3[1] | wordr3[1];
    w3[2] = pw_len * 8;
    w3[3] = 0;

    u32 wl[16];

    wl[ 0] = w0[0];
    wl[ 1] = w0[1];
    wl[ 2] = w0[2];
    wl[ 3] = w0[3];
    wl[ 4] = w1[0];
    wl[ 5] = w1[1];
    wl[ 6] = w1[2];
    wl[ 7] = w1[3];
    wl[ 8] = 0;
    wl[ 9] = 0;
    wl[10] = 0;
    wl[11] = 0;
    wl[12] = 0;
    wl[13] = 0;
    wl[14] = pw_len * 8;
    wl[15] = 0;

    u32 dgst[5];

    dgst[0] = RIPEMD160M_A;
    dgst[1] = RIPEMD160M_B;
    dgst[2] = RIPEMD160M_C;
    dgst[3] = RIPEMD160M_D;
    dgst[4] = RIPEMD160M_E;

    ripemd160_transform (wl, dgst);

    const u32 r0 = dgst[0];
    const u32 r1 = dgst[1];
    const u32 r2 = dgst[2];
    const u32 r3 = dgst[3];

    #include COMPARE_M
  }
}

__kernel void m06000_m08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}

__kernel void m06000_m16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}

__kernel void m06000_s04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global netntlm_t *netntlm_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * modifier
   */

  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 wordl0[4];

  wordl0[0] = pws[gid].i[ 0];
  wordl0[1] = pws[gid].i[ 1];
  wordl0[2] = pws[gid].i[ 2];
  wordl0[3] = pws[gid].i[ 3];

  u32 wordl1[4];

  wordl1[0] = pws[gid].i[ 4];
  wordl1[1] = pws[gid].i[ 5];
  wordl1[2] = pws[gid].i[ 6];
  wordl1[3] = pws[gid].i[ 7];

  u32 wordl2[4];

  wordl2[0] = 0;
  wordl2[1] = 0;
  wordl2[2] = 0;
  wordl2[3] = 0;

  u32 wordl3[4];

  wordl3[0] = 0;
  wordl3[1] = 0;
  wordl3[2] = 0;
  wordl3[3] = 0;

  const u32 pw_l_len = pws[gid].pw_len;

  if (combs_mode == COMBINATOR_MODE_BASE_RIGHT)
  {
    append_0x80_2x4 (wordl0, wordl1, pw_l_len);

    switch_buffer_by_offset (wordl0, wordl1, wordl2, wordl3, combs_buf[0].pw_len);
  }

  /**
   * digest
   */

  const u32 search[4] =
  {
    digests_buf[digests_offset].digest_buf[DGST_R0],
    digests_buf[digests_offset].digest_buf[DGST_R1],
    digests_buf[digests_offset].digest_buf[DGST_R2],
    digests_buf[digests_offset].digest_buf[DGST_R3]
  };

  /**
   * loop
   */

  for (u32 il_pos = 0; il_pos < combs_cnt; il_pos++)
  {
    const u32 pw_r_len = combs_buf[il_pos].pw_len;

    const u32 pw_len = pw_l_len + pw_r_len;

    u32 wordr0[4];

    wordr0[0] = combs_buf[il_pos].i[0];
    wordr0[1] = combs_buf[il_pos].i[1];
    wordr0[2] = combs_buf[il_pos].i[2];
    wordr0[3] = combs_buf[il_pos].i[3];

    u32 wordr1[4];

    wordr1[0] = combs_buf[il_pos].i[4];
    wordr1[1] = combs_buf[il_pos].i[5];
    wordr1[2] = combs_buf[il_pos].i[6];
    wordr1[3] = combs_buf[il_pos].i[7];

    u32 wordr2[4];

    wordr2[0] = 0;
    wordr2[1] = 0;
    wordr2[2] = 0;
    wordr2[3] = 0;

    u32 wordr3[4];

    wordr3[0] = 0;
    wordr3[1] = 0;
    wordr3[2] = 0;
    wordr3[3] = 0;

    if (combs_mode == COMBINATOR_MODE_BASE_LEFT)
    {
      switch_buffer_by_offset (wordr0, wordr1, wordr2, wordr3, pw_l_len);
    }

    u32 w0[4];

    w0[0] = wordl0[0] | wordr0[0];
    w0[1] = wordl0[1] | wordr0[1];
    w0[2] = wordl0[2] | wordr0[2];
    w0[3] = wordl0[3] | wordr0[3];

    u32 w1[4];

    w1[0] = wordl1[0] | wordr1[0];
    w1[1] = wordl1[1] | wordr1[1];
    w1[2] = wordl1[2] | wordr1[2];
    w1[3] = wordl1[3] | wordr1[3];

    u32 w2[4];

    w2[0] = wordl2[0] | wordr2[0];
    w2[1] = wordl2[1] | wordr2[1];
    w2[2] = wordl2[2] | wordr2[2];
    w2[3] = wordl2[3] | wordr2[3];

    u32 w3[4];

    w3[0] = wordl3[0] | wordr3[0];
    w3[1] = wordl3[1] | wordr3[1];
    w3[2] = pw_len * 8;
    w3[3] = 0;

    u32 wl[16];

    wl[ 0] = w0[0];
    wl[ 1] = w0[1];
    wl[ 2] = w0[2];
    wl[ 3] = w0[3];
    wl[ 4] = w1[0];
    wl[ 5] = w1[1];
    wl[ 6] = w1[2];
    wl[ 7] = w1[3];
    wl[ 8] = 0;
    wl[ 9] = 0;
    wl[10] = 0;
    wl[11] = 0;
    wl[12] = 0;
    wl[13] = 0;
    wl[14] = pw_len * 8;
    wl[15] = 0;

    u32 dgst[5];

    dgst[0] = RIPEMD160M_A;
    dgst[1] = RIPEMD160M_B;
    dgst[2] = RIPEMD160M_C;
    dgst[3] = RIPEMD160M_D;
    dgst[4] = RIPEMD160M_E;

    ripemd160_transform (wl, dgst);

    const u32 r0 = dgst[0];
    const u32 r1 = dgst[1];
    const u32 r2 = dgst[2];
    const u32 r3 = dgst[3];

    #include COMPARE_S
  }
}

__kernel void m06000_s08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}

__kernel void m06000_s16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __global bf_t *bfs_buf, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 combs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
}
