import urbitAPI from "./urbitAPI";
import * as P from "@/api/types/counter-pokes"

const DoMark = "counter-do"

class CounterAction {
  payload: any;

  constructor(
    payload: P.CounterPokes
  ) {
    this.payload = payload
  }

  poke(): Promise<any> {
    const json = this.payload
    console.log('json ', json)
    return urbitAPI.poke({
      app: 'counter',
      mark: DoMark,
      json
    })
  }
}

export class Inc extends CounterAction {
  declare payload: P.IncPayload

  constructor() {
    const json: P.IncPayload = { inc: null }
    super(json)
  }
}

export class Dec extends CounterAction {
  declare payload: P.DecPayload

  constructor() {
    const json: P.DecPayload = { dec: null }
    super(json)
  }
}
