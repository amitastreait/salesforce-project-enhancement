/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-14-2021
 * @last modified by  : Amit Singh
**/
public without sharing class EventListLWCService {

    @AuraEnabled(cacheable=true)
    public static List<Event__c> fetchUpComingEvents(){
        List<Event__c> eventList = new List<Event__c>();
        try {
            eventList = [SELECT Id, Location__c, 
                            Location__r.Name, Name__c, Start_DateTime__c, TitleImageUrl__c
                            FROM Event__c
                            WHERE Start_DateTime__c >= TODAY AND Live__c = true
                            WITH SECURITY_ENFORCED
                        ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return eventList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Event__c> fetchPastEvents(){
        List<Event__c> eventList = new List<Event__c>();
        try {
            eventList = [SELECT Id, Location__c, 
                            Location__r.Name, Name__c, Start_DateTime__c, TitleImageUrl__c
                            FROM Event__c
                            WHERE Start_DateTime__c <= TODAY
                            WITH SECURITY_ENFORCED
                        ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return eventList;
    }
}
