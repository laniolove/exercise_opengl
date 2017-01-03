//
//  pe_mtl_templates.metal
//  libpaintengine
//
//  Created by Georgy Ostrobrod on 05/02/16.
//  Copyright © 2016 Pixelmator. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

////////////////////////////////////////////////////////////////////////////////
// MARK: **************************** Merge ************************************



// ------------------------------  Types ---------------------------------------

struct VertexIO
{
    float4 m_Position [[position]];
    float2 m_TexCoord [[user(texturecoord)]];
};



struct Vertex2IO
{
    float4 m_Position  [[position]];
    float2 m_Tex1Coord [[user(texture1coord)]];
    float2 m_Tex2Coord [[user(texture2coord)]];
};



typedef enum BlendModesEnum {
    BLEND_NORMAL,
    BLEND_DARKEN,
    BLEND_LIGHTEN,
    BLEND_MULTIPLY,
    BLEND_SCREEN,
    BLEND_COLORBURN,
    BLEND_LINEARBURN,
    BLEND_COLORDODGE,
    BLEND_LINEARDODGE,
    BLEND_OVERLAY,
    BLEND_SOFTLIGHT,
    BLEND_HARDLIGHT,
    BLEND_VIVIDLIGHT,
    BLEND_LINEARLIGHT,
    BLEND_PINLIGHT,
    BLEND_DIFFERENCE,
    BLEND_EXCLUSION,
    BLEND_LIGHTERCOLOR,
    BLEND_DARKERCOLOR,
    BLEND_LUMINOSITY,
    BLEND_SATURATE,
    BLEND_HUE,
    BLEND_COLOR,
    BLEND_DIVIDE,
    BLEND_SUBTRACT,
    BLEND_DISSOLVE,
    BLEND_HARDMIX,
    BLEND_BEHIND,
    
    PE_BLEND_COUNT
} BlendModes;



struct BlendParams {
    int alpha_index;
    float2 cur_position;
};



struct MergeTemplateOptions {
    int m_Options        [[user(options)]];
    int m_AlphaIndex     [[user(alphaindex)]];
    int m_BlendTypeInner [[user(blendtypeinner)]];
    int m_Reserved0      [[user(reserved0)]];
    float4 m_Color       [[user(color)]];
    float m_OpacityLimit [[user(opacitylimit)]];
    float m_OpacityLayer [[user(opacitylayer)]];
};



enum FragmentMergeOptions {
    MERGE_OPTIONS_NONE     = 0,
    MERGE_OPTIONS_ERASER   = 1,
    MERGE_OPTIONS_SRGB     = MERGE_OPTIONS_ERASER   << 1,
    MERGE_OPTIONS_1CHANNEL = MERGE_OPTIONS_SRGB     << 1,
    MERGE_OPTIONS_2CHANNEL = MERGE_OPTIONS_1CHANNEL << 1
};



// ------------------------------  Blend ---------------------------------------

class CBlendNormal {
public:
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return src + dst * (1.0 - src[params.alpha_index]);
    }
};



