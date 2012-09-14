Red/System [
	Title:   "Block! datatype runtime functions"
	Author:  "Nenad Rakocevic"
	File: 	 %block.reds
	Rights:  "Copyright (C) 2011 Nenad Rakocevic. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/dockimbel/Red/blob/master/red-system/runtime/BSL-License.txt
	}
]

block: context [
	verbose: 0

	rs-length?: func [
		blk 	[red-block!]
		return: [integer!]
	][
		series: as series-buffer! blk/node/value
		(as-integer (series/tail - series/offset)) >> 4 - blk/head
	]
	
	store: func [
		blk 	[red-block!]
		return: [red-block!]
	][
		copy-cell
			as cell! blk
			alloc-at-tail root/node
		blk
	]
	
	append*: func [
		return: [red-block!]
		/local
			blk	[red-block!]
	][
		#if debug? = yes [if verbose > 0 [print-line "block/append*"]]
	
		blk: as red-block! stack/arguments
		assert blk/header and get-type-mask = TYPE_BLOCK
		
		copy-cell
			stack/arguments + 1
			alloc-at-tail blk/node
		blk
	]

	make-in: func [
		parent	[red-block!]
		size 	[integer!]								;-- number of cells to pre-allocate
		return:	[red-block!]
		/local
			blk [red-block!]
	][
		#if debug? = yes [if verbose > 0 [print-line "block/make-in"]]
		
		blk: either null? parent [
			_root
		][
			as red-block! alloc-at-tail parent/node
		]		
		blk/header: TYPE_BLOCK							;-- implicit reset of all header flags
		blk/head: 	0
		blk/node: 	alloc-cells size	
		blk
	]
	
	push: func [
		size	[integer!]
		return: [red-block!]	
		/local
			blk [red-block!]
	][
		#if debug? = yes [if verbose > 0 [print-line "block/push"]]
		
		blk: as red-block! stack/push
		blk/header: TYPE_BLOCK							;-- implicit reset of all header flags
		blk/head: 	0
		blk/node: 	alloc-cells size	
		blk
	]

	;--- Actions ---
	
	make: func [
	
	][
	
	]
	
	append: func [
		return: [red-block!]
		/local
			blk	[red-block!]
	][
		;@@ implement /part and /only support
		blk: as red-block! stack/arguments
		copy-cell
			stack/arguments + 1
			alloc-at-tail blk/node
		blk
	]

	mold: func [
		part	[integer!]
	][

	]
	
	length?: func [
		return: [integer!]
	][
		0
	]
		
	datatype/register [
		TYPE_BLOCK
		;-- General actions --
		:make
		null			;random
		null			;reflect
		null			;to
		null			;form
		null			;mold
		;-- Scalar actions --
		null			;absolute
		null			;add
		null			;divide
		null			;multiply
		null			;negate
		null			;power
		null			;remainder
		null			;round
		null			;subtract
		null			;even?
		null			;odd?
		;-- Bitwise actions --
		null			;and~
		null			;complement
		null			;or~
		null			;xor~
		;-- Series actions --
		null			;append
		null			;at
		null			;back
		null			;change
		null			;clear
		null			;copy
		null			;find
		null			;head
		null			;head?
		null			;index?
		null			;insert
		null			;length?
		null			;next
		null			;pick
		null			;poke
		null			;remove
		null			;reverse
		null			;select
		null			;sort
		null			;skip
		null			;swap
		null			;tail
		null			;tail?
		null			;take
		null			;trim
		;-- I/O actions --
		null			;create
		null			;close
		null			;delete
		null			;modify
		null			;open
		null			;open?
		null			;query
		null			;read
		null			;rename
		null			;update
		null			;write
	]
]