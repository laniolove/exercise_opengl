//
//  PXILTypes.h
//  PXImageLib
//
//  Created by Rolan Reznik on 28/08/13.
//
//

#ifndef PXImageLib_PXILTypes_h
#define PXImageLib_PXILTypes_h

typedef NS_ENUM(uint16_t, PXILMultithreadMode) {
    PXILMultithreadModeDisabled,
    PXILMultithreadModeUseLogicalCPUs,
    PXILMultithreadModeUseHardwareCPUs
};

typedef uint32_t PXILMultithreadOptions;


static inline PXILMultithreadOptions PXILPackMultithreadOptions(PXILMultithreadMode mode, uint maxThreads)
{
    return mode | maxThreads << 16;
}

static inline uint32_t PXILUnPackMultithreadMode(PXILMultithreadOptions options)
{
    return (options << 16) >> 16;
}

static inline uint32_t PXILUnPackMaxThreads(PXILMultithreadOptions options)
{
    return options >> 16;
}

#endif
