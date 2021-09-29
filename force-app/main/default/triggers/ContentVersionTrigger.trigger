trigger ContentVersionTrigger on ContentVersion (after insert) {
	ContentVersionTriggerHandler.createPublicLinkForFile(Trigger.New, Trigger.newMap);
}