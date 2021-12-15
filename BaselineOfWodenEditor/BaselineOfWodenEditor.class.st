Class {
	#name : #BaselineOfWodenEditor,
	#superclass : #BaselineOf,
	#category : #BaselineOfWodenEditor
}

{ #category : #baselines }
BaselineOfWodenEditor >> baseline: spec [
    <baseline>
	spec for: #'common' do: [
		spec
			baseline: #'WodenGameFramework' with: [ spec repository: 'github://ronsaldo/woden-core-game-framework' ];
			baseline: #'WodenRoassal' with: [ spec repository: 'github://ronsaldo/woden-core-roassal' ];
			package: #'WodenEditor-Model' with: [
				spec requires: #( #'WodenGameFramework' ).
			];
			package: #'WodenEditor-UI' with: [
				spec requires: #( #'WodenEditor-Model' ).
			];
			package: #'WodenEditor-Tests' with: [
				spec requires: #( #'WodenEditor-Model' ).
			]
	].

]
