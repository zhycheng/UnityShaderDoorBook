Shader "Chapter07/halflambertblinnphong"
{
     Properties
    {
        _Color("Color Tint",Color)=(1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(1.0,24.0))=20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
     

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D     _MainTex;
            fixed4      _Specular;
            float      _Gloss;
            float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal :NORMAL;
                float4 texcoord0 : TEXCOORD0;
            };

            struct v2f
            {     
                float3 worldPos:TEXCOORD0;
                float3 worldNormal:    TEXCOORD1 ;
                float2 uv : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

    

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord0, _MainTex);
                o.worldPos=mul(unity_ObjectToWorld,v.vertex).xyz;
                o.worldNormal=UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed3 worldNormal=i.worldNormal;
                fixed3 worldLightDir=normalize(_WorldSpaceLightPos0);
                fixed3 abedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT* abedo;
                fixed halfValue=dot(worldNormal,worldLightDir)*0.5+0.5;
                fixed3 diffuse=_LightColor0*abedo*halfValue; //∞Î¿º≤ÆÃÿπ‚’’
                //  fixed3 diffuse=fixed3(halfValue,halfValue,halfValue);
                fixed3 viewDir=normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir=(viewDir+  worldLightDir)/2;
                fixed3 specular=_LightColor0*abedo*pow(max(0,dot(halfDir,worldNormal)),_Gloss);      //blinn-phong
                fixed4 col = fixed4(ambient+diffuse+specular,1);
                return col;
            }
            ENDCG
        }
    }
}
