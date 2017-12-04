
Shader "Standard (Tessellation)" {
    Properties {
        _Tess ("Tessellation", Range(1,32)) = 4
        _Phong ("Curvature", Range(0,1)) = 1
        _Length ("Distance", Range(0,500)) = 25.0
        _Color ("Color (RGB)", 2D) = "white" { }
        _Physic ("Physic (RGBA)", 2D) = "black" { }
        _Normal ("Relief (RGBA)", 2D) = "bump" { }
        _Glow ("Glow (RGBA)", 2D) = "black" { }
    }

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard addshadow fullforwardshadows vertex:vert tessellate:tess tessphong:_Phong
        #pragma target 5.0
        #include "Tessellation.cginc"

        struct appdata {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
            float2 texcoord1 : TEXCOORD1;
            float2 texcoord2 : TEXCOORD2; };

        float _Tess, _Phong, _Length;

        float4 tess(appdata v0, appdata v1, appdata v2) { return UnityDistanceBasedTess(
            v0.vertex, v1.vertex, v2.vertex, _Length*0.2f, _Length*1.2f, _Tess); }

        void vert(inout appdata v) {
           const float fadeOut = saturate((_Length - distance(mul(unity_ObjectToWorld, v.vertex), _WorldSpaceCameraPos)) / (_Length * 0.7f));
           v.vertex.xyz += v.normal * 0.0001 * fadeOut;
        }

        struct Input { float2 uv_Color; float2 uv_Physic; float2 uv_Glow; };

        sampler2D _Color, _Physic, _Glow, _Normal;

        void surf(Input IN, inout SurfaceOutputStandard o) {
            half4 p = tex2D(_Physic, IN.uv_Color);
            o.Albedo = tex2D(_Color, IN.uv_Color).rgb;
            o.Emission = tex2D(_Glow, IN.uv_Color).rgb;
            o.Metallic = p.r; o.Smoothness = p.g; o.Occlusion = p.b;
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Color));
        }
        ENDCG
    }
    FallBack "Standard"
}
