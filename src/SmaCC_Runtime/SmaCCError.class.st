"
SmaCCError is a special node that is used when encountering an error during parsing and the parser uses the special ""error"" keyword in the grammar. When an error occurs the parser searches for a location on the stack that will shift the ""error"". 

Instance Variables:
	stackContents	<Array of: Object>	the objects that had to be popped off the node stack to be able to shift the error
	dismissedTokens	<OrderedCollection of: Object>	the token objects that needed to be ignored to be able to resume parsing
	errorToken	<SmaCCToken>	the token that started the error handling. This token may also be in the dismissedTokens or it may be used in some other node created after handling the error
"
Class {
	#name : #SmaCCError,
	#superclass : #SmaCCParseNode,
	#instVars : [
		'stackContents',
		'dismissedTokens',
		'errorToken'
	],
	#category : #'SmaCC_Runtime'
}

{ #category : #'visitor-double dispatching' }
SmaCCError >> acceptVisitor: aSmaCCParseNodeVisitor [
	^ aSmaCCParseNodeVisitor visitSmaCCError: self
]

{ #category : #private }
SmaCCError >> calculateStartPosition [
	| min |
	min := SmallInteger maxVal.
	self errorComponentsDo: [ :each | each startPosition ifNotNil: [ :pos | min := min min: pos ] ].
	min = SmallInteger maxVal
		ifTrue: [ min := errorToken startPosition ].
	^ min
]

{ #category : #private }
SmaCCError >> calculateStopPosition [
	| max |
	max := 0.
	self errorComponentsDo: [ :each | each stopPosition ifNotNil: [ :pos | max := max max: pos ] ].
	max = 0
		ifTrue: [ max := errorToken startPosition ].
	^ max
]

{ #category : #accessing }
SmaCCError >> dismissedTokens [
	^ dismissedTokens
]

{ #category : #accessing }
SmaCCError >> dismissedTokens: tokenCollection [
	dismissedTokens := tokenCollection
]

{ #category : #private }
SmaCCError >> errorComponentsDo: aBlock [
	self nodesAndTokensIn: stackContents do: aBlock.
	dismissedTokens do: aBlock
]

{ #category : #accessing }
SmaCCError >> errorToken [
	^ errorToken
]

{ #category : #accessing }
SmaCCError >> errorToken: smaccToken [
	errorToken := smaccToken
]

{ #category : #private }
SmaCCError >> nodesAndTokensIn: anObject do: aBlock [
	anObject isCollection
		ifTrue: [ anObject do: [ :each | self nodesAndTokensIn: each do: aBlock ] ]
		ifFalse: [ ((anObject isKindOf: SmaCCParseNode) or: [ anObject isKindOf: SmaCCToken ])
				ifTrue: [ aBlock value: anObject ] ]
]

{ #category : #accessing }
SmaCCError >> stackContents [
	^ stackContents
]

{ #category : #accessing }
SmaCCError >> stackContents: aCollection [
	stackContents := aCollection
]