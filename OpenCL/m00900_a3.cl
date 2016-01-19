/**
 * Author......: Jens Steube <jens.steube@gmail.com>
 * License.....: MIT
 */

#define _MD4_

#include "include/constants.h"
#include "include/kernel_vendor.h"

#define DGST_R0 0
#define DGST_R1 3
#define DGST_R2 2
#define DGST_R3 1

#include "include/kernel_functions.c"
#include "OpenCL/types_ocl.c"
#include "OpenCL/common.c"

#define COMPARE_S "OpenCL/check_single_comp4.c"
#define COMPARE_M "OpenCL/check_multi_comp4.c"

#define MD4_STEP_REV(f,a,b,c,d,x,t,s)   \
{                                       \
  a  = rotr32 (a, s);                   \
  a -= f (b, c, d);                     \
  a -= x;                               \
  a -= t;                               \
}

#define MD4_STEP_REV1(f,a,b,c,d,x,t,s)  \
{                                       \
  a  = rotr32 (a, s);                   \
  a -= x;                               \
  a -= t;                               \
}

static void m00900m (u32 w[16], const u32 pw_len, __global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset)
{
  /**
   * modifier
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 F_w0c00 =     0 + MD4C00;
  const u32 F_w1c00 = w[ 1] + MD4C00;
  const u32 F_w2c00 = w[ 2] + MD4C00;
  const u32 F_w3c00 = w[ 3] + MD4C00;
  const u32 F_w4c00 = w[ 4] + MD4C00;
  const u32 F_w5c00 = w[ 5] + MD4C00;
  const u32 F_w6c00 = w[ 6] + MD4C00;
  const u32 F_w7c00 = w[ 7] + MD4C00;
  const u32 F_w8c00 = w[ 8] + MD4C00;
  const u32 F_w9c00 = w[ 9] + MD4C00;
  const u32 F_wac00 = w[10] + MD4C00;
  const u32 F_wbc00 = w[11] + MD4C00;
  const u32 F_wcc00 = w[12] + MD4C00;
  const u32 F_wdc00 = w[13] + MD4C00;
  const u32 F_wec00 = w[14] + MD4C00;
  const u32 F_wfc00 = w[15] + MD4C00;

  const u32 G_w0c01 =     0 + MD4C01;
  const u32 G_w4c01 = w[ 4] + MD4C01;
  const u32 G_w8c01 = w[ 8] + MD4C01;
  const u32 G_wcc01 = w[12] + MD4C01;
  const u32 G_w1c01 = w[ 1] + MD4C01;
  const u32 G_w5c01 = w[ 5] + MD4C01;
  const u32 G_w9c01 = w[ 9] + MD4C01;
  const u32 G_wdc01 = w[13] + MD4C01;
  const u32 G_w2c01 = w[ 2] + MD4C01;
  const u32 G_w6c01 = w[ 6] + MD4C01;
  const u32 G_wac01 = w[10] + MD4C01;
  const u32 G_wec01 = w[14] + MD4C01;
  const u32 G_w3c01 = w[ 3] + MD4C01;
  const u32 G_w7c01 = w[ 7] + MD4C01;
  const u32 G_wbc01 = w[11] + MD4C01;
  const u32 G_wfc01 = w[15] + MD4C01;

  const u32 H_w0c02 =     0 + MD4C02;
  const u32 H_w8c02 = w[ 8] + MD4C02;
  const u32 H_w4c02 = w[ 4] + MD4C02;
  const u32 H_wcc02 = w[12] + MD4C02;
  const u32 H_w2c02 = w[ 2] + MD4C02;
  const u32 H_wac02 = w[10] + MD4C02;
  const u32 H_w6c02 = w[ 6] + MD4C02;
  const u32 H_wec02 = w[14] + MD4C02;
  const u32 H_w1c02 = w[ 1] + MD4C02;
  const u32 H_w9c02 = w[ 9] + MD4C02;
  const u32 H_w5c02 = w[ 5] + MD4C02;
  const u32 H_wdc02 = w[13] + MD4C02;
  const u32 H_w3c02 = w[ 3] + MD4C02;
  const u32 H_wbc02 = w[11] + MD4C02;
  const u32 H_w7c02 = w[ 7] + MD4C02;
  const u32 H_wfc02 = w[15] + MD4C02;

  /**
   * loop
   */

  u32 w0l = w[0];

  for (u32 il_pos = 0; il_pos < bfs_cnt; il_pos++)
  {
    const u32 w0r = words_buf_r[il_pos];

    const u32 w0 = w0l | w0r;

    u32 a = MD4M_A;
    u32 b = MD4M_B;
    u32 c = MD4M_C;
    u32 d = MD4M_D;

    MD4_STEP (MD4_Fo, a, b, c, d, w0, F_w0c00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_w1c00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_w2c00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_w3c00, MD4S03);
    MD4_STEP0(MD4_Fo, a, b, c, d,     F_w4c00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_w5c00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_w6c00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_w7c00, MD4S03);
    MD4_STEP0(MD4_Fo, a, b, c, d,     F_w8c00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_w9c00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_wac00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_wbc00, MD4S03);
    MD4_STEP0(MD4_Fo, a, b, c, d,     F_wcc00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_wdc00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_wec00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_wfc00, MD4S03);

    MD4_STEP (MD4_Go, a, b, c, d, w0, G_w0c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w4c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_w8c01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wcc01, MD4S13);
    MD4_STEP0(MD4_Go, a, b, c, d,     G_w1c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w5c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_w9c01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wdc01, MD4S13);
    MD4_STEP0(MD4_Go, a, b, c, d,     G_w2c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w6c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_wac01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wec01, MD4S13);
    MD4_STEP0(MD4_Go, a, b, c, d,     G_w3c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w7c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_wbc01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wfc01, MD4S13);

    MD4_STEP (MD4_H , a, b, c, d, w0, H_w0c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_w8c02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w4c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wcc02, MD4S23);
    MD4_STEP0(MD4_H , a, b, c, d,     H_w2c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_wac02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w6c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wec02, MD4S23);
    MD4_STEP0(MD4_H , a, b, c, d,     H_w1c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_w9c02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w5c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wdc02, MD4S23);
    MD4_STEP0(MD4_H , a, b, c, d,     H_w3c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_wbc02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w7c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wfc02, MD4S23);

    const u32 r0 = a;
    const u32 r1 = d;
    const u32 r2 = c;
    const u32 r3 = b;

    #include COMPARE_M
  }
}

