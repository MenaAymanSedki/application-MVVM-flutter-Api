import 'package:advanced_mvvm_flutter_api/app/app_prefs.dart';
import 'package:advanced_mvvm_flutter_api/data/data_source/local_data_source.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/assets_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/color_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/routes_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/strings_manager.dart';
import 'package:advanced_mvvm_flutter_api/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/di.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: EdgeInsets.all(AppPadding.p8),
        children: [
          ListTile(
            leading: SvgPicture.asset(ImageAssets.settings),
            title: Text(AppStrings.changelang.tr(),style: Theme.of(context).textTheme.bodyLarge,),
            trailing: SvgPicture.asset(ImageAssets.rightArrow,color: ColorManager.primary,),
            onTap: (){
              _changeLanguage();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.contactsus),
            title: Text(AppStrings.contactus.tr(),style: Theme.of(context).textTheme.bodyLarge,),
            trailing: SvgPicture.asset(ImageAssets.rightArrow,color: ColorManager.primary,),
            onTap: (){
              _contactUs();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.invitefriend),
            title: Text(AppStrings.invitefriend.tr(),style: Theme.of(context).textTheme.bodyLarge,),
            trailing: SvgPicture.asset(ImageAssets.rightArrow,color: ColorManager.primary,),
            onTap: (){
              _inviteFriends();
            },
          ),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.logout),
            title: Text(AppStrings.logout.tr(),style: Theme.of(context).textTheme.bodyLarge,),
            trailing: SvgPicture.asset(ImageAssets.rightArrow,color: ColorManager.primary,),
            onTap: (){
              _logout();
            },
          ),
        ],
      ),
    );
  }
  _changeLanguage(){
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }
  _contactUs(){
    // i will implement it later
  }
  _inviteFriends(){
    // i will implement it later
  }
  _logout(){
    // clear cache of logged out user 
    _localDataSource.clearCache();
    // app prefs make thar user logged out
    _appPreferences.logout();
    // navigate to login screen
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}