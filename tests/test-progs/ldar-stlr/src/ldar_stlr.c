#include <stdint.h>
#include <string.h>

static inline __attribute__((__always_inline__))
void do_st_rel(volatile uint32_t *loc, uint32_t val) {
    asm volatile("stlr %w[val], %[loc]\n"
    ::[loc] "Q"(*loc), [val] "r"(val) : "memory");
}

static __attribute__((always_inline)) inline
uint32_t do_ld_ac(volatile uint32_t *loc) {
    int val;
    asm volatile("ldar %w0, %1"
                 : "=r"(val)
                 : "Q"(*loc) : "memory");
    __asm__ __volatile__("" ::: "memory");
    return val;
}

uint32_t ac_loc;
uint32_t rel_loc;

#define PAYLOAD_SIZE 1024
uint32_t payload_src[1024];
uint32_t payload_dst[1024];

__attribute__((noinline)) void
run_acq_rel()
{
    uint32_t ac_val;

    ac_val = do_ld_ac(&ac_loc);
    memcpy(&payload_dst, &payload_src, PAYLOAD_SIZE * sizeof(uint32_t));
    do_st_rel(&rel_loc, ac_val + 1);

    ac_val = do_ld_ac(&ac_loc);
    memcpy(&payload_dst, &payload_src, PAYLOAD_SIZE * sizeof(uint32_t));
    do_st_rel(&rel_loc, ac_val + 1);
}

int main(int argc, char **argv)
{
    run_acq_rel();
    return 0;
}
