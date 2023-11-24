export interface IncPayload {
  inc: null
};
export interface DecPayload {
  dec: null
};

export type CounterPokes = IncPayload | DecPayload; // | OtherPokePayload | AnotherPayload
