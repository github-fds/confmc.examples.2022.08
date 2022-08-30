#ifndef MEM_API_H
#define MEM_API_H
//------------------------------------------------------------------------------
// Copyright (c) 2018 by Future Design Systems
// All right reserved.
// http://www.future-ds.com
//------------------------------------------------------------------------------
// mem_api.h
//------------------------------------------------------------------------------
// VERSION = 2018.04.27.
//------------------------------------------------------------------------------
#ifdef __cplusplus
extern "C" {
#endif

extern void mem_test(unsigned int saddr, unsigned int depth, int level);
extern int  MemTestRAW(unsigned int saddr, unsigned int depth, unsigned int size);
extern int  MemTestBurstRAW(unsigned int saddr, unsigned int depth, unsigned int leng);
extern int  MemTestAddWr(unsigned int saddr, unsigned int depth);
extern int  MemTestAddRr(unsigned int saddr, unsigned int depth);
extern int  MemTestAddRAW(unsigned int saddr, unsigned int depth);

#ifdef __cplusplus
}
#endif

//------------------------------------------------------------------------------
// Revision History
//
// 2018.04.27: Start by Ando Ki (adki@future-ds.com)
//------------------------------------------------------------------------------
#endif
