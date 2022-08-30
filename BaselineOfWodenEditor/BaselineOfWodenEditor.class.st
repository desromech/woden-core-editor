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
			baseline: #'WodenGameFramework' with: [ spec repository: 'github://desromech/woden-core-game-framework' ];
			baseline: #'WodenCoreModeling' with: [ spec repository: 'github://desromech/woden-core-modeling' ];
			baseline: #'WodenRoassal' with: [ spec repository: 'github://desromech/woden-core-roassal' ];
			package: #'WodenEditor-Model' with: [
				spec requires: #( #'WodenCoreModeling' #'WodenGameFramework' ).
			];
			package: #'WodenEditor-UI' with: [
				spec requires: #( #'WodenEditor-Model' ).
			];
			package: #'WodenEditor-Tests' with: [
				spec requires: #( #'WodenEditor-Model' ).
			]
	].

]
