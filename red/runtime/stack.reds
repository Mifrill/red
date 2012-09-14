Red/System [
	Title:   "Red execution stack functions"
	Author:  "Nenad Rakocevic"
	File: 	 %stack.reds
	Rights:  "Copyright (C) 2011 Nenad Rakocevic. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/dockimbel/Red/blob/master/red-system/runtime/BSL-License.txt
	}
]

stack: context [										;-- call stack
	verbose: 0

	frame!: alias struct! [
		header 	[integer!]								;-- cell header
		symbol	[integer!]								;-- index in symbol table
		spec	[node!]									;-- spec block (cleaned-up form)
		prev	[integer!]								;-- index to beginning of previous stack frame
	]

	data: block/make-in root 2048						;-- stack series
	frame-base: 0										;-- root frame has no previous frame
	base: 0
	
	set-flag data/node flag-ins-tail					;-- optimize for tail insertion
	
	reset: func [
		return: [cell!]
		/local
			s	[series!]
	][
		#if debug? = yes [if verbose > 0 [print-line "stack/reset"]]

		s: as series! data/node/value
		s/tail: s/offset + frame-base + 1
		either zero? frame-base [
			s/tail: s/offset + 1
		][
			s/tail: s/offset + frame-base + 1
		]
		s/tail
	]

	mark: func [
		call	[red-word!]
		/local
			frame [frame!]
			s	  [series!]
	][
		#if debug? = yes [if verbose > 0 [print-line "stack/mark"]]

		frame: as frame! push
		frame/header: TYPE_STACKFRAME
		frame/symbol: either null? call [-1][call/symbol]
		frame/prev: frame-base
		
		s: as series! data/node/value
		frame-base: (as-integer (as cell! frame) - s/offset) >> 4
				#if debug? = yes [
			if verbose > 1 [
				print-line ["frame-base: " frame-base]
				dump
			]
		]
	]
		
	unwind: func [
		/local 
			s	   [series!]
			frame  [frame!]
			offset [integer!]
	][
		#if debug? = yes [if verbose > 0 [print-line "stack/unwind"]]

		s: as series! data/node/value
		frame: as frame! s/offset + frame-base
		frame-base: frame/prev
		either zero? frame-base [
			s/tail: s/offset + 1
		][
			s/tail: as cell! frame + 1
		]
		copy-cell
			as cell! frame + 1
			as cell! frame
			
		#if debug? = yes [
			if verbose > 1 [
				print [
					"frame-base: " frame-base lf
					"tail: " s/tail lf
				]
				dump
			]
		]
	]
	
	init: does [
		mark null
	]
	
	arguments: func [
		return: [cell!]
		/local
			s [series!]
	][
		s: as series! data/node/value
		s/offset + frame-base + 1
	]

	push-last: func [
		last [red-value!]
	][
		#if debug? = yes [if verbose > 0 [print-line "stack/push-last"]]
		
		copy-cell last arguments		
	]
	
	push: func [
		return: [cell!]
	][
		#if debug? = yes [if verbose > 0 [print-line "stack/push"]]
		
		alloc-at-tail data/node
	]

	#if debug? = yes [	
		dump: func [										;-- debug purpose only
			/local
				s	[series!]
		][
			s: as series! data/node/value
			dump-memory
				as byte-ptr! s/offset
				4
				(as-integer s/tail + 1 - s/offset) >> 4
			print-line ["tail: " s/tail]
		]
	]
]