static void m00900s (u32 w[16], const u32 pw_len, __global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset)
{
  /**
   * modifier
   */

  const u32 gid = get_global_id (0);
  const u32 lid = get_local_id (0);

  /**
   * base
   */

  const u32 F_w0c00 =     0 + MD4C00;
  const u32 F_w1c00 = w[ 1] + MD4C00;
  const u32 F_w2c00 = w[ 2] + MD4C00;
  const u32 F_w3c00 = w[ 3] + MD4C00;
  const u32 F_w4c00 = w[ 4] + MD4C00;
  const u32 F_w5c00 = w[ 5] + MD4C00;
  const u32 F_w6c00 = w[ 6] + MD4C00;
  const u32 F_w7c00 = w[ 7] + MD4C00;
  const u32 F_w8c00 = w[ 8] + MD4C00;
  const u32 F_w9c00 = w[ 9] + MD4C00;
  const u32 F_wac00 = w[10] + MD4C00;
  const u32 F_wbc00 = w[11] + MD4C00;
  const u32 F_wcc00 = w[12] + MD4C00;
  const u32 F_wdc00 = w[13] + MD4C00;
  const u32 F_wec00 = w[14] + MD4C00;
  const u32 F_wfc00 = w[15] + MD4C00;

  const u32 G_w0c01 =     0 + MD4C01;
  const u32 G_w4c01 = w[ 4] + MD4C01;
  const u32 G_w8c01 = w[ 8] + MD4C01;
  const u32 G_wcc01 = w[12] + MD4C01;
  const u32 G_w1c01 = w[ 1] + MD4C01;
  const u32 G_w5c01 = w[ 5] + MD4C01;
  const u32 G_w9c01 = w[ 9] + MD4C01;
  const u32 G_wdc01 = w[13] + MD4C01;
  const u32 G_w2c01 = w[ 2] + MD4C01;
  const u32 G_w6c01 = w[ 6] + MD4C01;
  const u32 G_wac01 = w[10] + MD4C01;
  const u32 G_wec01 = w[14] + MD4C01;
  const u32 G_w3c01 = w[ 3] + MD4C01;
  const u32 G_w7c01 = w[ 7] + MD4C01;
  const u32 G_wbc01 = w[11] + MD4C01;
  const u32 G_wfc01 = w[15] + MD4C01;

  const u32 H_w0c02 =     0 + MD4C02;
  const u32 H_w8c02 = w[ 8] + MD4C02;
  const u32 H_w4c02 = w[ 4] + MD4C02;
  const u32 H_wcc02 = w[12] + MD4C02;
  const u32 H_w2c02 = w[ 2] + MD4C02;
  const u32 H_wac02 = w[10] + MD4C02;
  const u32 H_w6c02 = w[ 6] + MD4C02;
  const u32 H_wec02 = w[14] + MD4C02;
  const u32 H_w1c02 = w[ 1] + MD4C02;
  const u32 H_w9c02 = w[ 9] + MD4C02;
  const u32 H_w5c02 = w[ 5] + MD4C02;
  const u32 H_wdc02 = w[13] + MD4C02;
  const u32 H_w3c02 = w[ 3] + MD4C02;
  const u32 H_wbc02 = w[11] + MD4C02;
  const u32 H_w7c02 = w[ 7] + MD4C02;
  const u32 H_wfc02 = w[15] + MD4C02;

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
   * reverse
   */

  u32 a_rev = digests_buf[digests_offset].digest_buf[0];
  u32 b_rev = digests_buf[digests_offset].digest_buf[1];
  u32 c_rev = digests_buf[digests_offset].digest_buf[2];
  u32 d_rev = digests_buf[digests_offset].digest_buf[3];

  MD4_STEP_REV (MD4_H, b_rev, c_rev, d_rev, a_rev, w[15], MD4C02, MD4S23);
  MD4_STEP_REV (MD4_H, c_rev, d_rev, a_rev, b_rev, w[ 7], MD4C02, MD4S22);
  MD4_STEP_REV (MD4_H, d_rev, a_rev, b_rev, c_rev, w[11], MD4C02, MD4S21);
  MD4_STEP_REV (MD4_H, a_rev, b_rev, c_rev, d_rev, w[ 3], MD4C02, MD4S20);
  MD4_STEP_REV (MD4_H, b_rev, c_rev, d_rev, a_rev, w[13], MD4C02, MD4S23);
  MD4_STEP_REV (MD4_H, c_rev, d_rev, a_rev, b_rev, w[ 5], MD4C02, MD4S22);
  MD4_STEP_REV (MD4_H, d_rev, a_rev, b_rev, c_rev, w[ 9], MD4C02, MD4S21);
  MD4_STEP_REV (MD4_H, a_rev, b_rev, c_rev, d_rev, w[ 1], MD4C02, MD4S20);
  MD4_STEP_REV (MD4_H, b_rev, c_rev, d_rev, a_rev, w[14], MD4C02, MD4S23);
  MD4_STEP_REV (MD4_H, c_rev, d_rev, a_rev, b_rev, w[ 6], MD4C02, MD4S22);
  MD4_STEP_REV (MD4_H, d_rev, a_rev, b_rev, c_rev, w[10], MD4C02, MD4S21);
  MD4_STEP_REV (MD4_H, a_rev, b_rev, c_rev, d_rev, w[ 2], MD4C02, MD4S20);
  MD4_STEP_REV (MD4_H, b_rev, c_rev, d_rev, a_rev, w[12], MD4C02, MD4S23);
  MD4_STEP_REV (MD4_H, c_rev, d_rev, a_rev, b_rev, w[ 4], MD4C02, MD4S22);
  MD4_STEP_REV (MD4_H, d_rev, a_rev, b_rev, c_rev, w[ 8], MD4C02, MD4S21);
  MD4_STEP_REV (MD4_H, a_rev, b_rev, c_rev, d_rev,     0, MD4C02, MD4S20);

  const u32 sav_c = c_rev;
  const u32 sav_d = d_rev;

  MD4_STEP_REV1(MD4_G, b_rev, c_rev, d_rev, a_rev, w[15], MD4C01, MD4S13);
  MD4_STEP_REV1(MD4_G, c_rev, d_rev, a_rev, b_rev, w[11], MD4C01, MD4S12);

  /**
   * loop
   */

  u32 w0l = w[0];

  for (u32 il_pos = 0; il_pos < bfs_cnt; il_pos++)
  {
    const u32 w0r = words_buf_r[il_pos];

    const u32 w0 = w0l | w0r;

    u32 pre_a = a_rev;
    u32 pre_b = b_rev;
    u32 pre_c = c_rev;

    pre_a = pre_a - w0;
    pre_b = pre_b - MD4_G (sav_c, sav_d, pre_a);
    pre_c = pre_c - MD4_G (sav_d, pre_a, pre_b);

    u32 a = MD4M_A;
    u32 b = MD4M_B;
    u32 c = MD4M_C;
    u32 d = MD4M_D;

    MD4_STEP (MD4_Fo, a, b, c, d, w0, F_w0c00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_w1c00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_w2c00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_w3c00, MD4S03);
    MD4_STEP0(MD4_Fo, a, b, c, d,     F_w4c00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_w5c00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_w6c00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_w7c00, MD4S03);
    MD4_STEP0(MD4_Fo, a, b, c, d,     F_w8c00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_w9c00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_wac00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_wbc00, MD4S03);
    MD4_STEP0(MD4_Fo, a, b, c, d,     F_wcc00, MD4S00);
    MD4_STEP0(MD4_Fo, d, a, b, c,     F_wdc00, MD4S01);
    MD4_STEP0(MD4_Fo, c, d, a, b,     F_wec00, MD4S02);
    MD4_STEP0(MD4_Fo, b, c, d, a,     F_wfc00, MD4S03);

    MD4_STEP (MD4_Go, a, b, c, d, w0, G_w0c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w4c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_w8c01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wcc01, MD4S13);
    MD4_STEP0(MD4_Go, a, b, c, d,     G_w1c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w5c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_w9c01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wdc01, MD4S13);
    MD4_STEP0(MD4_Go, a, b, c, d,     G_w2c01, MD4S10);
    MD4_STEP0(MD4_Go, d, a, b, c,     G_w6c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_wac01, MD4S12);

    bool q_cond = allx (pre_c != c);

    if (q_cond) continue;

    MD4_STEP0(MD4_Go, b, c, d, a,     G_wec01, MD4S13);
    MD4_STEP0(MD4_Go, a, b, c, d,     G_w3c01, MD4S10);

    bool q_cond2 = allx (pre_a != a);

    if (q_cond2) continue;

    MD4_STEP0(MD4_Go, d, a, b, c,     G_w7c01, MD4S11);
    MD4_STEP0(MD4_Go, c, d, a, b,     G_wbc01, MD4S12);
    MD4_STEP0(MD4_Go, b, c, d, a,     G_wfc01, MD4S13);

    MD4_STEP (MD4_H , a, b, c, d, w0, H_w0c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_w8c02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w4c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wcc02, MD4S23);
    MD4_STEP0(MD4_H , a, b, c, d,     H_w2c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_wac02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w6c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wec02, MD4S23);
    MD4_STEP0(MD4_H , a, b, c, d,     H_w1c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_w9c02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w5c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wdc02, MD4S23);
    MD4_STEP0(MD4_H , a, b, c, d,     H_w3c02, MD4S20);
    MD4_STEP0(MD4_H , d, a, b, c,     H_wbc02, MD4S21);
    MD4_STEP0(MD4_H , c, d, a, b,     H_w7c02, MD4S22);
    MD4_STEP0(MD4_H , b, c, d, a,     H_wfc02, MD4S23);

    const u32 r0 = a;
    const u32 r1 = d;
    const u32 r2 = c;
    const u32 r3 = b;

    #include COMPARE_S
  }
}

