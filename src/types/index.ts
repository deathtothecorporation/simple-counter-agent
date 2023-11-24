import {Update} from "vite/types/hmrPayload";

export interface AgentSubscription {
  agentName: string;
  subscriptionNumber: number;
}

export type Ship = `~${ string }`

export interface Thing {
  key: 'value'
}

export type GallResponse = UpdateResponse | ExampleResponseTwo

export interface UpdateResponse {
  update: {
    counter: number
  }
}
export interface ExampleResponseTwo {
  testTwo: {
    thing: 'two'
  }
}

export const IsUpdateResponse = (r: GallResponse):
  r is UpdateResponse => {
  return ('update' in r)
}
