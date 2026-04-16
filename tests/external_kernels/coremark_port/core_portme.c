#include "coremark.h"

#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>

#define COREMARK_SIGNATURE_WORDS 32u
#ifndef COREMARK_THREAD_LABEL
#define COREMARK_THREAD_LABEL 0u
#endif
#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

__attribute__((section(".signature")))
volatile uint32_t coremark_signature_buffer[COREMARK_SIGNATURE_WORDS];

__asm__(".globl begin_signature\n"
        "begin_signature = coremark_signature_buffer\n");
__asm__(".globl end_signature\n"
        "end_signature = coremark_signature_buffer + "
        STR(COREMARK_SIGNATURE_WORDS * 4) "\n");

extern volatile uint64_t tohost;
extern volatile uint64_t fromhost;

#if VALIDATION_RUN
volatile ee_s32 seed1_volatile = 0x3415;
volatile ee_s32 seed2_volatile = 0x3415;
volatile ee_s32 seed3_volatile = 0x66;
#endif
#if PERFORMANCE_RUN
volatile ee_s32 seed1_volatile = 0x0;
volatile ee_s32 seed2_volatile = 0x0;
volatile ee_s32 seed3_volatile = 0x66;
#endif
#if PROFILE_RUN
volatile ee_s32 seed1_volatile = 0x8;
volatile ee_s32 seed2_volatile = 0x8;
volatile ee_s32 seed3_volatile = 0x8;
#endif
volatile ee_s32 seed4_volatile = ITERATIONS;
volatile ee_s32 seed5_volatile = 0;

static CORE_TICKS cycle_start;
static CORE_TICKS cycle_stop;
static CORE_TICKS last_ticks;
static core_results *global_results;
static ee_size_t heap_offset;

#define COREMARK_HEAP_SIZE (64u * 1024u)
static uint8_t coremark_heap[COREMARK_HEAP_SIZE];

ee_u32 default_num_contexts = 1;

static inline CORE_TICKS read_cycle(void) {
  static CORE_TICKS synthetic_ticks = 0;
  return ++synthetic_ticks;
}

static inline core_results *port_to_results(core_portable *p) {
  if (p == NULL) {
    return NULL;
  }
  uintptr_t base = (uintptr_t)p - offsetof(core_results, port);
  return (core_results *)base;
}

static void record_signature(const core_results *res) {
  if (!res) {
    return;
  }
  coremark_signature_buffer[0] = (uint32_t)res->crc;
  coremark_signature_buffer[1] = (uint32_t)res->crclist;
  coremark_signature_buffer[2] = (uint32_t)res->crcmatrix;
  coremark_signature_buffer[3] = (uint32_t)res->crcstate;
  coremark_signature_buffer[4] = (uint32_t)res->iterations;
  coremark_signature_buffer[5] = (uint32_t)res->execs;
  coremark_signature_buffer[6] = (uint32_t)(uint16_t)res->seed1;
  coremark_signature_buffer[7] = (uint32_t)(uint16_t)res->seed2;
  coremark_signature_buffer[8] = (uint32_t)(uint16_t)res->seed3;
  coremark_signature_buffer[9] = (uint32_t)res->size;
  coremark_signature_buffer[10] = (uint32_t)res->err;
  coremark_signature_buffer[11] = last_ticks;
  coremark_signature_buffer[12] = 0xC01ECAFEu;
  coremark_signature_buffer[13] = COREMARK_THREAD_LABEL;
  coremark_signature_buffer[14] = (uint32_t)res->err;
}

void start_time(void) {
  cycle_start = read_cycle();
}

void stop_time(void) {
  cycle_stop = read_cycle();
  last_ticks = cycle_stop - cycle_start;
}

CORE_TICKS get_time(void) {
  return cycle_stop - cycle_start;
}

secs_ret time_in_secs(CORE_TICKS ticks) {
  return (secs_ret)ticks;
}

void portable_init(core_portable *p, int *argc, char *argv[]) {
  (void)argc;
  (void)argv;
  if (p) {
    p->portable_id = 1;
    global_results = port_to_results(p);
  }
  heap_offset = 0;
}

void portable_fini(core_portable *p) {
  (void)p;
  if (global_results) {
    record_signature(global_results);
    if (global_results->err != 0) {
      coremark_signature_buffer[15] =
          0xBAD00000u | ((uint32_t)global_results->err & 0xFFFFu);
    } else {
      coremark_signature_buffer[15] = 0;
    }
  }
  tohost = 1;
}

void *portable_malloc(ee_size_t size) {
  const ee_size_t align = 8u;
  ee_size_t aligned_offset = (heap_offset + (align - 1u)) & ~(align - 1u);
  if (size == 0 || aligned_offset + size > COREMARK_HEAP_SIZE) {
    return NULL;
  }
  void *ptr = &coremark_heap[aligned_offset];
  heap_offset = aligned_offset + size;
  return ptr;
}

void portable_free(void *p) {
  (void)p;
}

int ee_printf(const char *fmt, ...) {
  (void)fmt;
  return 0;
}
