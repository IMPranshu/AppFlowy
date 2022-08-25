import 'package:app_flowy/startup/plugin/plugin.dart';
import 'package:app_flowy/startup/startup.dart';
import 'package:app_flowy/workspace/application/appearance.dart';
import 'package:app_flowy/workspace/presentation/home/home_stack.dart';
import 'package:app_flowy/workspace/presentation/home/menu/menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra/image.dart';
import 'package:flowy_infra_ui/style_widget/text.dart';
import 'package:flowy_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_flowy/generated/locale_keys.g.dart';
import 'package:flowy_infra/theme.dart';
import 'package:flowy_infra_ui/style_widget/hover.dart';
import 'package:flowy_sdk/protobuf/flowy-folder/view.pb.dart';

class MenuTrash extends StatelessWidget {
  final bool isSelected;
  final ViewPB view;
  final void Function(ViewPB) onSelected;

  MenuTrash({
    Key? key,
    required this.view,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: ValueKey('$view.hashCode/$isSelected'));

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<AppTheme>();
    return SizedBox(
        height: 26,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: InkWell(
              onTap: () {
                getIt<MenuSharedState>().latestOpenView = null;
                getIt<HomeStackManager>()
                    .setPlugin(makePlugin(pluginType: PluginType.trash));
              },
              child: FlowyHover(
                style: HoverStyle(hoverColor: theme.bg3),
                builder: (_, onHover) => _render(context, onHover),
                setSelected: () => isSelected,
              ),
            )));
  }

  Widget _render(BuildContext context, bool onHover) {
    return Row(children: [
      ChangeNotifierProvider.value(
        value: Provider.of<AppearanceSettingModel>(context, listen: true),
        child: Selector<AppearanceSettingModel, AppTheme>(
          selector: (ctx, notifier) => notifier.theme,
          builder: (ctx, theme, child) => SizedBox(
              width: 16,
              height: 16,
              child: svgWidget("home/trash", color: theme.iconColor)),
        ),
      ),
      const HSpace(6),
      ChangeNotifierProvider.value(
        value: Provider.of<AppearanceSettingModel>(context, listen: true),
        child: Selector<AppearanceSettingModel, Locale>(
          selector: (ctx, notifier) => notifier.locale,
          builder: (ctx, _, child) =>
              FlowyText.medium(LocaleKeys.trash_text.tr(), fontSize: 12),
        ),
      ),
    ]);
  }
}