__kernel void m00900_m04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = 0;
  w[ 5] = 0;
  w[ 6] = 0;
  w[ 7] = 0;
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = pws[gid].i[14];
  w[15] = 0;

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00900m (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, bfs_cnt, digests_cnt, digests_offset);
}

__kernel void m00900_m08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = pws[gid].i[14];
  w[15] = 0;

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00900m (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, bfs_cnt, digests_cnt, digests_offset);
}

__kernel void m00900_m16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = pws[gid].i[ 8];
  w[ 9] = pws[gid].i[ 9];
  w[10] = pws[gid].i[10];
  w[11] = pws[gid].i[11];
  w[12] = pws[gid].i[12];
  w[13] = pws[gid].i[13];
  w[14] = pws[gid].i[14];
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00900m (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, bfs_cnt, digests_cnt, digests_offset);
}

__kernel void m00900_s04 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = 0;
  w[ 5] = 0;
  w[ 6] = 0;
  w[ 7] = 0;
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = pws[gid].i[14];
  w[15] = 0;

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00900s (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, bfs_cnt, digests_cnt, digests_offset);
}

__kernel void m00900_s08 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = 0;
  w[ 9] = 0;
  w[10] = 0;
  w[11] = 0;
  w[12] = 0;
  w[13] = 0;
  w[14] = pws[gid].i[14];
  w[15] = 0;

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00900s (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, bfs_cnt, digests_cnt, digests_offset);
}

