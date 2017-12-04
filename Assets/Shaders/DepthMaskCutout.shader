Shader "Masked/MaskCutoff" {
    Properties {
        _Cutoff ("Alpha Cutoff", Range (-1,2)) = 0.5
        _MainTex ("Main Texture", 2D) = "white" { }
    }

    SubShader {
        Tags { "Queue" = "Geometry+10" }
        ColorMask 0
        ZWrite On
        Pass {
            AlphaTest Greater [_Cutoff]
            SetTexture[_MainTex]
            // SetTexture[_Texture2] {
            //     ConstantColor (0,0,0, [_Blend])
            //     Combine texture Lerp(constant alpha) previous alpha
            // }

            SetTexture[_MainTex] {
                Combine texture * previous alpha
            }
            
            SetTexture[_MainTex] {
                Combine texture * previous alpha
            }
        }
    }
}