Shader "Diffuse Transparency" {
	Properties{
		_Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_MainTex("Diffuse Texture", 2D) = "white"{}
		_transMap ("Transparency (A)", 2D) = "white"{}
		_SpecColor("Shininess", float) = 10.0
		_RimColor ("Rim Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower ("Rim Power", Range(0.1, 10)) = 3.0

	}
	SubShader{
		Tags{ "Queue" = "Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			Cull Off
			zWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform sampler2D _transMap;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _transMap_ST;
			uniform float4 _Color;
			uniform float4 _SpecColor;
			uniform float4 _RimColor;
			uniform float _RimPower;
			uniform float _Shininess;

			uniform float4 _LightColor0;

			//base structs
			struct vertexInput
			{
				float4 vertex : Position;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD1;
				float4 posWorld : TEXCOORD2;
				float3 normalDir : TEXCOORD3;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.posWorld = mul(_Object2World, v.vertex);
				o.normalDir = normalize(mul(float4(v.normal,0.0), _World2Object).xyz);
				o.tex = v.texcoord;
				
				return o;
			}
			float4 frag(vertexOutput i) : COLOR
			{
				float3 normalDirection = i.normalDir;
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, i.posWorld.xyz));
				float3 fragmentToLightSource = float3(_WorldSpaceLightPos0.xyz - float3(i.posWorld.xyz));
				float dist = length(fragmentToLightSource);
				float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, fragmentToLightSource, _WorldSpaceLightPos0.w));
				float atten = lerp(1.0, 1.0/dist, _WorldSpaceLightPos0.w);

				// Lighting
				float3 diffuseReflection = atten * _LightColor0.xyz * saturate(dot(normalDirection, lightDirection));
				float3 specularReflection = diffuseReflection * _SpecColor * pow(saturate(dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);

				half rim = 1 - saturate(dot(viewDirection, normalDirection));
				float3 rimLighting = saturate(dot(normalDirection, lightDirection)) * pow(rim, _RimPower);

				float4 texA = tex2D(_transMap, _transMap_ST.xy * i.tex.xy + _transMap_ST.zw);
				float4 tex = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				float alpha = texA.a * _Color.a;
				return float4(_Color.xyz * tex.xyz, alpha);
			}
			ENDCG
		}
	}
}