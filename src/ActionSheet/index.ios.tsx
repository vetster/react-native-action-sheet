import * as React from 'react';
import { View, type ViewProps, NativeModules } from 'react-native';

import type {
  ActionSheetIOSOptions,
  ActionSheetIOSOptionsInternal,
} from '../types';

const ActionSheetIOS = NativeModules.ReactNativeActionSheet;

interface Props {
  readonly children: React.ReactNode;
  readonly pointerEvents?: ViewProps['pointerEvents'];
}

type onSelect = (buttonIndex: number) => void;

export default class ActionSheet extends React.Component<Props> {
  render() {
    return (
      <View pointerEvents={this.props.pointerEvents} style={{ flex: 1 }}>
        {React.Children.only(this.props.children)}
      </View>
    );
  }

  showActionSheetWithOptions(
    dataOptions: ActionSheetIOSOptionsInternal,
    onSelect: onSelect
  ) {
    // ...dataOptions include other keys which use in android, thats why `Android-Only options` Crash on IOS
    const {
      cancelButtonIndex,
      destructiveButtonIndex,
      options,
      tintColor,
      cancelButtonTintColor,
      disabledButtonIndices,
    } = dataOptions;
    const iosOptions: ActionSheetIOSOptionsInternal = {
      cancelButtonIndex,
      destructiveButtonIndex,
      options,
      tintColor,
      cancelButtonTintColor,
      disabledButtonIndices,
      // A null title or message on iOS causes a crash
      title: dataOptions.title || undefined,
      message: dataOptions.message || undefined,
      anchor: dataOptions.anchor || undefined,
      userInterfaceStyle: dataOptions.userInterfaceStyle || undefined,
    };
    // @ts-ignore: Even though ActionSheetIOS supports array of numbers for `destructiveIndex` the types are not yet updated. See https://github.com/facebook/react-native/pull/18254.
    ActionSheetIOS.showActionSheetWithOptions(iosOptions, onSelect);
  }
}
