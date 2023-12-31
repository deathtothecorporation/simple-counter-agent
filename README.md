# Simple Counter agent + vue.js front end

docs for general urbit environment setup: https://docs.urbit.org/courses/environment

elm wrapper around the js api: https://github.com/figbus/elm-urbit-api

## Urbit setup

- Have `urbit` installed locally.
- start a "fake ship". we'll use the ship `~sum`. You'll often see suggestions
to "start a fakezod" with the assumption that you'll use the ship `~zod`, but in
hoon, `~zod` evaluates to `0`, which can result in very confusing bugs in dev
sometimes. (`~sum` happens to evaluate to `85`)
  - `./urbit -F sum`
  - note the port where the web interface is running (8080 below)
  ```
     conn: listening on /home/vcavallo/urbit/counter-zod/.urb/conn.sock
     http: web interface live on http://localhost:8080
     http: loopback live on http://localhost:12321
     pier (156): live
  ```
- now you have a fake ship running locally, which you can interact with through
the dojo above or through the web interface at `http://localhost:8080` (see
below for web login instructions)
- at the dojo, do `+code` to get the login code for this ship, note that down.
- install the "desk" in this repo on the fake ship. These commands are all in
`~sum`'s dojo:
  - `|new-desk %counter` - this creates an empty desk/directory in the ship (but
  not on your local filesystem)
  - `|mount %counter` - this mounts the above-created directory _to your unix
  filesystem_. It will be found at `/<wherever you ran the ./urbit
  command>/sum/counter`
  - outside the dojo, at the root of this repo: `$ cp -rL desk/*
  <zod-path>/counter` - this copies all the hoon source files into the running
  fake ship's "counter" desk.
  - back in dojo: `|commit %counter` - once the source files are in place, you
  must _commit_ the files for the compiler to pick them up.
  - `|install our %counter` - install the local app to the ship. This will make
  it appear "on the grid" at `http://localhost:8080`
  - `:counter +dbug` - just to see the state of the counter app, make sure it's
  running, etc.
  - `:treaty|publish %counter` - not strictly necessary. this "publishes" the
  app so any other fake ships on your local network can simply `|install ~sum
  %counter` to get it, rather than having to copy the files over in unix.
- do a basic test in the dojo
  - `:counter +dbug` - state debug, you should see: `[%0 numb=0]`
  - `:counter &counter-do [%inc ~]` - this is a "poke"; an action. This
  increases the counter by 1.
  - `:counter +dbug` you should see: `[%0 numb=1]`
  - `:counter &counter-do [%dec ~]` - another poke, to decrement.
  - `:counter +dbug` you should see: `[%0 numb=0]`

## UI Setup

- Create a `.env` file, copying in the example from `env.example`. if your local
fake ship is running at a different port, use those details in your `.env` file.
- `npm i`
- `npm run serve`
- This runs a `vite` dev server and proxies to the urbit, which helps avoid CORS
issues. You'll visit _this_ URL to see the result of js dev without having
to `build` the app to `/dist` files, etc.
- visit the base URL of the port mentioned there (probably
http://localhost:3000) and _log in to the fake ship_ with the code from above.
- now visit localhost:3000/apps/counter/ **note the trailing slash! include
this character**. If you go to the base route to get the "Grid" and click on the
"counter" app tile, it _won't_ add the trailing slash.

## Brief UI explanation:

- `src/views/Home.vue` - this is the single component that does all the
rendering and app logic. Normally you'd divide these responsibilities out to
multiple components.
  - we start an 'airlock' to the urbit (more below)
  - connect with some of the `Vuex` state for displaying FE state (the counter
  variable) and dispatching "actions" (which result in API pokes)
- `src/store/` - way more stuff around front end state management than this app
needs, but it was present in my template, so I left it. This is the most
relevant bit:

```js
  [ActionTypes.AIRLOCK_OPEN]({ commit, dispatch }, deskName: string) {

    airlock.openAirlockTo(
      deskName,

      // Main all-responses-handler
      (data) => {
        if (T.IsUpdateResponse(data)) {
          dispatch(ActionTypes.SET_COUNTER, data.update.counter);
        }
        if (R.IsThingResponse(data)) {
          // Do something for this particular response
          // dispatch(ActionTypes.EXAMPLE, data.testTwo.thing as string);
        }
      },

      (subscriptionNumber: number) => {
        // Thing to do on subscription callback, if anything
      }
    );
  },
```

and cross-referencing from `api/airlock.ts`:

```js
export function openAirlockTo(
  agent: string,
  onEvent,
  onSubNumber: onSubNumber
) {
  urbitAPI
    .subscribe({
      app: agent,
      path: "/web-ui", // TODO: set to your endpoint
      event: (data) => {
        console.log('REMOVEME: gall response ', data)
        onEvent(data);
      },
    })
    .then((sub: number) => {
      onSubNumber(sub);
    });
}
```

### Responding to "subscription" data

> These are like websocket events

The `openAirlockTo` function gets called when the app mounts (in `Home.vue`).
This sets up the eventsource loop. As subscription responses come back, the flow
through the `event` callback in `urbitAPI.subscribe` and potentially trigger
"actions" in the Vuex state. I use typescript the pattern match on the
subscription response "shape" (`T.isUpdateResponse` below) and dispatch other FE
actions depending on what the subscription data was.

```js
        if (T.IsUpdateResponse(data)) {
          dispatch(ActionTypes.SET_COUNTER, data.update.counter);
        }
```

In this case, when we get an "update" from the urbit (which only contains the
counter's state for now) we simply update the Vuex state's "counter" variable,
which automatically renders in the template.

We jumped straight to _getting_ data from urbit, but didn't say how we send it
anything.

### Sending actions; Pokes

> Like HTTP POST requests

I won't go into all the details about auth around pokes, but here are the
basics:

The front end can send something like a POST request with a JSON payload, like
this:

```js
   poke() {
    const json = { some: 'json', payload: [1,2,3] }
    return urbitAPI.poke({
      app: 'counter',
      mark: 'counter-do,
      json: json
    })
  }
```

There is a parallel "decoder" on the urbit side that goes from JSON data ->
nouns, but the details of that are not worth getting into here.

The Gall agent can _do things_ when it gets pokes. and it doesn't necessarily
need to tell anyone - including the FE that sent the poke.
In our case, we _do_ tell the FE something happened:

```hoon
    %dec                  :: when we get a decrement poke...
  =.  numb  (sub numb 1)  :: decrease the counter in state
  :_  state
  :~  :^  %give  %fact  ~[/web-ui] :: send out a "card"
      :-  %counter-update          :: on the 'web-ui' path
      !>  ^-  update
      [%update numb]
  ==
```

This Hoon says "send out a subscription response 'card' on the `/web-ui` path to
anyone who happens to be listening there. If you refer back up to the FE's
airlock function, you'll remember that our front end _is_ listening on the
`/web-ui` path. which explains how it gets subscription updates upon pokes.

(note here, anyone can subscribe to anything (basically) if we had _another_ UI
running that was subscribed to this path, it would see the counter changing even
if wasn't the agent _doing_ the increments/decrements.)

### Scries; asking for data

> Like HTTP GET requests

This example gall agent doesn't include any scry endpoints yet. If it did, you
would be able to `.scry()` from the FE and get back an immediate response,
unlike subscription data which comes back asynchronously / out of band over the
eventsource.

