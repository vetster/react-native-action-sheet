import * as React from 'react';
import type { ColorValue, TextStyle, ViewStyle } from 'react-native';

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
  options: Array<{ title: string; leftIcon?: string; rightIcon?: string }>;
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

export type IconDetails = {
  icon: string;
  direction: 'left' | 'right';
  index: number;
  color: string | ColorValue;
};

// for Android
export interface ActionSheetOptions extends ActionSheetIOSOptions {
  renderIcon?: (iconDetails: IconDetails) => React.ReactNode;
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