class CBlendDarken {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(min(src.rgb * dst[params.alpha_index], dst.rgb * src[params.alpha_index]) +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendLighten {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(max(src.rgb * dst[params.alpha_index], dst.rgb * src[params.alpha_index]) +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendMultiply {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src.rgb * dst.rgb + src.rgb * (1.0 - dst[params.alpha_index]) +
                         dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendScreen {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src.rgb + dst.rgb - src.rgb * dst.rgb,
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendColorBurn {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src[params.alpha_index] * dst[params.alpha_index] * (1.0 - min(src[params.alpha_index] * (dst[params.alpha_index] - dst.rgb) / max(src.rgb * dst[params.alpha_index], 0.001), 1.0)) +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendLinearBurn {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src.rgb * dst[params.alpha_index] + dst.rgb * src[params.alpha_index] - dst[params.alpha_index] * src[params.alpha_index] +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendColorDodge {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src[params.alpha_index] * dst[params.alpha_index] * min(dst.rgb * src[params.alpha_index] / max(dst[params.alpha_index] * (src[params.alpha_index] - src.rgb), 0.001), 1.0) +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendLinearDodge {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src.rgb * dst[params.alpha_index] + dst.rgb * src[params.alpha_index] +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendOverlay {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        vec<T, 3> dst_f = vec<T, 3>(dst.rgb * 2.0 > dst[params.alpha_index]);
        return vec<T, 4>((src.rgb * (1.0 + dst[params.alpha_index]) + dst.rgb * (1.0 + src[params.alpha_index]) -
                          2.0 * dst.rgb * src.rgb - dst[params.alpha_index] * src[params.alpha_index]) * dst_f +
                         (2.0 * src.rgb * dst.rgb + src.rgb * (1.0 - dst[params.alpha_index]) +
                          dst.rgb * (1.0 - src[params.alpha_index])) * (1.0 - dst_f),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendSoftLight {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        vec<T,3> m = dst.rgb / max(dst.a, T(0.001));
        vec<T,3> a = 2.0 * src.rgb - src.a;
        vec<T,3> b = dst.a * a;
        vec<T,3> c = src.rgb - src.rgb * dst.a + dst.rgb;
        vec<T,3> d_src = 2.0 * src.rgb;
        vec<T,3> q_dst = 4.0 * dst.rgb;
        vec<T,3> eq1 = vec<T,3>(T(d_src.r <= src.a),
                                T(d_src.g <= src.a),
                                T(d_src.b <= src.a));
        vec<T,3> eq2 = vec<T,3>(T(q_dst.r <= dst.a),
                                T(q_dst.g <= dst.a),
                                T(q_dst.b <= dst.a));
        
        vec<T,3> d = eq2 * (16.0 * m * m * m - 12.0 * m * m + 3.0 * m) + (1.0 - eq2) * (sqrt(m) - m);
        
        vec<T,3> eq1val = dst.rgb * (src.a + a * (1.0 - m)) + src.rgb * (1.0 - dst.a) + dst.rgb * (1.0 - src.a);
        vec<T,3> eq2val = b * d + c;
        
        vec<T,4> res = vec<T,4>(eq1 * eq1val + (1.0 - eq1) * eq2val,
                                src.a + dst.a * (1.0 - src.a));
        return res;
    }
};



class CBlendHardLight {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        vec<T, 3> dst_f = vec<T, 3>(src.rgb * 2.0 > dst[params.alpha_index]);
        return vec<T, 4>((src.rgb * (1.0 + dst[params.alpha_index]) + dst.rgb * (1.0 + src[params.alpha_index]) -
                          2.0 * dst.rgb * src.rgb - dst[params.alpha_index] * src[params.alpha_index]) * dst_f +
                         (2.0 * src.rgb * dst.rgb + src.rgb * (1.0 - dst[params.alpha_index]) +
                          dst.rgb * (1.0 - src[params.alpha_index])) * (1.0 - dst_f),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendVividLight {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        vec<T, 3> dst_f = vec<T, 3>(src.rgb * 2.0 > dst[params.alpha_index]);
        return vec<T, 4>((dst_f * clamp(dst.rgb * src[params.alpha_index] / max(2.0 * (src[params.alpha_index] - src.rgb) * dst[params.alpha_index], T(0.01)), T(0.0), T(1.0)) +
                          (1.0 - dst_f) * clamp((2.0 * dst[params.alpha_index] * src.rgb - (dst[params.alpha_index] - dst.rgb) * src[params.alpha_index]) / max(2.0 * src.rgb * dst[params.alpha_index], T(0.01)), T(0.0), T(1.0)))
                         * src[params.alpha_index] * dst[params.alpha_index] + src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendLinearLight {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(dst.rgb * src[params.alpha_index] + 2.0 * src.rgb * dst[params.alpha_index] - src[params.alpha_index] * dst[params.alpha_index] +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendPinLight {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        vec<T, 3> dst_f = vec<T, 3>(src.rgb * 2.0 > dst[params.alpha_index]);
        return vec<T, 4>(dst_f * clamp(max(dst.rgb * src[params.alpha_index], 2.0 * src.rgb * dst[params.alpha_index] - src[params.alpha_index] * dst[params.alpha_index]), T(0.0), T(1.0)) +
                         (1.0 - dst_f) * clamp(min(dst.rgb * src[params.alpha_index], 2.0 * src.rgb * dst[params.alpha_index]), T(0.0), T(1.0)) +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendDifference {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>(src.rgb + dst.rgb -
                         2.0 * min(src.rgb * dst[params.alpha_index], dst.rgb * src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendExclusion {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return vec<T, 4>((src.rgb * dst[params.alpha_index] + dst.rgb * src[params.alpha_index] -
                          2.0 * src.rgb * dst.rgb) + src.rgb * (1.0 - dst[params.alpha_index]) +
                         dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendLighterColor {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        T src_f = T((0.2126 * src.r + 0.7152 * src.g + 0.0722 * src.b) >
                    (0.2126 * dst.r + 0.7152 * dst.g + 0.0722 * dst.b));
        return vec<T, 4>(src_f * src.rgb * dst[params.alpha_index] + (1.0 - src_f) * dst.rgb * src[params.alpha_index] +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendDarkerColor {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        T src_f = T((0.2126 * src.r + 0.7152 * src.g + 0.0722 * src.b) <=
                    (0.2126 * dst.r + 0.7152 * dst.g + 0.0722 * dst.b));
        return vec<T, 4>(src_f * src.rgb * dst[params.alpha_index] + (1.0 - src_f) * dst.rgb * src[params.alpha_index] +
                         src.rgb * (1.0 - dst[params.alpha_index]) + dst.rgb * (1.0 - src[params.alpha_index]),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendLuminosity {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        // SetLum
        vec<T, 3>  res_rgb = dst_rgb + dot(half3(0.3, 0.59, 0.11), src_rgb - dst_rgb);
        
        // Clip color
        T l = dot(vec<T, 3>(0.3, 0.59, 0.11), res_rgb);
        T n = min(min(res_rgb.r, res_rgb.g), res_rgb.b);
        T x = max(max(res_rgb.r, res_rgb.g), res_rgb.b);
        if (n < 0.0) {
            res_rgb = l + (res_rgb - l) *        l  / (l - n);
        }
        if (x > 1.0) {
            res_rgb = l + (res_rgb - l) * (1.0 - l) / (x - l);
        }
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendSaturate {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        // Sat(src)
        T s = max(max(src_rgb.r, src_rgb.g), src_rgb.b) - min(min(src_rgb.r, src_rgb.g), src_rgb.b);
        
        // Lum(dst)
        T l_dst = dot(vec<T, 3>(0.3, 0.59, 0.11), dst_rgb);
        
        bool3 clr_sort = dst_rgb.rgb > dst_rgb.brg;
        
        dst_rgb = mix(dst_rgb, vec<T, 3>(dst_rgb.y, dst_rgb.xz), step(dst_rgb.x, dst_rgb.y));
        dst_rgb = mix(dst_rgb, vec<T, 3>(dst_rgb.x, dst_rgb.zy), step(dst_rgb.y, dst_rgb.z));
        dst_rgb = mix(dst_rgb, vec<T, 3>(dst_rgb.y, dst_rgb.xz), step(dst_rgb.x, dst_rgb.y));
        
        dst_rgb = (dst_rgb.x == dst_rgb.z ?
                   vec<T, 3>(0.0) :
                   vec<T, 3>(s,
                             (dst_rgb.y - dst_rgb.z) * s / (dst_rgb.x - dst_rgb.z),
                             0.0));
        
        dst_rgb = mix(vec<T, 3>(dst_rgb.z, dst_rgb.yx), dst_rgb, T(clr_sort.x));
        dst_rgb = mix(dst_rgb, vec<T, 3>(dst_rgb.y, dst_rgb.xz), T(clr_sort.y == clr_sort.x));
        dst_rgb = mix(dst_rgb, vec<T, 3>(dst_rgb.x, dst_rgb.zy), T(clr_sort.z == clr_sort.x));
        
        // SetLum
        vec<T, 3>  res_rgb = dst_rgb + l_dst - dot(vec<T, 3>(0.3, 0.59, 0.11), dst_rgb);
        
        // ClipClr(res_rgb)
        T l = dot(vec<T, 3>(0.3, 0.59, 0.11), res_rgb);
        T n = min(min(res_rgb.r, res_rgb.g), res_rgb.b);
        T x = max(max(res_rgb.r, res_rgb.g), res_rgb.b);
        if (n < 0.0) {
            res_rgb = l + (res_rgb - l) *        l  / (l - n);
        }
        if (x > 1.0) {
            res_rgb = l + (res_rgb - l) * (1.0 - l) / (x - l);
        }
        
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendHue {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        // Sat(src)
        T s = max(max(dst_rgb.r, dst_rgb.g), dst_rgb.b) - min(min(dst_rgb.r, dst_rgb.g), dst_rgb.b);
        
        // Lum(dst)
        T l_dst = dot(vec<T, 3>(0.3, 0.59, 0.11), dst_rgb);
        
        bool3 clr_sort = src_rgb.rgb > src_rgb.brg;
        
        src_rgb = mix(src_rgb, vec<T, 3>(src_rgb.y, src_rgb.xz), step(src_rgb.x, src_rgb.y));
        src_rgb = mix(src_rgb, vec<T, 3>(src_rgb.x, src_rgb.zy), step(src_rgb.y, src_rgb.z));
        src_rgb = mix(src_rgb, vec<T, 3>(src_rgb.y, src_rgb.xz), step(src_rgb.x, src_rgb.y));
        
        src_rgb = (src_rgb.x == src_rgb.z ?
                   vec<T, 3>(0.0) :
                   vec<T, 3>(s,
                             (src_rgb.y - src_rgb.z) * s / (src_rgb.x - src_rgb.z),
                             0.0));
        
        src_rgb = mix(vec<T, 3>(src_rgb.z, src_rgb.yx), src_rgb, T(clr_sort.x));
        src_rgb = mix(src_rgb, vec<T, 3>(src_rgb.y, src_rgb.xz), T(clr_sort.y == clr_sort.x));
        src_rgb = mix(src_rgb, vec<T, 3>(src_rgb.x, src_rgb.zy), T(clr_sort.z == clr_sort.x));
        
        // SetLum()
        vec<T, 3>  res_rgb = src_rgb + l_dst - dot(vec<T, 3>(0.3, 0.59, 0.11), src_rgb);
        
        // ClipClr(res_rgb)
        T l = dot(vec<T, 3>(0.3, 0.59, 0.11), res_rgb);
        T n = min(min(res_rgb.r, res_rgb.g), res_rgb.b);
        T x = max(max(res_rgb.r, res_rgb.g), res_rgb.b);
        if (n < 0.0) {
            res_rgb = l + (res_rgb - l) *        l  / (l - n);
        }
        if (x > 1.0) {
            res_rgb = l + (res_rgb - l) * (1.0 - l) / (x - l);
        }
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendColor {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        // SetLum
        vec<T, 3>  res_rgb = src_rgb + dot(vec<T, 3>(0.3, 0.59, 0.11), dst_rgb - src_rgb);
        
        // ClipClr
        T l = dot(vec<T, 3>(0.3, 0.59, 0.11), res_rgb);
        T n = min(min(res_rgb.r, res_rgb.g), res_rgb.b);
        T x = max(max(res_rgb.r, res_rgb.g), res_rgb.b);
        if (n < 0.0) {
            res_rgb = l + (res_rgb - l) *        l  / (l - n);
        }
        if (x > 1.0) {
            res_rgb = l + (res_rgb - l) * (1.0 - l) / (x - l);
        }
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendDivide {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        vec<T, 3> res_rgb = clamp(dst_rgb / src_rgb, T(0.0), T(1.0));
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendSubtract {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        vec<T, 3> res_rgb = clamp(dst_rgb - src_rgb, T(0.0), T(1.0));
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendDissolve {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        
        float2 xy = (params.cur_position + 1.0) * 0.5;
        
        float dy = fract(sin(dot(xy, float2(75.542, 35.7124))) * 22854.812);
        xy.y += dy;
        float randomVal = fract(sin(dot(xy, float2(2.124, 24.3598))) * 22854.812);
        
        float colorOpacity = src[params.alpha_index];
        src.rgb /= (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        src[params.alpha_index] = step(T(0.0001), src[params.alpha_index]);
        src.rgb *= src[params.alpha_index];
        
        return src[params.alpha_index] == 0.0 ? dst : (randomVal < colorOpacity ? src : dst);
    }
};



class CBlendHardmix {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        // Unpremultiplied src
        vec<T, 3> src_rgb = src.rgb / (src[params.alpha_index] + step(T(0.0), -src[params.alpha_index]));
        // unpremultiplied dst
        vec<T, 3> dst_rgb = dst.rgb / (dst[params.alpha_index] + step(T(0.0), -dst[params.alpha_index]));
        
        vec<T, 3> res_rgb = step(T(0.0), src_rgb + dst_rgb);
        
        // Premultiplied
        return vec<T, 4>(((1.0 - src[params.alpha_index]) * dst.rgb) + ((1.0 - dst[params.alpha_index]) * src.rgb) + (src[params.alpha_index] * dst[params.alpha_index] * res_rgb),
                         src[params.alpha_index] + dst[params.alpha_index] * (1.0 - src[params.alpha_index]));
    }
};



class CBlendBehind {
public:
    
    template<typename T>
    inline static vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, BlendParams params) {
        return dst + src * (1.0 - dst[params.alpha_index]);
    }
};


template<typename T>
vec<T, 4> blend(vec<T, 4> src, vec<T, 4> dst, int alphaIndex, float2 curPos, int blendType) {
    vec<T, 4> res = 0.0;
    BlendParams params = {
        alphaIndex,
        curPos
    };
    switch (blendType) {
        case BLEND_NORMAL:
            res = CBlendNormal::blend(src, dst, params);
            break;
        case BLEND_DARKEN:
            res = CBlendDarken::blend(src, dst, params);
            break;
        case BLEND_LIGHTEN:
            res = CBlendLighten::blend(src, dst, params);
            break;
        case BLEND_MULTIPLY:
            res = CBlendMultiply::blend(src, dst, params);
            break;
        case BLEND_SCREEN:
            res = CBlendScreen::blend(src, dst, params);
            break;
        case BLEND_COLORBURN:
            res = CBlendColorBurn::blend(src, dst, params);
            break;
        case BLEND_LINEARBURN:
            res = CBlendLinearBurn::blend(src, dst, params);
            break;
        case BLEND_COLORDODGE:
            res = CBlendColorDodge::blend(src, dst, params);
            break;
        case BLEND_LINEARDODGE:
            res = CBlendLinearDodge::blend(src, dst, params);
            break;
        case BLEND_OVERLAY:
            res = CBlendOverlay::blend(src, dst, params);
            break;
        case BLEND_SOFTLIGHT:
            res = CBlendSoftLight::blend(src, dst, params);
            break;
        case BLEND_HARDLIGHT:
            res = CBlendHardLight::blend(src, dst, params);
            break;
        case BLEND_VIVIDLIGHT:
            res = CBlendVividLight::blend(src, dst, params);
            break;
        case BLEND_LINEARLIGHT:
            res = CBlendLinearLight::blend(src, dst, params);
            break;
        case BLEND_PINLIGHT:
            res = CBlendPinLight::blend(src, dst, params);
            break;
        case BLEND_DIFFERENCE:
            res = CBlendDifference::blend(src, dst, params);
            break;
        case BLEND_EXCLUSION:
            res = CBlendExclusion::blend(src, dst, params);
            break;
        case BLEND_LIGHTERCOLOR:
            res = CBlendLighterColor::blend(src, dst, params);
            break;
        case BLEND_DARKERCOLOR:
            res = CBlendDarkerColor::blend(src, dst, params);
            break;
        case BLEND_LUMINOSITY:
            res = CBlendLuminosity::blend(src, dst, params);
            break;
        case BLEND_SATURATE:
            res = CBlendSaturate::blend(src, dst, params);
            break;
        case BLEND_HUE:
            res = CBlendHue::blend(src, dst, params);
            break;
        case BLEND_COLOR:
            res = CBlendColor::blend(src, dst, params);
            break;
        case BLEND_DIVIDE:
            res = CBlendDivide::blend(src, dst, params);
            break;
        case BLEND_SUBTRACT:
            res = CBlendSubtract::blend(src, dst, params);
            break;
        case BLEND_DISSOLVE:
            res = CBlendDissolve::blend(src, dst, params);
            break;
        case BLEND_HARDMIX:
            res = CBlendHardmix::blend(src, dst, params);
            break;
        case BLEND_BEHIND:
            res = CBlendBehind::blend(src, dst, params);
            break;
    };
    return res;
}
    
    
template<typename T>
vec<T, 4> post_process(vec<T, 4> src,
                       vec<T, 4> dst,
                       int alphaIndex,
                       float2 curPos,
                       T opacity);
    
    
template<typename T>
vec<T, 4> blendCC(vec<T, 4> src, vec<T, 4> dst, int alphaIndex, float2 curPos, int blendType, bool isSRGB);

template<typename T>
vec<T, 4> blendCC(vec<T, 4> src, vec<T, 4> dst, int alphaIndex, float2 curPos, int blendType, bool isSRGB) {
    vec<T, 4> res = src;
    if (isSRGB) {
        res = blend(res, dst, alphaIndex, curPos, blendType);
    }
    else {
        T sa = res[alphaIndex];
        res /= sa > 0.0 ? sa : 1.0;
        res *= res;
        res *= sa;
        dst *= dst;
        
        res = blend(res, dst, alphaIndex, curPos, blendType);
        
        res  = sqrt(res);
    }
    return res;
}



// ------------------------------ Fragment -------------------------------------

// Simple texture applying
vertex VertexIO vSimple(
    device float4 *pPosition   [[ buffer(0) ]],
    device float2 *pTexCoords  [[ buffer(1) ]],
    uint           vid         [[ vertex_id ]])
{
    VertexIO outVertices;
    float4 pos = pPosition[vid];
    pos.y = -pos.y;
    outVertices.m_Position = pos;
    outVertices.m_TexCoord = pTexCoords[vid];
    
    return outVertices;
}



vertex Vertex2IO vSimple2(
    device float4 *pPosition   [[ buffer(0) ]],
    device float2 *pTex1Coords [[ buffer(1) ]],
    device float2 *pTex2Coords [[ buffer(2) ]],
    uint           vid         [[ vertex_id ]])
{
    Vertex2IO outVertices;
    
    float4 pos = pPosition[vid];
    pos.y = -pos.y;
    outVertices.m_Position = pos;
    outVertices.m_Tex1Coord = pTex1Coords[vid];
    outVertices.m_Tex2Coord = pTex2Coords[vid];
    
    return outVertices;
}



// ------------------------------ Fragment -------------------------------------

fragment half4 fMergeInplaceTemplate(
    VertexIO                        inFrag     [[ stage_in  ]],
    texture2d<half, access::sample> srcTexture [[ texture(0)]],
#if PE_TARGET_IOS
    half4        dstColor [[ color(0) ]],
#else
    texture2d<half, access::sample> bkgTexture [[ texture(2) ]],
#endif
    constant MergeTemplateOptions   *options   [[ buffer(0)  ]])
{
    constexpr sampler quadSampler(address::clamp_to_zero, filter::nearest);
    half4 src = srcTexture.sample(quadSampler, inFrag.m_TexCoord);
    
#if PE_TARGET_OSX
    half4 dstColor = bkgTexture.sample(quadSampler, inFrag.m_TexCoord);
#endif
    
    return post_process(src,
                        dstColor,
                        options->m_AlphaIndex,
                        inFrag.m_Position.xy,
                        half(options->m_OpacityLayer));
}
    
    
    
fragment half4 fMergeSimple2Template(
    Vertex2IO                       inFrag     [[ stage_in   ]],
    texture2d<half, access::sample> srcTexture [[ texture(0) ]],
    texture2d<half, access::sample> dstTexture [[ texture(1) ]],
    sampler srcSampler [[ sampler(0) ]],
    sampler dstSampler [[ sampler(1) ]],
#if PE_TARGET_IOS
    half4        dstColor [[ color(0) ]],
#else
    texture2d<half, access::sample> bkgTexture [[ texture(2) ]],
#endif
    constant MergeTemplateOptions  *options    [[ buffer(0) ]])
{
    half4 dst = dstTexture.sample(srcSampler, inFrag.m_Tex2Coord);
    half4 src = srcTexture.sample(dstSampler, inFrag.m_Tex1Coord);
    
    half4 src0 = 0.0;
    if (options->m_Options & MERGE_OPTIONS_1CHANNEL) {
        src = src.rrrr;
    }
    else if (options->m_Options & MERGE_OPTIONS_2CHANNEL) {
        src.r *= src.g;
        src.ba = src.gg;
    }
    else {
        src.rgb *= src.a;
    }
    
    if (options->m_Options & MERGE_OPTIONS_ERASER) {
        src0 = dst * (1.0 - src[options->m_AlphaIndex]);
    }
    else {
        src0 = blendCC(src,
                       dst,
                       options->m_AlphaIndex,
                       inFrag.m_Position.xy,
                       options->m_BlendTypeInner,
                       options->m_Options & MERGE_OPTIONS_SRGB);
    }
    
#if PE_TARGET_OSX
    half4 dstColor = bkgTexture.sample(dstSampler, inFrag.m_Tex2Coord);
#endif
    
    return post_process(src0,
                        dstColor,
                        options->m_AlphaIndex,
                        inFrag.m_Position.xy,
                        half(options->m_OpacityLayer));
}
    
    
    
fragment half4 fMergeSimpleTemplate(
    VertexIO                        inFrag     [[ stage_in  ]],
    texture2d<half, access::sample> srcTexture [[ texture(0)]],
    sampler srcSampler [[ sampler(0) ]],
#if PE_TARGET_IOS
    half4        dstColor [[ color(0) ]],
#else
    texture2d<half, access::sample> bkgTexture [[ texture(2) ]],
    sampler dstSampler [[ sampler(0) ]],
#endif
    constant MergeTemplateOptions   *options   [[ buffer(0)  ]])
{
    half4 src = srcTexture.sample(srcSampler, inFrag.m_TexCoord);
    half4 dst = 0.0;
    
    half4 src0 = 0.0;
    if (options->m_Options & MERGE_OPTIONS_1CHANNEL) {
        src = src.rrrr;
    }
    else if (options->m_Options & MERGE_OPTIONS_2CHANNEL) {
        src.r *= src.g;
        src.ba = src.gg;
    }
    else {
        src.rgb *= src.a;
    }
    
    if (options->m_Options & MERGE_OPTIONS_ERASER) {
        src0 = dst * (1.0 - src[options->m_AlphaIndex]);
    }
    else {
        src0 = blendCC(src,
                       dst,
                       options->m_AlphaIndex,
                       inFrag.m_Position.xy,
                       options->m_BlendTypeInner,
                       options->m_Options & MERGE_OPTIONS_SRGB);
    }
    
#if PE_TARGET_OSX
    half4 dstColor = bkgTexture.sample(dstSampler, inFrag.m_TexCoord);
#endif
    
    return post_process(src0,
                        dstColor,
                        options->m_AlphaIndex,
                        inFrag.m_Position.xy,
                        half(options->m_OpacityLayer));
}



fragment half4 fMergeWatercolor2Template(
    Vertex2IO          inFrag   [[ stage_in  ]],
    texture2d<half, access::sample> srcTexture [[ texture(0) ]],
    texture2d<half, access::sample> dstTexture [[ texture(1) ]],
    texture2d<half, access::sample> lutTexture [[ texture(3) ]],
    sampler srcSampler [[ sampler(0) ]],
    sampler dstSampler [[ sampler(1) ]],
    sampler lutSampler [[ sampler(2) ]],
#if PE_TARGET_IOS
    half4        dstColor [[ color(0) ]],
#else
    texture2d<half, access::sample> bkgTexture [[ texture(2) ]],
#endif
    constant MergeTemplateOptions *options     [[ buffer(0)  ]])
{
    half4 dst = dstTexture.sample(srcSampler, inFrag.m_Tex2Coord);
    half4 src = srcTexture.sample(dstSampler, inFrag.m_Tex1Coord);
    
    half a = min(src.r, src.g);
    a = options->m_OpacityLimit * lutTexture.sample(lutSampler, float2(a, 0.5)).r;
    
    // Set source solor.
    src = half4(half3(options->m_Color.rgb), a);
    
    half4 src0 = 0.0;
    if (options->m_Options & MERGE_OPTIONS_1CHANNEL) {
        src = src.rrrr;
    }
    else if (options->m_Options & MERGE_OPTIONS_2CHANNEL) {
        src.r *= src.g;
        src.ba = src.gg;
    }
    else {
        src.rgb *= src.a;
    }
    
    if (options->m_Options & MERGE_OPTIONS_ERASER) {
        src0 = dst * (1.0 - src[options->m_AlphaIndex]);
    }
    else {
        src0 = blendCC(src,
                       dst,
                       options->m_AlphaIndex,
                       inFrag.m_Position.xy,
                       options->m_BlendTypeInner,
                       options->m_Options & MERGE_OPTIONS_SRGB);
    }
    
#if PE_TARGET_OSX
    half4 dstColor = bkgTexture.sample(dstSampler, inFrag.m_Tex2Coord);
#endif

    return post_process(src0,
                        dstColor,
                        options->m_AlphaIndex,
                        inFrag.m_Position.xy,
                        half(options->m_OpacityLayer));
}
    
    
    
fragment half4 fMergeWatercolorTemplate(
    VertexIO                        inFrag     [[ stage_in   ]],
    texture2d<half, access::sample> srcTexture [[ texture(0) ]],
    texture2d<half, access::sample> lutTexture [[ texture(3) ]],
    sampler srcSampler [[ sampler(0) ]],
    sampler lutSampler [[ sampler(2) ]],
#if PE_TARGET_IOS
    half4        dstColor [[ color(0) ]],
#else
    texture2d<half, access::sample> bkgTexture [[ texture(2) ]],
    sampler dstSampler [[ sampler(1) ]],
#endif
    constant MergeTemplateOptions *options     [[ buffer(0)  ]])
{
    half4 src = srcTexture.sample(srcSampler, inFrag.m_TexCoord);
    half4 dst = 0.0;
    
    half a = min(src.r, src.g);
    a = options->m_OpacityLimit * lutTexture.sample(lutSampler, float2(a, 0.5)).r;
    
    // Set source solor.
    src = half4(half3(options->m_Color.rgb), a);
    
    half4 src0 = 0.0;
    if (options->m_Options & MERGE_OPTIONS_1CHANNEL) {
        src = src.rrrr;
    }
    else if (options->m_Options & MERGE_OPTIONS_2CHANNEL) {
        src.r *= src.g;
        src.ba = src.gg;
    }
    else {
        src.rgb *= src.a;
    }
    
    if (options->m_Options & MERGE_OPTIONS_ERASER) {
        src0 = dst * (1.0 - src[options->m_AlphaIndex]);
    }
    else {
        src0 = blendCC(src,
                       dst,
                       options->m_AlphaIndex,
                       inFrag.m_Position.xy,
                       options->m_BlendTypeInner,
                       options->m_Options & MERGE_OPTIONS_SRGB);
    }
    
#if PE_TARGET_OSX
    half4 dstColor = bkgTexture.sample(dstSampler, inFrag.m_TexCoord);
#endif
    
    return post_process(src0,
                        dstColor,
                        options->m_AlphaIndex,
                        inFrag.m_Position.xy,
                        half(options->m_OpacityLayer));
}

// Add code of post_process here:
// Example (src return without post porcessing):
/*
 template<typename T>
 vec<T, 4> post_process(vec<T, 4> src,
                        vec<T, 4> dst,
                        int alphaIndex,
                        float2 curPos,
                        T opacity)
 {
    return src;
 }
 */
