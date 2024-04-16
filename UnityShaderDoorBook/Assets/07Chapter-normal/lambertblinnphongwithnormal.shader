Shader "Chapter07/withnormooal"
{
    Properties
    {
        _Color("Color Tint",Color)=(1,1,1,1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _BumpMap("Normal Map",2D)="bump"{}
        _BumpScale("Bump Scale",float)=1.0
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
            sampler2D         _BumpMap;
            float4       _BumpMap_ST;
            fixed4      _Specular;
            float      _Gloss;
            float4 _MainTex_ST;
            float _BumpScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal :NORMAL;
                float4 tangent :TANGENT;
                float4 texcoord0 : TEXCOORD0;
            };

            struct v2f
            {  
                float4 pos : SV_POSITION;
                float4 uv:TEXCOORD0;
                float4 TtoW0:  TEXCOORD1;
                float4 TtoW1:  TEXCOORD2;
                float4 TtoW2:  TEXCOORD3;
            };

    

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy=v.texcoord0.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                o.uv.zw=v.texcoord0.xy*_BumpMap_ST.xy+_BumpMap_ST.zw;
                float3 wpos=mul(unity_ObjectToWorld,v.vertex).xyz ;
                fixed3 worldNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent= UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal=cross(worldNormal,worldTangent)*v.tangent.w;
                o.TtoW0=float4(worldTangent.x,worldBinormal.x,worldNormal.x,wpos.x);
                o.TtoW1=float4(worldTangent.y,worldBinormal.y,worldNormal.y,wpos.y);
                o.TtoW2=float4(worldTangent.z,worldBinormal.z,worldNormal.z,wpos.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

    //        	// Get the position in world space		
				//float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				//// Compute the light and view dir in world space
				//fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				//fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				
				//// Get the normal in tangent space
				//fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
				//bump.xy *= _BumpScale;
				//bump.z = sqrt(1.0 - saturate(dot(bump.xy, bump.xy)));
				//// Transform the narmal from tangent space to world space
				//bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));
				
				//fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
				
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				
				//fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(bump, lightDir));

				//fixed3 halfDir = normalize(lightDir + viewDir);
				//fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(bump, halfDir)), _Gloss);
				
				//return fixed4(ambient + diffuse + specular, 1.0);

                float3 worldPos=float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
       	        fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                fixed3 bump=UnpackNormal(tex2D(_BumpMap,i.uv.zw));
                 bump.xy*=  _BumpScale;
                 bump.z=sqrt(1.0-saturate(dot(bump.xy,bump.xy)));
                bump=normalize(float3( dot(i.TtoW0.xyz,bump),dot(i.TtoW1.xyz,bump),dot(i.TtoW2.xyz,bump)));     

   
             
                fixed3 abedo=tex2D(_MainTex,i.uv).rgb*_Color.rgb;
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz* abedo;

                fixed3 diffuse=_LightColor0.rgb*abedo*max(0,dot(bump,lightDir)); //¿º≤ÆÃÿπ‚’’

               
                fixed3 halfDir=normalize(viewDir+  lightDir);
                fixed3 specular=_LightColor0.rgb*abedo*pow(max(0,dot(halfDir,bump)),_Gloss);      //blinn-phong
                fixed4 col = fixed4(ambient+diffuse+specular,1);
                return col;
                
            }
            ENDCG
        }
    }
}
