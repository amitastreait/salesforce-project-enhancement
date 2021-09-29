global class RegistrationHandler {
    
    public static User createPortalUser(Auth.UserData data){
    
        System.debug('&&&& data \n '+JSON.serialize(data) );
        
        //We have a community id, so create a user with community access
        Account act = new Account(
            Name = data.firstName+' '+data.lastName,
            OwnerId = UserInfo.getUserId()
        );
        Database.insert(act);
        
        Contact c = new Contact();
        c.accountId = act.Id;
        c.email = data.email;
        c.firstName = data.firstName;
        c.lastName = data.lastName;
        insert(c);

        
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE Name =: System.Label.MAX_FIT_ATTENDEE LIMIT 1];
        u.username = data.email.substringBefore('@') + '@maxfit.com.attendee';
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.email.substringBefore('@');
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLocale();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        u.contactId = c.Id;
        return u;
    }
    
    public static User createUser(Auth.UserData data){
        //This is not a community, so create a regular standard user
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='MaxFit Organizer' LIMIT 1];
        
        u.username = data.email.subStringBefore('@') + '@maxfit.com.organizer';
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = u.username;
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLocale();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        
        return u;
    }
    
}