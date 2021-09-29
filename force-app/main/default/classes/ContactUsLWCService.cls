/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 09-29-2021
 * @last modified by  : Amit Singh
**/
public without sharing class ContactUsLWCService {
    
    @AuraEnabled
    public static void recordResponse(Map<Object, String> paramsMap, String emailAddress, String ownerId, String eventId){
        System.debug(' params \n '+ paramsMap);
        
        try {
            
            String description = paramsMap.get('Message');
            String sbject = 'Query From '+ paramsMap.get('Name')+' : '+ paramsMap.get('Subject');

            /* Create a Task related to that event */
            Task task = new Task();
            task.Subject = sbject;
            task.Priority = 'High';
            task.Description = description;
            task.Status = 'Not Started';
            task.ActivityDate = System.today().addDays(1); // due date
            task.OwnerId = ownerId;
            task.WhatId  = eventId;

            insert task;
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses( new List<String> { emailAddress } ); 
            message.setCcAddresses( new List<String> { paramsMap.get('Email') } );
            
            message.setSubject(sbject);
            message.setHtmlBody( description );
            
            List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
            emailMessages.add(message);
            
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailMessages);

            for (Messaging.SendEmailResult sr : results) {
                if (!sr.isSuccess()) {
                    List<Messaging.SendEmailError> errors = sr.getErrors();
                    String erroString = String.join( errors , ', ');
                    throw new AuraHandledException( erroString );
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
