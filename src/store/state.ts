import * as T from "@/types";
import * as L from "@/types/loading-types";

import { loaderStates } from "@/types/loading-types";

const uiElementLoadingState: L.UILoaderState = {
  yourElementHere: loaderStates.initial,
  anotherElement: loaderStates.initial,
}

export const state = {
  counter: 0 as number,
  loadingStates: uiElementLoadingState as L.UILoaderState,
}

export type State = typeof state
