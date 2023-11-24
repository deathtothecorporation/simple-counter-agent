
docs for environment setup: https://docs.urbit.org/courses/environment


- start a zod
  - note the port where the web interface is running (8080 below)
  ```
     conn: listening on /home/vcavallo/urbit/counter-zod/.urb/conn.sock
     http: web interface live on http://localhost:8080
     http: loopback live on http://localhost:12321
     pier (156): live
  ```
- start a sum, note its port
- do `+code` to get the login code for this ship, note that down.
- install the desk:
  - `|new-desk %counter`
  - `|mount %counter`
  - `$ cp -rL desk/* <zod-path>/counter`
  - `|commit %counter`
  - `|install our %counter`
  - `:counter +dbug`
  - `:treaty|publish %counter`
- do a basic test in the dojo
  - `:counter +dbug` you should see: `[%0 numb=0]`
  - `:counter &counter-do [%inc ~]`
  - `:counter +dbug` you should see: `[%0 numb=1]`
  - `:counter &counter-do [%dec ~]`
  - `:counter +dbug` you should see: `[%0 numb=0]`

- `npm i`
- `npm run serve`
- visit the base URL of the port mentioned there (probably
http://localhost:3000) and _log in to the fake ship_ with the code from above.
- now visit localhost:3000/apps/counter/ **note the trailing slash! include
this**.


# Vite/Vue3/Typescript/Tailwind/Urbit template


With typed Vuex store, CompositionAPI and `setup`-style script tags.

To install this elsewhere:

```
npx degit vcavallo/vite-vue-urbit-template#vue3-typed-store your-project-name
cd your-project-name

npm install
```

Then:

- Define a .env file, copied from env.example
  - Set the port based on your running fakeship
  - Set the desk name to the name of your desk
- Check out `src/components/Start.vue`
- There are some example actions, mutations, getters in `src/store/`
- Make sure to update `src/api/airlock.ts`'s `path` entry to match your desk's
- Update the history function in `src/router/index.ts`
implementation
- `npm run serve`
- Visit the URL that the vite server output shows (probably `localhost:3000`)
- Log in with your `+code`
