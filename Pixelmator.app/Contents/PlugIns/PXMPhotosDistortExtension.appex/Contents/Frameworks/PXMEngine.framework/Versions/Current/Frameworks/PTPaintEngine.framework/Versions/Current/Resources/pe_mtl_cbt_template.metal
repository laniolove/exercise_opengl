//
//  pe_mtl_cbt_template.metal
//  libpaintengine
//
//  Created by Georgy Ostrobrod on 28/03/16.
//  Copyright © 2016 Pixelmator. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;



#define DITHER_COEFFICIENT 0.004



template <typename T>
vec<T, 4> custom_process(
    texture2d<T, access::sample> srcTexture,
    float2 current_position,
    vec<T, 4> mask_value,
    float2 pixel_step,
    float amount,
    float2 params2,
    float4 params4);



// -------------------------------- Types --------------------------------------

struct BasicPaintingOutput {
    float4 m_Position   [[position]];
    float4 m_Utility    [[user(utility)]];
    float4 m_Color      [[user(color)]];
    float2 m_ShapeCoord [[user(shapecoord)]];
    float2 m_GrainCoord [[user(graincoord)]];
    float  m_DabEdge    [[user(dabedge)]];
};



struct BasicIO {
    float4 m_Position [[position]];
    float2 m_TexCoord [[user(texturecoord)]];
};



struct CustomToolOptions {
    float2 m_PixelStep;
    float2 m_Params2;
    float4 m_Params4;
    float amount;
    float reserved1;
    float reserved2;
    float reserved3;
};



struct MergeOptions {
    int m_Options        [[user(options)]];
    int m_AlphaIndex     [[user(alphaindex)]];
    int m_BlendType      [[user(blendtype)]];
    int m_Reserved0;
    float4 m_Color       [[user(color)]];
    float m_OpacityLimit [[user(opacitylimit)]];
    float m_Reserved1;
};



enum FragmentPaintingOptions {
    PAINT_OPTIONS_NONE           = 0,
    PAINT_OPTIONS_USE_SELECTION  = 1,
    PAINT_OPTIONS_USE_ALPHA_LOCK = 2,
    PAINT_OPTIONS_USE_COMBINED   = 4,
    PAINT_OPTIONS_USE_SHAPE      = 8,
    PAINT_OPTIONS_USE_GRAIN      = 16
};



enum FragmentMergeOptions {
    MERGE_OPTIONS_NONE           = 0,
    MERGE_OPTIONS_TWO_TEXTURES   = 1,
    MERGE_OPTIONS_USE_BACKGROUND = MERGE_OPTIONS_TWO_TEXTURES   << 1,
    MERGE_OPTIONS_UP_MERGE       = MERGE_OPTIONS_USE_BACKGROUND << 1,
    MERGE_OPTIONS_ERASER         = MERGE_OPTIONS_UP_MERGE       << 1,
    MERGE_OPTIONS_ALPHA_LOCK     = MERGE_OPTIONS_ERASER         << 1,
    MERGE_OPTIONS_SRGB           = MERGE_OPTIONS_ALPHA_LOCK     << 1,
    MERGE_OPTIONS_1CHANNEL       = MERGE_OPTIONS_SRGB           << 1,
    MERGE_OPTIONS_2CHANNEL       = MERGE_OPTIONS_1CHANNEL       << 1,
    MERGE_OPTIONS_DST_LINEAR     = MERGE_OPTIONS_2CHANNEL       << 1,
    MERGE_OPTIONS_CBT_LINEAR     = MERGE_OPTIONS_DST_LINEAR     << 1
};



// ------------------------------ Fragment -------------------------------------

