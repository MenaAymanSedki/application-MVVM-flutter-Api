import 'package:advanced_mvvm_flutter_api/presentation/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(fontSize: fontSize,
  fontFamily: FontConstants.fontFamily,
  color: color,
  fontWeight: fontWeight
  
  );
}

// regular Style 
TextStyle getRegularStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}
// medium Style 
TextStyle getMediumStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}
// light Style 
TextStyle getLightStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}
// bold Style 
TextStyle getBoldStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}
// semibold Style 
TextStyle getSemiBoldStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}
