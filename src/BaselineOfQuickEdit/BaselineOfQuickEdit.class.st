Class {
	#name : #BaselineOfQuickEdit,
	#superclass : #BaselineOf,
	#category : 'BaselineOfQuickEdit'
}

{ #category : #baseline }
BaselineOfQuickEdit >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			package: 'QuickEdit'. ].

]