fragment float4 fSimplePaintingCBT(
    BasicPaintingOutput inFrag   [[ stage_in  ]],
    texture2d<float, access::sample> texShapeOrCombined [[ texture(0) ]],
    texture2d<float, access::sample> texGrain           [[ texture(1) ]],
    texture2d<float, access::sample> texSelection       [[ texture(2) ]],
    texture2d<half, access::sample>  texHardnessLUT     [[ texture(3) ]],
    texture2d<float, access::sample> texBackground      [[ texture(4) ]],
    sampler shapeSampler [[sampler(0)]],
    sampler grainSampler [[sampler(1)]],
    sampler edgeLinearSampler [[sampler(2)]],
    constant int                    *options            [[ buffer(0) ]],
    constant CustomToolOptions      *customOptions      [[ buffer(1) ]])
{
    float a = 1.0;
    
    // Hardness.
    float r = 2.0 * distance(float2(0.5), inFrag.m_ShapeCoord);
    {
        float randomVal = fract(sin(dot(inFrag.m_ShapeCoord ,float2(12.9898,78.233))) * 43758.5453);
        r += (randomVal * 2.0 - 1.0) * (1.0 - inFrag.m_Utility.w) * DITHER_COEFFICIENT;
    }
    a *= texHardnessLUT.sample(edgeLinearSampler, float2(r, inFrag.m_Utility.w)).x;
    
    // Brush texture.
    if (*options & PAINT_OPTIONS_USE_COMBINED) {
        a *= (texShapeOrCombined.sample(shapeSampler, inFrag.m_ShapeCoord).x *
              texShapeOrCombined.sample(grainSampler, inFrag.m_GrainCoord).y);
    }
    else {
        if (*options & PAINT_OPTIONS_USE_GRAIN) {
            a *= texGrain.sample(grainSampler, inFrag.m_GrainCoord).x;
        }
        if (*options & PAINT_OPTIONS_USE_SHAPE) {
            a *= texShapeOrCombined.sample(shapeSampler, inFrag.m_ShapeCoord).x;
        }
        else {
            a *= 1.0 - smoothstep(inFrag.m_Utility.z, 1.0, r);
            a *= float(r <= 1.0);
        }
    }
    
    // Opacity.
    a *= inFrag.m_Color.a;
    
    // Selection.
    if (*options & PAINT_OPTIONS_USE_SELECTION) {
        float s = texSelection.sample(edgeLinearSampler, inFrag.m_Utility.xy).x;
        a *= s;
    }
    
    // Post process.
    float4 res = custom_process(texBackground,
                                inFrag.m_Utility.xy,
                                float4(a),
                                customOptions->m_PixelStep,
                                customOptions->amount,
                                customOptions->m_Params2,
                                customOptions->m_Params4);
    
    // Alpha lock.
    if (*options & PAINT_OPTIONS_USE_ALPHA_LOCK) {
        float4 dstColor = texBackground.sample(edgeLinearSampler, inFrag.m_Utility.xy);
        float back_a = dstColor.a;
        res = res.a > 0.0 ? float4((res.rgb / res.a) * back_a, back_a) : float4(0.0, 0.0, 0.0, back_a);
    }
    
    return res;
}


// TODO: merge self on background
fragment half4 fMergeCBT(
    BasicIO          inFrag   [[ stage_in  ]],
    texture2d<half, access::sample> srcTexture [[ texture(0) ]],
    texture2d<half, access::sample> dstTexture [[ texture(1) ]],
    sampler srcSampler [[ sampler(0) ]],
    sampler dstSampler [[ sampler(1) ]],
    constant MergeOptions    *options          [[ buffer(0) ]],
    constant CustomToolOptions *customOptions  [[ buffer(1) ]])
{
    half4 src = srcTexture.sample(srcSampler, inFrag.m_TexCoord);
    if (options->m_Options & MERGE_OPTIONS_1CHANNEL) {
        src = src.rrrr;
    }
    else if (options->m_Options & MERGE_OPTIONS_2CHANNEL) {
        src = src.rggg;
    }
    
    half4 dst = half4(0.0);
    bool need_linear = ((options->m_Options & MERGE_OPTIONS_DST_LINEAR) ||
                        ((options->m_Options & MERGE_OPTIONS_CBT_LINEAR) &&
                         src.a > 0.0));
    if (need_linear) {
        dst = dstTexture.sample(dstSampler, inFrag.m_TexCoord);
    }
    else {
        dst = dstTexture.sample(srcSampler, inFrag.m_TexCoord);
    }
    
    half4 src0 =  custom_process(dstTexture,
                                 inFrag.m_TexCoord,
                                 src,
                                 customOptions->m_PixelStep,
                                 customOptions->amount,
                                 customOptions->m_Params2,
                                 customOptions->m_Params4);
    
    if (!(options->m_Options & MERGE_OPTIONS_1CHANNEL)) {
        if (options->m_Options & MERGE_OPTIONS_ALPHA_LOCK) {
            if (options->m_Options & MERGE_OPTIONS_2CHANNEL) {
                src0 = src0.g > 0.0 ? half4((src0.r / src0.g) * dst.g, dst.g, dst.g, dst.g) : half4(0.0, dst.g, dst.g, dst.g);
            }
            else {
                src0 = src0.a > 0.0 ? half4((src0.rgb / src0.a) * dst.a, dst.a) : half4(0.0, 0.0, 0.0, dst.a);
            }
        }
    }
    
    return src0;
}
