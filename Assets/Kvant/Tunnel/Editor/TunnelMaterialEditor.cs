//
// Custom material editor for Tunnel surface shader
//
using UnityEngine;
using UnityEditor;

namespace Kvant {
    public class TunnelMaterialEditor : ShaderGUI {
        MaterialProperty _color;
        MaterialProperty _metallic;
        MaterialProperty _smoothness;
        MaterialProperty _albedoMap;
        MaterialProperty _normalMap;
        MaterialProperty _normalScale;
        MaterialProperty _occlusionMap;
        MaterialProperty _occlusionStr;
        MaterialProperty _emissionMap;
        MaterialProperty _emissionStr;
        MaterialProperty _mapScale;

        static GUIContent _albedoText    = new GUIContent("Albedo");
        static GUIContent _normalMapText = new GUIContent("Normal");
        static GUIContent _occlusionText = new GUIContent("Occlusion");
        static GUIContent _emissionText = new GUIContent("Emission");

        bool _initial = true;

        void FindProperties(MaterialProperty[] props) {
            _color        = FindProperty("_Color", props);
            _metallic     = FindProperty("_Metallic", props);
            _smoothness   = FindProperty("_Smoothness", props);
            _albedoMap    = FindProperty("_MainTex", props);
            _normalMap    = FindProperty("_NormalMap", props);
            _normalScale  = FindProperty("_NormalScale", props);
            _occlusionMap = FindProperty("_OcclusionMap", props);
            _occlusionStr = FindProperty("_OcclusionStr", props);
            _emissionMap  = FindProperty("_EmissionMap", props);
            _emissionStr  = FindProperty("_EmissionStr", props);
            _mapScale     = FindProperty("_MapScale", props);
        }

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties) {
            FindProperties(properties);

            if (ShaderPropertiesGUI(materialEditor) || _initial)
                foreach (Material m in materialEditor.targets) SetMaterialKeywords(m);
            _initial = false;
        }

        bool ShaderPropertiesGUI(MaterialEditor materialEditor) {
            EditorGUI.BeginChangeCheck();

            materialEditor.ShaderProperty(_color, "Color");
            materialEditor.ShaderProperty(_metallic, "Metallic");
            materialEditor.ShaderProperty(_smoothness, "Smoothness");

            EditorGUILayout.Space();

            materialEditor.TexturePropertySingleLine(_albedoText, _albedoMap, null);

            var scale = _normalMap.textureValue ? _normalScale : null;
            materialEditor.TexturePropertySingleLine(_normalMapText, _normalMap, scale);

            var str = _occlusionMap.textureValue ? _occlusionStr : null;
            materialEditor.TexturePropertySingleLine(_occlusionText, _occlusionMap, str);

            var ems = _emissionMap.textureValue ? _emissionStr : null;
            materialEditor.TexturePropertySingleLine(_emissionText, _emissionMap, ems);

            if (_albedoMap.textureValue || _normalMap.textureValue || _occlusionMap.textureValue || _emissionMap.textureValue)
                materialEditor.ShaderProperty(_mapScale, "Scale");

            return EditorGUI.EndChangeCheck();
        }

        static void SetMaterialKeywords(Material material) {
            SetKeyword(material, "_ALBEDOMAP", material.GetTexture("_MainTex"));
            SetKeyword(material, "_NORMALMAP", material.GetTexture("_NormalMap"));
            SetKeyword(material, "_OCCLUSIONMAP", material.GetTexture("_OcclusionMap"));
            SetKeyword(material, "_EMISSIONMAP", material.GetTexture("_EmissionMap"));
        }

        static void SetKeyword(Material m, string keyword, bool state) {
            if (state) m.EnableKeyword(keyword); else m.DisableKeyword(keyword); }
    }
}
