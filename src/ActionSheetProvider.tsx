import * as React from 'react';

// NativeActionSheet will always be custom when on Android
import NativeActionSheet from './ActionSheet';
import CustomActionSheet from './ActionSheet/CustomActionSheet';
import { Provider } from './context';
import type {
  ActionSheetOptions,
  ActionSheetOptionsInternal,
  ActionSheetProviderRef,
  IconResource,
} from './types';

import isArray from 'lodash/isArray';

interface Props {
  children: React.ReactNode;
  useNativeDriver?: boolean;
  useCustomActionSheet?: boolean;
}

export default React.forwardRef<ActionSheetProviderRef, Props>(
  function ActionSheetProvider(
    { children, useNativeDriver, useCustomActionSheet = false },
    ref
  ) {
    const actionSheetRef = React.useRef<NativeActionSheet>(null);

    const context = React.useMemo(
      () => ({
        showActionSheetWithOptions: (
          options: ActionSheetOptions,
          callback: (i: number) => void
        ) => {
          const modifiedOptions: ActionSheetOptionsInternal = {
            ...options,
            options: [],
          };
          if (
            isArray(options.options) &&
            typeof options.options[0] === 'string'
          ) {
            modifiedOptions.options = options.options.map((title) => ({
              title,
            })) as IconResource[];
          } else {
            modifiedOptions.options = options.options as IconResource[];
          }

          if (actionSheetRef.current) {
            actionSheetRef.current.showActionSheetWithOptions(
              modifiedOptions,
              callback
            );
          }
        },
      }),
      [actionSheetRef]
    );

    React.useImperativeHandle(
      ref,
      () => ({
        // backwards compatible with 13.x before context was being passed right on the ref
        getContext: () => context,
        showActionSheetWithOptions: context.showActionSheetWithOptions,
      }),
      [context]
    );

    const ActionSheet = React.useMemo(
      () => (useCustomActionSheet ? CustomActionSheet : NativeActionSheet),
      [useCustomActionSheet]
    );

    return (
      <Provider value={context}>
        <ActionSheet ref={actionSheetRef} useNativeDriver={useNativeDriver}>
          {React.Children.only(children)}
        </ActionSheet>
      </Provider>
    );
  }
);
