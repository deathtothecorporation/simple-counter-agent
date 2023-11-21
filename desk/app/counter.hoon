/-  *counter
/+  verb, dbug, default-agent
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  [%0 =numb]
::
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-0
=*  state  -
::
^-  agent:gall
::
=<
  |_  =bowl:gall
  +*  this  .
      def  ~(. (default-agent this %|) bowl)
      eng   ~(. +> [bowl ~])
  ++  on-init
    ^-  (quip card _this)
    ~>  %bout.[0 '%counter +on-init']
    =^  cards  state  abet:init:eng
    [cards this]
  ::
  ++  on-save
    ^-  vase
    ~>  %bout.[0 '%counter +on-save']
    !>(state)
  ::
  ++  on-load
    |=  ole=vase
    ~>  %bout.[0 '%counter +on-load']
    ^-  (quip card _this)
    =^  cards  state  abet:(load:eng ole)
    [cards this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ~>  %bout.[0 '%counter +on-poke']
    |^  ^-  (quip card _this)
    =^  cards  state
      ?+  mark  (on-poke:def mark vase)
        %counter-do  (handle-do !<(act vase))
      ==
    [cards this]
    ::
    ++  handle-do
        |=  =act
        ^-  (quip card _state)
        ?-  -.act
          %inc
        =.  numb  (add 1 numb)
        :_  state
        :~  :^  %give  %fact  ~[/web-ui]
            :-  %counter-update
            !>  ^-  update
            [%incd numb]
        ==
          %dec
        =.  numb  (sub numb 1)
        :_  state
        :~  :^  %give  %fact  ~[/web-ui]
            :-  %counter-update
            !>  ^-  update
            [%decd numb]
        ==
          %sub
        :_  state
        ::  TODO: change to subscription
        :~  :^  %give  %fact  ~[/web-ui]
            :-  %counter-update
            !>  ^-  update
            [%subd whom.act]
        ==
      ==
    --
  ::
  ++  on-peek
    |=  pat=path
    ~>  %bout.[0 '%counter +on-peek']
    ^-  (unit (unit cage))
    [~ ~]
  ::
  ++  on-agent
    |=  [wir=wire sig=sign:agent:gall]
    ~>  %bout.[0 '%counter +on-agent']
    ^-  (quip card _this)
    `this
  ::
  ++  on-arvo
    |=  [wir=wire sig=sign-arvo]
    ~>  %bout.[0 '%counter +on-arvo']
    ^-  (quip card _this)
    `this
  ::
  ++  on-watch
    |=  pat=path
    ~>  %bout.[0 '%counter +on-watch']
    ^-  (quip card _this)
    ?+  pat  (on-watch:def pat)
        [%web-ui ~]
      :_  this
      :~  :^  %give  %fact  ~
          :-  %counter-update
          !>  ^-  update
          [%update numb]
      ==
    ==
  ::
  ++  on-fail
    ~>  %bout.[0 '%counter +on-fail']
    on-fail:def
  ::
  ++  on-leave
    ~>  %bout.[0 '%counter +on-leave']
    on-leave:def
  --
|_  [bol=bowl:gall dek=(list card)]
+*  dat  .
++  emit  |=(=card dat(dek [card dek]))
++  emil  |=(lac=(list card) dat(dek (welp lac dek)))
++  abet  ^-((quip card _state) [(flop dek) state])
::
++  init
  ^+  dat
  dat
::
++  load
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%0 *] q.vaz)
  dat(state !<(state-0 vaz))
--
