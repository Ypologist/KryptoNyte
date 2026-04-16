#ifndef CORE_PORTME_H
#define CORE_PORTME_H

#include <stddef.h>
#include <stdint.h>

/* Platform capabilities */
#define HAS_FLOAT   0
#define HAS_TIME_H  0
#define USE_CLOCK   0
#define HAS_STDIO   0
#define HAS_PRINTF  0

/* Execution model */
#define MEM_METHOD      MEM_MALLOC
#define SEED_METHOD     SEED_VOLATILE
#define MULTITHREAD     1
#define MAIN_HAS_NOARGC 1
#define MAIN_HAS_NORETURN 0

#ifndef TOTAL_DATA_SIZE
#define TOTAL_DATA_SIZE (2 * 1000)
#endif

#ifndef COMPILER_VERSION
#ifdef __GNUC__
#define COMPILER_VERSION "GCC " __VERSION__
#else
#define COMPILER_VERSION "unknown"
#endif
#endif

#ifndef COMPILER_FLAGS
#define COMPILER_FLAGS "-march=rv32i_zicsr -mabi=ilp32 -O2 -ffreestanding"
#endif

#ifndef MEM_LOCATION
#define MEM_LOCATION "FLASH"
#endif

/* CoreMark required typedefs */
typedef signed short   ee_s16;
typedef unsigned short ee_u16;
typedef signed int     ee_s32;
typedef unsigned int   ee_u32;
typedef unsigned char  ee_u8;
typedef unsigned int   ee_ptr_int;
typedef size_t         ee_size_t;
typedef ee_u32         CORE_TICKS;

#define align_mem(x) (void *)(4 + (((ee_ptr_int)(x) - 1) & ~3))

typedef struct CORE_PORTABLE_S {
  ee_u32 portable_id;
} core_portable;

extern ee_u32 default_num_contexts;

void portable_init(core_portable *p, int *argc, char *argv[]);
void portable_fini(core_portable *p);
void *portable_malloc(ee_size_t size);
void portable_free(void *p);
int ee_printf(const char *fmt, ...);

#endif  /* CORE_PORTME_H */