__kernel void m00900_s16 (__global pw_t *pws, __global kernel_rule_t *rules_buf, __global comb_t *combs_buf, __constant u32 * words_buf_r, __global void *tmps, __global void *hooks, __global u32 *bitmaps_buf_s1_a, __global u32 *bitmaps_buf_s1_b, __global u32 *bitmaps_buf_s1_c, __global u32 *bitmaps_buf_s1_d, __global u32 *bitmaps_buf_s2_a, __global u32 *bitmaps_buf_s2_b, __global u32 *bitmaps_buf_s2_c, __global u32 *bitmaps_buf_s2_d, __global plain_t *plains_buf, __global digest_t *digests_buf, __global u32 *hashes_shown, __global salt_t *salt_bufs, __global void *esalt_bufs, __global u32 *d_return_buf, __global u32 *d_scryptV_buf, const u32 bitmap_mask, const u32 bitmap_shift1, const u32 bitmap_shift2, const u32 salt_pos, const u32 loop_pos, const u32 loop_cnt, const u32 bfs_cnt, const u32 digests_cnt, const u32 digests_offset, const u32 combs_mode, const u32 gid_max)
{
  /**
   * base
   */

  const u32 gid = get_global_id (0);

  if (gid >= gid_max) return;

  u32 w[16];

  w[ 0] = pws[gid].i[ 0];
  w[ 1] = pws[gid].i[ 1];
  w[ 2] = pws[gid].i[ 2];
  w[ 3] = pws[gid].i[ 3];
  w[ 4] = pws[gid].i[ 4];
  w[ 5] = pws[gid].i[ 5];
  w[ 6] = pws[gid].i[ 6];
  w[ 7] = pws[gid].i[ 7];
  w[ 8] = pws[gid].i[ 8];
  w[ 9] = pws[gid].i[ 9];
  w[10] = pws[gid].i[10];
  w[11] = pws[gid].i[11];
  w[12] = pws[gid].i[12];
  w[13] = pws[gid].i[13];
  w[14] = pws[gid].i[14];
  w[15] = pws[gid].i[15];

  const u32 pw_len = pws[gid].pw_len;

  /**
   * main
   */

  m00900s (w, pw_len, pws, rules_buf, combs_buf, words_buf_r, tmps, hooks, bitmaps_buf_s1_a, bitmaps_buf_s1_b, bitmaps_buf_s1_c, bitmaps_buf_s1_d, bitmaps_buf_s2_a, bitmaps_buf_s2_b, bitmaps_buf_s2_c, bitmaps_buf_s2_d, plains_buf, digests_buf, hashes_shown, salt_bufs, esalt_bufs, d_return_buf, d_scryptV_buf, bitmap_mask, bitmap_shift1, bitmap_shift2, salt_pos, loop_pos, loop_cnt, bfs_cnt, digests_cnt, digests_offset);
}
