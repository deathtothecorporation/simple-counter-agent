/-  *counter
|%
++  en-js
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    ^-  json
    %+  frond  'update'
    %-  pairs
    :~  counter+(numb (jam numb.upd))
        entire-update+(numb (jam upd))
    ==
  ::
  --
++  de-js
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  inc+ul
        dec+ul
        sub+(se %p)
    ==
  --
--
