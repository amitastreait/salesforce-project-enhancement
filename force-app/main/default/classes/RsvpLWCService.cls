/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-17-2021
 * @last modified by  : Amit Singh
**/
public without sharing class RsvpLWCService {
    
    @AuraEnabled
    public static void doRSVP(String params, String eventId){
        /*
            {
                'Name' : 'Amit Singh',
                'Email__c' : '',
                'Title__c' : '',
                'Company__c' : ''
            }

        */

        Attendee__c attendeeRecord = (Attendee__c)JSON.deserialize(params, Attendee__c.class);

        attendeeRecord.User__c     = UserInfo.getUserId();
        /* Check if the Attendee is already there in the RSVP list */
        String attendeeId = checkAttendee(UserInfo.getUserId());
        try {
            if(String.isBlank(attendeeId)){
                insert attendeeRecord;
                attendeeId = attendeeRecord.Id;
            }else{
                attendeeRecord.Id = attendeeId;
                update attendeeRecord;
            }
            Event_Attendee__c eventAttendeeRecord = new Event_Attendee__c();
            eventAttendeeRecord.Attendee__c = attendeeId;
            eventAttendeeRecord.Event__c    = eventId;
            insert eventAttendeeRecord;
        }catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    private static String checkAttendee(String userId) {
        String attendeeId = '';
        List<Attendee__c> attendeeList = [SELECT Id, User__c FROM Attendee__c WHERE User__c = :userId];
        if(attendeeList != null && attendeeList.size() > 0){
            attendeeId = attendeeList[0].Id;
        }
        return attendeeId;
    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Attendee__c> fethRsvpList(String eventId){
        List<Event_Attendee__c> attendees = new List<Event_Attendee__c>();
        attendees = [SELECT Id, Event__c 
                        FROM  Event_Attendee__c 
                        WHERE Event__c =: eventId 
                        AND   Attendee__r.User__c =: UserInfo.getUserId()
                    ];
        return attendees;
    }

    @AuraEnabled(cacheable=true)
    public static User fetchUserDetails(){
        User user = new User();
        try {
            user = [SELECT Id, Name, Email, Title, CompanyName FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return user;
    }
}
