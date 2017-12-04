// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

Shader "Custom/Heatmap" {
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Density ("Density", Float) = 1
        _Volume ("Volume", Float) = 1
        _Alpha ("Alpha", Float) = 1
    }

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            struct vertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;

                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct fragInput {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            UNITY_INSTANCING_CBUFFER_START (MyProperties)
            UNITY_DEFINE_INSTANCED_PROP (float4, _Color)
            UNITY_DEFINE_INSTANCED_PROP (float, _Density)
            UNITY_DEFINE_INSTANCED_PROP (float, _Volume)
            UNITY_DEFINE_INSTANCED_PROP (float, _Alpha)
            UNITY_INSTANCING_CBUFFER_END
           
            fragInput vert(vertexInput v) {
                fragInput o;
                v.vertex.xyz += v.normal * (UNITY_ACCESS_INSTANCED_PROP (_Volume) - 1);
                o.color = fixed4(
                    UNITY_ACCESS_INSTANCED_PROP(_Density), 1, 
                    UNITY_ACCESS_INSTANCED_PROP(_Volume), 
                    UNITY_ACCESS_INSTANCED_PROP(_Alpha));

                UNITY_SETUP_INSTANCE_ID (v);
                UNITY_TRANSFER_INSTANCE_ID (v, o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
           
            fixed4 frag (fragInput i) : SV_Target {
                UNITY_SETUP_INSTANCE_ID (i);
                return UNITY_ACCESS_INSTANCED_PROP (_Color);
            }

            ENDCG
        }
    }
}