import * as React from 'react';
import type { TextStyle, ViewStyle } from 'react-native';

export interface ActionSheetProps {
  showActionSheetWithOptions: (
    options: ActionSheetOptions,
    callback: (i?: number) => void | Promise<void>
  ) => void;
}

export interface ActionSheetProviderRef extends ActionSheetProps {
  /**
   * @deprecated Simply call `showActionSheetWithOptions()` directly from the ref now
   */
  getContext: () => ActionSheetProps;
}

// for iOS
export interface ActionSheetIOSOptions {
  options: Array<{ title: string; iconName?: string }>;
  title?: string;
  message?: string;
  tintColor?: string;
  cancelButtonIndex?: number;
  cancelButtonTintColor?: string;
  destructiveButtonIndex?: number | number[];
  anchor?: number;
  userInterfaceStyle?: 'light' | 'dark';
  disabledButtonIndices?: number[];
}

// for Android
export interface ActionSheetOptions extends ActionSheetIOSOptions {
  icons?: React.ReactNode[];
  tintIcons?: boolean;
  textStyle?: TextStyle;
  titleTextStyle?: TextStyle;
  messageTextStyle?: TextStyle;
  autoFocus?: boolean;
  showSeparators?: boolean;
  containerStyle?: ViewStyle;
  separatorStyle?: ViewStyle;
  useModal?: boolean;
  destructiveColor?: string;
}
