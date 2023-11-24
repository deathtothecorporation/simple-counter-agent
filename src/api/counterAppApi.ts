import * as PokeTypes from "@/api/types/counter-pokes"
import * as PP from "@/api/poker"
import * as SS from "@/api/scrier"
import * as R from "@/api/types/my-response"

export const Pokes = {
  Inc() { return pokeInc() },
  Dec() { return pokeDec() }
}

export const Scries = {
  Thing() { return scryThing() }
}

function pokeInc(): Promise<any> {
  const poker = new PP.Inc()
  return poker.poke()
}

function pokeDec(): Promise<any> {
  const poker = new PP.Dec()
  return poker.poke()
}

function scryThing(): Promise<R.MyAppThingResponse> {
  const scrier = new SS.ScryThing()
  return scrier.scry()
}
