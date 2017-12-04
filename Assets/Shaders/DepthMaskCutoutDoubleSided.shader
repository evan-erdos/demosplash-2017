
Shader "Masked/MaskCutoffDoubleSided" {

    Properties {
        _Cutoff ("Alpha Cutoff", Range (0,1)) = 0.5
        _MainTex ("Main Texture", 2D) = "white" { }
    }

    SubShader {
        Tags { "Queue" = "Geometry+10" "PerformanceChecks"="False" }
        ColorMask 0
        ZWrite On
        Cull Off

        Pass {
            AlphaTest Greater [_Cutoff]
            SetTexture[_MainTex]

            SetTexture[_MainTex] {
                Combine texture * previous alpha
            }
            
            SetTexture[_MainTex] {
                Combine texture * previous alpha
            }
        }

        Pass {
            Fog { Color (0,0,0,0) }
            ZWrite Off
            ZTest LEqual

            // CGPROGRAM
            // #pragma target 3.0

            // #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            // #pragma multi_compile_fog

            // ENDCG
        }
    }    
}
